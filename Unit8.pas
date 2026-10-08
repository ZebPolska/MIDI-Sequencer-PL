unit Unit8;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.Math, Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, System.Threading;

type
  TForm8 = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    PopupMenu2: TPopupMenu;
    DodajZdarzenie1: TMenuItem;
    UsuZaznaczoneZdarzenie1: TMenuItem;
    EdytujZaznaczonezdarzenie1: TMenuItem;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: LongInt; var CanSelect: Boolean);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure DodajZdarzenie1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UsuZaznaczoneZdarzenie1Click(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure EdytujZaznaczonezdarzenie1Click(Sender: TObject);

  private
    function GetEventColor(const Kind: string): TColor;
    function GetNoteName(Note: Byte; IsDrum: Boolean): string;
    function GetControlName(CC: Byte): string;

  public
    FLastUserClickTick: Cardinal;
    FUpdatingFromEventView: Boolean;
    procedure LoadEventsFromTrack(SelectedRow: Integer);
    procedure SyncToMainPos;
  end;

var
  Form8: TForm8;
  FIsManualClick: Boolean = False;

implementation

{$R *.dfm}

uses SekwencerMidi, Unit7, Unit13, Unit14, Unit5, Unit17;



procedure TForm8.SyncToMainPos;
var
  i, BestRow: Integer;
  MinDiff, Diff: Int64;
begin
  if StringGrid1.RowCount < 2 then Exit;

  BestRow := 1;
  MinDiff := High(Int64);

  // Szukamy wiersza z czasem najbli¿szym FCurrentPos
  for i := 1 to StringGrid1.RowCount - 1 do
  begin
    if Assigned(StringGrid1.Objects[0, i]) then
    begin
      Diff := Abs(Int64(StringGrid1.Objects[0, i]) - Form1.FCurrentPos);
      if Diff < MinDiff then
      begin
        MinDiff := Diff;
        BestRow := i;
      end;
    end;
  end;

  // Ustawiamy wiersz bez wywo³ywania SelectCell u¿ytkownika
  FIsManualClick := False;
  StringGrid1.Row := BestRow;

  // Przewijamy widok, ¿eby zaznaczony wiersz by³ na œrodku
  if (BestRow < StringGrid1.TopRow) or (BestRow >= StringGrid1.TopRow + StringGrid1.VisibleRowCount) then
    StringGrid1.TopRow := Max(1, BestRow - (StringGrid1.VisibleRowCount div 2));
end;


function BytesToHex(const Data: TBytes): string;
var i: Integer;
begin
  Result := '';
  for i := 0 to High(Data) do
    Result := Result + IntToHex(Data[i], 2);
end;

procedure TForm8.FormActivate(Sender: TObject);
begin
   // 1. £adujemy eventy
  LoadEventsFromTrack(Form1.StringGrid2.Row);

  // 2. WYMUSZENIE POWROTU KURSORA NA EKRAN
  if Form1.Timer1.Enabled then
  begin
    SyncToMainPos;
  end;

end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  StringGrid1.DoubleBuffered := True;
  with StringGrid1 do
  begin
    FixedCols := 0; FixedRows := 1;
    ColCount := 7; RowCount := 40;
    DefaultRowHeight := 22;
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goColSizing];

    Cells[0, 0] := 'Pozycja';
    Cells[1, 0] := 'Typ';
    Cells[2, 0] := 'Parametr 1';
    Cells[3, 0] := 'Vol';
    Cells[4, 0] := 'D³ugoœæ';
    Cells[5, 0] := 'Parametr 2';
    Cells[6, 0] := 'Parametr 3';

    ColWidths[0] := 64;   // Pozycja
    ColWidths[1] := 90;  // Typ
    ColWidths[2] := 120;   // Parametr1
    ColWidths[3] := 35;   // G³oœnoœæ
    ColWidths[4] := 50;   // D³ugoœæ
    ColWidths[5] := 120;   // Parametr2
    ColWidths[6] := 160;  // Parametr3

  end;
end;

procedure TForm8.FormShow(Sender: TObject);
begin
  LoadEventsFromTrack(Form1.StringGrid2.Row);
end;

procedure TForm8.LoadEventsFromTrack(SelectedRow: Integer);
var
  i, n, RowPos, CurrentTrack, j, k: Integer;
  Status, B1, B2, LastStatus, Channel: Byte;
  Kind, MBTStr, D1, D2, D3, D4 ,D5, D6, TextContent: string;
  AbsTick, SearchTick: Int64;
  IsDrum, SkipEvent: Boolean;
  EventData: TBytes;
  WheelValue: Integer;
begin
  IsDrum := (SelectedRow = 10);
  StringGrid1.BeginUpdate;

  try
    for i := 0 to StringGrid1.ColCount - 1 do
      for j := 1 to StringGrid1.RowCount - 1 do
      begin
        StringGrid1.Cells[i, j] := '';
        StringGrid1.Objects[i, j] := nil;
      end;

    StringGrid1.RowCount := 2;
    RowPos := 1; AbsTick := 0; LastStatus := 0;

    if Length(SekwencerMidi.MidiTracks) > 0 then
    begin
      if Length(SekwencerMidi.MidiTracks) = 1 then
        CurrentTrack := 0
      else
        CurrentTrack := SelectedRow - 1;

      if (CurrentTrack >= 0) and (CurrentTrack < Length(SekwencerMidi.MidiTracks)) then
      begin
        for i := 0 to High(SekwencerMidi.MidiTracks[CurrentTrack].Events) do
        begin
          AbsTick := AbsTick + SekwencerMidi.MidiTracks[CurrentTrack].Events[i].DeltaTime;
          EventData := SekwencerMidi.MidiTracks[CurrentTrack].Events[i].Data;
          if Length(EventData) = 0 then Continue;

          Status := EventData[0];
          if Status < $80 then
            Status := LastStatus
          else
            LastStatus := Status;

          Channel := Status and $0F;

          if (Status < $F0) and (Channel <> (SelectedRow - 1)) then Continue;

          if CheckBox2.Checked and (B1 in [$01..$07, $51, $58]) then SkipEvent := True;

          Kind := ''; D1 := ''; D2 := ''; D3 := ''; D4 := ''; D5 := ''; D6 := '';
          SkipEvent := False;
          MBTStr := Form1.GetMidiTimeStr(AbsTick);

          case Status of

            $FF:
            begin
              if Length(EventData) > 2 then
              begin
                B1 := EventData[1];

                if CheckBox2.Checked and (B1 in [$01..$07, $51, $58]) then
                  begin
                    SkipEvent := True;
                  end;

                case B1 of
                  $00: Kind := 'Identifier';
                  $01: Kind := 'Text';
                  $02: Kind := 'Copyright';
                  $03: Kind := 'Track';
                  $04: Kind := 'Instr';
                  $05:
                  begin
                    if SelectedRow = 4 then
                      Kind := 'Lyrics'
                    else
                      Continue;
                  end;
                  $06: Kind := 'Marker';
                  $07: Kind := 'Cue';
                  $08: Kind := 'Patch name';
                  $09: Kind := 'Device';
                  $20: Kind := 'Channel';
                  $21: Kind := 'MCI';
                  $2F: Continue;
                  $51: Kind := 'Tempo';
                  $54: Kind := 'SMPTE';
                  $58: Kind := 'Metrum';
                  $59: Kind := 'Tonacja';
                  $7F: Kind := 'Sysbank';
                else
                  Kind := 'Meta';
                end;

                if Length(EventData) >= 3 then
                begin
                  TextContent := '';
                  for j := 3 to High(EventData) do
                    TextContent := TextContent + Char(EventData[j]);
                end;

                if Kind = 'Tonacja' then
                begin
                  if Length(EventData) >= 5 then
                  begin
                    case ShortInt(EventData[3]) of
                      -7: D5 := 'Cb';
                      -6: D5 := 'Gb';
                      -5: D5 := 'Db';
                      -4: D5 := 'Ab';
                      -3: D5 := 'Eb';
                      -2: D5 := 'Bb';
                      -1: D5 := 'F';
                       0: D5 := 'C';
                       1: D5 := 'G';
                       2: D5 := 'D';
                       3: D5 := 'A';
                       4: D5 := 'E';
                       5: D5 := 'B';
                       6: D5 := 'F#';
                       7: D5 := 'C#';
                    end;

                    if EventData[4] = 0 then
                      D6 := D5 + ' Major'
                    else
                      D6 := D5 + ' Minor';
                  end;
                end
                else
                begin
                  D6 := TextContent;
                end;
              end;
            end;

            $F0, $F7:
            begin
              if CheckBox1.Checked then SkipEvent := True;
              Kind := 'SysData';
              D6 := BytesToHex(EventData);
            end;

          else
            case (Status and $F0) of

              $90:
              begin
                if (Length(EventData) >= 3) and (EventData[2] > 0) then
                begin
                  Kind := 'note';
                  D2 := GetNoteName(EventData[1], IsDrum);
                  D3 := IntToStr(EventData[2]);

                  SearchTick := AbsTick;
                  for k := i + 1 to High(SekwencerMidi.MidiTracks[CurrentTrack].Events) do
                  begin
                    SearchTick := SearchTick + SekwencerMidi.MidiTracks[CurrentTrack].Events[k].DeltaTime;
                    if Length(SekwencerMidi.MidiTracks[CurrentTrack].Events[k].Data) >= 3 then
                    begin
                      B1 := SekwencerMidi.MidiTracks[CurrentTrack].Events[k].Data[0];
                      if (SekwencerMidi.MidiTracks[CurrentTrack].Events[k].Data[1] = EventData[1]) and
                         (((B1 and $F0) = $80) or
                          (((B1 and $F0) = $90) and
                           (SekwencerMidi.MidiTracks[CurrentTrack].Events[k].Data[2] = 0))) then
                      begin
                        D4 := IntToStr(SearchTick - AbsTick);
                        Break;
                      end;
                    end;
                  end;
                end;
              end;

              $A0:
              begin
                if Length(EventData) >= 3 then
                begin
                  Kind := 'KeyAfter';
                  D2 := GetNoteName(EventData[1], IsDrum);
                  D3 := IntToStr(EventData[2]);
                end;
              end;

              $B0:
              begin
                if Length(EventData) >= 3 then
                begin
                  B1 := EventData[1];
                  B2 := EventData[2];

                  if B1 = 11 then
                  begin
                    Kind := 'Expression';
                    D3 := IntToStr(B2);
                  end
                  else
                  if B1 in [98,99] then
                  begin
                    Kind := 'NRPN';
                    D5 := IntToStr(B1);
                    D6 := IntToStr(B2);
                  end
                  else
                  if B1 in [100,101] then
                  begin
                    Kind := 'RPN';
                    D5 := IntToStr(B1);
                    D6 := IntToStr(B2);
                  end
                  else
                  begin
                    Kind := 'Controller';
                    D2 := GetControlName(B1);
                    D5 := IntToStr(B2);
                  end;
                end;
              end;

              $C0:
              begin
                if Length(EventData) >= 2 then
                begin
                  Kind := 'Patch';
                  D2 := 'Normal';
                  D5 := 'Bank ';
                  D6 := IntToStr(EventData[1]);
                end;
              end;

              $D0:
              begin
                if Length(EventData) >= 2 then
                begin
                  Kind := 'ChannelAfter';
                  D5 := IntToStr(EventData[1]);
                end;
              end;

              $E0:
              begin
                if Length(EventData) >= 3 then
                begin
                  Kind := 'Wheel';
                  WheelValue := ((EventData[2] shl 7) or EventData[1]) - 8192;
                  D5 := IntToStr(WheelValue);
                end;
              end;

            end;
          end;

          if SkipEvent or (Kind = '') then Continue;

          if RowPos >= StringGrid1.RowCount then
            StringGrid1.RowCount := RowPos + 1;

          StringGrid1.Cells[0, RowPos] := MBTStr;
          StringGrid1.Cells[1, RowPos] := Kind;
          StringGrid1.Cells[2, RowPos] := D2;
          StringGrid1.Cells[3, RowPos] := D3;
          StringGrid1.Cells[4, RowPos] := D4;
          StringGrid1.Cells[5, RowPos] := D5;
          StringGrid1.Cells[6, RowPos] := D6;

          StringGrid1.Objects[0, RowPos] := TObject(AbsTick);
          StringGrid1.Objects[1, RowPos] := TObject(i);
          StringGrid1.Objects[2, RowPos] := TObject(1);

          Inc(RowPos);
        end;
      end;
    end;

    if RowPos > 1 then
      StringGrid1.RowCount := RowPos
    else
      StringGrid1.RowCount := 2;

  finally
    StringGrid1.EndUpdate;

  end;
end;

function TForm8.GetNoteName(Note: Byte; IsDrum: Boolean): string;
const
  Notes: array[0..11] of string = ('C','C#','D','D#','E','F','F#','G','G#','A','A#','B');
begin
  Result := Notes[Note mod 12] + IntToStr((Note div 12) - 1); // -1 = C-1 jako MIDI 0
end;

function TForm8.GetControlName(CC: Byte): string;
begin
  // DYNAMICZNE POBIERANIE Z COMBOBOX3
  if (Form17.ComboBox3 <> nil) and (CC < Form17.ComboBox3.Items.Count) then
    Result := Form17.ComboBox3.Items[CC]
  else
    case CC of
      1: Result := 'Modulation';
      7: Result := 'Volume';
      10: Result := 'Pan';
      11: Result := 'Expression';
      64: Result := 'Sustain';
      91: Result := 'Reverb';
      98: Result := 'NRPN LSB';
      99: Result := 'NRPN MSB';
      100: Result := 'RPN LSB';
      101: Result := 'RPN MSB';
      else Result := 'Control ' + IntToStr(CC);
    end;
end;

function TForm8.GetEventColor(const Kind: string): TColor;
begin
  if (Kind = 'note') then Result := clBlack
  else if Kind = 'Wheel' then Result := $00FF00FF
  else if (Kind = 'SysData') or (Kind = 'SysBank') then Result := $0000A5FF
  else if (Kind = 'lyrics') or (Kind = 'Lyrics') then Result := clRed
  else if (Kind = 'Controller') or (Kind = 'Expression') or (Kind = 'Control') then Result := $00008000
  else if Kind = 'Patch' then Result := $F54927
  else if (Kind = 'chord') or (Kind = 'hairpin') or (Kind = 'Chord') or (Kind = 'Hairpin') then Result := clTeal
  else if (Kind = 'keyafter') or (Kind = 'ChannelAfter') then Result := clMaroon
  else Result := clBlack;
end;

procedure TForm8.StringGrid1DblClick(Sender: TObject);
var
  ARow, TargetCol: Integer;
  TargetTick: Int64;
  TicksPerCol: Double;
  WasPlaying: Boolean;
begin
  ARow := StringGrid1.Row;
  if (ARow < 1) or (Form1.FPPQ <= 0) then Exit;

  if Assigned(StringGrid1.Objects[0, ARow]) then
  begin
    TargetTick := Int64(StringGrid1.Objects[0, ARow]);

    // Sprawdzamy czy sekwencer gra
    WasPlaying := Form1.Timer1.Enabled;
    if WasPlaying then Form1.Timer1.Enabled := False; // Zatrzymujemy

    Winapi.Windows.LockWindowUpdate(Form1.Handle);
    try
      // USTAWIENIE POZYCJI
      Form1.FCurrentPos := TargetTick;
      Form1.FLastPos := TargetTick;

      TicksPerCol := Form1.FPPQ / 16.0;
      TargetCol := Trunc(TargetTick / TicksPerCol);

      if (TargetCol >= 0) and (TargetCol < Form1.StringGrid2.ColCount) then
      begin
        Form1.StringGrid2.LeftCol := Max(0, TargetCol - 5);
        Form1.StringGrid2.Col := TargetCol;
      end;

      Form1.Edit5.Text := StringReplace(Form1.GetMidiTimeStr(TargetTick), ':', '.', [rfReplaceAll]);
    finally
      Winapi.Windows.LockWindowUpdate(0);
    end;

    Form1.StringGrid2.Repaint;
    Form1.UpdateOverviewMap;

    // Jeœli gra³o - puszczamy od nowej pozycji
    if WasPlaying then Form1.Timer1.Enabled := True;

    FIsManualClick := False;
  end;
end;

procedure TForm8.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  EventTick, NextEventTick: Int64;
  IsCurrentEvent: Boolean;
  Grid: TStringGrid;
  DisplayStr: string;
begin

  Grid := TStringGrid(Sender);
  IsCurrentEvent := False;
  if (Form1.FCurrentPos = EventTick) then
    begin
      IsCurrentEvent := True;
    end
    else if (Form1.FCurrentPos > EventTick) and (Form1.FCurrentPos < NextEventTick) then
    begin
      IsCurrentEvent := True;
     end;

  DisplayStr := Grid.Cells[ACol, ARow];

  if (ARow > 0) and Assigned(Grid.Objects[0, ARow]) then
  begin
    EventTick := Int64(Grid.Objects[0, ARow]);

     DisplayStr := Grid.Cells[ACol, ARow];

    // --- 2. LOGIKA PODŒWIETLANIA (PLAYBACK) ---
    IsCurrentEvent := False;

    if Form1.Timer1.Enabled then
        begin
          if (ARow < Grid.RowCount - 1) and Assigned(Grid.Objects[0, ARow + 1]) then
          NextEventTick := Int64(Grid.Objects[0, ARow + 1])
          else
          NextEventTick := EventTick + 120;

          if (Form1.FCurrentPos >= EventTick) and (Form1.FCurrentPos < NextEventTick) then
          IsCurrentEvent := True;
        end;
   end;

  // --- 3. RYSOWANIE GRAFIKI ---
  if ARow = 0 then Grid.Canvas.Brush.Color := clBtnFace
  else if IsCurrentEvent then Grid.Canvas.Brush.Color := $008080FF
  else if gdSelected in State then Grid.Canvas.Brush.Color := clHighlight
  else Grid.Canvas.Brush.Color := clWhite;

  Grid.Canvas.FillRect(Rect);

  if ARow = 0 then Grid.Canvas.Font.Color := clBlack
  else if IsCurrentEvent then Grid.Canvas.Font.Color := clWhite
  else Grid.Canvas.Font.Color := GetEventColor(Grid.Cells[1, ARow]);

   DrawText(Grid.Canvas.Handle, PChar(DisplayStr), -1, Rect,
           DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);

  // --- 4. AUTO-SCROLL ---
  if IsCurrentEvent and Form1.Timer1.Enabled then
  begin
    if (ARow >= Grid.TopRow + Grid.VisibleRowCount - 3) or (ARow < Grid.TopRow) then
    begin
      TThread.ForceQueue(nil,
        procedure
        begin
          if IsCurrentEvent then
            Grid.TopRow := Max(1, ARow - 2);
        end);
    end;
  end;
end;

procedure TForm8.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  FIsManualClick := True;

    if Button = mbRight then
  begin
    StringGrid1.MouseToCell(X, Y, ACol, ARow);
    if ARow >= StringGrid1.FixedRows then
      StringGrid1.Row := ARow; // TO JEST WYMUSZONE SELECT ROW
  end;
end;

procedure TForm8.StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FIsManualClick := False;
end;

procedure TForm8.StringGrid1SelectCell(Sender: TObject; ACol, ARow: LongInt; var CanSelect: Boolean);
var
  TargetTick: Int64;
  TargetCol: Integer;
begin

  if FUpdatingFromEventView then Exit;

  // --- A. BLOKADA EDYCJI KOLUMNY POZYCJI (MBT) ---
  if ACol = 0 then
    StringGrid1.Options := StringGrid1.Options - [goEditing]
  else
    StringGrid1.Options := StringGrid1.Options + [goEditing];

  if not FIsManualClick then Exit;

  if (ARow < StringGrid1.FixedRows) or (Form1.FPPQ <= 0) then Exit;

  try
    if Assigned(StringGrid1.Objects[0, ARow]) then
    begin
      TargetTick := Int64(StringGrid1.Objects[0, ARow]);

      Winapi.Windows.LockWindowUpdate(Form1.Handle);
      try
        Form1.FCurrentPos := TargetTick;
        Form1.FLastPos := TargetTick;

        TargetCol := Trunc(TargetTick / (Form1.FPPQ / 16.0));

        if (TargetCol >= 0) and (TargetCol < Form1.StringGrid2.ColCount) then
        begin
          Form1.StringGrid2.LeftCol := Max(0, TargetCol - 5);
          Form1.StringGrid2.Col := TargetCol;
        end;

        Form1.Edit5.Text := StringReplace(Form1.GetMidiTimeStr(TargetTick), ':', '.', [rfReplaceAll]);

      finally
        Winapi.Windows.LockWindowUpdate(0);
      end;

      Form1.StringGrid2.Repaint;
      Form1.UpdateOverviewMap;
    end;

  except
  end;

end;

procedure TForm8.UsuZaznaczoneZdarzenie1Click(Sender: TObject);
var
  IdxInArray, DataType, CurrentTrack, j: Integer;
  SavedRow: Integer;
begin
  if (StringGrid1.Row < 1) or (not Assigned(StringGrid1.Objects[2, StringGrid1.Row])) then Exit;

  SavedRow := StringGrid1.Row;
  IdxInArray := Integer(StringGrid1.Objects[1, StringGrid1.Row]);
  DataType := Integer(StringGrid1.Objects[2, StringGrid1.Row]);

  if Length(SekwencerMidi.MidiTracks) = 1 then
    CurrentTrack := 0
  else
    CurrentTrack := Form1.StringGrid2.Row - 1;

  if DataType = 1 then
  begin
    if (CurrentTrack >= 0) and (CurrentTrack < Length(SekwencerMidi.MidiTracks)) then
    begin
      if (IdxInArray >= 0) and (IdxInArray < Length(SekwencerMidi.MidiTracks[CurrentTrack].Events)) then
      begin
        for j := IdxInArray to High(SekwencerMidi.MidiTracks[CurrentTrack].Events) - 1 do
          SekwencerMidi.MidiTracks[CurrentTrack].Events[j] := SekwencerMidi.MidiTracks[CurrentTrack].Events[j + 1];

        SetLength(SekwencerMidi.MidiTracks[CurrentTrack].Events, Length(SekwencerMidi.MidiTracks[CurrentTrack].Events) - 1);
      end;
    end;
  end;

  if DataType = 2 then
  begin
    if (IdxInArray >= 0) and (IdxInArray < SekwencerMidi.MidiNoteCount) then
    begin
      for j := IdxInArray to SekwencerMidi.MidiNoteCount - 2 do
        SekwencerMidi.MidiNotes[j] := SekwencerMidi.MidiNotes[j + 1];

      Dec(SekwencerMidi.MidiNoteCount);
      Form1.RebuildMidiTracksFromNotes;
    end;
  end;

  LoadEventsFromTrack(Form1.StringGrid2.Row);

  if SavedRow >= StringGrid1.RowCount then SavedRow := StringGrid1.RowCount - 1;
  if SavedRow < 1 then SavedRow := 1;
  StringGrid1.Row := SavedRow;

  Form1.UpdateOverviewMap;
  Form1.StringGrid2.Repaint;

  if Assigned(Form7) and Form7.Visible then
    Form7.DrawGrid2.Repaint;
end;

procedure TForm8.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm8.CheckBox1Click(Sender: TObject);
begin
  LoadEventsFromTrack(Form1.StringGrid2.Row);
end;

procedure TForm8.CheckBox2Click(Sender: TObject);
begin
  LoadEventsFromTrack(Form1.StringGrid2.Row);
end;

procedure TForm8.DodajZdarzenie1Click(Sender: TObject);
var
  R: Integer;
begin
  R := StringGrid1.Row;
  if (StringGrid1.Cells[1, R] = 'Tempo')
  or (StringGrid1.Cells[1, R] = 'Metrum')
  or (StringGrid1.Cells[1, R] = 'Tonacja')
  or (StringGrid1.Cells[1, R] = 'Copyright')
  or (StringGrid1.Cells[1, R] = 'Device')
  or (StringGrid1.Cells[1, R] = 'Track')
  or (StringGrid1.Cells[1, R] = 'Cue')
  or (StringGrid1.Cells[1, R] = 'Marker')
  or (StringGrid1.Cells[1, R] = 'SMPTE')
  or (StringGrid1.Cells[1, R] = 'Meta')

  then begin
    ShowMessage('Tutaj nie mo¿esz tego edytowaæ'); Exit;
  end;

  StringGrid1.Options := StringGrid1.Options + [goRowSelect];

  Form17.Edit1.Text := StringGrid1.Cells[0, R];
  Form17.Edit16.Text := StringGrid1.Cells[1, R];
  Form17.Edit19.Text := StringGrid1.Cells[2, R];
  Form17.Edit20.Text := StringGrid1.Cells[3, R];
  Form17.Edit21.Text := StringGrid1.Cells[4, R];
  Form17.Edit22.Text := StringGrid1.Cells[5, R];
  Form17.Edit23.Text := StringGrid1.Cells[6, R];

  if SameText(Form17.Edit16.Text, 'Note') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Color := clWindow;
        Form17.Edit19.ReadOnly := False;

        Form17.Edit20.Color := clWindow;
        Form17.Edit20.ReadOnly := False;

        Form17.Edit21.Color := clWindow;
        Form17.Edit21.ReadOnly := False;

        Form17.Edit22.Text := '';
        Form17.Edit22.Color := cl3DLight;
        Form17.Edit22.ReadOnly := True;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;
  if SameText(Form17.Edit16.Text, 'KeyAfter') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Color := clWindow;
        Form17.Edit19.ReadOnly := False;

        Form17.Edit20.Color := clWindow;
        Form17.Edit20.ReadOnly := false;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Text := '';
        Form17.Edit22.Color := cl3DLight;
        Form17.Edit22.ReadOnly := True;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;

  if SameText(Form17.Edit16.Text, 'Controller') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Color := clWindow;
        Form17.Edit19.ReadOnly := False;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;

  if SameText(Form17.Edit16.Text, 'Patch') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Color := clWindow;
        Form17.Edit19.ReadOnly := False;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Color := clWindow;
        Form17.Edit22.ReadOnly := False;

        Form17.Edit23.Color := clWindow;
        Form17.Edit23.ReadOnly := False;
    end;

  if SameText(Form17.Edit16.Text, 'ChannelAfter') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Color := clWindow;
        Form17.Edit22.ReadOnly := False;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;

  if SameText(Form17.Edit16.Text, 'Wheel') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Color := clWindow;
        Form17.Edit22.ReadOnly := False;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;

  if SameText(Form17.Edit16.Text, 'RPN') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Color := clWindow;
        Form17.Edit22.ReadOnly := False;

        Form17.Edit23.Color := clWindow;
        Form17.Edit23.ReadOnly := False;
    end;

  if SameText(Form17.Edit16.Text, 'NRPN') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Color := clWindow;
        Form17.Edit22.ReadOnly := False;

        Form17.Edit23.Color := clWindow;
        Form17.Edit23.ReadOnly := False;
    end;

  if SameText(Form17.Edit16.Text, 'SysBank') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Color := clWindow;
        Form17.Edit19.ReadOnly := False;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Text := '';
        Form17.Edit22.Color := cl3DLight;
        Form17.Edit22.ReadOnly := True;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;

  if SameText(Form17.Edit16.Text, 'SysData') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Text := '';
        Form17.Edit22.Color := cl3DLight;
        Form17.Edit22.ReadOnly := True;

        Form17.Edit23.Color := clWindow;
        Form17.Edit23.ReadOnly := False;
    end;

  if SameText(Form17.Edit16.Text, 'Text') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Text := '';
        Form17.Edit22.Color := cl3DLight;
        Form17.Edit22.ReadOnly := True;

        Form17.Edit23.Color := clWindow;
        Form17.Edit23.ReadOnly := False;
    end;

   if SameText(Form17.Edit16.Text, 'Lyrics') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Text := '';
        Form17.Edit22.Color := cl3DLight;
        Form17.Edit22.ReadOnly := True;

        Form17.Edit23.Color := clWindow;
        Form17.Edit23.ReadOnly := False;
    end;

  if SameText(Form17.Edit16.Text, 'MCI') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Text := '';
        Form17.Edit22.Color := cl3DLight;
        Form17.Edit22.ReadOnly := True;

        Form17.Edit23.Color := clWindow;
        Form17.Edit23.ReadOnly := False;
    end;

  if SameText(Form17.Edit16.Text, 'Expression') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Color := clWindow;
        Form17.Edit20.ReadOnly := False;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Text := '';
        Form17.Edit22.Color := cl3DLight;
        Form17.Edit22.ReadOnly := True;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;

  if SameText(Form17.Edit16.Text, 'Hairpin') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Color := clWindow;
        Form17.Edit22.ReadOnly := False;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;

  if SameText(Form17.Edit16.Text, 'Chord') then
    begin
        Form17.Edit16.Color := cl3DLight;
        Form17.Edit16.ReadOnly := True;

        Form17.Edit19.Text := '';
        Form17.Edit19.Color := cl3DLight;
        Form17.Edit19.ReadOnly := True;

        Form17.Edit20.Text := '';
        Form17.Edit20.Color := cl3DLight;
        Form17.Edit20.ReadOnly := True;

        Form17.Edit21.Text := '';
        Form17.Edit21.Color := cl3DLight;
        Form17.Edit21.ReadOnly := True;

        Form17.Edit22.Color := clWindow;
        Form17.Edit22.ReadOnly := False;

        Form17.Edit23.Text := '';
        Form17.Edit23.Color := cl3DLight;
        Form17.Edit23.ReadOnly := True;
    end;

  Form17.ShowModal;

end;

procedure TForm8.EdytujZaznaczonezdarzenie1Click(Sender: TObject);
var
  R: Integer;
begin

  R := StringGrid1.Row;
  if (StringGrid1.Cells[1, R] = 'Tempo')
  or (StringGrid1.Cells[1, R] = 'Metrum')
  or (StringGrid1.Cells[1, R] = 'Tonacja')
  or (StringGrid1.Cells[1, R] = 'Copyright')
  or (StringGrid1.Cells[1, R] = 'Device')
  or (StringGrid1.Cells[1, R] = 'Track')
  or (StringGrid1.Cells[1, R] = 'Cue')
  or (StringGrid1.Cells[1, R] = 'Marker')
  or (StringGrid1.Cells[1, R] = 'SMPTE')
  or (StringGrid1.Cells[1, R] = 'Meta')

  then begin
    ShowMessage('Tutaj nie mo¿esz tego edytowaæ'); Exit;
  end;

  StringGrid1.Options := StringGrid1.Options + [goRowSelect];

  Form5.Edit1.Text := StringGrid1.Cells[0, R];
  Form5.Edit16.Text := StringGrid1.Cells[1, R];
  Form5.Edit19.Text := StringGrid1.Cells[2, R];
  Form5.Edit20.Text := StringGrid1.Cells[3, R];
  Form5.Edit21.Text := StringGrid1.Cells[4, R];
  Form5.Edit22.Text := StringGrid1.Cells[5, R];
  Form5.Edit23.Text := StringGrid1.Cells[6, R];

  if SameText(Form5.Edit16.Text, 'Note') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Color := clWindow;
        Form5.Edit19.ReadOnly := False;

        Form5.Edit20.Color := clWindow;
        Form5.Edit20.ReadOnly := False;

        Form5.Edit21.Color := clWindow;
        Form5.Edit21.ReadOnly := False;

        Form5.Edit22.Text := '';
        Form5.Edit22.Color := cl3DLight;
        Form5.Edit22.ReadOnly := True;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := cl3DLight;
        Form5.Edit23.ReadOnly := True;
    end;
  if SameText(Form5.Edit16.Text, 'KeyAfter') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Color := clWindow;
        Form5.Edit19.ReadOnly := False;

        Form5.Edit20.Color := clWindow;
        Form5.Edit20.ReadOnly := false;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Text := '';
        Form5.Edit22.Color := cl3DLight;
        Form5.Edit22.ReadOnly := True;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := cl3DLight;
        Form5.Edit23.ReadOnly := True;
    end;

  if SameText(Form5.Edit16.Text, 'Controller') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Color := clWindow;
        Form5.Edit19.ReadOnly := False;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := cl3DLight;
        Form5.Edit23.ReadOnly := True;
    end;

  if SameText(Form5.Edit16.Text, 'Patch') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Color := clWindow;
        Form5.Edit19.ReadOnly := False;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form5.Edit23.Color := clWindow;
        Form5.Edit23.ReadOnly := False;
    end;

  if SameText(Form5.Edit16.Text, 'ChannelAfter') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := cl3DLight;
        Form5.Edit23.ReadOnly := True;
    end;

  if SameText(Form5.Edit16.Text, 'Wheel') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := cl3DLight;
        Form5.Edit23.ReadOnly := True;
    end;

  if SameText(Form5.Edit16.Text, 'RPN') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form5.Edit23.Color := clWindow;
        Form5.Edit23.ReadOnly := False;
    end;

  if SameText(Form5.Edit16.Text, 'NRPN') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form5.Edit23.Color := clWindow;
        Form5.Edit23.ReadOnly := False;
    end;

  if SameText(Form5.Edit16.Text, 'SysBank') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Color := clWindow;
        Form5.Edit19.ReadOnly := False;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Text := '';
        Form5.Edit22.Color := cl3DLight;
        Form5.Edit22.ReadOnly := True;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := cl3DLight;
        Form5.Edit23.ReadOnly := True;
    end;

  if SameText(Form5.Edit16.Text, 'SysData') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Text := '';
        Form5.Edit22.Color := cl3DLight;
        Form5.Edit22.ReadOnly := True;

        Form5.Edit23.Color := clWindow;
        Form5.Edit23.ReadOnly := False;
    end;

  if SameText(Form5.Edit16.Text, 'Text') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Text := '';
        Form5.Edit22.Color := cl3DLight;
        Form5.Edit22.ReadOnly := True;

        Form5.Edit23.Color := clWindow;
        Form5.Edit23.ReadOnly := False;
    end;

   if SameText(Form5.Edit16.Text, 'Lyrics') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Text := '';
        Form5.Edit22.Color := cl3DLight;
        Form5.Edit22.ReadOnly := True;

        Form5.Edit23.Color := clWindow;
        Form5.Edit23.ReadOnly := False;
    end;

  if SameText(Form5.Edit16.Text, 'MCI') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Text := '';
        Form5.Edit22.Color := cl3DLight;
        Form5.Edit22.ReadOnly := True;

        Form5.Edit23.Color := clWindow;
        Form5.Edit23.ReadOnly := False;
    end;

  if SameText(Form5.Edit16.Text, 'Expression') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Color := clWindow;
        Form5.Edit20.ReadOnly := False;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Text := '';
        Form5.Edit22.Color := cl3DLight;
        Form5.Edit22.ReadOnly := True;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := cl3DLight;
        Form5.Edit23.ReadOnly := True;
    end;

  if SameText(Form5.Edit16.Text, 'Hairpin') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := clWindow;
        Form5.Edit23.ReadOnly := False;
    end;

  if SameText(Form5.Edit16.Text, 'Chord') then
    begin
        Form5.Edit16.Color := cl3DLight;
        Form5.Edit16.ReadOnly := True;

        Form5.Edit19.Text := '';
        Form5.Edit19.Color := cl3DLight;
        Form5.Edit19.ReadOnly := True;

        Form5.Edit20.Text := '';
        Form5.Edit20.Color := cl3DLight;
        Form5.Edit20.ReadOnly := True;

        Form5.Edit21.Text := '';
        Form5.Edit21.Color := cl3DLight;
        Form5.Edit21.ReadOnly := True;

        Form5.Edit22.Color := clWindow;
        Form5.Edit22.ReadOnly := False;

        Form5.Edit23.Text := '';
        Form5.Edit23.Color := cl3DLight;
        Form5.Edit23.ReadOnly := True;
    end;

  Form5.ShowModal;

end;

procedure TForm8.SpeedButton1Click(Sender: TObject);
begin
  Form1.SpeedButton1Click(Sender);
end;

procedure TForm8.SpeedButton2Click(Sender: TObject);
begin
  Form1.SpeedButton2Click(Sender);
end;

procedure TForm8.SpeedButton3Click(Sender: TObject);
begin
  Form1.SpeedButton3Click(Sender);
end;

procedure TForm8.SpeedButton5Click(Sender: TObject);
begin
  Form1.SpeedButton5Click(Sender);
end;

end.
