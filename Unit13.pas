unit Unit13;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm13 = class(TForm)
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
     function GetSelectedEventID: Integer;
      { Public declarations }
  end;

var
  Form13: TForm13;

implementation

{$R *.dfm}

uses Unit9;


function TForm13.GetSelectedEventID: Integer;
begin
  // Standardowe 1-8
  if RadioButton1.Checked then Exit(1); // Note
  if RadioButton2.Checked then Exit(2); // Key Aftertouch
  if RadioButton3.Checked then Exit(3); // Controller
  if RadioButton4.Checked then Exit(4); // Patch Change
  if RadioButton5.Checked then Exit(5); // Channel Aftertouch
  if RadioButton6.Checked then Exit(6); // Pitch Wheel
  if RadioButton7.Checked then Exit(7); // RPN
  if RadioButton8.Checked then Exit(8); // NRPN

  // Specjalne 9-16
  if RadioButton9.Checked  then Exit(9);  // Sys Bank
  if RadioButton10.Checked then Exit(10); // Sys Data
  if RadioButton11.Checked then Exit(11); // Text
  if RadioButton12.Checked then Exit(12); // Lyrics
  if RadioButton13.Checked then Exit(13); // MCI Command
  if RadioButton14.Checked then Exit(14); // Expression (Meta)
  if RadioButton15.Checked then Exit(15); // Hairpin
  if RadioButton16.Checked then Exit(16); // Chord

  Result := 0;
end;

procedure TForm13.Button1Click(Sender: TObject);
begin
  Form9.Show;
  Form13.Close;
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
  Form13.Close;
end;

end.
