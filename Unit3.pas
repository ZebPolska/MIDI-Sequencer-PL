unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Label1: TLabel;
    RadioButton5: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses SekwencerMidi;

procedure TForm3.Button1Click(Sender: TObject);
begin
form3.Close;
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  i: Integer;
  TempNames: TArray<string>;
  TempTimes: TArray<string>;
begin
  // --- KROK 1: Zapamiêtaj obecne nazwy i ich tekstowe pozycje (np. "3:00:000") ---
  SetLength(TempNames, Form1.MidiMarkerCount);
  SetLength(TempTimes, Form1.MidiMarkerCount);
  for i := 0 to Form1.MidiMarkerCount - 1 do
  begin
    TempNames[i] := Form1.MidiMarkers[i].Name;
    // GetMidiTimeStr zwróci nam np. "3:00:000" przy OBECNYM metrum
    TempTimes[i] := Form1.GetMidiTimeStr(Form1.MidiMarkers[i].Tick);
  end;

  // --- KROK 2: Ustaw nowe metrum w Form1 ---
  if Form3.RadioButton1.Checked then
  begin
  Form1.Edit2.Text := '2';
  Form1.Edit3.Text := '4';
  end;

  if Form3.RadioButton2.Checked then
  begin
  Form1.Edit2.Text := '3';
  Form1.Edit3.Text := '4';
  end;
  if Form3.RadioButton3.Checked then
  begin
  Form1.Edit2.Text := '4';
  Form1.Edit3.Text := '4';
  end;

  if Form3.RadioButton4.Checked then
  begin Form1.Edit2.Text := '6';
  Form1.Edit3.Text := '4';
  end;

  if Form3.RadioButton7.Checked then
  begin
  Form1.Edit2.Text := '6';
  Form1.Edit3.Text := '8';
  end;

  if Form3.RadioButton8.Checked then
  begin
  Form1.Edit2.Text := '7';
  Form1.Edit3.Text := '8';
  end;



  // WA¯NE: Wymuœ przeliczenie FTicksPerMeasure dla NOWEGO metrum
  Form1.FNumerator := StrToIntDef(Form1.Edit2.Text, 4);
  Form1.FDenominator := StrToIntDef(Form1.Edit2.Text, 4); // Tu ma byæ Edit3!
  Form1.RecalculateTimeStructure;

  // --- KROK 3: Zaktualizuj ticki markerów wed³ug NOWEGO metrum ---
  for i := 0 to Form1.MidiMarkerCount - 1 do
  begin
    // GetMidiTickFromStr u¿yje nowej wartoœci FTicksPerMeasure
    // i przesunie marker "3:00:000" z ticka 3840 (4/4) na tick 2880 (3/4)
    Form1.MidiMarkers[i].Tick := Form1.GetMidiTickFromStr(TempTimes[i]);
  end;

  Form1.StringGrid2.Invalidate;
  Form3.Close;
end;




end.
