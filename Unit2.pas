unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Zastosowane: TGroupBox;
    Projekt: TGroupBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button3: TButton;
    ListView1: TListView;
    Button4: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    UpDown1: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Edit1Click(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshMarkerList;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses SekwencerMidi;

function IsValidYamahaMarker(const AName: string): Boolean;
var
  U: string;
begin
  U := UpperCase(Trim(AName));
  // Lista dopuszczalnych wzorców na podstawie Twoich RadioButtonów
  Result :=
    U.StartsWith('SFF') or
    U.StartsWith('SINT') or
    U.StartsWith('MAIN ') or
    U.StartsWith('INTRO ') or
    U.StartsWith('ENDING ') or
    U.StartsWith('FILL IN ') or
    U.StartsWith('BREAK') or
    U.StartsWith('FN:'); // Obs³uga Twoich par fn:
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  Col: TListColumn;
begin
  // Konfiguracja ListView
  ListView1.ViewStyle := vsReport;
  ListView1.ReadOnly := True;
  ListView1.RowSelect := True;
  ListView1.GridLines := True;

  ListView1.Columns.Clear;
  Col := ListView1.Columns.Add;
  Col.Caption := 'Pozycja';
  Col.Width := 70;

  Col := ListView1.Columns.Add;
  Col.Caption := 'Marker';
  Col.Width := 120;

end;

procedure TForm2.FormShow(Sender: TObject);
begin
  RefreshMarkerList;
end;

procedure TForm2.RefreshMarkerList;
var
  i: Integer;
  NewItem: TListItem;
  MName, UpperM: string;
  IsValidYamaha: Boolean;
begin
  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;
    if Assigned(Form1) then
    begin
      for i := 0 to Form1.MarkerCount - 1 do
      begin
        if Form1.MidiMarkers[i].MetaType <> $06 then Continue;
        MName := Form1.GetMarkerName(i);
        UpperM := UpperCase(Trim(MName));

        // RYGORYSTYCZNY FILTR YAMAHA
        IsValidYamaha :=
          UpperM.StartsWith('MAIN') or UpperM.StartsWith('INTRO') or
          UpperM.StartsWith('ENDING') or UpperM.StartsWith('FILL') or
          UpperM.StartsWith('SFF') or UpperM.StartsWith('SINT') or
          UpperM.StartsWith('FN:') or UpperM.StartsWith('SECTION');

       if IsValidYamahaMarker(MName) then
        begin
          NewItem := ListView1.Items.Add;
          NewItem.Caption := Form1.GetMarkerTime(i);
          NewItem.SubItems.Add(MName);
        end;
      end;
    end;
  finally
    ListView1.Items.EndUpdate;
  end;
end;

procedure TForm2.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
// Ka¿de klikniêcie zmienia tylko numer taktu, reszta jest sta³a
  Edit1.Text := IntToStr(UpDown1.Position) + ':00:000';
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  i, j: Integer;
begin
  if not Assigned(Form1) then Exit;

  // USUWANIE TYLKO MARKERÓW ($06), zostawiamy Lyrics ($05)
  i := 0;
  while i < Form1.MidiMarkerCount do
  begin
    if Form1.MidiMarkers[i].MetaType = $06 then
    begin
      // Przesuwamy resztê tablicy o 1 w lewo
      for j := i to Form1.MidiMarkerCount - 2 do
        Form1.MidiMarkers[j] := Form1.MidiMarkers[j + 1];
      Dec(Form1.MidiMarkerCount);
    end
    else
      Inc(i); // Jeœli to Lyrics, idziemy dalej
  end;

  // TERAZ dodaj nowe markery z ListView
  for i := 0 to ListView1.Items.Count - 1 do
  begin
    Form1.AddMarkerToMidiEngine(
      ListView1.Items[i].Caption,
      ListView1.Items[i].SubItems[0]
    );
    // WA¯NE: Wewn¹trz AddMarkerToMidiEngine dopisz:
    Form1.MidiMarkers[Form1.MidiMarkerCount-1].MetaType := $06;

  end;

  Form1.StringGrid2.Invalidate;
  form2.Close;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  ListItem: TListItem;
  SelectedValue, Position: string;
  IsSystemMarker, HasSInt: Boolean;
  i: Integer;
begin
   for i := 0 to ListView1.Items.Count - 1 do
    if ListView1.Items[i].SubItems[0] = ComboBox1.Text then
    begin
      ShowMessage('Ten marker jest ju¿ u¿yty!');
      Exit; // Przerywa procedurê, nie doda duplikatu
    end;

  if ComboBox1.ItemIndex = -1 then Exit;

  Position := Edit1.Text;
  if Position = '' then
  begin
    ShowMessage('Brak pozycji markera');
    Exit;
  end;

  SelectedValue := ComboBox1.Text;

  IsSystemMarker :=
    (SelectedValue = 'SFF1') or
    (SelectedValue = 'SFF2') or
    (SelectedValue = 'SInt');

  // --- dodanie markera g³ównego ---
  ListItem := ListView1.Items.Add;
  ListItem.Caption := Position;
  ListItem.SubItems.Add(SelectedValue);

  if Assigned(Form1) then
    Form1.AddMarkerToMidiEngine(Position, SelectedValue);

  // --- SInt + SFF zawsze 1:00:000 ---
  if (SelectedValue = 'SFF1') or (SelectedValue = 'SFF2') then
  begin
    HasSInt := False;
    for i := 0 to ListView1.Items.Count - 1 do
      if ListView1.Items[i].SubItems[0] = 'SInt' then
        HasSInt := True;

    if not HasSInt then
    begin
      ListItem := ListView1.Items.Add;
      ListItem.Caption := '1:00:000';
      ListItem.SubItems.Add('SInt');

      if Assigned(Form1) then
        Form1.AddMarkerToMidiEngine('1:00:000', 'SInt');
    end;
  end;

  // --- para fn: ---
  if not IsSystemMarker then
  begin
    ListItem := ListView1.Items.Add;
    ListItem.Caption := Position;
    ListItem.SubItems.Add('fn:' + SelectedValue);

    if Assigned(Form1) then
      Form1.AddMarkerToMidiEngine(Position, 'fn:' + SelectedValue);
  end;

  Form1.StringGrid2.Invalidate;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
    ListView1.Selected.Delete
  else
    RefreshMarkerList;
end;

procedure TForm2.Edit1Click(Sender: TObject);
begin
// Skoro Associate jest puste, sami kontrolujemy co l¹duje w Edit1
  Edit1.Text := IntToStr(UpDown1.Position) + ':00:000';
end;

procedure TForm2.RadioButton1Click(Sender: TObject);
begin
  // Ostrze¿enie przy zmianie formatu, jeœli lista nie jest pusta
  if ListView1.Items.Count > 0 then
    if MessageDlg('Zmiana formatu wyczyœci listê markerów. Kontynuowaæ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  ListView1.Items.Clear;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('SFF1');
  ComboBox1.Items.Add('Main A'); ComboBox1.Items.Add('Main B');
  ComboBox1.Items.Add('Main C'); ComboBox1.Items.Add('Main D');
  ComboBox1.Items.Add('Fill In AA'); ComboBox1.Items.Add('Fill In BB');
  ComboBox1.Items.Add('Fill In CC'); ComboBox1.Items.Add('Fill In DD');
  ComboBox1.Items.Add('Intro A'); ComboBox1.Items.Add('Intro B');
  ComboBox1.Items.Add('Intro C');
  ComboBox1.Items.Add('Ending A'); ComboBox1.Items.Add('Ending B');
  ComboBox1.Items.Add('Ending C');
  ComboBox1.Items.Add('Fill In BA');
end;

procedure TForm2.RadioButton2Click(Sender: TObject);
begin
  if ListView1.Items.Count > 0 then
    if MessageDlg('Zmiana formatu wyczyœci listê markerów. Kontynuowaæ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  ListView1.Items.Clear;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('SFF2');
  ComboBox1.Items.Add('SInt');
  ComboBox1.Items.Add('Main A'); ComboBox1.Items.Add('Main B');
  ComboBox1.Items.Add('Main C'); ComboBox1.Items.Add('Main D');
  ComboBox1.Items.Add('Fill In AA'); ComboBox1.Items.Add('Fill In BB');
  ComboBox1.Items.Add('Fill In CC'); ComboBox1.Items.Add('Fill In DD');
  ComboBox1.Items.Add('Fill In AB'); ComboBox1.Items.Add('Fill In AC');
  ComboBox1.Items.Add('Fill In AD'); ComboBox1.Items.Add('Fill In BA');
  ComboBox1.Items.Add('Fill In BC'); ComboBox1.Items.Add('Fill In BD');
  ComboBox1.Items.Add('Fill In CA'); ComboBox1.Items.Add('Fill In CB');
  ComboBox1.Items.Add('Fill In CD'); ComboBox1.Items.Add('Fill In DA');
  ComboBox1.Items.Add('Fill In DB'); ComboBox1.Items.Add('Fill In DC');
  ComboBox1.Items.Add('Break');
  ComboBox1.Items.Add('Intro A'); ComboBox1.Items.Add('Intro B');
  ComboBox1.Items.Add('Intro C');
  ComboBox1.Items.Add('Ending A'); ComboBox1.Items.Add('Ending B');
  ComboBox1.Items.Add('Ending C');
end;

end.
