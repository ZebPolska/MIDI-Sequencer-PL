unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,  Math;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public
    procedure RefreshNoteMap;
    procedure Quantize(TrackIdx: Integer; ComboIdx: Integer);
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses sekwencermidi, unit7, Unit8;

procedure TForm4.RefreshNoteMap;
var i, Col, Ch: Integer; TicksPerCol: Double;
begin
  if form1.FPPQ <= 0 then form1.FPPQ := 480;
  TicksPerCol := form1.FPPQ / 16.0;
  if Length(form1.FNoteMinMax) < 17 then Exit;

  // 1. CZYŒCIMY MAPÊ (Twoje)
  for Ch := 1 to 16 do
    if Length(form1.FNoteMinMax[Ch]) > 0 then
      for Col := 0 to High(form1.FNoteMinMax[Ch]) do
        form1.FNoteMinMax[Ch, Col].HasNote := False;

  // 2. WYPE£NIAMY Z AKTUALNYCH NUT (To przywraca widok w Unit1)
  for i := 0 to MidiNoteCount - 1 do
    if MidiNotes[i].Active and (MidiNotes[i].Note < 128) then
    begin
      Col := Round(MidiNotes[i].StartTick / TicksPerCol); // ZMIANA: Round zamiast Trunc!
      Ch := MidiNotes[i].Channel + 1;
      if (Ch >= 1) and (Ch <= 16) and (Col >= 0) and (Col < Length(form1.FNoteMinMax[Ch])) then
      begin
        form1.FNoteMinMax[Ch, Col].HasNote := True;
        form1.FNoteMinMax[Ch, Col].MaxPitch := MidiNotes[i].Note;
        form1.FNoteMinMax[Ch, Col].MinPitch := MidiNotes[i].Note;
      end;
    end;
  form1.StringGrid2.Invalidate;
end;

procedure TForm4.Quantize(TrackIdx: Integer; ComboIdx: Integer);
var
  Ch, Col, NewCol, GridCols: Integer;
  t, i: Integer;
  GridTicks, AbsTick, LastAbsTick: Int64;
  StatusByte: Byte;
  TicksPerCol: Double;
begin
  // 1. Ustalenie siatki w KOLUMNACH (Twoja kolumna to 1/64)
  case ComboIdx of
    0: GridCols := 32; // 1/2
    1: GridCols := 16; // 1/4
    2: GridCols := 8;  // 1/8
    3: GridCols := 4;  // 1/16
    4: GridCols := 2;  // 1/32
    5: GridCols := 1;  // 1/64
    else Exit;
  end;

  // --- KROK A: KWANTYZACJA WIZUALNA (FNoteMinMax) ---
  for Ch := 1 to 16 do
  begin
    if (TrackIdx <> -1) and (Ch <> TrackIdx + 1) then Continue;

    if Length(form1.FNoteMinMax) > Ch then
    begin
      for Col := High(form1.FNoteMinMax[Ch]) downto 0 do
      begin
        if form1.FNoteMinMax[Ch, Col].HasNote then
        begin
          NewCol := Round(Col / GridCols) * GridCols;
          if NewCol <> Col then
          begin
            if (NewCol >= 0) and (NewCol < Length(form1.FNoteMinMax[Ch])) then
            begin
              form1.FNoteMinMax[Ch, NewCol] := form1.FNoteMinMax[Ch, Col];
              form1.FNoteMinMax[Ch, Col].HasNote := False;
            end;
          end;
        end;
      end;
    end;
  end;

  // --- KROK B: KWANTYZACJA DANYCH RAW (MidiTracks) ---
  if (form1.FPPQ > 0) and (Length(MidiTracks) > 0) then
  begin
    // Obliczamy ile ticków ma siatka kwantyzacji (np. dla 1/16 to FPPQ / 4)
    // TicksPerCol to FPPQ / 16, wiêc siatka w tickach to GridCols * TicksPerCol
    TicksPerCol := form1.FPPQ / 16.0;
    GridTicks := Round(GridCols * TicksPerCol);

    for t := 0 to High(MidiTracks) do
    begin
      // Sprawdzamy czy track ma byæ kwantyzowany (TrackIdx = -1 dla ca³oœci)
      if (TrackIdx = -1) or (t = TrackIdx) then
      begin
        AbsTick := 0;
        LastAbsTick := 0;

        for i := 0 to High(MidiTracks[t].Events) do
        begin
          AbsTick := AbsTick + MidiTracks[t].Events[i].DeltaTime;

          if Length(MidiTracks[t].Events[i].Data) > 0 then
          begin
            StatusByte := MidiTracks[t].Events[i].Data[0];
            // Kwantyzujemy czas zdarzeñ Note ON ($90) i Note OFF ($80)
            if (StatusByte and $F0 = $90) or (StatusByte and $F0 = $80) then
            begin
              AbsTick := Round(AbsTick / GridTicks) * GridTicks;
            end;
          end;

          // Przeliczamy DeltaTime (ró¿nica miêdzy nowym czasem a poprzednim skwantyzowanym)
          MidiTracks[t].Events[i].DeltaTime := Cardinal(Max(0, AbsTick - LastAbsTick));
          LastAbsTick := AbsTick;
        end;
      end;
    end;
  end;
     Form1.StringGrid2.Invalidate;

 end;

procedure TForm4.Button1Click(Sender: TObject);
var
  TIdx, i, Col, NewCol, GridCols: Integer;
  TicksPerCol: Double;
begin
  // 1. USTALENIE PARAMETRÓW
  if RadioButton1.Checked then TIdx := Form1.StringGrid1.Row - 1 else TIdx := -1;
  case ComboBox1.ItemIndex of
    0: GridCols := 32; 1: GridCols := 16; 2: GridCols := 8;
    3: GridCols := 4;  4: GridCols := 2;  5: GridCols := 1;
    else GridCols := 1;
  end;
  TicksPerCol := form1.FPPQ / 16.0;

  // 2. KWANTYZACJA RAW I NOTE
  Quantize(TIdx, ComboBox1.ItemIndex);

  for i := 0 to MidiNoteCount - 1 do
  begin
    if ((TIdx = -1) or (MidiNotes[i].Channel = TIdx)) and (MidiNotes[i].Note < 128) then
    begin
      Col := Round(MidiNotes[i].StartTick / TicksPerCol);
      NewCol := Round(Col / GridCols) * GridCols;
      MidiNotes[i].StartTick := Round(NewCol * TicksPerCol);
    end;
  end;

  // 3. REFRESH MAPY (Twoja procedura z Unit4)
  RefreshNoteMap;

  // 4. ODŒWIE¯ANIE "METOD¥ Z UNIT7" (Klucz do pojawienia siê nut w Unit1)
  Form1.UpdateOverviewMap;
  Form1.StringGrid2.Invalidate;
  // Synchronizacja listy zdarzeñ (Unit8), ¿eby widok RAW te¿ siê zgadza³
  //Form8.LoadEventsFromTrack(Form1.StringGrid2.Row);

  // 5. ODŒWIE¯ENIE PIANO ROLL
  if Assigned(Form7) then Form7.DrawGrid2.Invalidate;

  Form4.Close;
end;


procedure TForm4.Button2Click(Sender: TObject);
begin
  Form4.Close; // Zostaje bez zmian
end;


end.
