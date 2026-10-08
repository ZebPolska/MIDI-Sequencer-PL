unit Unit16;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons;

type
  TForm16 = class(TForm)
    Button1: TButton; // Zastosuj
    Button2: TButton; // Anuluj / Zamknij
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    CheckBox1: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: LongInt;
      Rect: TRect; State: TGridDrawState);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    SelectedChannel: Integer;
    procedure PrepareLyrics;
  end;

var
  Form16: TForm16;

implementation

uses SekwencerMidi; // Unit1

{$R *.dfm}


function UsunPolskieZnaki(const S: string): string;
const
  Polskie:    string = '¹æê³ñóœŸ¿¥ÆÊ£ÑÓŒ¯';
  Zamienniki: string = 'acelnoszzACELNOSZZ';
var
  i, p: Integer;
begin
  Result := S;
  for i := 1 to Length(Result) do
  begin
    p := Pos(Result[i], Polskie);
    if p > 0 then
      Result[i] := Zamienniki[p];
  end;
end;

procedure TForm16.PrepareLyrics; // Zmieniono z Button2Click na PrepareLyrics
var
  i, RowIdx: Integer;
  TargetCol: Integer;
  FoundLyric: string;
  j: Integer;
begin
  // Reset Grida
  StringGrid1.RowCount := 0;
  StringGrid1.ColCount := 2;
  StringGrid1.FixedCols := 0;
  StringGrid1.FixedRows := 0;
  StringGrid1.Options := StringGrid1.Options + [goEditing, goAlwaysShowEditor];

  StringGrid1.ColWidths[0] := 0;
  StringGrid1.ColWidths[1] := 250;

  RowIdx := 0;

  for i := 0 to MidiNoteCount - 1 do
  begin
    if MidiNotes[i].Channel = SelectedChannel then
    begin
      FoundLyric := '';

      // 1. Szukamy w MidiMarkers (tolerancja 20 ticków)
      for j := 0 to Form1.MidiMarkerCount - 1 do
      begin
        if Abs(Int64(Form1.MidiMarkers[j].Tick) - Int64(MidiNotes[i].StartTick)) < 20 then
        begin
          if not Form1.IsValidYamahaMarker(Form1.MidiMarkers[j].Name) then
          begin
            FoundLyric := Form1.MidiMarkers[j].Name;
            Break;
          end;
        end;
      end;

      // 2. Jeœli nie ma w markerach, sprawdŸ StringGrid2
      if FoundLyric = '' then
      begin
        if Form1.FPPQ > 0 then
        begin
          TargetCol := Trunc(MidiNotes[i].StartTick / (Form1.FPPQ / 16.0));
          if (TargetCol >= 0) and (TargetCol < Form1.StringGrid2.ColCount) then
          begin
            // POBIERAMY WARTOŒÆ (nie czyœcimy jej tutaj!)
            FoundLyric := Trim(Form1.StringGrid2.Cells[TargetCol, SelectedChannel + 1]);
          end;
        end;
      end;

      // 3. DODAWANIE DO GRIDA (KA¯DA NUTA Z KANA£U 4)
      StringGrid1.RowCount := RowIdx + 1;
      StringGrid1.Cells[0, RowIdx] := IntToStr(MidiNotes[i].StartTick);

      // Jeœli tekst jest pusty lub jest sam¹ kresk¹, wymuœ wyœwietlenie kreski '-'
      if (FoundLyric = '') or (FoundLyric = '-') then
        StringGrid1.Cells[1, RowIdx] := '-'
      else
        StringGrid1.Cells[1, RowIdx] := FoundLyric;

      StringGrid1.DefaultRowHeight := 40;
      Inc(RowIdx);
    end;
  end;

  // Korekta szerokoœci po wype³nieniu
  if RowIdx > 0 then
    StringGrid1.ColWidths[1] := StringGrid1.ClientWidth - 20;

  if (SelectedChannel = 3) and (RowIdx = 0) then
    ShowMessage('Brak nut na kanale 4');
end;


procedure TForm16.Button1Click(Sender: TObject);
var
  i, t, ev, j: Integer;
  ATick, CurrentAbsTick: Int64;
  NewText: string;
  AnsiTxt: AnsiString;
  NewData: System.SysUtils.TBytes;
  TargetCol: Integer;
begin
  // Iterujemy przez wszystkie wiersze w edytorze (Form16)
  for i := 0 to StringGrid1.RowCount - 1 do
  begin
    ATick := StrToInt64Def(StringGrid1.Cells[0, i], -1);
    NewText := StringGrid1.Cells[1, i];

    // Jeœli wiersz ma przypisany czas
    if (ATick <> -1) then
    begin
      // --- LOGIKA CHECKBOXA (USUWANIE OGONKÓW) ---
      if CheckBox1.Checked and (NewText <> '-') and (NewText <> '') then
        NewText := UsunPolskieZnaki(NewText);

      // --- 1. AKTUALIZACJA W FORM1.MidiMarkers (KLUCZOWE DLA PONOWNEGO OTWARCIA) ---
      for j := 0 to Form1.MidiMarkerCount - 1 do
      begin
        // Szukamy markera o dok³adnie tym samym czasie
        if Int64(Form1.MidiMarkers[j].Tick) = ATick then
        begin
          // Sprawdzamy czy to nie jest systemowy marker Yamahy (¿eby ich nie zepsuæ)
          if not Form1.IsValidYamahaMarker(Form1.MidiMarkers[j].Name) then
          begin
            // Jeœli tekst to "-" lub pusty, czyœcimy marker
            if NewText = '-' then Form1.MidiMarkers[j].Name := ''
            else Form1.MidiMarkers[j].Name := NewText;
          end;
        end;
      end;

      // --- 2. AKTUALIZACJA WIZUALNA W FORM1 (StringGrid2) ---
      if Form1.FPPQ > 0 then
      begin
        TargetCol := Trunc(ATick / (Form1.FPPQ / 16.0));
        if (TargetCol >= 0) and (TargetCol < Form1.StringGrid2.ColCount) then
        begin
          if NewText = '-' then Form1.StringGrid2.Cells[TargetCol, SelectedChannel + 1] := ''
          else Form1.StringGrid2.Cells[TargetCol, SelectedChannel + 1] := NewText;
        end;
      end;

      // --- 3. CHIRURGICZNA PODMIANA W MIDI TRACKS (RAW DATA) ---
      // Jeœli tekst to "-", traktujemy to jako chêæ wyczyszczenia zdarzenia w MIDI
      if NewText = '-' then AnsiTxt := ''
      else AnsiTxt := AnsiString(NewText);

      // Przeszukujemy globaln¹ tablicê MidiTracks (z SekwencerMidi.pas)
      for t := 0 to High(MidiTracks) do
      begin
        CurrentAbsTick := 0;
        for ev := 0 to High(MidiTracks[t].Events) do
        begin
          CurrentAbsTick := CurrentAbsTick + MidiTracks[t].Events[ev].DeltaTime;

          // Jeœli czas zdarzenia RAW zgadza siê z czasem naszej sylaby
          if (CurrentAbsTick = ATick) then
          begin
            // Sprawdzamy czy to Meta Event Lyrics ($05) lub Text ($01)
            if (Length(MidiTracks[t].Events[ev].Data) >= 3) and
               (MidiTracks[t].Events[ev].Data[0] = $FF) and
               ((MidiTracks[t].Events[ev].Data[1] = $05) or (MidiTracks[t].Events[ev].Data[1] = $01)) then
            begin
              // Budujemy now¹ strukturê bajtów: [FF] [TYP] [D£UGOŒÆ] [TEKST]
              SetLength(NewData, 3 + Length(AnsiTxt));
              NewData[0] := $FF;
              NewData[1] := MidiTracks[t].Events[ev].Data[1]; // Zachowaj oryginalny typ
              NewData[2] := Byte(Length(AnsiTxt));          // Nowa d³ugoœæ

              // Kopiujemy tekst Ansi do tablicy bajtów (od indeksu 3)
              if Length(AnsiTxt) > 0 then
                Move(AnsiTxt[1], NewData[3], Length(AnsiTxt));

              // Podmieniamy oryginalne dane w pamiêci (to pójdzie do zapisu pliku)
              MidiTracks[t].Events[ev].Data := NewData;
            end;
          end;
        end;
      end;
    end;
  end;

  // Ustawienie flagi edycji, ¿eby system zapisu wiedzia³ o zmianach
  MidiEdited := True;
  ModalResult := mrOk;
  Form16.Close;
end;

procedure TForm16.Button2Click(Sender: TObject); // ANULUJ
begin
  Form16.Close;
end;

procedure TForm16.Button3Click(Sender: TObject);
var
  i: Integer;
begin
  // Spytaj dla pewnoœci
  if MessageDlg('Czy na pewno chcesz usun¹æ CA£Y tekst lyrics z tego kana³u i zostawiæ puste nuty?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // U¿ywamy zwyk³ej pêtli po wierszach Twojego Grida
    for i := 0 to StringGrid1.RowCount - 1 do
    begin
      // Zamiast czyœciæ do '', wpisujemy '-', co Twoje Button1Click
      // zinterpretuje jako usuniêcie tekstu z MIDI, ale zachowa wiersz w edytorze.
      StringGrid1.Cells[1, i] := '-';
    end;

    // Wymuszamy przerysowanie, ¿eby od razu by³o widaæ "kreseczki"
    StringGrid1.Invalidate;
  end;
end;


procedure TForm16.CheckBox1Click(Sender: TObject);
var
  i: Integer;
begin
  // Jeœli zaznaczono, przeleæ przez ca³y grid i usuñ ogonki
  if CheckBox1.Checked then
  begin
    for i := 0 to StringGrid1.RowCount - 1 do
    begin
      StringGrid1.Cells[1, i] := UsunPolskieZnaki(StringGrid1.Cells[1, i]);
    end;
  end;
end;

procedure TForm16.SpeedButton1Click(Sender: TObject);
begin
  Form1.SpeedButton1Click(Sender);
end;

procedure TForm16.SpeedButton2Click(Sender: TObject);
begin
  Form1.SpeedButton2Click(sender);
end;

procedure TForm16.SpeedButton3Click(Sender: TObject);
begin
Form1.SpeedButton3Click(Sender);
end;

procedure TForm16.SpeedButton5Click(Sender: TObject);
begin
  Form1.SpeedButton5Click(Sender);
end;

procedure TForm16.StringGrid1DrawCell(Sender: TObject; ACol, ARow: LongInt;
  Rect: TRect; State: TGridDrawState);
var
  NoteTick: Int64;
  CurrentTick: Int64;
begin
  // Pobieramy czas z Form1 (SekwencerMidi)
  CurrentTick := Form1.FCurrentPos;

  // Pobieramy czas zapisany w ukrytej kolumnie 0 dla tego wiersza
  NoteTick := StrToInt64Def(StringGrid1.Cells[0, ARow], -1);

  // LOGIKA PODŒWIETLANIA:
  // Podœwietlamy, jeœli aktualny czas odtwarzania przekroczy³ czas nuty,
  // ale nie minê³o jeszcze np. 300 ticków (czas trwania podœwietlenia sylaby)
  if (NoteTick >= 0) and (CurrentTick >= NoteTick) and (CurrentTick < NoteTick + 300) then
  begin
    StringGrid1.Canvas.Brush.Color := $BFFFFF; // Kolor Karaoke
    StringGrid1.Canvas.Font.Color := clBlack;
    StringGrid1.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    // Standardowe kolory dla nieaktywnych sylab
    if gdSelected in State then
      StringGrid1.Canvas.Brush.Color := clHighlight
    else
    StringGrid1.Canvas.Brush.Color := clWhite;
    StringGrid1.Canvas.Font.Style := [];
    StringGrid1.Canvas.Font.Color := clGray;
  end;

  // POWIÊKSZANIE CZCIONKI
  // Ustawiamy rozmiar czcionki (np. 18 lub 24, aby by³a 2x wiêksza od standardowej)
  StringGrid1.Canvas.Font.Name := 'Segoe UI'; // Nowoczesna czcionka
  StringGrid1.Canvas.Font.Size := 18;         // Du¿y, wyraŸny tekst

  // Rysowanie
  StringGrid1.Canvas.FillRect(Rect);
  StringGrid1.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, StringGrid1.Cells[ACol, ARow]);
end;

procedure TForm16.StringGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if StringGrid1.Row < StringGrid1.RowCount - 1 then
      StringGrid1.Row := StringGrid1.Row + 1;
    Key := 0;
  end;
end;

end.
