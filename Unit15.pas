unit Unit15;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm15 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form15: TForm15;

implementation

{$R *.dfm}

uses SekwencerMidi;

procedure TForm15.Button1Click(Sender: TObject);
var

 Select, Liczba, ARow: Integer;
 //TrackIdx: Integer;
 i: Integer;
 TransVal: Integer;
 NewNote: Integer;
begin
  // --- POCZ¥TEK DODANEJ LOGIKI TRANSPOZYCJI ---
  //Select := Form1.StringGrid1.Row;
  //if (Select > 0) and (ComboBox1.ItemIndex <> -1) then
  //begin
    //TransVal := Integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
    //TrackIdx := Select - 1; // Indeks œcie¿ki (0-15)

    // Jeœli wybrano transpozycjê inn¹ ni¿ 0, modyfikujemy nuty bezpoœrednio w liœcie
    //if (TransVal <> 0) and (TrackIdx >= 0) and (TrackIdx < 16) then
    //begin
      //for i := 0 to Form1.FTrackLists[TrackIdx].Count - 1 do
      //begin
        //Ev := PMidiEvent(Form1.FTrackLists[TrackIdx][i]);

        // Sprawdzamy czy to Note On ($90) lub Note Off ($80)
        //if (Ev^.Status and $F0 = $90) or (Ev^.Status and $F0 = $80) then
        //begin
        //  NewNote := Ev^.Data1 + TransVal;
          // Zabezpieczenie zakresu MIDI 0-127
        //  if NewNote < 0 then NewNote := 0;
        //  if NewNote > 127 then NewNote := 127;

        //  Ev^.Data1 := Byte(NewNote);
        //end;
      //end;
      // Odœwie¿amy widok nut w Unit1
      //Form1.StringGrid2.Invalidate;
    //end;
  //end;
  // --- KONIEC DODANEJ LOGIKI TRANSPOZYCJI ---

  // Pobieramy aktualnie zaznaczony wiersz w Form1
  Select := Form1.StringGrid1.Row;
  // Sprawdzamy czy to nie nag³ówek
  if Select > 0 then
  begin
    Select := Form1.StringGrid1.Row;
      if (Select > 0) and (ComboBox1.ItemIndex <> -1) then
        begin
          liczba := Integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);

          // Sprawdzamy czy liczba jest ró¿na od zera
          if liczba <> 0 then
          Form1.StringGrid1.Cells[2, Select] := IntToStr(liczba)
          else
          Form1.StringGrid1.Cells[2, Select] := ''; // Czyœcimy komórkê, jeœli 0
        end;
  end;

  ARow := Form1.StringGrid1.Row;
  if ARow >= Form1.StringGrid1.FixedRows then
  begin
    // 3. Zapisujemy ComboBoxy
    Form1.StringGrid1.Cells[3, ARow] := ComboBox2.Text;
    Form1.StringGrid1.Cells[4, ARow] := ComboBox3.Text;

    Liczba := StrToIntDef(Edit1.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then Liczba := 1;
    Form1.StringGrid1.Cells[5, ARow] := IntToStr(Liczba);

    Liczba := StrToIntDef(Edit2.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then Liczba := 1;
    Form1.StringGrid1.Cells[6, ARow] := IntToStr(Liczba);
    Self.Close;
  end;
end;

procedure TForm15.Button2Click(Sender: TObject);
begin
  Form15.close;
end;

procedure TForm15.Edit1Exit(Sender: TObject);

var
  Liczba: Integer;
begin
  if form15.Edit1.Text <> '' then
  begin
    Liczba := StrToIntDef(Form15.Edit1.Text, 0);

    // Sprawdzenie zakresu 1-20
    if (Liczba < 1) or (Liczba > 127) then
    begin
      ShowMessage('WprowadŸ liczbê z zakresu od 1 do 127!');
      Form15.Edit1.SetFocus; // Wraca do pola, aby u¿ytkownik poprawi³ b³¹d
      Form15.Edit1.Text := '95';
    end;
  end;
end;

procedure TForm15.Edit2Exit(Sender: TObject);

var
  Liczba: Integer;
begin
  if form15.Edit2.Text <> '' then
  begin
    Liczba := StrToIntDef(Form15.Edit2.Text, 0);

    // Sprawdzenie zakresu 1-20
    if (Liczba < 1) or (Liczba > 127) then
    begin
      ShowMessage('WprowadŸ liczbê z zakresu od 1 do 127!');
      Form15.Edit2.SetFocus; // Wraca do pola, aby u¿ytkownik poprawi³ b³¹d
      Form15.Edit2.Text := '64';
    end;
  end;
end;

procedure TForm15.FormCreate(Sender: TObject);
begin
  ComboBox1.Clear;
  ComboBox1.Items.AddObject('Transpozycja +12', TObject(12));
  ComboBox1.Items.AddObject('Transpozycja +11', TObject(11));
  ComboBox1.Items.AddObject('Transpozycja +10', TObject(10));
  ComboBox1.Items.AddObject('Transpozycja +9', TObject(9));
  ComboBox1.Items.AddObject('Transpozycja +8', TObject(8));
  ComboBox1.Items.AddObject('Transpozycja +7', TObject(7));
  ComboBox1.Items.AddObject('Transpozycja +6', TObject(6));
  ComboBox1.Items.AddObject('Transpozycja +5', TObject(5));
  ComboBox1.Items.AddObject('Transpozycja +4', TObject(4));
  ComboBox1.Items.AddObject('Transpozycja +3', TObject(3));
  ComboBox1.Items.AddObject('Transpozycja +2', TObject(2));
  ComboBox1.Items.AddObject('Transpozycja +1', TObject(1));
  ComboBox1.Items.AddObject('Brak transpozycji', TObject(0));
  ComboBox1.Items.AddObject('Transpozycja -1', TObject(-1));
  ComboBox1.Items.AddObject('Transpozycja -2', TObject(-2));
  ComboBox1.Items.AddObject('Transpozycja -3', TObject(-3));
  ComboBox1.Items.AddObject('Transpozycja -4', TObject(-4));
  ComboBox1.Items.AddObject('Transpozycja -5', TObject(-5));
  ComboBox1.Items.AddObject('Transpozycja -6', TObject(-6));
  ComboBox1.Items.AddObject('Transpozycja -7', TObject(-7));
  ComboBox1.Items.AddObject('Transpozycja -8', TObject(-8));
  ComboBox1.Items.AddObject('Transpozycja -9', TObject(-9));
  ComboBox1.Items.AddObject('Transpozycja -10', TObject(-10));
  ComboBox1.Items.AddObject('Transpozycja -11', TObject(-11));
  ComboBox1.Items.AddObject('Transpozycja -12', TObject(-12));
  ComboBox1.ItemIndex := 12;
end;

procedure TForm15.FormShow(Sender: TObject);
var
  Liczba, ARow: Integer;
  TargetForm: TForm15;

  begin
    ARow := Form1.StringGrid1.Row;
    if ARow >= Form1.StringGrid1.FixedRows then
      begin
        Form15.ComboBox2.Text := Trim(Form1.StringGrid1.Cells[3, ARow]);
        Form15.ComboBox3.Text := Trim(Form1.StringGrid1.Cells[4, ARow]);
        Form15.Edit1.Text := Trim(Form1.StringGrid1.Cells[5, ARow]);
        Form15.Edit2.Text := Trim(Form1.StringGrid1.Cells[6, ARow]);
      end;

   Liczba := StrToIntDef(Edit1.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Edit1.Text := '95';
    end;

    // Obs³uga Edit2: Analogicznie jak wy¿ej
    Liczba := StrToIntDef(Edit2.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Edit2.Text := '64';
    end;

  if form15.Edit2.Text <> '' then
  begin
    Liczba := StrToIntDef(Form15.Edit2.Text, 0);

    // Sprawdzenie zakresu 1-20
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Edit2.Text := Inttostr(1);
    end;
  end;
end;



end.
