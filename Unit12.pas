unit Unit12;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.StdCtrls, Vcl.Dialogs, Vcl.Grids,
  Vcl.ComCtrls, Vcl.Controls, System.Generics.Collections;

type
  // Rekord do przechowywania nazwy i numeru patcha (brzmienia)
  TInsEntry = record
    ID: Integer;
    Name: string;
  end;

 type
  TProgramEntry = record
    MSB: Integer;
    LSB: Integer;
    Patch: Integer;
    Name: string;
  end;

  TForm12 = class(TForm)
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    GroupBox1: TGroupBox;
    Button1: TButton; // Zastosuj
    Button2: TButton; // Anuluj
    Button3: TButton; // Dodaj nowy
    Button4: TButton; // Zapisz
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCurrentInsFilePath: string; // Zapamiętuje ścieżkę do aktualnego pliku .ins
  public
    FAllPatchMaps: TObjectDictionary<string, TList<TInsEntry>>;
    FProgramMap: TObjectDictionary<string, TList<TProgramEntry>>;
    procedure LoadPatchMapForInstrument(const InsName: string);
    procedure LoadFullProgramMap(const InsName: string);
    function GetPatchNameByNumber(const MapName: string; PatchNumber: Integer): string;
    function GetProgramName(const InsName: string; MSB, LSB, Patch: Integer): string;
  end;

var
  Form12: TForm12;

implementation

uses SekwencerMidi;

{$R *.dfm}


procedure TForm12.LoadFullProgramMap(const InsName: string);
var
  SL: TStringList;
  S: string;
  CurMSB, CurLSB: Integer;
  Entry: TProgramEntry;
  p1, p2, p3: Integer;
  ProgList: TList<TProgramEntry>;
  Cur: string;
  SelectedName: string;

begin
  if not FileExists(FCurrentInsFilePath) then Exit;

  if not FProgramMap.ContainsKey(SelectedName) then
  LoadFullProgramMap(SelectedName);

  ProgList := TList<TProgramEntry>.Create;
  FProgramMap.Add(InsName, ProgList);

  SL := TStringList.Create;
  try
    SL.LoadFromFile(FCurrentInsFilePath, TEncoding.ANSI);

    CurMSB := -1;
    CurLSB := -1;

    for S in SL do
    begin
    Cur := Trim(S);

      // [Bank 0 64]
      if S.StartsWith('[Bank') then
      begin
        // rozbijamy: [Bank MSB LSB]
        p1 := Pos(' ', S);
        p2 := Pos(' ', S, p1 + 1);
        p3 := Pos(']', S);

        CurMSB := StrToIntDef(Copy(S, p1 + 1, p2 - p1 - 1), -1);
        CurLSB := StrToIntDef(Copy(S, p2 + 1, p3 - p2 - 1), -1);
        Continue;
      end;

      // Patch[x]=Name
      if (CurMSB >= 0) and (CurLSB >= 0) and S.StartsWith('Patch[') then
      begin
        p1 := Pos('[', S);
        p2 := Pos(']', S);

        Entry.MSB := CurMSB;
        Entry.LSB := CurLSB;
        Entry.Patch := StrToIntDef(Copy(S, p1 + 1, p2 - p1 - 1), -1);
        Entry.Name := Trim(Copy(S, Pos('=', S) + 1, MaxInt));

        if Entry.Patch >= 0 then
          ProgList.Add(Entry);
      end;
    end;

  finally
    SL.Free;
  end;
end;

function TForm12.GetProgramName(
  const InsName: string;
  MSB, LSB, Patch: Integer
): string;
var
  List: TList<TProgramEntry>;
  Entry: TProgramEntry;
begin
  Result := '';  // ← ZERO opisów technicznych

  if not FProgramMap.TryGetValue(InsName, List) then
    Exit;

  for Entry in List do
    if (Entry.MSB = MSB)
    and (Entry.LSB = LSB)
    and (Entry.Patch = Patch) then
      Exit(Entry.Name);
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
  // Inicjalizacja słownika - doOwnsValues automatycznie czyści pamięć

  FAllPatchMaps :=
    TObjectDictionary<string, TList<TInsEntry>>.Create([doOwnsValues]);
  FProgramMap :=
    TObjectDictionary<string, TList<TProgramEntry>>.Create([doOwnsValues]);

end;

procedure TForm12.FormDestroy(Sender: TObject);
begin
  FAllPatchMaps.Free;
  FProgramMap.Free;
end;

// BUTTON 3: DODAJ NOWY (DOPISUJE DO LISTY)
procedure TForm12.Button3Click(Sender: TObject);
var
  InsFile: TStringList;
  i: Integer;
  Line, InsName: string;
  InHeader: Boolean;
begin
  if OpenDialog1.Execute then
  begin
    FCurrentInsFilePath := OpenDialog1.FileName; // Zapamiętaj ścieżkę
    InsFile := TStringList.Create;
    try
      InsFile.LoadFromFile(FCurrentInsFilePath, TEncoding.ANSI);
      InHeader := False;
      ListBox1.Items.BeginUpdate;

      for i := 0 to InsFile.Count - 1 do
      begin
        Line := Trim(InsFile[i]);
        if Line = '.Instrument Definitions' then InHeader := True;

        if InHeader and Line.StartsWith('[') and Line.EndsWith(']') then
        begin
          InsName := Copy(Line, 2, Length(Line) - 2);
          // Dodaj tylko jeśli jeszcze nie ma na liście
          if ListBox1.Items.IndexOf(InsName) = -1 then
            ListBox1.Items.Add(InsName);
        end;

        if InHeader and Line.StartsWith('.') and (Line <> '.Instrument Definitions') then
          InHeader := False;
      end;
      ListBox1.Items.EndUpdate;
    finally
      InsFile.Free;
    end;
  end;
end;

// BUTTON 1: ZASTOSUJ
procedure TForm12.Button1Click(Sender: TObject);
var
  SelectedName: string;
begin
  if ListBox1.ItemIndex = -1 then Exit;
  SelectedName := ListBox1.Items[ListBox1.ItemIndex];

  // 1. Najpierw ładujemy mapę patchy do słownika
  LoadPatchMapForInstrument(SelectedName);

  // 2. Kopiujemy całą listę do ComboBox2 na Form1
  Form1.ComboBox2.Items.Assign(ListBox1.Items);
  Form1.ComboBox2.ItemIndex := ListBox1.ItemIndex;

  // 3. Wpisujemy nazwę instrumentu do aktywnego wiersza (kolumna 4)
  if Form1.StringGrid1.Row > 0 then
    Form1.StringGrid1.Cells[4, Form1.StringGrid1.Row] := SelectedName;

  // 4. WYWOŁANIE TŁUMACZA W UNIT1 (to zamieni liczby na nazwy w cały gridzie)

  Self.Close;
end;

// ŁADOWANIE MAPY Z PLIKU .INS
procedure TForm12.LoadPatchMapForInstrument(const InsName: string);
var
  SL: TStringList;
  Line, CurLine: string;
  InInstrument: Boolean;
  Entry: TInsEntry;
  List: TList<TInsEntry>;
  p1, p2: Integer;
begin
  if not FileExists(FCurrentInsFilePath) then Exit;

  SL := TStringList.Create;
  try
    SL.LoadFromFile(FCurrentInsFilePath, TEncoding.ANSI);

    FAllPatchMaps.Remove(InsName);
    List := TList<TInsEntry>.Create;
    InInstrument := False;

    for Line in SL do
    begin
      CurLine := Trim(Line);

      if CurLine = '[' + InsName + ']' then
        begin
          InInstrument := True;
          Continue;
        end;

      if InInstrument and CurLine.StartsWith('[') then
      Break;

      if InInstrument and CurLine.StartsWith('Patch[') then
        begin
          p1 := Pos('[', CurLine);
          p2 := Pos(']', CurLine);

      if (p1 > 0) and (p2 > p1) then
        begin
          Entry.ID := StrToIntDef(Copy(CurLine, p1 + 1, p2 - p1 - 1), -1);
          Entry.Name := Trim(Copy(CurLine, Pos('=', CurLine) + 1, MaxInt));

          if Entry.ID >= 0 then
          List.Add(Entry);
        end;
      end;
    end;

    if List.Count > 0 then
      FAllPatchMaps.Add(InsName, List)
    else
      List.Free;

  finally
    SL.Free;
  end;
end;

// FUNKCJA DLA UNIT1 DO TŁUMACZENIA LICZB
function TForm12.GetPatchNameByNumber(const MapName: string; PatchNumber: Integer): string;
var
  List: TList<TInsEntry>;
  Entry: TInsEntry;
begin
  Result := IntToStr(PatchNumber); // Domyślnie zwraca liczbę
  if FAllPatchMaps.TryGetValue(MapName, List) then
  begin
    for Entry in List do
      if Entry.ID = PatchNumber then Exit(Entry.Name);
  end;
end;

procedure TForm12.Button4Click(Sender: TObject);
begin
  if ListBox1.ItemIndex <> -1 then ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TForm12.Button5Click(Sender: TObject);
begin
  if SaveDialog1.Execute then ListBox1.Items.SaveToFile(SaveDialog1.FileName, TEncoding.UTF8);
end;

procedure TForm12.Button2Click(Sender: TObject);
begin
  Self.Close;
end;

end.
