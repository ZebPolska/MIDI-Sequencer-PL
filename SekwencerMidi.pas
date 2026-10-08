unit SekwencerMidi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.Menus, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.MPlayer, Vcl.ButtonGroup, Vcl.Buttons, Math, Winapi.MMSystem,
  System.Generics.Collections, System.Generics.Defaults;

type
  TNoteData = record
    HasNote: Boolean;
    MinPitch, MaxPitch: Byte;
  end;
    TMarkerEvent = record
    Tick: Cardinal;
    Name: string;
    TrackIdx: Integer;
    MetaType: Byte;
  end;

  TForm1 = class(TForm)
    MainMenu1:
    TMainMenu;
    Plik1: TMenuItem;
    Edycja1: TMenuItem;
    EfektyMidi1: TMenuItem;
    About1: TMenuItem;
    Nowy1: TMenuItem;
    Wczytaj1: TMenuItem;
    Zapisz1: TMenuItem;
    Zakocz1: TMenuItem;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
    Button6: TButton;
    Splitter1: TSplitter;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    N3: TMenuItem;
    N4: TMenuItem;
    View1: TMenuItem;
    Timer1: TTimer;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    N6: TMenuItem;
    WczytajdefinicjInstrumentu1: TMenuItem;
    N8: TMenuItem;
    DodajCASMdoplikumidi1: TMenuItem;
    CheckBox1: TCheckBox;
    PopupMenu1: TPopupMenu;
    PianoRoll1: TMenuItem;
    EventView1: TMenuItem;
    ComboBox1: TComboBox;
    ekstLyrics1: TMenuItem;
    ekstLyrics2: TMenuItem;
    Panel2: TPanel;
    ComboBox2: TComboBox;
    Label7: TLabel;
    UpDown1: TUpDown;
    About2: TMenuItem;
    Podrcznikuytkownika1: TMenuItem;
    N2: TMenuItem;
    UsuSysExzpliku1: TMenuItem;
    Mikser1: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid2SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure StringGrid2TopLeftChanged(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Wczytaj1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Zakocz1Click(Sender: TObject);
    procedure Markery1Click(Sender: TObject);
    procedure Metrum1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Kwantyzacja1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject;
      var NewSize: Integer;
      var Accept: Boolean);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PlayMidiEvents(FromTick, ToTick: Cardinal);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Zapisz1Click(Sender: TObject);
    procedure PrepareMidiChannels(AtTick: Cardinal);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure EventView1Click(Sender: TObject);
    procedure PianoRoll1Click(Sender: TObject);
    procedure Nowy1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ekstLyrics1Click(Sender: TObject);
     procedure ComboBox1Change(Sender: TObject);
    procedure ekstLyrics2Click(Sender: TObject);
    procedure WczytajdefinicjInstrumentu1Click(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: LongInt;
      const Value: string);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StringGrid2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure About2Click(Sender: TObject);
    procedure Podrcznikuytkownika1Click(Sender: TObject);
    procedure Mikser1Click(Sender: TObject);

  private
    FIsSyncing: Boolean;
    FIsDraggingCursor: Boolean;
    FIsDraggingRedline: Boolean;
    FColsPerBar: Integer;
    FColsPerBeat: Integer;
    FTicksPerColCached: Double;
    FMaxPos: Cardinal;
    function TicksPerGridCol: Integer;
    function ColsPerMeasure: Integer;
  public
    FCurrentPos: Cardinal;
    FLastPos: Cardinal;
    FMidiOut:HMIDIOUT;
    FMidiOutName: string;
    FStartQPC: Int64;
    FQPCFreq: Int64;
    FPPQ: Integer;
    FNumerator: Integer;
    FDenominator: Integer;
    FTicksPerMeasure: Integer;
    FTicksPerBeat: Integer;
    FBeatsPerMeasure: Integer;
    FNoteMinMax: array of array of TNoteData;
    FActiveNoteCol: array[0..15] of Integer; // Przechowuje numer kolumny dla każdego z 16 kanałów
    FExtraData: TBytes; // Bufor na sekcje CASM/OTS

    MidiMarkers: array[0..500000] of TMarkerEvent;
    MidiMarkerCount: Integer;
    procedure AddMarkerToMidiEngine(ATimeStr, AName: string);
    function GetMarkerTime(Index: Integer): string;
    function GetMarkerName(Index: Integer): string;
    property MarkerCount: Integer read MidiMarkerCount;

    procedure UpdateGridWidth;
    procedure RecalculateTimeStructure;
    function GetMidiTimeStr(APosition: Int64): string;
    procedure PlayGridColumn(ACol: Integer);
    procedure RefreshMidiOutList;
    procedure NotifyDataChanged; // Mechanizm flagowania

    procedure UpdateOverviewMap;
    function GetMidiTickFromStr(const S: string): Int64;
    function IsValidYamahaMarker(const AName: string): Boolean;
    procedure SyncPianoNoteToRaw(AChannel: Byte; AOriginalStartTick: Int64; NewNote: Byte);
    procedure RefreshMidiNotesFromRAW;
    procedure RebuildMidiTracksFromNotes;
  end;

  var
  Form1: TForm1;
  SequenceData: array[0..15, 0..500, 0..127] of Boolean;
  FUpdatingFromEventView: Boolean = False;

type
  TMidiNoteEvent = record
    StartTick: Cardinal;
    Duration: Cardinal;
    Note: Byte;
    Velocity: Byte;
    Channel: Byte;
    Active: Boolean;
    Patch: Byte;
  end;

type
  TInstrumentData = class
    Name: string;
    PatchSection: string; // Referencja do sekcji [Patch Names]
    BankSelectMethod: Integer;
  end;


  var
  MidiNotes: array[0..500000] of TMidiNoteEvent;
  MidiNoteCount: Integer;


type
  TRawEvent = record
    DeltaTime: Cardinal;
    AbsTick: Int64;
    Data: TBytes;
  end;

  var
  RawEvents: array of TRawEvent;
  MidiEdited: Boolean;

type
  TTrackData = record
    Events: array of TRawEvent;
  end;

  var
  // Zamiast jednej tablicy, jest tablica ścieżek
  MidiTracks: array of TTrackData;
  OriginalFormat: Word; // Tu zapis czy plik był Format 0 czy 1

type
  TWheelEvent = record
    Tick: Cardinal;
    Channel: Byte;
    LSB, MSB: Byte;
    Active: Boolean;
  end;

  var
  WheelEvents: array[0..50000] of TWheelEvent;
  WheelCount: Integer;

type
  TExportEvent = record
    AbsTick: Int64;
    Data: TBytes;
  end;


implementation

{$R *.dfm}

uses Unit2, Unit3, Unit4, Unit6, Unit7, Unit8, Unit12,
  Unit15, Unit16, S775Ins, Unit10, Unit18;


procedure TForm1.RebuildMidiTracksFromNotes;
var
  TrackIndex: Integer;
  i: Integer;
  TempEvents: TList<TRawEvent>;
  E: TRawEvent;
  LastTick: Int64;
begin
  if FUpdatingFromEventView then Exit;

  FUpdatingFromEventView := True;
  try

    // Wyczyść wszystkie tracki
    for TrackIndex := 0 to High(MidiTracks) do
      SetLength(MidiTracks[TrackIndex].Events, 0);

    // Dla każdego tracka budujemy osobno
    for TrackIndex := 0 to High(MidiTracks) do
    begin
      TempEvents := TList<TRawEvent>.Create;
      try

        // 1 Zbierz NOTE ON / OFF jako AbsTick
        for i := 0 to MidiNoteCount - 1 do
        begin
          if not MidiNotes[i].Active then Continue;
          if MidiNotes[i].Channel <> TrackIndex then Continue;

          // NOTE ON
          E.AbsTick := MidiNotes[i].StartTick;
          E.DeltaTime := 0;
          SetLength(E.Data, 3);
          E.Data[0] := $90 or TrackIndex;
          E.Data[1] := MidiNotes[i].Note;
          E.Data[2] := MidiNotes[i].Velocity;
          TempEvents.Add(E);

          // NOTE OFF
          E.AbsTick := MidiNotes[i].StartTick + MidiNotes[i].Duration;
          E.DeltaTime := 0;
          SetLength(E.Data, 3);
          E.Data[0] := $80 or TrackIndex;
          E.Data[1] := MidiNotes[i].Note;
          E.Data[2] := 0;
          TempEvents.Add(E);
        end;

        // 2 Sortuj po AbsTick
        TempEvents.Sort(
          TComparer<TRawEvent>.Construct(
            function(const L, R: TRawEvent): Integer
            begin
              Result := CompareValue(L.AbsTick, R.AbsTick);
            end
          )
        );

        // 3 Zamień AbsTick → DeltaTime
        LastTick := 0;
        SetLength(MidiTracks[TrackIndex].Events, TempEvents.Count);

        for i := 0 to TempEvents.Count - 1 do
        begin
          E := TempEvents[i];

          E.DeltaTime := E.AbsTick - LastTick;
          LastTick := E.AbsTick;

          MidiTracks[TrackIndex].Events[i] := E;
        end;

      finally
        TempEvents.Free;
      end;
    end;

  finally
    FUpdatingFromEventView := False;
  end;
end;


procedure TForm1.RefreshMidiNotesFromRAW;
var
  t, e, n: Integer;
  CurAbsTick: Int64;
  NoteStart: array[0..15, 0..127] of Int64;
  NoteStartVelo: array[0..15, 0..127] of Byte;
begin
  MidiNoteCount := 0;
  FillChar(NoteStart, SizeOf(NoteStart), $FF);

  for t := 0 to High(MidiTracks) do
  begin
    CurAbsTick := 0;
    for e := 0 to High(MidiTracks[t].Events) do
    begin
      CurAbsTick := CurAbsTick + MidiTracks[t].Events[e].DeltaTime;
      var Data := MidiTracks[t].Events[e].Data;
      if Length(Data) < 3 then Continue;

      // Note On
      if (Data[0] and $F0 = $90) and (Data[2] > 0) then
      begin
        NoteStart[Data[0] and $0F, Data[1]] := CurAbsTick;
        NoteStartVelo[Data[0] and $0F, Data[1]] := Data[2];
      end
      // Note Off
      else if ((Data[0] and $F0 = $80) or ((Data[0] and $F0 = $90) and (Data[2] = 0))) then
      begin
        var Ch := Data[0] and $0F;
        var Nt := Data[1];
        if NoteStart[Ch, Nt] >= 0 then
        begin
          MidiNotes[MidiNoteCount].StartTick := NoteStart[Ch, Nt];
          MidiNotes[MidiNoteCount].Duration := CurAbsTick - NoteStart[Ch, Nt];
          MidiNotes[MidiNoteCount].Note := Nt;
          MidiNotes[MidiNoteCount].Channel := Ch;
          MidiNotes[MidiNoteCount].Velocity := NoteStartVelo[Ch, Nt];
          Inc(MidiNoteCount);
          NoteStart[Ch, Nt] := -1;
        end;
      end;
    end;
  end;
end;


procedure TForm1.SyncPianoNoteToRaw(AChannel: Byte; AOriginalStartTick: Int64; NewNote: Byte);
var
  t, e: Integer;
  NMin, NMax: Byte;
begin
  // 1. Pobieramy limity dla kanału (ARow to kanał + 1)
  NMin := 0; NMax := 127;
  if (AChannel + 1 < Length(FNoteMinMax)) then
  begin
    NMin := FNoteMinMax[AChannel + 1, 0].MinPitch;
    NMax := FNoteMinMax[AChannel + 1, 0].MaxPitch;
  end;
  if NMax = 0 then NMax := 127;

  // 2. Szukamy zdarzenia w MidiTracks po AbsTick i kanale
  for t := 0 to High(MidiTracks) do
  begin
    for e := 0 to High(MidiTracks[t].Events) do
    begin
      if (MidiTracks[t].Events[e].AbsTick = AOriginalStartTick) and
         (Length(MidiTracks[t].Events[e].Data) >= 2) and
         (MidiTracks[t].Events[e].Data[0] and $0F = AChannel) and
         (MidiTracks[t].Events[e].Data[0] and $F0 = $90) then
      begin
        // 3. Nadpisujemy bajt nuty w RAW (Data[1])
        MidiTracks[t].Events[e].Data[1] := EnsureRange(NewNote, NMin, NMax);
        Exit;
      end;
    end;
  end;
end;


function TForm1.IsValidYamahaMarker(const AName: string): Boolean;
var
  U: string;
begin
  U := UpperCase(Trim(AName));
  // Filtr przepuszczający tylko techniczne markery Yamahy
  Result := U.StartsWith('MAIN') or U.StartsWith('INTRO') or
           U.StartsWith('ENDING') or U.StartsWith('FILL') or
           U.StartsWith('SFF') or U.StartsWith('SINT') or
           U.StartsWith('BREAK') or U.StartsWith('SECTION') or
           U.StartsWith('FN:');
end;

function TForm1.GetMidiTickFromStr(const S: string): Int64;
var
  P: TArray<string>;
  Bar, Beat, Grid: Int64;
begin
  Result := 0;
  P := S.Split([':']);
  if Length(P) <> 3 then Exit;

  // Pobieramy wartości z tekstu (np. "2:00:000")
  Bar  := StrToIntDef(P[0], 1) - 1; // Takt (indeksowany od 0 do obliczeń)
  Beat := StrToIntDef(P[1], 0);     // Uderzenie
  Grid := StrToIntDef(P[2], 0);     // Ticki / Grid

  // Zabezpieczenie przed zerami w polach metrum
  if FTicksPerMeasure <= 0 then RecalculateTimeStructure;

  // KLUCZOWA POPRAWKA:
  // Zamiast (Bar * 4 * FPPQ) używamy Twojego FTicksPerMeasure.
  // Zamiast (Beat * FPPQ) używamy Twojego FTicksPerBeat.

  Result :=
    (Bar * FTicksPerMeasure) +
    (Beat * FTicksPerBeat) +
    Grid;

  // Uwaga: Jeśli Twoje "Grid" w formacie 1:00:000 to numer kolumny (0-15),
  // a nie surowe ticki, użyj poniższej linii zamiast Grid:
  // Round(Grid * (FPPQ / 16.0));
end;


procedure TForm1.UpdateOverviewMap;
var
  i, TrackIdx, Col: Integer;
  TicksPerCol: Double;
begin
  // 1. Czyścimy całą mapę kapsułek
  for TrackIdx := 1 to 16 do
    for Col := 0 to High(FNoteMinMax[TrackIdx]) do
      FNoteMinMax[TrackIdx, Col].HasNote := False;

  // 2. Budujemy ją od nowa na podstawie aktywnych nut
  if FPPQ > 0 then TicksPerCol := FPPQ / 4.0 else TicksPerCol := 1.0;

  for i := 0 to MidiNoteCount - 1 do
  begin
    // Sprawdzamy tylko nuty, które NIE są usunięte (255)
    if MidiNotes[i].Note < 128 then
    begin
      TrackIdx := MidiNotes[i].Channel + 1;
      Col := Trunc(MidiNotes[i].StartTick / TicksPerCol);

      if (TrackIdx >= 1) and (TrackIdx <= 16) and (Col < Length(FNoteMinMax[TrackIdx])) then
        FNoteMinMax[TrackIdx, Col].HasNote := True;
    end;
  end;

  StringGrid2.Invalidate; // Teraz DrawCell narysuje tylko to co zostało
end;


procedure ParseBank(const S: string; out MSB, LSB: Integer);
  var
    p: Integer;
  begin
    MSB := 0;
    LSB := 0;

    p := Pos(':', S);
    if p > 0 then
      begin
        MSB := StrToIntDef(Copy(S, 1, p - 1), 0);
        LSB := StrToIntDef(Copy(S, p + 1, MaxInt), 0);
      end
    else
    MSB := StrToIntDef(S, 0); // fallback
  end;

procedure TForm1.NotifyDataChanged;
begin
  // 1. OZNACZENIE ZMIANY (Dla zapisu pliku)
  MidiEdited := True;
  RefreshMidiNotesFromRAW;

  // 2. SYNCHRONIZACJA BRZMIENIA (Live MIDI)
  if FMidiOut <> 0 then PrepareMidiChannels(FCurrentPos);

  StringGrid2.Invalidate;

  // 4. POWIADOMIENIE PIANO ROLL (Unit 7)
  if Assigned(Form7) then
      begin
        Form7.EnsureGridSize;
        Form7.DrawGrid2.Invalidate;
        Form7.Edit1.Text := Self.Edit5.Text;
      end;

  // 5. POWIADOMIENIE EVENT VIEW (Unit 8) - KLUCZOWA SYNCHRONIZACJA
 if Assigned(Form8) then
    Form8.LoadEventsFromTrack(StringGrid1.Row);
    Form8.StringGrid1.Invalidate;

  // 6. POWIADOMIENIE TEKSTU/LYRICS (Unit 16)
  if Assigned(Form16) then Form16.StringGrid1.Invalidate;

end;


function Swap32(Value: Cardinal): Cardinal;
  begin
    Result := ((Value and $FF000000) shr 24) or ((Value and $00FF0000) shr 8) or
              ((Value and $0000FF00) shl 8) or ((Value and $000000FF) shl 24);
  end;

function Swap16(Value: Word): Word;
  begin
    Result := ((Value and $FF00) shr 8) or ((Value and $00FF) shl 8);
  end;

procedure WriteVarLen(AStream: TStream; Value: Cardinal);
  var Buf: Cardinal; B: Byte;
  begin
    Buf := Value and $7F;
    while Value > $7F do begin
      Value := Value shr 7;
      Buf := (Buf shl 8) or $80 or (Value and $7F);
    end;
    repeat
      B := Buf and $FF;
      AStream.Write(B, 1);
      if (Buf and $80) <> 0 then Buf := Buf shr 8 else Break;
    until False;
  end;


function GetMidiOutName(DeviceID: UINT): string;
var Caps: MIDIOUTCAPS;
begin
  Result := '';
  if midiOutGetDevCaps(DeviceID, @Caps, SizeOf(Caps)) = MMSYSERR_NOERROR then
    Result := Caps.szPname;
end;

procedure TForm1.RefreshMidiOutList;
var
  NumDevs: Integer;
  Caps: TMidiOutCaps;
  i: Integer;
begin
  ComboBox1.Items.Clear;
  NumDevs := Winapi.MMSystem.midiOutGetNumDevs;
  if NumDevs = 0 then begin
    ComboBox1.Items.Add('Brak urządzeń MIDI');
    Exit;
  end;
  for i := 0 to NumDevs - 1 do
    if Winapi.MMSystem.midiOutGetDevCaps(i, @Caps, SizeOf(TMidiOutCaps)) = MMSYSERR_NOERROR then
      ComboBox1.Items.Add(Caps.szPname);
  if ComboBox1.Items.Count > 0 then ComboBox1.ItemIndex := 0;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var DeviceID: Integer; Res: MMRESULT;
begin
  if FMidiOut <> 0 then begin
    Winapi.MMSystem.midiOutReset(FMidiOut);
    Winapi.MMSystem.midiOutClose(FMidiOut);
    FMidiOut := 0;
  end;
  DeviceID := ComboBox1.ItemIndex;
  if DeviceID < 0 then Exit;
  Res := Winapi.MMSystem.midiOutOpen(@FMidiOut, DeviceID, 0, 0, CALLBACK_NULL);
  if Res = MMSYSERR_NOERROR then begin
    FMidiOutName := ComboBox1.Text;
    combobox1.Text := FMidiOutName;
    PrepareMidiChannels(FCurrentPos);
  end;
end;


procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  // Gdy użytkownik zmieni instrument na liście w Form1:
  // 1. Form12 ładuje mapę dla nowego instrumentu
  Form12.LoadPatchMapForInstrument(ComboBox2.Text);

end;

function OpenMicrosoftGS(out Midi: HMIDIOUT): Boolean;
var i: Integer; Caps: TMidiOutCaps;
begin
  Result := False; Midi := 0;
  for i := 0 to midiOutGetNumDevs - 1 do
    if midiOutGetDevCaps(i, @Caps, SizeOf(Caps)) = MMSYSERR_NOERROR then
      if (Pos('Microsoft GS', Caps.szPname) > 0) or (Pos('Wavetable', Caps.szPname) > 0) then
        if midiOutOpen(@Midi, i, 0, 0, 0) = MMSYSERR_NOERROR then begin
          Result := True; Break;
        end;
end;


procedure TForm1.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  StringGrid1.MouseToCell(X, Y, ACol, ARow);

  if (ARow <= 0) then Exit; // Ignoruj nagłówek

  //1: POJEDYNCZE KLIKNIĘCIE W KOLUMNĘ "M" (Mute)
  if (ACol = 1) and not (ssDouble in Shift) then
  begin
    if StringGrid1.Cells[1, ARow] = 'M' then
      StringGrid1.Cells[1, ARow] := ''
    else
      StringGrid1.Cells[1, ARow] := 'M';

    StringGrid1.Invalidate;
    if FMidiOut <> 0 then PrepareMidiChannels(FCurrentPos);
  end;

  //2: PODWÓJNE KLIKNIĘCIE W INNE KOLUMNY (Edycja)
  if (ACol > 1) and (ssDouble in Shift) then
  begin
    Form15.ShowModal;

    // Po zamknięciu Form15 odświeża brzmienie
    if FMidiOut <> 0 then PrepareMidiChannels(FCurrentPos);
    StringGrid1.Invalidate;
  end;
end;

procedure TForm1.PrepareMidiChannels(AtTick: Cardinal);
var
  ch: Byte;
  Msg: DWORD;
  Patch, Vol, Pan, B_MSB, B_LSB: Integer;
begin
  if FMidiOut = 0 then Exit;

  for ch := 0 to 15 do
  begin
    // 1. Pobranie danych podstawowych
    ParseBank(StringGrid1.Cells[3, ch + 1], B_MSB, B_LSB);
    Patch := StrToIntDef(StringGrid1.Cells[4, ch + 1], 0);
    Vol   := StrToIntDef(StringGrid1.Cells[5, ch + 1], 95);
    Pan   := StrToIntDef(StringGrid1.Cells[6, ch + 1], 64);

    //LOGIKA "GRAJ JAKO 10" DLA KANAŁU 9 (Indeks 8)
    if (ch = 8) and CheckBox1.Checked then
    begin
      // Bank 127 wymusza tryb perkusyjny na dowolnym kanale w Yamaha XG / GM2
      B_MSB := 127;
      B_LSB := 0;
      // W trybie perkusyjnym Patch 0 to Standard Kit.
      // Można użyć Patch z tabeli, Room Kit (Patch 8)
      if Patch = 0 then Patch := 0;
    end;

    // 2. Wysłanie Bank Select (MSB i LSB)
     // 1. NAJPIERW RESET (Czysta karta dla kanału)
    midiOutShortMsg(FMidiOut, $B0 or ch or (121 shl 8) or (0 shl 16)); // Reset Controllers
    midiOutShortMsg(FMidiOut, $B0 or ch or (123 shl 8) or (0 shl 16)); // All Notes Off

    // 2. TERAZ BANKI (Kolejność MSB -> LSB)
    midiOutShortMsg(FMidiOut, $B0 or ch or (0 shl 8) or (B_MSB shl 16));
    midiOutShortMsg(FMidiOut, $B0 or ch or (32 shl 8) or (B_LSB shl 16));

    // 3. TERAZ INSTRUMENT
    Msg := $C0 or ch or (Patch shl 8);
    midiOutShortMsg(FMidiOut, Msg);

    // 4. PARAMETRY (Głośność, Panorama, Pitch Bend)
    midiOutShortMsg(FMidiOut, $B0 or ch or (7 shl 8) or (Vol shl 16));
    midiOutShortMsg(FMidiOut, $B0 or ch or (10 shl 8) or (Pan shl 16));

    // RPN Pitch Bend Sensitivity (Ustawienie na końcu)
    midiOutShortMsg(FMidiOut, $B0 or ch or (101 shl 8) or (0 shl 16));
    midiOutShortMsg(FMidiOut, $B0 or ch or (100 shl 8) or (0 shl 16));
    midiOutShortMsg(FMidiOut, $B0 or ch or (6 shl 8) or (2 shl 16));
    midiOutShortMsg(FMidiOut, $B0 or ch or (101 shl 8) or ($7F shl 16));
    midiOutShortMsg(FMidiOut, $B0 or ch or (100 shl 8) or ($7F shl 16));
  end;

end;

procedure TForm1.PlayMidiEvents(FromTick, ToTick: Cardinal);
var i: Integer; Msg: DWORD; OffTick: Cardinal; Ch, EffCh: Byte;
begin
  if (FMidiOut = 0) or (ToTick <= FromTick) then Exit;

  // 1. Pitch Bend
  for i := 0 to WheelCount - 1 do
    if (WheelEvents[i].Tick >= FromTick) and (WheelEvents[i].Tick < ToTick) then
    begin
      Msg := $E0 or WheelEvents[i].Channel or (WheelEvents[i].LSB shl 8) or (WheelEvents[i].MSB shl 16);
      midiOutShortMsg(FMidiOut, Msg);
    end;

  // 2. Nuty
  for i := 0 to MidiNoteCount - 1 do begin
    Ch := MidiNotes[i].Channel;
    if StringGrid1.Cells[1, Ch + 1] = 'M' then Continue;

    EffCh := Ch;
    if CheckBox1.Checked and (Ch = 8) then EffCh := 9;

    //START NUTY
    if (not MidiNotes[i].Active) and (MidiNotes[i].StartTick >= FromTick) and (MidiNotes[i].StartTick < ToTick) then
    begin
      //Wymuszone Note-Off przed Note-On
      midiOutShortMsg(FMidiOut, $80 or (EffCh and $0F) or (MidiNotes[i].Note shl 8));

      Msg := $90 or (EffCh and $0F) or (MidiNotes[i].Note shl 8) or (MidiNotes[i].Velocity shl 16);
      midiOutShortMsg(FMidiOut, Msg);
      MidiNotes[i].Active := True;

    end;

    //KONIEC NUTY
    OffTick := MidiNotes[i].StartTick + MidiNotes[i].Duration;
    if MidiNotes[i].Active and (OffTick >= FromTick) and (OffTick < ToTick) then
    begin
      Msg := $80 or (EffCh and $0F) or (MidiNotes[i].Note shl 8);
      midiOutShortMsg(FMidiOut, Msg);
      MidiNotes[i].Active := False;
    end;
  end;
end;

procedure TForm1.Podrcznikuytkownika1Click(Sender: TObject);
begin
  Form10.Show;
end;

procedure TForm1.PianoRoll1Click(Sender: TObject);

begin
  N4Click(Sender);
end;

procedure TForm1.PlayGridColumn(ACol: Integer);
var Track: Integer; Note, Channel: Byte;
begin
  for Track := 1 to 16 do begin
    if (ACol <= 5000) and FNoteMinMax[Track, ACol].HasNote then begin
      Channel := Track - 1;
      Note := FNoteMinMax[Track, ACol].MinPitch;
      midiOutShortMsg(FMidiOut, $90 or Channel or (Note shl 8) or ($64 shl 16));
    end;
  end;
end;

function TForm1.TicksPerGridCol: Integer;
begin
  if FPPQ < 16 then Result := 1 else Result := FPPQ div 16;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 // 1. Natychmiast przerysuj grid, by zmienić kolory nut
  StringGrid2.Invalidate;

  // 2. Jeśli instrument gra lub jest otwarty, prześlij nowe ustawienia kanałów
  if FMidiOut <> 0 then
    PrepareMidiChannels(FCurrentPos);
end;

function TForm1.ColsPerMeasure: Integer;
begin
  if TicksPerGridCol = 0 then Result := 16
  else Result := FTicksPerMeasure div TicksPerGridCol;
end;

procedure TForm1.RecalculateTimeStructure;
var
  i, col, row, startCol, endCol: Integer;
  TicksPerCol: Double;
  ColsPerBar, ColsPerBeat: Integer;
begin
  // 1. Przeliczenie struktury czasu (To co już masz)
  FNumerator   := StrToIntDef(Edit2.Text, 4);
  FDenominator := StrToIntDef(Edit3.Text, 4);
  if FNumerator <= 0 then FNumerator := 4;
  if FDenominator <= 0 then FDenominator := 4;
  if FPPQ <= 0 then FPPQ := 480;

  FTicksPerBeat    := (FPPQ * 4) div FDenominator;
  FBeatsPerMeasure := FNumerator;
  FTicksPerMeasure := FTicksPerBeat * FBeatsPerMeasure;

  // 2. Definicja rozdzielczości siatki
  // Przyjmujemy stałą: 16 kolumn na jedną ćwiartkę (PPQ),
  // dzięki temu nuty nie zmieniają szerokości przy zmianie metrum, zmienia się tylko gęstość taktów.
  TicksPerCol := FPPQ / 4.0;

   if TicksPerCol > 0 then
    ColsPerBar := Round(FTicksPerMeasure / TicksPerCol)
  else
    ColsPerBar := 64; // bezpieczny fallback dla 4/4

  // Ile kolumn przypada na jedno uderzenie (Beat)
  if FTicksPerBeat > 0 then
    ColsPerBeat := Round(FTicksPerBeat / TicksPerCol)
  else
    ColsPerBeat := 16;

  // Wyczyść grid
  for row := 1 to StringGrid2.RowCount - 1 do
    for col := 0 to StringGrid2.ColCount - 1 do
      StringGrid2.Cells[col, row] := '';

  // 3. Rysuj nuty z MidiNotes
  for i := 0 to MidiNoteCount - 1 do
  begin
    row := MidiNotes[i].Channel + 1;

    // OBLICZANIE KOLUMN NA PODSTAWIE STAŁEJ ROZDZIELCZOŚCI (TicksPerCol)
    // To gwarantuje, że nuta zaczynająca się w 480 ticku zawsze będzie w tej samej kolumnie
    startCol := Trunc(MidiNotes[i].StartTick / TicksPerCol);
    endCol   := Trunc((MidiNotes[i].StartTick + MidiNotes[i].Duration) / TicksPerCol);

    if endCol < startCol then
      endCol := startCol;

    // Rysowanie symbolu w komórkach
    while (startCol <= endCol) and (startCol < StringGrid2.ColCount) do
    begin
      if (row >= 1) and (row < StringGrid2.RowCount) then
        StringGrid2.Cells[startCol, row] := '■';
      Inc(startCol);
    end;
  end;

  StringGrid2.Invalidate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  NowQPC: Int64;
  ElapsedSec, BPM: Double;
  NewPos: Cardinal;
  CursorCol, PianoCursorCol, OldCursorCol: Integer;
  TicksPC: Double;
begin
  // 1. POBIERANIE PRECYZYJNEGO CZASU
  QueryPerformanceCounter(NowQPC);

  // Obliczamy czas od punktu startowego FStartQPC
  ElapsedSec := (NowQPC - FStartQPC) / FQPCFreq;

  // ZABEZPIECZENIE: Jeśli czas wyjdzie ujemny (przez błąd synchronizacji kliknięcia), wymuszamy 0
  if ElapsedSec < 0 then ElapsedSec := 0;

  BPM := StrToFloatDef(StringReplace(Edit1.Text, ',', '.', [rfReplaceAll]), 120.0);
  if BPM <= 0 then BPM := 120.0;

  // 2. OBLICZANIE NOWEJ POZYCJI MIDI (Ticki)
  NewPos := Round(ElapsedSec * (BPM / 60.0) * FPPQ);

  // 3. OBLICZANIE KOLUMNY (Precyzyjne rzutowanie)
  if FPPQ > 0 then
  begin
    TicksPC := FPPQ / 4.0;
    // OldCursorCol bierzemy z FCurrentPos, które mogło zostać zmienione przez MouseDown
    OldCursorCol := Trunc(FCurrentPos / TicksPC);
    CursorCol := Trunc(NewPos / TicksPC);
  end
  else
  begin
    OldCursorCol := 0;
    CursorCol := 0;
    TicksPC := 1.0;
  end;

  // BEZPIECZNIK DLA BARDZO DŁUGICH UTWORÓW
  if CursorCol > 5000000 then CursorCol := 5000000;

  // 4. ODTWARZANIE ZDARZEŃ MIDI
  // KLUCZ: Startujemy od FCurrentPos (gdzie kursor BYŁ przed cyklem timera lub gdzie KLIKNĄŁEŚ)
  PlayMidiEvents(FCurrentPos, NewPos);

  // 5. AKTUALIZACJA STANÓW
  // Wszystkie zmienne pozycji muszą być teraz równe NewPos
  FLastPos := NewPos;
  FCurrentPos := NewPos;

  // 6. SYNCHRONIZACJA WIZUALNA (StringGrid2)
  if CursorCol <> OldCursorCol then
  begin
    // Auto-scroll jeśli wyjdzie poza widoczny obszar (prawa strona)
    if CursorCol > StringGrid2.LeftCol + StringGrid2.VisibleColCount - 2 then
      StringGrid2.LeftCol := CursorCol - 5;

    // Auto-scroll jeśli kursor jest przed widocznym obszarem (lewa strona)
    if CursorCol < StringGrid2.LeftCol then
      StringGrid2.LeftCol := Max(0, CursorCol);

    StringGrid2.Invalidate;
  end;

  // 7. ZATRZYMANIE PO ZAKOŃCZENIU
  if (FMaxPos > 0) and (FCurrentPos >= FMaxPos) then
  begin
    Timer1.Enabled := False;
    SpeedButton3Click(SpeedButton3);
    StatusBar1.Panels[0].Text := 'Odtwarzanie zakończone';
    Exit;
  end;

  // 8. LOGIKA PIANO ROLL (Form7)
  if Form7.Visible then
  begin
    PianoCursorCol := Trunc(FCurrentPos / TicksPC);

    if PianoCursorCol > Form7.DrawGrid2.LeftCol + Form7.DrawGrid2.VisibleColCount - 2 then
      Form7.DrawGrid2.LeftCol := PianoCursorCol - 5;

    if PianoCursorCol < Form7.DrawGrid2.LeftCol then
      Form7.DrawGrid2.LeftCol := Max(0, PianoCursorCol);

    Form7.DrawGrid2.Invalidate;
  end;

  // 9. AKTUALIZACJA LISTY ZDARZEŃ (Form8)
  if Assigned(Form8) and Form8.Visible then Form8.StringGrid1.Invalidate;

  // 10. LOGIKA FORM16 (SYLABY / TEKST)
  if Form16.Visible then
  begin
    Form16.StringGrid1.Invalidate;
    for var i := 0 to Form16.StringGrid1.RowCount - 1 do
    begin
      // Zakładamy, że w Cells[0, i] trzymasz Ticki zdarzenia tekstowego
      var t := StrToInt64Def(Form16.StringGrid1.Cells[0, i], -1);
      if (t >= FCurrentPos) then
      begin
        Form16.StringGrid1.TopRow := Max(0, i - 3);
        Break;
      end;
    end;
  end;

  // 11. AKTUALIZACJA LICZNIKÓW TEKSTOWYCH
  Edit4.Text := FormatDateTime('h:nn:ss', ElapsedSec / 86400.0);
  Edit5.Text := StringReplace(GetMidiTimeStr(FCurrentPos), ':', '.', [rfReplaceAll]);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
i :integer;
begin

  QueryPerformanceFrequency(FQPCFreq);

  S775Ins.InitializeInstruments;

  for i := 0 to 15 do FActiveNoteCol[i] := -1;

  StringGrid1.OnMouseDown := StringGrid1MouseDown;
  StringGrid1.OnDblClick := StringGrid1DblClick;
  StringGrid1.Options := StringGrid1.Options - [goEditing];

  SetLength(FNoteMinMax, 17);
  for i := 0 to 16 do SetLength(FNoteMinMax[i], 2000); // 2000 to startowe ColCount


  FMidiOut := 0;
  RefreshMidiOutList; // Wypełnia listę urządzeń
  if ComboBox1.Items.Count > 0 then ComboBox1Change(ComboBox1); // Otwiera domyślne urządzenie


  //usuwa migotanie i lagowanie
  StringGrid1.DoubleBuffered := True;
  StringGrid2.DoubleBuffered := True;

  StringGrid1.RowHeights[0] := 30;
  StringGrid2.RowHeights[0] := 30;

  Timer1.Enabled := False;
  FIsSyncing := False;
  FCurrentPos := 0;
  FLastPos := 0; FPPQ := 480;
  Edit1.Text := '100';
  Edit2.Text := '4';
  Edit3.Text := '4';

  StringGrid1.ColCount := 7;
  StringGrid1.RowCount := 17;
  StringGrid1.FixedCols := 1;
  StringGrid1.FixedRows := 1;
  StringGrid1.Options := StringGrid1.Options + [goRowSelect, goDrawFocusSelected];
  StringGrid1.Cells[0, 0] := 'Track';
  StringGrid1.Cells[1, 0] := 'M';
  StringGrid1.Cells[2, 0] := 'Trsp';
  StringGrid1.Cells[3, 0] := 'Bank';
  StringGrid1.Cells[4, 0] := 'Patch';
  StringGrid1.Cells[5, 0] := 'Vol';
  StringGrid1.Cells[6, 0] := 'Pan';

  StringGrid1.ColWidths[0] := 40;
  StringGrid1.ColWidths[1] := 25;
  StringGrid1.ColWidths[2] := 30;
  StringGrid1.ColWidths[3] := 40;
  StringGrid1.ColWidths[4] := 140;
  StringGrid1.ColWidths[5] := 30;
  StringGrid1.ColWidths[6] := 30;

  for i := 1 to 16 do StringGrid1.Cells[0, i] := IntToStr(i);
  // INICJALIZACJA TABLICY DYNAMICZNEJ
  SetLength(FNoteMinMax, 17); // 16 tracków + 1
  for i := 0 to 16 do
  SetLength(FNoteMinMax[i], 2000); // Tyle samo co początkowe ColCount

  StringGrid2.FixedRows := 1;
  StringGrid2.RowCount := 17;
  StringGrid2.ColCount := 2000;
  StringGrid2.DefaultColWidth := 14;
  StringGrid2.Options := StringGrid2.Options + [goRowSelect, goDrawFocusSelected];

  StringGrid1.Align := alLeft; Splitter1.Align := alLeft; StringGrid2.Align := alClient;

  RecalculateTimeStructure;
  UpdateGridWidth;
end;


procedure TForm1.StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: string;
  NoteY, NoteH: Integer;
  TicksPerCol, TicksPerBeat: Double;
  ColsPerBar, ColsPerBeat: Integer;
  m, MarkerCol: Integer;
  TextR: TRect;
  IsSection: Boolean;
  UpperS: string;
  BarStartCol: Integer;
begin

   // --- A. LOGIKA METRUM ---
  if FPPQ <= 0 then FPPQ := 480;
  if FNumerator <= 0 then FNumerator := 4;
  if FDenominator <= 0 then FDenominator := 4;

  // 1 kolumna to 1/16 ćwiartki (standard w sekwencerach)
  TicksPerCol := FPPQ / 4.0;

  // Obliczamy TicksPerBeat na podstawie mianownika (np. dla /8 to 240, dla /4 to 480)
  TicksPerBeat := FPPQ * (4 / FDenominator);

  // Ile kolumn zajmuje jedno uderzenie (Beat) i cały takt (Bar)
  ColsPerBeat := Round(TicksPerBeat / TicksPerCol);
  ColsPerBar  := FNumerator * ColsPerBeat;


  // B. NAGŁÓWEK (ARow = 0)
  if ARow = 0 then
  begin
    // 1. TŁO
    StringGrid2.Canvas.Brush.Color := $E0E0E0;
    StringGrid2.Canvas.FillRect(Rect);
    SetBkMode(StringGrid2.Canvas.Handle, TRANSPARENT);

    // 2. RYSOWANIE MARKERÓW (Zostaje bez zmian, bo działa dobrze)
    for m := 0 to MidiMarkerCount - 1 do
    begin
      S := Trim(MidiMarkers[m].Name);
      UpperS := UpperCase(S);
      IsSection := (Pos('MAIN', UpperS) > 0) or (Pos('INTRO', UpperS) > 0) or
                   (Pos('ENDING', UpperS) > 0) or (Pos('FILL', UpperS) > 0) or
                   (Pos('SECTION', UpperS) > 0) or (Pos('SINT', UpperS) > 0);

      if not IsSection then Continue;

      MarkerCol := Trunc(MidiMarkers[m].Tick / TicksPerCol);

      if ACol = MarkerCol then
      begin
        StringGrid2.Canvas.Pen.Color := clWebOrange;
        StringGrid2.Canvas.Pen.Width := 1;
        StringGrid2.Canvas.MoveTo(Rect.Left, Rect.Top);
        StringGrid2.Canvas.LineTo(Rect.Left, Rect.Bottom);
      end;

      if (ACol >= MarkerCol) and (ACol < MarkerCol + 15) then
      begin
        if Pos(':', S) > 0 then S := Copy(S, Pos(':', S) + 1, MaxInt);
        S := Trim(S);
        StringGrid2.Canvas.Font.Color := clRed;
        StringGrid2.Canvas.Font.Style := [fsBold];
        StringGrid2.Canvas.Font.Size := 9;

        TextR := Rect;
        TextR.Left := Rect.Left - (ACol - MarkerCol) * (StringGrid2.DefaultColWidth + 1);
        TextR.Top := Rect.Top + 14;
        TextR.Right := TextR.Left + 500;
        // Korekta dla początku taktu
        if (MarkerCol mod ColsPerBar = 0) then TextR.Left := TextR.Left + 2;

        DrawText(StringGrid2.Canvas.Handle, PChar(S), Length(S), TextR, DT_LEFT or DT_TOP or DT_NOCLIP);
        Break;
      end;
    end;

    // 3. NUMER TAKTU (Zastosowanie metody rysowania ciągłego jak w markerach)
    BarStartCol := (ACol div ColsPerBar) * ColsPerBar;
    if (ACol >= BarStartCol) and (ACol < BarStartCol + 5) then
    begin
      S := IntToStr((BarStartCol div ColsPerBar) + 1);
      StringGrid2.Canvas.Font.Color := clBlack;
      StringGrid2.Canvas.Font.Style := [fsBold];
      StringGrid2.Canvas.Font.Size := 10;

      TextR := Rect;
      TextR.Left := Rect.Left - (ACol - BarStartCol) * (StringGrid2.DefaultColWidth + 1) + 2;
      TextR.Top := Rect.Top;
      TextR.Right := TextR.Left + 200;
      DrawText(StringGrid2.Canvas.Handle, PChar(S), Length(S), TextR, DT_LEFT or DT_TOP or DT_NOCLIP);
    end;

    // Linia pionowa taktu - tylko w pierwszej kolumnie taktu
    if ACol mod ColsPerBar = 0 then
    begin
      StringGrid2.Canvas.Pen.Width := 2;
      StringGrid2.Canvas.Pen.Color := clBlack;
      StringGrid2.Canvas.MoveTo(Rect.Left, Rect.Top);
      StringGrid2.Canvas.LineTo(Rect.Left, Rect.Bottom);
    end;

    Exit;
  end;

  // C, D, E - RESZTA KODU BEZ ZMIAN
  if ARow = StringGrid2.Row then
    StringGrid2.Canvas.Brush.Color := $FFFAF0
  else
    StringGrid2.Canvas.Brush.Color := clWhite;
  StringGrid2.Canvas.FillRect(Rect);

  if (ACol mod ColsPerBar = 0) then StringGrid2.Canvas.Pen.Color := clGray
  else if (ACol mod ColsPerBeat = 0) then StringGrid2.Canvas.Pen.Color := clSilver
  else StringGrid2.Canvas.Pen.Color := $F8F8F8;

  StringGrid2.Canvas.MoveTo(Rect.Left, Rect.Top);
  StringGrid2.Canvas.LineTo(Rect.Left, Rect.Bottom);

  if (ARow >= 1) and (ARow <= 16) then
  begin
    if (Length(FNoteMinMax) > ARow) and (ACol >= 0) and (ACol < Length(FNoteMinMax[ARow])) then
    begin
      if FNoteMinMax[ARow, ACol].HasNote then
      begin
        StringGrid2.Canvas.Brush.Color := clBlue;
        if (ARow = 10) or ((ARow = 9) and CheckBox1.Checked) then StringGrid2.Canvas.Brush.Color := $5555FF;
        StringGrid2.Canvas.Pen.Color := $000044;
        NoteY := Rect.Top + 2 + Round(((127 - FNoteMinMax[ARow, ACol].MaxPitch) mod 24 / 24) * (Rect.Height - 10));
        StringGrid2.Canvas.RoundRect(Rect.Left + 2, NoteY, Rect.Right - 2, NoteY + 5, 4, 4);
      end;
    end;
  end;

  for m := 0 to MidiMarkerCount - 1 do
  begin
    S := Trim(MidiMarkers[m].Name);
    UpperS := UpperCase(S);
    IsSection := (Pos('MAIN', UpperS) > 0) or (Pos('INTRO', UpperS) > 0) or
                 (Pos('ENDING', UpperS) > 0) or (Pos('FILL', UpperS) > 0) or
                 (Pos('SECTION', UpperS) > 0) or (Pos('SINT', UpperS) > 0);
    if IsSection then
    begin
      MarkerCol := Trunc(MidiMarkers[m].Tick / TicksPerCol);
      if ACol = MarkerCol then
      begin
        StringGrid2.Canvas.Pen.Color := clWebOrange;
        StringGrid2.Canvas.MoveTo(Rect.Left, Rect.Top);
        StringGrid2.Canvas.LineTo(Rect.Left, Rect.Bottom);
      end;
    end;
  end;

  if Abs(ACol - (FCurrentPos / TicksPerCol)) < 0.5 then
  begin
    StringGrid2.Canvas.Pen.Color := clRed;
    StringGrid2.Canvas.Pen.Width := 2;
    StringGrid2.Canvas.MoveTo(Rect.Left, Rect.Top);
    StringGrid2.Canvas.LineTo(Rect.Left, Rect.Bottom);
    StringGrid2.Canvas.Pen.Width := 1;
  end;
end;

procedure TForm1.StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin
    FIsDraggingRedline := True;
    // Od razu przeliczamy pozycję, żeby nie było mignięcia
    StringGrid2MouseMove(Sender, Shift, X, Y);
  end;
end;

procedure TForm1.StringGrid2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ACol, ARow: Integer;
  TicksPC, CurrentBPM, ElapsedSecAtClick: Double;
  NowQPC: Int64;
begin
  if not FIsDraggingRedline then Exit;

  // Pobieramy komórkę pod myszką
  StringGrid2.MouseToCell(X, Y, ACol, ARow);

  if (ACol >= 0) then
  begin
    if FPPQ <= 0 then FPPQ := 480;
    TicksPC := FPPQ / 4.0;

    // 1. USTALENIE POZYCJI (Zgodnie z Twoim Unit7)
    // Ticki = Kolumna * Ticki_na_kolumnę
    FCurrentPos := Round(ACol * TicksPC);
    FLastPos := FCurrentPos;

    // 2. SYNCHRONIZACJA TYLKO JEŚLI GRA (Timer1.Enabled)
    // Jeśli nie gra, tylko zmieniamy FCurrentPos (Redline stoi tam, gdzie puścisz)
    if Timer1.Enabled then
    begin
      CurrentBPM := StrToFloatDef(StringReplace(Edit1.Text, ',', '.', [rfReplaceAll]), 120.0);
      if CurrentBPM <= 0 then CurrentBPM := 120.0;

      ElapsedSecAtClick := FCurrentPos / ((CurrentBPM / 60.0) * FPPQ);
      QueryPerformanceCounter(NowQPC);

      // Nowa baza czasu dla Timera, żeby grał dalej od tego miejsca
      FStartQPC := NowQPC - Round(ElapsedSecAtClick * FQPCFreq);
    end;

    // 3. ODŚWIEŻANIE WIDOKU (Wymuszamy DrawCell)
    StringGrid2.Invalidate;
    if Assigned(Form7) and Form7.Visible then Form7.DrawGrid2.Invalidate;

    // Tekstowe liczniki (od razu widać zmianę)
    Edit5.Text := StringReplace(GetMidiTimeStr(FCurrentPos), ':', '.', [rfReplaceAll]);
  end;
end;

procedure TForm1.StringGrid2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FIsDraggingRedline := False;
  // Resetujemy nuty, żeby nie "piszczały" po zmianie pozycji
  for var i := 0 to MidiNoteCount - 1 do MidiNotes[i].Active := False;
  StringGrid2.Invalidate;
  if Form8.Showing then Form8.SyncToMainPos;
end;

function TForm1.GetMidiTimeStr(APosition: Int64): string;
var
  Bar, Beat, TickInBeat: Int64;
  TicksPerBeat, TicksPerBar: Double;
begin
  // 1. Zabezpieczenia danych wejściowych
  if FPPQ <= 0 then FPPQ := 480;
  if FNumerator <= 0 then FNumerator := 4;
  if FDenominator <= 0 then FDenominator := 4;

  // 2. Obliczamy ile ticków przypada na jedno uderzenie (Beat)
  TicksPerBeat := FPPQ * (4.0 / FDenominator);

  // 3. Obliczamy ile ticków ma cały takt (Bar)
  TicksPerBar := TicksPerBeat * FNumerator;

  if TicksPerBar <= 0 then Exit('1:00:000');

  // 4. Obliczamy Takt (Bar) - numeracja od 1
  Bar := (APosition div Trunc(TicksPerBar)) + 1;

  // 5. Obliczamy Uderzenie (Beat) - zakres 00 do (FNumerator - 1)
  // Zostawiamy BEZ +1, aby początek taktu to było zawsze :00:
  Beat := (APosition mod Trunc(TicksPerBar)) div Trunc(TicksPerBeat);

  // 6. Obliczamy Ticki wewnątrz uderzenia (reszta)
  TickInBeat := APosition mod Trunc(TicksPerBeat);

  // 7. Formatowanie: Takt:Beat(00-NN):Tick(000-NNN)
  // Używamy %.2d dla Beatu, żeby zawsze były 2 cyfry (np. 1:00:000)
  Result := Format('%d:%.2d:%.3d', [Bar, Beat, TickInBeat]);
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  Form15.Show;
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject;
ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);

var
 B, P: Integer;
  S: string;
begin
  S := StringGrid1.Cells[ACol, ARow];

  if (ARow > 0) and (ACol = 4) and (S <> '') then
  begin
    // 1. Pobierz Kanał (Sprawdź czy masz go w kolumnie 1 czy 2!)

    P := StrToIntDef(StringGrid1.Cells[4, ARow], 0);
    B := StrToIntDef(StringGrid1.Cells[3, ARow], 0);

    S := S775Ins.GetInstrumentName(B, P);

    // JEŚLI S JEST PUSTE (funkcja nic nie znalazła), TO WYMUŚ NUMER
    if S = '' then
      S := StringGrid1.Cells[4, ARow];

    if StringGrid1.Cells[3, 10] <> '127' then
    StringGrid1.Cells[3, 10] := '127';

    end;

  if ARow = 0 then begin
    StringGrid1.Canvas.Brush.Color := clBtnFace;
    StringGrid1.Canvas.Font.Color := clWindowText;
  end
  else if ARow = StringGrid1.Row then begin
    StringGrid1.Canvas.Brush.Color := $FFFAF0;
    StringGrid1.Canvas.Font.Color := clBlack;
  end
  else if ACol = 0 then begin
    StringGrid1.Canvas.Brush.Color := clBtnFace;
    StringGrid1.Canvas.Font.Color := clWindowText;
  end
  else begin
    StringGrid1.Canvas.Brush.Color := clWindow;
    StringGrid1.Canvas.Font.Color := clWindowText;
  end;

  StringGrid1.Canvas.FillRect(Rect);
  if S <> '' then begin
    StringGrid1.Canvas.Brush.Style := bsClear;
    DrawText(StringGrid1.Canvas.Handle, PChar(S), Length(S), Rect,
             DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
  end;
  StringGrid1.Canvas.Pen.Color := clSilver;
  StringGrid1.Canvas.Brush.Style := bsClear;
  StringGrid1.Canvas.Rectangle(Rect);
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if FIsSyncing then Exit;
  FIsSyncing := True;
  try
    StringGrid2.Row := ARow;
    StringGrid2.Invalidate;
  finally
    FIsSyncing := False;
  end;
end;

procedure TForm1.StringGrid1SetEditText(Sender: TObject; ACol, ARow: LongInt;
  const Value: string);
begin
  // Jeśli edytowano kolumny: Bank, Patch, Vol, Pan (3-7)
  if (ARow > 0) and (ACol in [3..7]) then
  begin
    // Wysyła natychmiastowe polecenie zmiany do urządzenia MIDI
    PrepareMidiChannels(FCurrentPos);
    NotifyDataChanged; // Flaga zmiany
  end;
end;

procedure TForm1.StringGrid2SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  BPM, ElapsedSecAtClick: Double;
  NowQPC: Int64;
  i, SavedLeftCol: Integer;
begin
  if FIsSyncing then Exit;
  SavedLeftCol := StringGrid2.LeftCol;

  // 1. Synchronizacja wierszy (Tracków)
  FIsSyncing := True;
  try
    StringGrid1.Row := ARow;
    // Zamiast Invalidate, użyj Repaint dla Grid1, by uniknąć migotania przy szybkim kliku
    StringGrid1.Repaint;
  finally
    FIsSyncing := False;
  end;

  // 2. Logika pozycji (Wymuszenie przeliczenia)
  // Upewnij się, że FTicksPerColCached jest dokładnie tym samym co w DrawCell!
  if (FTicksPerColCached > 0) then
  begin
    FCurrentPos := Round(ACol * FTicksPerColCached);
    FLastPos := FCurrentPos;

    if Timer1.Enabled then
    begin
      BPM := StrToFloatDef(StringReplace(Edit1.Text, ',', '.', [rfReplaceAll]), 120.0);
      ElapsedSecAtClick := FCurrentPos / ((BPM / 60.0) * FPPQ);
      QueryPerformanceCounter(NowQPC);
      FStartQPC := NowQPC - Round(ElapsedSecAtClick * FQPCFreq);
      for i := 0 to MidiNoteCount - 1 do MidiNotes[i].Active := False;
    end;

    // KLUCZOWE: Musimy odświeżyć Grid2, żeby narysował Redline
    StringGrid2.Invalidate;

    // Synchronizacja z Piano Rollem (Form7)
    if Assigned(Form7) and Form7.Visible then
    begin
       Form7.DrawGrid2.Invalidate;
       // Opcjonalnie: ustaw Piano Roll na ten sam czas
       // Form7.DrawGrid2.LeftCol := StringGrid2.LeftCol;
    end;
  end;

  // 3. Blokada skoku - zmień na bezpieczniejszą metodę
  TThread.ForceQueue(nil,
    procedure
    begin
      if StringGrid2.LeftCol <> SavedLeftCol then
        StringGrid2.LeftCol := SavedLeftCol;
    end);
end;

procedure TForm1.StringGrid1TopLeftChanged(Sender: TObject);
begin
  if FIsSyncing then Exit;
  FIsSyncing := True;
  try StringGrid2.TopRow := StringGrid1.TopRow;
  finally FIsSyncing := False; end;
end;

procedure TForm1.StringGrid2TopLeftChanged(Sender: TObject);
begin
   StringGrid1.TopRow := StringGrid2.TopRow;
  if FIsSyncing then Exit;
  FIsSyncing := True;
  try StringGrid1.TopRow := StringGrid2.TopRow;
  finally FIsSyncing := False; end;
end;

procedure TForm1.Edit1Exit(Sender: TObject);
var
  InputVal: Double;
  FinalVal: Integer;
  S: string;
begin
  // 1. Pobierz tekst z Edit1
  S := Edit1.Text;

  // 2. Ręczna zamiana kropki na przecinek (tradycyjna funkcja)
  // rfReplaceAll zamieni wszystkie wystąpienia, rfIgnoreCase ignoruje wielkość liter
  S := StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]);
  S := StringReplace(S, ',', FormatSettings.DecimalSeparator, [rfReplaceAll]);

  // 3. Próba konwersji tekstu na liczbę
  if TryStrToFloat(S, InputVal) then
  begin
    // Zaokrąglanie: 99.5 -> 100, 99.4 -> 99
    FinalVal := Round(InputVal);

    // Ograniczenie zakresu do 1-255
    if FinalVal < 1 then
      FinalVal := 1
    else if FinalVal > 255 then
      FinalVal := 255;
  end
  else
  begin
    // Jeśli wpisano litery lub pole jest puste, ustaw 1
    FinalVal := 1;
  end;

  // 4. Przypisz wynik z powrotem do pola tekstowego
  Edit1.Text := IntToStr(FinalVal);

end;


procedure TForm1.Edit2Change(Sender: TObject);
begin
  RecalculateTimeStructure;
end;
procedure TForm1.Edit3Change(Sender: TObject);
begin
  RecalculateTimeStructure;
end;

procedure TForm1.ekstLyrics1Click(Sender: TObject);
begin
  ekstLyrics2Click(Sender);
end;


procedure TForm1.ekstLyrics2Click(Sender: TObject);
begin
   // StringGrid2.Row to aktualnie wybrana ścieżka (1-16)
  Form16.SelectedChannel := StringGrid2.Row - 1;
  Form16.PrepareLyrics;
    // BLOKADA: Lyrics mają być widoczne TYLKO na tracku nr 4 (Channel 3)
  if form16.SelectedChannel <> 3 then
  begin
    ShowMessage('Tekst (Lyrics) jest dostępny tylko dla ścieżki nr 4.');
    Exit
    end
      else
        Form16.ShowModal;
end;

procedure TForm1.EventView1Click(Sender: TObject);
begin
  View1Click(Sender);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  // 1. Zatrzymujemy timer, jeśli gra
  Timer1.Enabled := False;

  // 2. Resetujemy pozycje MIDI
  FCurrentPos := 0;
  FLastPos := 0;

  // 3. Wyłączamy wszystkie grające nuty (Panic/Silence)
  for var i := 0 to 15 do midiOutShortMsg(FMidiOut, $B0 or i or ($7B shl 8));

  // 4. Przewija ekran siatki na początek
  StringGrid2.LeftCol := 0;

  // 5. Aktualizuje Piano Roll jeśli jest otwarty
  if Form7.Visible then Form7.DrawGrid2.LeftCol := 0;

  // 6. Odświeża widok i liczniki
  StringGrid2.Invalidate;
  if Form7.Visible then Form7.DrawGrid2.Invalidate;
  Edit5.Text := StringReplace(GetMidiTimeStr(FCurrentPos), ':', '.', [rfReplaceAll]);
  StatusBar1.Panels[0].Text := 'Start utworu';
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  i: Integer;
  BPM, ElapsedSecAtStart: Double;
  NowQPC: Int64;
begin
  // Synchronizuje ostatnią pozycję z aktualną
  FLastPos := FCurrentPos;

  //Ta procedura wysyła instrumenty ze StringGrid1 do portu MIDI
  PrepareMidiChannels(FCurrentPos);

  // Czyścimy flagi nut
  for i := 0 to MidiNoteCount - 1 do
    MidiNotes[i].Active := False;

  BPM := StrToFloatDef(StringReplace(Edit1.Text, ',', '.', [rfReplaceAll]), 120.0);

  // OBLICZANIE CZASU STARTU
  if (FCurrentPos > 0) and (FPPQ > 0) then
    ElapsedSecAtStart := FCurrentPos / ((BPM / 60.0) * FPPQ)
  else
    ElapsedSecAtStart := 0;

  QueryPerformanceFrequency(FQPCFreq);
  QueryPerformanceCounter(NowQPC);

  // Przesunięcie punktu zero w czasie
  FStartQPC := NowQPC - Round(ElapsedSecAtStart * FQPCFreq);

  Timer1.Enabled := True;
  StringGrid2.Invalidate; // Odśwież widok, aby kursor/nuty były aktualne
  StatusBar1.Panels[0].Text := 'Odtwarzanie: ' + Edit5.Text;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  Timer1.Enabled := False;
  // Wyłącza dźwięki (All Notes Off)
  for var i := 0 to 15 do midiOutShortMsg(FMidiOut, $B0 or i or ($7B shl 8));

  for var ch := 0 to 15 do
  begin
     // Reset Pitch Bend do pozycji ZERO (środek)
    midiOutShortMsg(FMidiOut, $E0 or ch or (0 shl 8) or (64 shl 16));
  end;
  StringGrid2.Invalidate;
end;


procedure TForm1.SpeedButton5Click(Sender: TObject);
var
  EndCol: Integer;
  TicksPC: Double;
begin
  // 1. Zatrzymuje timer
  Timer1.Enabled := False;

  // 2. Ustawia pozycję na maksymalną wykrytą podczas wczytywania
  FCurrentPos := FMaxPos;
  FLastPos := FMaxPos;

  // 3. Oblicza, która to kolumna, aby tam przewinąć ekran
  if FPPQ > 0 then TicksPC := FPPQ / 4.0 else TicksPC := 1.0;
  EndCol := Trunc(FMaxPos / TicksPC);

  // 4. Przewija siatkę główną (ustawiamy kursor kilka kolumn przed końcem, by był widoczny)
  StringGrid2.LeftCol := Max(0, EndCol - (StringGrid2.VisibleColCount div 2));

  // 5. Przewija Piano Roll (jeśli otwarty)
  if Form7.Visible then
    Form7.DrawGrid2.LeftCol := Max(0, EndCol - (Form7.DrawGrid2.VisibleColCount div 2));

  // 6. Odświeża interfejs
  StringGrid2.Invalidate;
  if Form7.Visible then Form7.DrawGrid2.Invalidate;
  Edit5.Text := StringReplace(GetMidiTimeStr(FCurrentPos), ':', '.', [rfReplaceAll]);
  StatusBar1.Panels[0].Text := 'Koniec utworu';
end;

procedure TForm1.Splitter1CanResize(Sender: TObject; var NewSize: Integer;
var
  Accept: Boolean);
begin
  NewSize := 257; Accept := False; end;

procedure TForm1.Button1Click(Sender: TObject);
var
  FS: TFileStream;
  MHeader: array[0..13] of Byte;
  ID: array[0..3] of AnsiChar;
  TSize, TSizeMeta: Cardinal;
  NumTracks: Word;
  Delta: Cardinal;
  AbsTick: Int64;
  Status, RunningStatus: Byte;
  B, Note, Velo, CC_Num, CC_Val, PatchNum: Byte;
  B1, B2: Byte;
  i, j, r, c: Integer;
  NoteStart: array[0..15, 0..127] of Int64;
  RawStartPos: Int64;
  Size: Integer;
  CurrentGridCol, GridRow, CurrentChannel: Integer;
  MName: AnsiString;
  EventIdx: Integer;
  Remaining: Int64;
  NoteStartVelo: array[0..15, 0..127] of Byte;

  function ReadVarLen: Cardinal;
  var BVar: Byte;
  begin
    Result := 0;
    repeat
      FS.ReadBuffer(BVar, 1);
      Result := (Result shl 7) or (BVar and $7F);
    until (BVar and $80) = 0;
  end;

begin
  if not OpenDialog1.Execute then Exit;

  // Czyszczenie Gridów i struktur
  StringGrid1.BeginUpdate;
  StringGrid2.BeginUpdate;
  try
    // 1. Czyszczenie StringGrid1 (ma FixedCols, np. 1)
    for r := StringGrid1.FixedRows to 16 do
    begin
      // Czyścimy od kolumny stałej (omijamy etykiety)
      for c := StringGrid1.FixedCols to StringGrid1.ColCount - 1 do
        StringGrid1.Cells[c, r] := '';

      // Czyszczenie Twojej struktury danych
      if r < Length(FNoteMinMax) then
      begin
        SetLength(FNoteMinMax[r], 5000);
        for c := 0 to 4999 do FNoteMinMax[r, c].HasNote := False;
      end;
    end;

    // 2. Czyszczenie StringGrid2 (brak FixedCols, czysto dane)
    // Czyścimy wszystkie komórki wierszy 1-16 (zakładając, że wiersz 0 to nagłówek)
    for r := StringGrid2.FixedRows to 16 do
    begin
      // Jeśli Grid2 nie ma FixedCols, to pętla zacznie od c := 0
      for c := StringGrid2.FixedCols to StringGrid2.ColCount - 1 do
        StringGrid2.Cells[c, r] := '';
    end;

  finally
    StringGrid1.EndUpdate;
    StringGrid2.EndUpdate;
  end;

  FMaxPos := 0;
  MidiNoteCount := 0;
  MidiMarkerCount := 0;
  WheelCount := 0;
  FillChar(NoteStart, SizeOf(NoteStart), $FF);
  SetLength(FExtraData, 0);

  FS := TFileStream.Create(OpenDialog1.FileName, fmOpenRead or fmShareDenyNone);
  try
    FS.ReadBuffer(MHeader, 14);
    NumTracks := (MHeader[10] shl 8) or MHeader[11];
    FPPQ := (MHeader[12] shl 8) or MHeader[13];
    if FPPQ <= 0 then FPPQ := 480;

    SetLength(MidiTracks, NumTracks);

    for i := 0 to NumTracks - 1 do
    begin
      FS.ReadBuffer(ID, 4);
      FS.ReadBuffer(TSize, 4);

      TSize := Swap32(TSize);

      j := FS.Position;
      AbsTick := 0;
      RunningStatus := 0;
      SetLength(MidiTracks[i].Events, 0);

      while FS.Position < j + TSize do
      begin
        Delta := ReadVarLen;
        AbsTick := AbsTick + Delta;
        if AbsTick > FMaxPos then FMaxPos := AbsTick;
        RawStartPos := FS.Position;
        FS.ReadBuffer(Status, 1);

        if Status < $80 then begin FS.Position := FS.Position - 1; Status := RunningStatus; end
        else if Status < $F0 then RunningStatus := Status;

        CurrentGridCol := Trunc(AbsTick / (FPPQ / 4.0));
        GridRow := (Status and $0F) + 1;

        if (GridRow >= 1) and (GridRow <= 16) then
        begin
          if CurrentGridCol >= Length(FNoteMinMax[GridRow]) then
            for var rowIdx := 0 to 16 do SetLength(FNoteMinMax[rowIdx], CurrentGridCol + 2000);
        end;

        if (Status and $F0) = $90 then
        begin
          FS.ReadBuffer(Note, 1); FS.ReadBuffer(Velo, 1);
          if Velo > 0 then begin
            NoteStart[Status and $0F, Note] := AbsTick;
            NoteStartVelo[Status and $0F, Note] := Velo; // <--- ZAPAMIĘTAJ VELOCITY
            if (GridRow >= 1) and (GridRow <= 16) then begin
              FNoteMinMax[GridRow, CurrentGridCol].HasNote := True;
              FNoteMinMax[GridRow, CurrentGridCol].MaxPitch := Note;
            end;
          end else if NoteStart[Status and $0F, Note] >= 0 then begin
            MidiNotes[MidiNoteCount].StartTick := NoteStart[Status and $0F, Note];
            MidiNotes[MidiNoteCount].Duration := AbsTick - NoteStart[Status and $0F, Note];
            MidiNotes[MidiNoteCount].Note := Note;
            MidiNotes[MidiNoteCount].Channel := Status and $0F;
            MidiNotes[MidiNoteCount].Velocity := NoteStartVelo[Status and $0F, Note]; // <--- UŻYJ ZAPAMIĘTANEGO
            Inc(MidiNoteCount); NoteStart[Status and $0F, Note] := -1;
          end;
        end
        else if (Status and $F0) = $80 then
        begin
          FS.ReadBuffer(Note, 1); FS.ReadBuffer(Velo, 1);
          if NoteStart[Status and $0F, Note] >= 0 then begin
            MidiNotes[MidiNoteCount].StartTick := NoteStart[Status and $0F, Note];
            MidiNotes[MidiNoteCount].Duration := AbsTick - NoteStart[Status and $0F, Note];
            MidiNotes[MidiNoteCount].Note := Note;
            MidiNotes[MidiNoteCount].Channel := Status and $0F;

             MidiNotes[MidiNoteCount].Velocity := NoteStartVelo[Status and $0F, Note];

            Inc(MidiNoteCount); NoteStart[Status and $0F, Note] := -1;
          end;
        end
        else if Status = $FF then
        begin
          FS.ReadBuffer(B, 1); TSizeMeta := ReadVarLen;
          if B = $51 then begin
            var Tmp: array[0..2] of Byte; FS.ReadBuffer(Tmp, 3);
            var MPQN := (Tmp[0] shl 16) or (Tmp[1] shl 8) or Tmp[2];
             Edit1.Text := IntToStr(Math.EnsureRange(Round(60000000 / MPQN), 1, 255));

          end else if B = $58 then begin // METRUM
            var TimeSig: array[0..3] of Byte;
            FS.ReadBuffer(TimeSig, 4);
            Edit2.Text := IntToStr(Math.EnsureRange(Round(TimeSig[0]), 1, 255));
            Edit3.Text := IntToStr(Math.EnsureRange(Round(Math.Power(2, TimeSig[1])), 1, 255));

          end else if B in [$01, $05, $06] then begin
            SetLength(MName, TSizeMeta); if TSizeMeta > 0 then FS.ReadBuffer(MName[1], TSizeMeta);
            MidiMarkers[MidiMarkerCount].Tick := AbsTick;
            MidiMarkers[MidiMarkerCount].Name := string(MName);

            MidiMarkers[MidiMarkerCount].TrackIdx := (RunningStatus and $0F);  // i to aktualny track
            MidiMarkers[MidiMarkerCount].MetaType := B;

            Inc(MidiMarkerCount);
          end else FS.Seek(TSizeMeta, soFromCurrent);
        end
        else if (Status = $F0) or (Status = $F7) then begin TSizeMeta := ReadVarLen; FS.Seek(TSizeMeta, soFromCurrent); end
        else begin
          case (Status and $F0) of
            $B0: begin
              FS.ReadBuffer(CC_Num, 1); FS.ReadBuffer(CC_Val, 1);
              CurrentChannel := Status and $0F; GridRow := CurrentChannel + 1;
              if CC_Num = 0 then StringGrid1.Cells[3, GridRow] := IntToStr(CC_Val);
              if CC_Num = 32 then StringGrid1.Cells[7, GridRow] := IntToStr(CC_Val);
              if CC_Num = 7 then StringGrid1.Cells[5, GridRow] := IntToStr(CC_Val);
              if CC_Num = 10 then StringGrid1.Cells[6, GridRow] := IntToStr(CC_Val);
            end;
            $C0: begin FS.ReadBuffer(PatchNum, 1); StringGrid1.Cells[4, (Status and $0F) + 1] := IntToStr(PatchNum); end;
            $E0: begin
              FS.ReadBuffer(B1, 1); FS.ReadBuffer(B2, 1);
              WheelEvents[WheelCount].Tick := AbsTick; WheelEvents[WheelCount].Channel := Status and $0F;
              WheelEvents[WheelCount].LSB := B1; WheelEvents[WheelCount].MSB := B2; Inc(WheelCount);
            end;
            $A0: FS.Seek(2, soFromCurrent); $D0: FS.Seek(1, soFromCurrent);
          end;
        end;

        Size := FS.Position - RawStartPos;
        EventIdx := Length(MidiTracks[i].Events);
        SetLength(MidiTracks[i].Events, EventIdx + 1);
        MidiTracks[i].Events[EventIdx].DeltaTime := Delta;
        SetLength(MidiTracks[i].Events[EventIdx].Data, Size);
        FS.Position := RawStartPos; FS.ReadBuffer(MidiTracks[i].Events[EventIdx].Data[0], Size);
      end;
      FS.Position := j + TSize;
    end;

    Remaining := FS.Size - FS.Position;
    if Remaining > 0 then begin SetLength(FExtraData, Remaining); FS.ReadBuffer(FExtraData[0], Remaining); end;
    StringGrid1.Invalidate;
  finally
    FS.Free;
  end;

  StringGrid2.ColCount := Max(2000, Trunc(FMaxPos / (FPPQ / 4.0)) + 128);
  NotifyDataChanged;

  Timer1.Enabled := False;
  FCurrentPos := 0;
  FLastPos := 0;
  //for var i := 0 to 15 do midiOutShortMsg(FMidiOut, $B0 or i or ($7B shl 8));
  StringGrid2.LeftCol := 0;
  if Form7.Visible then Form7.DrawGrid2.LeftCol := 0;
  StringGrid2.Invalidate;
  if Form7.Visible then Form7.DrawGrid2.Invalidate;
  Edit5.Text := StringReplace(GetMidiTimeStr(FCurrentPos), ':', '.', [rfReplaceAll]);
  StatusBar1.Panels[0].Text := 'Wczytano: ' + ExtractFileName(OpenDialog1.FileName);
end;


procedure TForm1.Button2Click(Sender: TObject);
var
  FS: TFileStream;
  TrackStream: TMemoryStream;
  i, t: Integer;
  ID: array[0..3] of AnsiChar;
  C: Cardinal;
  W: Word;
  EndOfTrack: array[0..2] of Byte;
  BPM_Val: Double;
  MPQN: Cardinal;
  AllEvents: TList<TExportEvent>;
  CurrentAbs, LastTick: Int64;
  TempEv: TExportEvent;
  vTrans: Integer;
  DenPower, Num: Byte;
  DenomRaw: Integer;
  EvData: TBytes;
begin
  if not SaveDialog1.Execute then Exit;

  EndOfTrack[0] := $FF;
  EndOfTrack[1] := $2F;
  EndOfTrack[2] := $00;

  BPM_Val := EnsureRange(
    Round(StrToFloatDef(StringReplace(Edit1.Text, ',', '.', [rfReplaceAll]), 120.0)),
    1, 255
  );
  MPQN := Round(60000000 / BPM_Val);

  Num := EnsureRange(StrToIntDef(Edit2.Text, 4), 1, 255);
  DenomRaw := EnsureRange(StrToIntDef(Edit3.Text, 4), 1, 255);
  DenPower := Round(Log2(DenomRaw));

  FS := TFileStream.Create(SaveDialog1.FileName, fmCreate);
  try
    // ===== MThd =====
    ID := 'MThd';
    FS.Write(ID, 4);
    C := Swap32(6);
    FS.Write(C, 4);

    if SaveDialog1.FilterIndex = 1 then
      W := Swap16(1)
    else
      W := Swap16(0);
    FS.Write(W, 2);

    if SaveDialog1.FilterIndex = 1 then
      W := Swap16(Length(MidiTracks))
    else
      W := Swap16(1);
    FS.Write(W, 2);

    W := Swap16(FPPQ);
    FS.Write(W, 2);

    // ============================================================
    // ======================= FORMAT 1 ===========================
    // ============================================================
    if SaveDialog1.FilterIndex = 1 then
    begin
      for t := 0 to High(MidiTracks) do
      begin
        TrackStream := TMemoryStream.Create;
        try
          vTrans := StrToIntDef(StringGrid1.Cells[2, t + 1], 0);

          for i := 0 to High(MidiTracks[t].Events) do
          begin
            EvData := Copy(MidiTracks[t].Events[i].Data);

            if Length(EvData) < 1 then Continue;

            // Tempo
            if (Length(EvData) >= 6) and (EvData[0] = $FF) and (EvData[1] = $51) then
            begin
              EvData[3] := Byte((MPQN shr 16) and $FF);
              EvData[4] := Byte((MPQN shr 8) and $FF);
              EvData[5] := Byte(MPQN and $FF);
            end;

            // Metrum
            if (Length(EvData) >= 5) and (EvData[0] = $FF) and (EvData[1] = $58) then
            begin
              EvData[3] := Num;
              EvData[4] := DenPower;
            end;

            WriteVarLen(TrackStream, MidiTracks[t].Events[i].DeltaTime);

            // Transpozycja nut (bez perkusji)
            if (Length(EvData) >= 3) and
               ((EvData[0] and $F0 = $90) or (EvData[0] and $F0 = $80)) and
               ((EvData[0] and $0F) <> 9) then
              EvData[1] := Byte(EnsureRange(EvData[1] + vTrans, 0, 127));

            TrackStream.Write(EvData[0], Length(EvData));
          end;

          ID := 'MTrk';
          FS.Write(ID, 4);
          C := Swap32(TrackStream.Size);
          FS.Write(C, 4);
          FS.Write(TrackStream.Memory^, TrackStream.Size);
        finally
          TrackStream.Free;
        end;
      end;
    end
    // ============================================================
    // ======================= FORMAT 0 ===========================
    // ============================================================
    else
    begin
      AllEvents := TList<TExportEvent>.Create;
        try
          for t := 0 to High(MidiTracks) do
          begin
            CurrentAbs := 0;
            vTrans := StrToIntDef(StringGrid1.Cells[2, t + 1], 0);

              for i := 0 to High(MidiTracks[t].Events) do
              begin
                EvData := Copy(MidiTracks[t].Events[i].Data);
                if Length(EvData) < 1 then Continue;
                   CurrentAbs := CurrentAbs + MidiTracks[t].Events[i].DeltaTime;

                // Tempo
                if (Length(EvData) >= 6) and (EvData[0] = $FF)
                and (EvData[1] = $51) then
                    begin
                    EvData[3] := Byte((MPQN shr 16) and $FF);
                    EvData[4] := Byte((MPQN shr 8) and $FF);
                    EvData[5] := Byte(MPQN and $FF);
                    end;

                // Metrum
                if (Length(EvData) >= 5) and (EvData[0] = $FF)
                and (EvData[1] = $58) then
                    begin
                    EvData[3] := Num;
                    EvData[4] := DenPower;
                    end;

                // Transpozycja nut (bez perkusji)
                if (Length(EvData) >= 3) and
                  ((EvData[0] and $F0 = $90) or (EvData[0] and $F0 = $80)) and
                  ((EvData[0] and $0F) <> 9) then
                  EvData[1] := Byte(EnsureRange(EvData[1] + vTrans, 0, 127));

                  TempEv.AbsTick := CurrentAbs;
                  TempEv.Data := EvData;
                  AllEvents.Add(TempEv);
              end;
          end;

            TrackStream := TMemoryStream.Create;
          try
            LastTick := 0;
            for i := 0 to AllEvents.Count - 1 do
              begin
                WriteVarLen(TrackStream, AllEvents[i].AbsTick - LastTick);
                TrackStream.Write(AllEvents[i].Data[0], Length(AllEvents[i].Data));
                LastTick := AllEvents[i].AbsTick;
              end;

              WriteVarLen(TrackStream, 0);
              TrackStream.Write(EndOfTrack[0], 3);

              ID := 'MTrk';
              FS.Write(ID, 4);
              C := Swap32(TrackStream.Size);
              FS.Write(C, 4);
              FS.Write(TrackStream.Memory^, TrackStream.Size);
            finally
          TrackStream.Free;
          end;
        finally
          AllEvents.Free;
        end;
    end;
      finally
        FS.Free;
        StatusBar1.Panels[0].Text := 'Plik zapisany.';
  end;
end;

procedure TForm1.UpdateGridWidth;
var I, TotalWidth: Integer;
begin
  TotalWidth := 0;
  for I := 0 to StringGrid1.ColCount - 1
  do TotalWidth := TotalWidth + StringGrid1.ColWidths[I] + 1;
  StringGrid1.Width := TotalWidth + 4;
end;

procedure TForm1.Wczytaj1Click(Sender: TObject);
begin
  Button1Click(Sender);
end;

procedure TForm1.WczytajdefinicjInstrumentu1Click(Sender: TObject);
begin
  Form12.Show;
end;

procedure TForm1.Zakocz1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Zapisz1Click(Sender: TObject);
begin
  Button2Click(Sender);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if FMidiOut <> 0 then begin
      midiOutReset(FMidiOut);
      midiOutClose(FMidiOut);
  end;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  NewTopRow: Integer;
  MaxTopRow: Integer;
begin
  Handled := True;

  // Oblicza max dopuszczalny scroll (żeby nie było pustego miejsca na dole)
  MaxTopRow := StringGrid2.RowCount - StringGrid2.VisibleRowCount;
  if MaxTopRow < StringGrid2.FixedRows then MaxTopRow := StringGrid2.FixedRows;

  if ssShift in Shift then
  begin
    // POZIOMO (Shift + Scroll)
    if WheelDelta > 0 then
      StringGrid2.LeftCol := Max(0, StringGrid2.LeftCol - 3)
    else
      StringGrid2.LeftCol := Min(StringGrid2.ColCount - 1, StringGrid2.LeftCol + 3);
  end
  else
  begin
    // PIONOWO
    if WheelDelta > 0 then
      NewTopRow := StringGrid2.TopRow - 3
    else
      NewTopRow := StringGrid2.TopRow + 3;

    // Aplikuje bezpieczny zakres
    StringGrid2.TopRow := System.Math.EnsureRange(NewTopRow, StringGrid2.FixedRows, MaxTopRow);

    // SYNCHRONIZACJA KLAWIATURY (DrawGrid1)
    StringGrid1.TopRow := StringGrid2.TopRow;
  end;
end;

procedure TForm1.StringGrid2DblClick(Sender: TObject);
var
  TargetRowC3: Integer;
begin
  Form7.ResetAllModes; // Wyłącza wszystko

  if StringGrid2.Row > 0 then begin
  Form7.SelectedTrackID := StringGrid2.Row;
  Form7.Caption := Format('Piano Roll - Track %d', [StringGrid2.Row]);
  Form7.EnsureGridSize;
  Form7.DrawGrid2.LeftCol := StringGrid2.LeftCol;
  TargetRowC3 := 114 - 35;
  Form7.DrawGrid2.TopRow := TargetRowC3 - (Form7.DrawGrid2.VisibleRowCount div 2);
  Form7.DrawGrid1.TopRow := Form7.DrawGrid2.TopRow;
  Form7.Edit1.Text := Form1.Edit5.Text;
  Form7.Show;
  end;
end;

procedure TForm1.Markery1Click(Sender: TObject);
begin
  Form2.UpDown1.Position := 1;
  Form2.Edit1.Text := '1:00:000';
  Form2.Show;
end;

procedure TForm1.Metrum1Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.Mikser1Click(Sender: TObject);
begin
  Form18.Show;
end;

procedure TForm1.Kwantyzacja1Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.N4Click(Sender: TObject);
var
  TargetRowC3: Integer;
begin
  Form7.ResetAllModes; // Wyłącza wszystko

  if StringGrid2.Row > 0 then begin
  Form7.SelectedTrackID := StringGrid2.Row;
  Form7.Caption := Format('Piano Roll - Track %d', [StringGrid2.Row]);
  Form7.EnsureGridSize;
  Form7.DrawGrid2.LeftCol := StringGrid2.LeftCol;
  TargetRowC3 := 114 - 35;
  Form7.DrawGrid2.TopRow := TargetRowC3 - (Form7.DrawGrid2.VisibleRowCount div 2);
  Form7.DrawGrid1.TopRow := Form7.DrawGrid2.TopRow;
  Form7.Edit1.Text := Form1.Edit5.Text;
  Form7.Show;
  end;
end;

procedure TForm1.Nowy1Click(Sender: TObject);
var
  NoteStart: array[0..15, 0..127] of Int64;
  i, r, c: Integer;
begin
   StringGrid1.BeginUpdate;
    try
      // Przechodzi po wszystkich komórkach danych (pominąwszy nagłówki)
      for r := StringGrid1.FixedRows to StringGrid1.RowCount - 1 do
        for c := StringGrid1.FixedCols to StringGrid1.ColCount - 1 do
          StringGrid1.Cells[c, r] := '';
      finally
        StringGrid1.EndUpdate;
    end;

    begin
    StringGrid2.BeginUpdate;
      try
        // Przechodzimy po wszystkich komórkach danych (pominąwszy nagłówki)
        for r := StringGrid2.FixedRows to StringGrid2.RowCount - 1 do
          for c := StringGrid2.FixedCols to StringGrid2.ColCount - 1 do
            StringGrid2.Cells[c, r] := '';
        finally
          StringGrid2.EndUpdate;
      end;

      StringGrid2.ColCount := 2000; // Ustawiasz domyślną długość dla nowego pliku
      // Jeśli używasz Cells w StringGrid2, dodaj to:
      for i := 0 to StringGrid2.ColCount - 1 do
      StringGrid2.Cols[i].Clear;

      // 1. INICJALIZACJA I CZYSZCZENIE TABLICY WIZUALNEJ (GRID)
      FMaxPos := 0;
      SetLength(FNoteMinMax, 17);
      for r := 0 to 16 do
        begin
          SetLength(FNoteMinMax[r], 5000);
          for c := 0 to 4999 do FNoteMinMax[r, c].HasNote := False;
        end;

      // 2. RESETOWANIE STRUKTUR MIDI (NOTY I ŚCIEŻKI)
      MidiEdited := False;
      MidiNoteCount := 0;
      MidiMarkerCount := 0;
      FillChar(NoteStart, SizeOf(NoteStart), $FF);
      //Reset pozycji MIDI
      FCurrentPos := 0;
      FLastPos := 0;

      // 3. Wyłączamy wszystkie grające nuty
      for i := 0 to 15 do midiOutShortMsg(FMidiOut, $B0 or i or ($7B shl 8));

      // 4. Przewijamy ekran siatki na początek
      StringGrid2.LeftCol := 0;

      // 5. Aktualizujemy Piano Roll jeśli jest otwarty
      if Form7.Visible then Form7.DrawGrid2.LeftCol := 0;

      // 6. Odświeżamy widok i liczniki
      StringGrid2.Invalidate;
      if Form7.Visible then Form7.DrawGrid2.Invalidate;
      Edit5.Text := StringReplace(GetMidiTimeStr(FCurrentPos), ':', '.', [rfReplaceAll]);
      StatusBar1.Panels[0].Text := 'Nowy plik midi';
      StringGrid2.Invalidate;
      if Form8.Visible then Form8.StringGrid1.Invalidate;
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Kwantyzacja1Click(Sender);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Metrum1Click(Sender);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Markery1Click(Sender);
end;

procedure TForm1.View1Click(Sender: TObject);
 begin
  if StringGrid2.Row > 0 then
  begin
    if not Assigned(Form8) then
      Form8 := TForm8.Create(Application);

    // 1. WYMUSZENIE PRZEŁADOWANIA DANYCH
    // Nawet jeśli okno już jest widoczne, te linie zaciągną nowe zdarzenia (te "wstrzyknięte")
    Form8.LoadEventsFromTrack(StringGrid2.Row);

    // 2. PRZENIESIENIE NA FRONT I POKAZANIE
    Form8.Show;
    Form8.BringToFront; // Upewnia się, że nie jest schowane pod Unit1

    // 3. AKTUALIZACJA CAPTION I REPAINT
    Form8.Caption := Format('Event View - Track %d', [StringGrid2.Row]);
    Form8.StringGrid1.Repaint; // Wymusza odświeżenie graficzne komórek
  end;
end;

procedure TForm1.About2Click(Sender: TObject);
begin
  Form6.Show;
end;

procedure TForm1.AddMarkerToMidiEngine(ATimeStr, AName: string);
  begin
    if MidiMarkerCount < 500000 then
    begin
    MidiMarkers[MidiMarkerCount].Tick := GetMidiTickFromStr(ATimeStr);
    MidiMarkers[MidiMarkerCount].Name := AName;
    MidiMarkers[MidiMarkerCount].MetaType := $06;
    Inc(MidiMarkerCount);
    end;
end;


function TForm1.GetMarkerTime(Index: Integer): string;
begin
   // Sprawdzamy czy to Marker ($06), a nie Lyrics ($05)
   if (Index >= 0) and (Index < MidiMarkerCount) and
      (MidiMarkers[Index].MetaType = $06) then

    Result := GetMidiTimeStr(MidiMarkers[Index].Tick)
  else
    Result := '';
end;

function TForm1.GetMarkerName(Index: Integer): string;
begin
  // Sprawdzamy czy to Marker ($06), a nie Lyrics ($05)
  if (Index >= 0) and (Index < MidiMarkerCount) and
     (MidiMarkers[Index].MetaType = $06) then

    Result := MidiMarkers[Index].Name
  else
    Result := '';
end;

end.


