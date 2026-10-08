unit Unit7;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Grids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Dialogs,
  Vcl.StdCtrls, System.Math, Vcl.Buttons, Winapi.MMSystem;

type
  TForm7 = class(TForm)
    DrawGrid1: TDrawGrid;
    Splitter1: TSplitter;
    DrawGrid2: TDrawGrid;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    Panel3: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Panel4: TPanel;
    Button4: TButton;
    Panel5: TPanel;
    Button3: TButton;
    Panel6: TPanel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure DrawGrid2DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure DrawGridTopLeftChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure DrawGrid2SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DrawGrid2TopLeftChanged(Sender: TObject);
    procedure DrawGrid1TopLeftChanged(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure DrawGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGrid2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DrawGrid2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGrid2DblClick(Sender: TObject);
  private
    FDragOffsetTicks: Integer;
    FDragStartTick: Integer;
    FDragStartNote: Integer;
    OldGrid1Proc, OldGrid2Proc: TWndMethod;
    procedure Grid1WindowProc(var Message: TMessage);
    procedure Grid2WindowProc(var Message: TMessage);
    function IsBlackKey(ARow: Integer): Boolean;
    function GetNoteName(ARow: Integer): string;
  public
    FDeleteMode: Boolean;
    FEditMode: Boolean;
    FLastPreviewNote: Integer;
    FIsDragging: Boolean;
    FIsResizing: Boolean;
    FDragNoteIndex: Integer;
    FStartCol: Integer; // do obliczania zmiany długości/pozycji
    FIsSyncingInternal: Boolean; // Publiczna, by Timer w Form1 mógł ją sprawdzać
    SelectedTrackID: Integer;
    procedure EnsureGridSize;
    procedure ResetAllModes;
    procedure PlayNote(ANote: Byte; AVelocity: Byte; ADuration: Integer = 100);
    function IsNoteOverlapping(ANoteIndex: Integer): Boolean;

  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

uses SekwencerMidi, Unit8, Unit11;

// --- SYNCHRONIZACJA PRZEWIJANIA PIONOWEGO (Z BLOKADĄ SZARPANIA) ---


procedure TForm7.PlayNote(ANote: Byte; AVelocity: Byte; ADuration: Integer = 100);
var
  Msg: DWORD;
  TrackIndex: Integer;
begin
  if (Form1.FMidiOut = 0) then Exit; // Jeśli wyjście MIDI nie jest otwarte, wyjdź

  TrackIndex := SelectedTrackID - 1;
  if (TrackIndex < 0) or (TrackIndex > 15) then TrackIndex := 0;

  // Budujemy komunikat MIDI Note On: $90 + Kanał, Nuta, Velocity
  Msg := $90 or TrackIndex or (ANote shl 8) or (AVelocity shl 16);
  midiOutShortMsg(Form1.FMidiOut, Msg);

  // Opcjonalnie: Note Off po krótkim czasie (aby nuta nie "wisiała")
  // W przypadku Piano Roll najlepiej wysłać Note Off przy MouseUp lub po krótkim czasie
  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(ADuration);
      Msg := $80 or TrackIndex or (ANote shl 8) or (0 shl 16);
      midiOutShortMsg(Form1.FMidiOut, Msg);
    end).Start;
end;


procedure TForm7.ResetAllModes;
begin
  // Reset zmiennych logicznych
  FEditMode := False;
  FDeleteMode := False;
  // Jeśli masz zmienną dla Button3 (np. FOtherMode), też ją tu wyłącz

  // Reset wizualny Button 1 (Panel 6)
  Button1.StyleElements := Button1.StyleElements + [seFont];
  Button1.Font.Style := [];
  Panel6.Color := clBtnFace;

  // Reset wizualny Button 4 (Panel 4)
  Button4.StyleElements := Button4.StyleElements + [seFont];
  Button4.Font.Style := [];
  Panel4.Color := clBtnFace;

  // Reset wizualny Button 3 (Panel 5)
  Button3.StyleElements := Button3.StyleElements + [seFont];
  Button3.Font.Style := [];
  Panel5.Color := clBtnFace;
end;


procedure TForm7.Grid1WindowProc(var Message: TMessage);
begin
  if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_MOUSEWHEEL) then
  begin
    FIsSyncingInternal := True;
    try
      OldGrid1Proc(Message);
      DrawGrid2.TopRow := DrawGrid1.TopRow;
    finally
      FIsSyncingInternal := False;
    end;
  end else OldGrid1Proc(Message);
end;

procedure TForm7.Grid2WindowProc(var Message: TMessage);
begin
  if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_MOUSEWHEEL) then
  begin
    FIsSyncingInternal := True;
    try
      OldGrid2Proc(Message);
      DrawGrid1.TopRow := DrawGrid2.TopRow;
    finally
      FIsSyncingInternal := False;
    end;
  end else OldGrid2Proc(Message);
end;

// --- LOGIKA MIDI ---

function TForm7.IsBlackKey(ARow: Integer): Boolean;
var Note: Integer;
begin
  Note := (127 - ARow) mod 12;
  Result := (Note = 1) or (Note = 3) or (Note = 6) or (Note = 8) or (Note = 10);
end;

function TForm7.GetNoteName(ARow: Integer): string;
const Names: array[0..11] of string = ('C','C#','D','D#','E','F','F#','G','G#','A','A#','B');
begin
  Result := Names[(127 - ARow) mod 12] + IntToStr((127 - ARow) div 12 - 1);
end;

procedure TForm7.EnsureGridSize;
begin
  DrawGrid1.ColCount := 1;
  DrawGrid1.RowCount := 128;
  DrawGrid1.FixedRows := 1;
  DrawGrid1.DefaultRowHeight := 20;

  DrawGrid2.RowCount := 128;
  DrawGrid2.ColCount := Form1.StringGrid2.ColCount;
  DrawGrid2.FixedRows := 1;
  DrawGrid2.DefaultRowHeight := 20;
  DrawGrid2.DefaultColWidth := 15;
  DrawGrid2.GridLineWidth := 0;
end;

// --- KLIKNIĘCIE W PIANO ROLL (Z BLOKADĄ PRZESKAKIWANIA EKRANU) ---

procedure TForm7.DrawGrid2SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  TicksPC, BPM, ElapsedSecAtClick: Double;
  NowQPC: Int64;
  SavedLeftCol: Integer;
  i: Integer;
  P: TPoint;
  MouseX: Integer;
  NoteStartCol, NoteEndCol: Integer;
  ClickedOnNote: Boolean;
begin
  SavedLeftCol := DrawGrid2.LeftCol;
  TicksPC := Form1.FPPQ / 16.0;

  ClickedOnNote := False;

  // SPRAWDZAMY CZY KLIKNIĘTO NUTĘ
  for i := 0 to MidiNoteCount - 1 do
  begin
    if (MidiNotes[i].Note = (127 - ARow)) and
       (MidiNotes[i].Channel = SelectedTrackID - 1) then
    begin
      NoteStartCol := Trunc(MidiNotes[i].StartTick / TicksPC);
      NoteEndCol := Trunc((MidiNotes[i].StartTick + MidiNotes[i].Duration) / TicksPC);

      if (ACol >= NoteStartCol) and (ACol <= NoteEndCol) then
      begin
        ClickedOnNote := True;
        Break;
      end;
    end;
  end;

  // JEŚLI KLIK W NUTĘ → tylko zaznaczenie, bez przesuwania kursora
  if ClickedOnNote then
  begin
    DrawGrid2.LeftCol := SavedLeftCol;
    Exit; // wychodzimy z procedury, nic nie zmieniamy
  end;

  // === REAKCJA NA KLIKNIĘCIE W PUSTE MIEJSCE ===
  if not FDeleteMode then
  begin
    if (Form1.FPPQ > 0) and (ACol >= 0) then
    begin
      TicksPC := Form1.FPPQ / 16.0;

      // Pobieramy pozycję myszy względem komponentu DrawGrid2
      P := DrawGrid2.ScreenToClient(Mouse.CursorPos);
      MouseX := P.X;

      // Obliczamy ticki na podstawie pikseli:
      Form1.FCurrentPos := Round((( (DrawGrid2.LeftCol * DrawGrid2.DefaultColWidth) + MouseX ) / DrawGrid2.DefaultColWidth ) * TicksPC);

      Form1.FLastPos := Form1.FCurrentPos;

      if Form1.Timer1.Enabled then
      begin
        BPM := StrToFloatDef(StringReplace(Form1.Edit1.Text, ',', '.', [rfReplaceAll]), 120.0);
        ElapsedSecAtClick := Form1.FCurrentPos / ((BPM / 60.0) * Form1.FPPQ);
        QueryPerformanceCounter(NowQPC);
        Form1.FStartQPC := NowQPC - Round(ElapsedSecAtClick * Form1.FQPCFreq);
        for i := 0 to MidiNoteCount - 1 do MidiNotes[i].Active := False;
      end;

      DrawGrid2.Invalidate;
      Form1.StringGrid2.Invalidate;
      Form7.Edit1.Text := StringReplace(Form1.GetMidiTimeStr(Form1.FCurrentPos), ':', '.', [rfReplaceAll]);
    end;
  end;

  DrawGrid2.LeftCol := SavedLeftCol;
end;


procedure TForm7.DrawGrid2TopLeftChanged(Sender: TObject);
begin
 DrawGrid1.TopRow := DrawGrid2.TopRow;
end;

procedure TForm7.FormCreate(Sender: TObject);
var
  C3Row: Integer;
  TotalTicks, PPQ, Numerator: Integer;
  Bar, Beat, RemainingTick: Integer;
begin

  TotalTicks := StrToIntDef(Edit1.Text, 0);
  PPQ := Form1.FPPQ;
  Numerator := Form1.FNumerator;

  // Matematyka Yamahy:
  Bar := (TotalTicks div (PPQ * Numerator)) + 1;
  Beat := ((TotalTicks mod (PPQ * Numerator)) div PPQ) + 1;
  RemainingTick := TotalTicks mod PPQ;


  DrawGrid1.DoubleBuffered := True;
  DrawGrid2.DoubleBuffered := True;

  FDeleteMode := False;

  DrawGrid1.DoubleBuffered := True;
  DrawGrid1.Width := 120; // Twoja nienaruszalna szerokość
  Splitter1.MinSize := 120;
  FIsSyncingInternal := False;
  //ustawienie ekranu z form1

  C3Row := 114 - 35;
  DrawGrid2.TopRow := Max(0, C3Row - 5);
  DrawGrid2.LeftCol := Form1.StringGrid2.LeftCol;

  OldGrid1Proc := DrawGrid1.WindowProc;
  OldGrid2Proc := DrawGrid2.WindowProc;
  DrawGrid1.WindowProc := Grid1WindowProc;
  DrawGrid2.WindowProc := Grid2WindowProc;

  DrawGrid2.OnMouseDown := DrawGrid2MouseDown;
  EnsureGridSize;

end;

procedure TForm7.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  NewTopRow: Integer;
  MaxTopRow: Integer;
begin
  Handled := True;

  // Obliczamy max dopuszczalny scroll (żeby nie było pustego miejsca na dole)
  MaxTopRow := DrawGrid2.RowCount - DrawGrid2.VisibleRowCount;
  if MaxTopRow < DrawGrid2.FixedRows then MaxTopRow := DrawGrid2.FixedRows;

  if ssShift in Shift then
  begin
    // POZIOMO (Shift + Scroll)
    if WheelDelta > 0 then
      DrawGrid2.LeftCol := Max(0, DrawGrid2.LeftCol - 3)
    else
      DrawGrid2.LeftCol := Min(DrawGrid2.ColCount - 1, DrawGrid2.LeftCol + 3);
  end
  else
  begin
    // PIONOWO
    if WheelDelta > 0 then
      NewTopRow := DrawGrid2.TopRow - 3
    else
      NewTopRow := DrawGrid2.TopRow + 3;

    // Aplikujemy bezpieczny zakres
    DrawGrid2.TopRow := System.Math.EnsureRange(NewTopRow, DrawGrid2.FixedRows, MaxTopRow);

    // SYNCHRONIZACJA KLAWIATURY (DrawGrid1)
    DrawGrid1.TopRow := DrawGrid2.TopRow;
  end;
end;

procedure TForm7.FormShow(Sender: TObject);
var C4Row: Integer;
begin
  // Ustawienie widoku na wysokości oktawy C4 (MIDI 60 -> Wiersz 67)
  C4Row := 67;
  DrawGrid1.TopRow := Max(0, C4Row - (DrawGrid1.VisibleRowCount div 2));
  DrawGrid2.TopRow := DrawGrid1.TopRow;

  DrawGrid1.RowHeights[0] := 30;
  DrawGrid2.RowHeights[0] := 30;

end;

procedure TForm7.FormActivate(Sender: TObject);
begin
  EnsureGridSize;
  DrawGrid2.LeftCol := Form1.StringGrid2.LeftCol;
  DrawGrid2.TopRow := DrawGrid1.TopRow;
  DrawGrid2.Repaint;
end;

procedure TForm7.DrawGridTopLeftChanged(Sender: TObject);
begin
  if FIsSyncingInternal then Exit;
  if Sender = DrawGrid1 then DrawGrid2.TopRow := DrawGrid1.TopRow
  else DrawGrid1.TopRow := DrawGrid2.TopRow;
end;

procedure TForm7.SpeedButton1Click(Sender: TObject);
begin
  Form1.SpeedButton1Click(Sender);
end;

procedure TForm7.SpeedButton2Click(Sender: TObject);
begin
  Form1.SpeedButton2Click(Sender);
end;

procedure TForm7.SpeedButton3Click(Sender: TObject);
begin
  Form1.SpeedButton3Click(Sender);
end;

procedure TForm7.SpeedButton5Click(Sender: TObject);
begin
  Form1.SpeedButton5Click(Sender);
end;

procedure TForm7.Splitter1CanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
begin NewSize := 120; Accept := False; end;

procedure TForm7.Button1Click(Sender: TObject);
var
  LWasActive: Boolean;
begin
  LWasActive := FEditMode;
  ResetAllModes; // Wyłącza wszystko

  if not LWasActive then // Jeśli nie był aktywny, włącz go
  begin
    FEditMode := True;
    Button1.StyleElements := Button1.StyleElements - [seFont];
    Button1.Font.Style := [fsBold];
    Panel6.Color := clBlue;
  end;
end;

procedure TForm7.Button4Click(Sender: TObject);
var
  LWasActive: Boolean;
begin
  LWasActive := FDeleteMode;
  ResetAllModes; // Wyłącza wszystko

  if not LWasActive then
  begin
    FDeleteMode := True;
    Button4.StyleElements := Button4.StyleElements - [seFont];
    Button4.Font.Style := [fsBold];
    Panel4.Color := clRed;
  end;
end;

procedure TForm7.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var KeyRect: TRect;
begin
  DrawGrid1.ColWidths[0] := DrawGrid1.ClientWidth;
  if ARow = 0 then
  begin
    DrawGrid1.Canvas.Brush.Color := clBtnFace;
    DrawGrid1.Canvas.FillRect(Rect);
    DrawGrid1.Canvas.TextOut(Rect.Left + 5, Rect.Top + 2, 'Klawisz');
  end
  else
  begin
    DrawGrid1.Canvas.Brush.Color := clWhite;
    DrawGrid1.Canvas.FillRect(Rect);
    if IsBlackKey(ARow) then
    begin
      DrawGrid1.Canvas.Brush.Color := clBlack;
      KeyRect := Rect;
      KeyRect.Right := Rect.Left + (Rect.Width * 2 div 3);
      DrawGrid1.Canvas.FillRect(KeyRect);
    end
    else
    begin
      DrawGrid1.Canvas.Font.Size := 10;
      DrawGrid1.Canvas.Font.Color := clGray;
      DrawGrid1.Canvas.TextOut(Rect.Left + (Rect.Width * 2 div 3) + 4, Rect.Top + 2, GetNoteName(ARow));
    end;
    DrawGrid1.Canvas.Pen.Color := clSilver;
    DrawGrid1.Canvas.Brush.Style := bsClear;
    DrawGrid1.Canvas.Rectangle(Rect);
    DrawGrid1.Canvas.Brush.Style := bsSolid;
  end;
end;

procedure TForm7.DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  DrawGrid1.MouseToCell(X, Y, ACol, ARow);
  if (ARow > 0) and (Button = mbLeft) then
  begin
    FLastPreviewNote := 127 - ARow;
    // Używamy tej samej procedury co przy wstawianiu nut!
    // velocity 127, czas trwania 200ms (lub 0 jeśli obsługujesz MouseUp)
    PlayNote(FLastPreviewNote, 127, 200);
  end;
end;

procedure TForm7.DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Msg: DWORD;
  TrackIndex: Integer;
begin
  if FLastPreviewNote <> -1 then
  begin
    TrackIndex := SelectedTrackID - 1;
    if (TrackIndex < 0) or (TrackIndex > 15) then TrackIndex := 0;

    // Wysyłamy Note Off ($80) dla zapamiętanej nuty
    Msg := $80 or TrackIndex or (FLastPreviewNote shl 8) or (0 shl 16);
    midiOutShortMsg(Form1.FMidiOut, Msg);

    FLastPreviewNote := -1;
  end;
end;

procedure TForm7.DrawGrid1TopLeftChanged(Sender: TObject);
begin
  DrawGrid1.TopRow := DrawGrid2.TopRow;
end;

procedure TForm7.DrawGrid2DblClick(Sender: TObject);
begin
  Button3Click(Sender);
end;

function TForm7.IsNoteOverlapping(ANoteIndex: Integer): Boolean;
var
  i: Integer;
  StartA, EndA, StartB, EndB: Integer;
begin
  Result := False;
  if (ANoteIndex < 0) or (ANoteIndex >= MidiNoteCount) then Exit;

  StartA := MidiNotes[ANoteIndex].StartTick;
  EndA := StartA + MidiNotes[ANoteIndex].Duration;

  for i := 0 to MidiNoteCount - 1 do
  begin
    // Nie sprawdzamy nuty z samą sobą, nut usuniętych (255) i tylko ten sam kanał i ta sama nuta (Pitch)
    if (i <> ANoteIndex) and (MidiNotes[i].Note = MidiNotes[ANoteIndex].Note) and
       (MidiNotes[i].Channel = MidiNotes[ANoteIndex].Channel) and (MidiNotes[i].Note < 128) then
    begin
      StartB := MidiNotes[i].StartTick;
      EndB := StartB + MidiNotes[i].Duration;

      // Logika nachodzenia na siebie odcinków czasu:
      if (StartA < EndB) and (EndA > StartB) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;


procedure TForm7.DrawGrid2DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S, UpperS: string;
  TicksPerCol, TicksPerBeat: Double;
  ColsPerBar, ColsPerBeat: Integer;
  m, MarkerCol, BarStartCol, PianoCursorX, TargetChannel, i, XStart, XEnd: Integer;
  TextR, NoteRect: TRect;
  IsSection: Boolean;
begin
  // --- POPRAWKA: TŁO ZAWSZE TAKIE SAMO (PRZEZROCZYSTY FOCUS) ---
    if ARow = 0 then
    DrawGrid2.Canvas.Brush.Color := $E0E0E0
  else if IsBlackKey(ARow) then
    DrawGrid2.Canvas.Brush.Color := $F4F4F4
  else
    DrawGrid2.Canvas.Brush.Color := clWhite;

  // TO JEST KLUCZ: Wypełniamy Rect i czyścimy flagę gdSelected dla Canvasu
  DrawGrid2.Canvas.FillRect(Rect);

  // Jeśli system nadal próbuje rysować focus/selection, "oszukujemy" go,
  // resetując kolor tła Canvasu na taki sam jak przed chwilą:
  SetBkColor(DrawGrid2.Canvas.Handle, ColorToRGB(DrawGrid2.Canvas.Brush.Color));

  // --- A. LOGIKA METRUM ---
  if Form1.FPPQ <= 0 then Form1.FPPQ := 480;
  if Form1.FNumerator <= 0 then Form1.FNumerator := 4;
  if Form1.FDenominator <= 0 then Form1.FDenominator := 4;

  TicksPerCol := Form1.FPPQ / 16.0;
  TicksPerBeat := Form1.FPPQ * (4 / Form1.FDenominator);
  ColsPerBeat := Round(TicksPerBeat / TicksPerCol);
  ColsPerBar  := Form1.FNumerator * ColsPerBeat;

  // RESETUJEMY PEN NA START KAŻDEJ KOMÓRKI
  DrawGrid2.Canvas.Pen.Width := 1;
  DrawGrid2.Canvas.Pen.Style := psSolid;

  // --- B. NAGŁÓWEK (ARow = 0) ---
  if ARow = 0 then
  begin
    DrawGrid2.Canvas.Brush.Color := $E0E0E0;
    DrawGrid2.Canvas.FillRect(Rect);
    SetBkMode(DrawGrid2.Canvas.Handle, TRANSPARENT);

    // 1. MARKERY
    for m := 0 to Form1.MidiMarkerCount - 1 do
    begin
      S := Trim(Form1.MidiMarkers[m].Name);
      UpperS := UpperCase(S);
      IsSection := (Pos('MAIN', UpperS) > 0) or (Pos('INTRO', UpperS) > 0) or
                   (Pos('ENDING', UpperS) > 0) or (Pos('FILL', UpperS) > 0) or
                   (Pos('SECTION', UpperS) > 0) or (Pos('SINT', UpperS) > 0);

      if not IsSection then Continue;
      MarkerCol := Trunc(Form1.MidiMarkers[m].Tick / TicksPerCol);

      if ACol = MarkerCol then
      begin
        DrawGrid2.Canvas.Pen.Color := clWebOrange;
        DrawGrid2.Canvas.MoveTo(Rect.Left, Rect.Top);
        DrawGrid2.Canvas.LineTo(Rect.Left, Rect.Bottom);
      end;

      if (ACol >= MarkerCol) and (ACol < MarkerCol + 15) then
      begin
        if Pos(':', S) > 0 then S := Copy(S, Pos(':', S) + 1, MaxInt);
        S := Trim(S);
        DrawGrid2.Canvas.Font.Color := clRed;
        DrawGrid2.Canvas.Font.Style := [];
        DrawGrid2.Canvas.Font.Size := 8;
        TextR := Rect;
        TextR.Left := Rect.Left - (ACol - MarkerCol) * (DrawGrid2.DefaultColWidth);
        TextR.Top := Rect.Top + 14;
        TextR.Right := TextR.Left + 500;
        DrawText(DrawGrid2.Canvas.Handle, PChar(S), Length(S), TextR, DT_LEFT or DT_TOP or DT_NOCLIP);
        Break;
      end;
    end;

    // 2. NUMER TAKTU
    BarStartCol := (ACol div ColsPerBar) * ColsPerBar;
    if (ACol >= BarStartCol) and (ACol < BarStartCol + 8) then
    begin
      S := IntToStr((BarStartCol div ColsPerBar) + 1);
      DrawGrid2.Canvas.Font.Color := clBlack;
      DrawGrid2.Canvas.Font.Style := [];
      DrawGrid2.Canvas.Font.Size := 9;
      TextR := Rect;
      TextR.Left := Rect.Left - (ACol - BarStartCol) * (DrawGrid2.DefaultColWidth) + 2;
      TextR.Top := Rect.Top;
      TextR.Right := TextR.Left + 200;
      DrawText(DrawGrid2.Canvas.Handle, PChar(S), Length(S), TextR, DT_LEFT or DT_TOP or DT_NOCLIP);
    end;

    if ACol mod ColsPerBar = 0 then
    begin
      DrawGrid2.Canvas.Pen.Color := clBlack;
      DrawGrid2.Canvas.MoveTo(Rect.Left, Rect.Top);
      DrawGrid2.Canvas.LineTo(Rect.Left, Rect.Bottom);
    end;
    Exit;
  end;

  // --- C. TŁO I SIATKA ---
  // Rysujemy siatkę (Tło już narysowane na początku)
  DrawGrid2.Canvas.Pen.Width := 1;
  if (ACol mod ColsPerBar = 0) then DrawGrid2.Canvas.Pen.Color := clGray
  else if (ACol mod ColsPerBeat = 0) then DrawGrid2.Canvas.Pen.Color := clSilver
  else DrawGrid2.Canvas.Pen.Color := $F0F0F0;

  DrawGrid2.Canvas.MoveTo(Rect.Left, Rect.Top);
  DrawGrid2.Canvas.LineTo(Rect.Left, Rect.Bottom);

  // --- D. RYSOWANIE NUT (POPRAWIONA MATEMATYKA) ---
  // --- D. RYSOWANIE NUT (MIN 15 TICKÓW, TWOJA LOGIKA RAMKI) ---
  TargetChannel := SelectedTrackID - 1;
  for i := 0 to MidiNoteCount - 1 do
  begin
    if (MidiNotes[i].Note = (127 - ARow)) and (MidiNotes[i].Channel = TargetChannel) and (MidiNotes[i].Note < 128) then
    begin
      // 1. OBLICZENIA WIZUALNE (MINIMUM 15)
      var VisualDur: Integer;
      VisualDur := MidiNotes[i].Duration;
      if VisualDur < 15 then VisualDur := 15;

      XStart := Round(((MidiNotes[i].StartTick / TicksPerCol) - ACol) * Rect.Width);
      XEnd := Round((((MidiNotes[i].StartTick + VisualDur) / TicksPerCol) - ACol) * Rect.Width);

      if (XEnd > 0) and (XStart < Rect.Width) then
      begin
        NoteRect.Top := Rect.Top + 1;
        NoteRect.Bottom := Rect.Bottom - 1;
        NoteRect.Left := Rect.Left + Max(0, XStart);
        NoteRect.Right := Rect.Left + Min(Rect.Width, XEnd);

        if NoteRect.Left < NoteRect.Right then
        begin
          DrawGrid2.Canvas.Brush.Style := bsSolid;

          // 2. KOLORYSTYKA (ZIELONY DLA < 15)
          if i = FDragNoteIndex then
            DrawGrid2.Canvas.Brush.Color := clYellow
          else if MidiNotes[i].Duration < 15 then
            DrawGrid2.Canvas.Brush.Color := clLime
          else if IsNoteOverlapping(i) then
            DrawGrid2.Canvas.Brush.Color := clWebLightCoral
          else
            DrawGrid2.Canvas.Brush.Color := $FFAA55;

          DrawGrid2.Canvas.FillRect(NoteRect);

          // 3. TWOJA LOGIKA RAMKI (BEZ KRESKOWANIA)
          DrawGrid2.Canvas.Pen.Color := clNavy;
          DrawGrid2.Canvas.Pen.Width := 1;

          // Linie poziome (Góra i Dół)
          DrawGrid2.Canvas.MoveTo(NoteRect.Left, NoteRect.Top);
          DrawGrid2.Canvas.LineTo(NoteRect.Right, NoteRect.Top);
          DrawGrid2.Canvas.MoveTo(NoteRect.Left, NoteRect.Bottom - 1);
          DrawGrid2.Canvas.LineTo(NoteRect.Right, NoteRect.Bottom - 1);

          // Linie pionowe (Początek i Koniec nuty - tylko jeśli widać krawędź)
          if (XStart >= 0) and (XStart < Rect.Width) then
          begin
            DrawGrid2.Canvas.MoveTo(NoteRect.Left, NoteRect.Top);
            DrawGrid2.Canvas.LineTo(NoteRect.Left, NoteRect.Bottom);
          end;

          if (XEnd > 0) and (XEnd <= Rect.Width) then
          begin
            DrawGrid2.Canvas.MoveTo(NoteRect.Right - 1, NoteRect.Top);
            DrawGrid2.Canvas.LineTo(NoteRect.Right - 1, NoteRect.Bottom);
          end;
        end;
      end;
    end;
  end;


  // --- E. KURSOR (ZABEZPIECZONY) ---
  PianoCursorX := Round(((Max(0, Form1.FCurrentPos) / TicksPerCol) - ACol) * Rect.Width);
  if (PianoCursorX >= 0) and (PianoCursorX < Rect.Width) then
  begin
    DrawGrid2.Canvas.Pen.Color := clRed;
    DrawGrid2.Canvas.Pen.Width := 2;
    DrawGrid2.Canvas.MoveTo(Rect.Left + PianoCursorX, Rect.Top);
    DrawGrid2.Canvas.LineTo(Rect.Left + PianoCursorX, Rect.Bottom);
    DrawGrid2.Canvas.Pen.Width := 1;

    if (FDragNoteIndex = -1) then
      Edit1.Text := StringReplace(Form1.GetMidiTimeStr(Max(0, Form1.FCurrentPos)), ':', '.', [rfReplaceAll]);
  end;

  // UKRYWANIE FOCUS RECT (INWERSJA)
  if gdFocused in State then
  begin
    DrawGrid2.Canvas.DrawFocusRect(Rect);
  end;
end;

procedure TForm7.DrawGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow, i, NoteStartCol, NoteEndCol: Integer;
  TicksPC: Double;
  FoundAny: Boolean;
begin
  DrawGrid2.MouseToCell(X, Y, ACol, ARow);
  if (ACol < 0) or (ARow < 0) then Exit;

  if Form1.FPPQ > 0 then TicksPC := Form1.FPPQ / 16.0 else TicksPC := 1.0;

  FoundAny := False;
  FIsDragging := False;
  FIsResizing := False;

  // =========================
  // SZUKAMY NUTY POD MYSZĄ
  // =========================

  for i := 0 to MidiNoteCount - 1 do
  begin
    if (MidiNotes[i].Note = (127 - ARow)) and
       (MidiNotes[i].Channel = SelectedTrackID - 1) and
       (MidiNotes[i].Note < 128) then
    begin
      NoteStartCol := Trunc(MidiNotes[i].StartTick / TicksPC);
      NoteEndCol := Trunc((MidiNotes[i].StartTick + MidiNotes[i].Duration) / TicksPC);

      if (ACol >= NoteStartCol) and (ACol <= NoteEndCol) then
      begin
        FDragNoteIndex := i; // ZAPAMIĘTUJEMY NUTĘ
        FoundAny := True;
        Break;
      end;
    end;
  end;

    if not FoundAny then
        begin
          FDragNoteIndex := -1;
        end;

  // =========================
  // TRYB USUWANIA
  // =========================
  if FDeleteMode and (Button = mbLeft) and FoundAny then
  begin
    MidiNotes[FDragNoteIndex].Note := 255;
    MidiNotes[FDragNoteIndex].Active := False;
    FDragNoteIndex := -1;
    Form1.UpdateOverviewMap;
    DrawGrid2.Invalidate;
    Exit;
  end;

  // =========================
  // TRYB EDYCJI (Button1 ON)
  // =========================
  if FEditMode then
  begin
    if FoundAny then
    begin
      // tylko zmiana długości
      FIsResizing := True;
      FIsDragging := False;

      // Zapamiętujemy pozycję kliknięcia do poprawnego Delta-Resize
      FDragStartTick := Round((ACol * TicksPC) + ((X mod DrawGrid2.DefaultColWidth) / DrawGrid2.DefaultColWidth * TicksPC));

      PlayNote(MidiNotes[FDragNoteIndex].Note, 100, 150);
    end
    else if (Button = mbLeft) then
    begin
      // wstawianie nowej nuty
      if CheckBox1.Checked then
          MidiNotes[MidiNoteCount].StartTick := Round(ACol * TicksPC)
        else
          MidiNotes[MidiNoteCount].StartTick :=
          Round((ACol * TicksPC) +
          ((X mod DrawGrid2.DefaultColWidth) /
          DrawGrid2.DefaultColWidth * TicksPC));

      MidiNotes[MidiNoteCount].Duration := Round(TicksPC);
      MidiNotes[MidiNoteCount].Note := 127 - ARow;
      MidiNotes[MidiNoteCount].Channel := SelectedTrackID - 1;
      MidiNotes[MidiNoteCount].Velocity := 100;

      FDragNoteIndex := MidiNoteCount;
      Inc(MidiNoteCount);

      // Ustawiamy flagi, aby nowo wstawiona nuta mogła być od razu rozciągana
      FIsDragging := False;
      FIsResizing := True;
      FDragStartTick := Round((ACol * TicksPC) + ((X mod DrawGrid2.DefaultColWidth) / DrawGrid2.DefaultColWidth * TicksPC));

      Form1.UpdateOverviewMap;
    end;
  end
  // =========================
  // TRYB NORMALNY (Button1 OFF)
  // =========================
  else
  begin

    if (not FEditMode) and (not FDeleteMode) then
    CheckBox1.Checked := False;

    if FoundAny then
    begin
      FIsDragging := (Button = mbLeft);
      FIsResizing := (Button = mbRight);

      // Zapamiętujemy stan początkowy nuty
      FDragStartNote := MidiNotes[FDragNoteIndex].Note;

      // KLUCZ: Zapamiętujemy dokładną pozycję kursora w Tickach w momencie kliknięcia
      FDragStartTick := Round((ACol * TicksPC) + ((X mod DrawGrid2.DefaultColWidth) / DrawGrid2.DefaultColWidth * TicksPC));

      // Zapamiętujemy różnicę między kursorem a faktycznym początkiem nuty
      FDragOffsetTicks := FDragStartTick - MidiNotes[FDragNoteIndex].StartTick;

      PlayNote(MidiNotes[FDragNoteIndex].Note, 100, 150);
    end;
  end;

  DrawGrid2.Invalidate;
end;

procedure TForm7.Button3Click(Sender: TObject);
var
  i, NoteStartCol, NoteEndCol: Integer;
  TicksPC: Double;
  LWasActive: Boolean;
begin


  if Form1.FPPQ > 0 then TicksPC := Form1.FPPQ / 16.0 else TicksPC := 1.0;

  // SZUKAMY NUTY DOKŁADNIE TAM, GDZIE STOI KWADRAT FOCUS RECT
  for i := 0 to MidiNoteCount - 1 do
  begin
    // Sprawdzamy czy nuta jest w tym samym wierszu (ARow) co kursor Grida
    if (MidiNotes[i].Note = (127 - DrawGrid2.Row)) and (MidiNotes[i].Channel = SelectedTrackID - 1) then

    begin
      NoteStartCol := Trunc(MidiNotes[i].StartTick / TicksPC);
      NoteEndCol := Trunc((MidiNotes[i].StartTick + MidiNotes[i].Duration) / TicksPC);

      // Sprawdzamy czy kursor Grida (Col) jest wewnątrz tej nuty
      if (DrawGrid2.Col >= NoteStartCol) and (DrawGrid2.Col <= NoteEndCol) then
      begin
        // ZNALEZIONO! Otwieramy Unit11
        Form11.FEditingNoteIndex := i;
        // Edit1 pokaże dokładną liczbę ticków (np. 1920)
        Form11.Edit1.Text := IntToStr(MidiNotes[i].StartTick);
        Form11.Edit2.Text := IntToStr(MidiNotes[i].Duration);
        Form11.Edit3.Text := IntToStr(MidiNotes[i].Velocity);

        ResetAllModes; // Wyłączamy panele
        Panel5.Color := clGreen; // Ustawiamy zielony (Edycja)
        Form11.ShowModal;
        Exit; // Kończymy, bo nuta znaleziona
      end;
    end;
  end;

  ShowMessage('Wybierz nutę do edycji');
end;


procedure TForm7.DrawGrid2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ACol, ARow, NewNote: Integer;
  TicksPC: Double;
  CurrentMouseTick, NewStart: Integer;
begin
  // Sprawdzamy czy indeks nuty jest poprawny
  if (FDragNoteIndex = -1) or (FDragNoteIndex >= MidiNoteCount) or
     (not ((ssLeft in Shift) or (ssRight in Shift))) then Exit;

  DrawGrid2.MouseToCell(X, Y, ACol, ARow);
  if (ACol < 0) or (ARow < 0) then Exit;

  if Form1.FPPQ > 0 then
    TicksPC := Form1.FPPQ / 16.0
  else
    TicksPC := 1.0;

  // Obliczamy aktualną precyzyjną pozycję myszy w Tickach
  CurrentMouseTick := Round((ACol * TicksPC) + ((X mod DrawGrid2.DefaultColWidth) / DrawGrid2.DefaultColWidth * TicksPC));

  // ==========================================
  // TRYB EDYCJI (Button1 ON) - TYLKO DŁUGOŚĆ
  // ==========================================
  if FEditMode then
  begin
    if FIsResizing or (ssLeft in Shift) then
    begin
      if CheckBox1.Checked then
        // Rozciąganie do pełnych kolumn (ACol + 1, aby dociągnąć do końca komórki)
        MidiNotes[FDragNoteIndex].Duration :=
          Max(1, Round((ACol + 1) * TicksPC) - MidiNotes[FDragNoteIndex].StartTick)
      else
        // Rozciąganie płynne
        MidiNotes[FDragNoteIndex].Duration :=
          Max(1, CurrentMouseTick - MidiNotes[FDragNoteIndex].StartTick);
    end;
  end
  // ==========================================
  // TRYB NORMALNY (Button1 OFF)
  // ==========================================
  else
  begin
    // --- LEWY PRZYCISK: PRZESUWANIE ---
    if (ssLeft in Shift) and FIsDragging then
    begin
      if CheckBox1.Checked then
      begin
        // KWANTYZACJA: Nuta traci swój "krzywy" offset i wskakuje na siatkę.
        // Obliczamy do której kolumny najbliżej jest mysz i tam ustawiamy start nuty.
        NewStart := Round(CurrentMouseTick / TicksPC) * Round(TicksPC);
      end
      else
      begin
        // TRYB PŁYNNY: Zachowujemy offset kliknięcia (nuta nie drga przy złapaniu)
        NewStart := CurrentMouseTick - FDragOffsetTicks;
      end;

      // ZABEZPIECZENIE przed 1:00:000 (Tick 0)
      if NewStart < 0 then NewStart := 0;

      MidiNotes[FDragNoteIndex].StartTick := NewStart;

      // Zmiana wysokości (Pitch)
      if (ARow >= 0) and (ARow < 128) then
      begin
        NewNote := 127 - ARow;
        if MidiNotes[FDragNoteIndex].Note <> NewNote then
        begin
          MidiNotes[FDragNoteIndex].Note := NewNote;
          PlayNote(MidiNotes[FDragNoteIndex].Note, 90, 80);
        end;
      end;

      DrawGrid2.Col := Round(MidiNotes[FDragNoteIndex].StartTick / TicksPC);
      DrawGrid2.Row := 127 - MidiNotes[FDragNoteIndex].Note;

    end
    // --- PRAWY PRZYCISK: ROZCIĄGANIE (Resize) ---
    else if (ssRight in Shift) or FIsResizing then
    begin
      if CheckBox1.Checked then
        MidiNotes[FDragNoteIndex].Duration :=
          Max(1, Round((ACol + 1) * TicksPC) - MidiNotes[FDragNoteIndex].StartTick)
      else
        MidiNotes[FDragNoteIndex].Duration :=
          Max(1, CurrentMouseTick - MidiNotes[FDragNoteIndex].StartTick);
    end;
  end;

  // Aktualizacja etykiety czasu w Edit1 (zabezpieczona przed wartościami ujemnymi)
  if (FDragNoteIndex >= 0) and (FDragNoteIndex < MidiNoteCount) then
  begin
    Edit1.Text := StringReplace(
      Form1.GetMidiTimeStr(Max(0, MidiNotes[FDragNoteIndex].StartTick)),
      ':', '.', [rfReplaceAll]
    );
  end;

  Form1.UpdateOverviewMap;
  DrawGrid2.Invalidate;
end;

procedure TForm7.DrawGrid2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FDragNoteIndex <> -1 then
  begin
    // Synchronizujemy zmianę z RAW w Unit 1
    Form1.SyncPianoNoteToRaw(
      MidiNotes[FDragNoteIndex].Channel,
      MidiNotes[FDragNoteIndex].StartTick,
      MidiNotes[FDragNoteIndex].Note
    );
  end;

  FDragNoteIndex := -1;
  FIsDragging := False;
  FIsResizing := False;

  Form1.StringGrid2.Invalidate;
  Form1.UpdateOverviewMap;
end;

end.
