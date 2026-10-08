unit Unit18;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Winapi.CommCtrl;


type
  TForm18 = class(TForm)
    Panel1: TPanel;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    GroupBox2: TGroupBox;
    Edit16: TEdit;
    Edit1: TEdit;
    ProgressBar1: TProgressBar;
    UpDown1: TUpDown;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    ProgressBar4: TProgressBar;
    ProgressBar5: TProgressBar;
    ProgressBar6: TProgressBar;
    ProgressBar7: TProgressBar;
    ProgressBar8: TProgressBar;
    ProgressBar9: TProgressBar;
    ProgressBar10: TProgressBar;
    ProgressBar11: TProgressBar;
    ProgressBar12: TProgressBar;
    ProgressBar13: TProgressBar;
    ProgressBar14: TProgressBar;
    ProgressBar15: TProgressBar;
    ProgressBar16: TProgressBar;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    UpDown5: TUpDown;
    UpDown6: TUpDown;
    UpDown7: TUpDown;
    UpDown8: TUpDown;
    UpDown9: TUpDown;
    UpDown10: TUpDown;
    UpDown11: TUpDown;
    UpDown12: TUpDown;
    UpDown13: TUpDown;
    UpDown14: TUpDown;
    UpDown15: TUpDown;
    UpDown16: TUpDown;
    UpDown17: TUpDown;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
    procedure Edit12Change(Sender: TObject);
    procedure Edit13Change(Sender: TObject);
    procedure Edit14Change(Sender: TObject);
    procedure Edit15Change(Sender: TObject);
    procedure Edit16Change(Sender: TObject);
    procedure UpDown17Click(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form18: TForm18;

implementation

{$R *.dfm}

uses sekwencermidi;


procedure TForm18.Button2Click(Sender: TObject);

var
  W: Integer; //numer wiersza
begin
  if (Edit1.Text = '0') or (Trim(Edit1.Text) = '')
    then Form1.StringGrid1.Cells[5,1] := ''
  else Form1.StringGrid1.Cells[5,1] := Edit1.Text;

  if (Edit2.Text = '0') or (Trim(Edit2.Text) = '')
    then Form1.StringGrid1.Cells[5,2] := ''
  else Form1.StringGrid1.Cells[5,2] := Edit2.Text;

  if (Edit3.Text = '0') or (Trim(Edit3.Text) = '')
    then Form1.StringGrid1.Cells[5,3] := ''
  else Form1.StringGrid1.Cells[5,3] := Edit3.Text;

  if (Edit4.Text = '0') or (Trim(Edit4.Text) = '')
    then Form1.StringGrid1.Cells[5,4] := ''
  else Form1.StringGrid1.Cells[5,4] := Edit4.Text;

  if (Edit5.Text = '0') or (Trim(Edit5.Text) = '')
    then Form1.StringGrid1.Cells[5,5] := ''
  else Form1.StringGrid1.Cells[5,5] := Edit5.Text;

  if (Edit6.Text = '0') or (Trim(Edit6.Text) = '')
    then Form1.StringGrid1.Cells[5,6] := ''
  else Form1.StringGrid1.Cells[5,6] := Edit6.Text;

  if (Edit7.Text = '0') or (Trim(Edit7.Text) = '')
    then Form1.StringGrid1.Cells[5,7] := ''
  else Form1.StringGrid1.Cells[5,7] := Edit7.Text;

  if (Edit8.Text = '0') or (Trim(Edit8.Text) = '')
    then Form1.StringGrid1.Cells[5,8] := ''
  else Form1.StringGrid1.Cells[5,8] := Edit8.Text;

  if (Edit9.Text = '0') or (Trim(Edit9.Text) = '')
    then Form1.StringGrid1.Cells[5,9] := ''
  else Form1.StringGrid1.Cells[5,9] := Edit9.Text;

  if (Edit10.Text = '0') or (Trim(Edit10.Text) = '')
    then Form1.StringGrid1.Cells[5,10] := ''
  else Form1.StringGrid1.Cells[5,10] := Edit10.Text;

  if (Edit11.Text = '0') or (Trim(Edit11.Text) = '')
    then Form1.StringGrid1.Cells[5,11] := ''
  else Form1.StringGrid1.Cells[5,11] := Edit11.Text;

  if (Edit12.Text = '0') or (Trim(Edit12.Text) = '')
    then Form1.StringGrid1.Cells[5,12] := ''
  else Form1.StringGrid1.Cells[5,12] := Edit12.Text;

  if (Edit13.Text = '0') or (Trim(Edit13.Text) = '')
    then Form1.StringGrid1.Cells[5,13] := ''
  else Form1.StringGrid1.Cells[5,13] := Edit13.Text;

  if (Edit14.Text = '0') or (Trim(Edit14.Text) = '')
    then Form1.StringGrid1.Cells[5,14] := ''
  else Form1.StringGrid1.Cells[5,14] := Edit14.Text;

  if (Edit15.Text = '0') or (Trim(Edit15.Text) = '')
    then Form1.StringGrid1.Cells[5,15] := ''
  else Form1.StringGrid1.Cells[5,15] := Edit15.Text;

  if (Edit16.Text = '0') or (Trim(Edit16.Text) = '')
    then Form1.StringGrid1.Cells[5,16] := ''
  else Form1.StringGrid1.Cells[5,16] := Edit16.Text;

  ModalResult := mrOk;
  Form18.Close;
end;

procedure TForm18.Edit10Change(Sender: TObject);
begin
  ProgressBar10.Position := StrToIntDef(Edit10.Text, 0);
end;

procedure TForm18.Edit11Change(Sender: TObject);
begin
  ProgressBar11.Position := StrToIntDef(Edit11.Text, 0);
end;

procedure TForm18.Edit12Change(Sender: TObject);
begin
ProgressBar12.Position := StrToIntDef(Edit12.Text, 0);
end;

procedure TForm18.Edit13Change(Sender: TObject);
begin
  ProgressBar13.Position := StrToIntDef(Edit13.Text, 0);
end;

procedure TForm18.Edit14Change(Sender: TObject);
begin
  ProgressBar14.Position := StrToIntDef(Edit14.Text, 0);
end;

procedure TForm18.Edit15Change(Sender: TObject);
begin
ProgressBar15.Position := StrToIntDef(Edit15.Text, 0);
end;

procedure TForm18.Edit16Change(Sender: TObject);
begin
  ProgressBar16.Position := StrToIntDef(Edit16.Text, 0);
end;

procedure TForm18.Edit1Change(Sender: TObject);
begin
  ProgressBar1.Position := StrToIntDef(Edit1.Text, 0);
end;

procedure TForm18.Edit2Change(Sender: TObject);
begin
  ProgressBar2.Position := StrToIntDef(Edit2.Text, 0);
end;

procedure TForm18.Edit3Change(Sender: TObject);
begin
  ProgressBar3.Position := StrToIntDef(Edit3.Text, 0);
end;

procedure TForm18.Edit4Change(Sender: TObject);
begin
  ProgressBar4.Position := StrToIntDef(Edit4.Text, 0);
end;

procedure TForm18.Edit5Change(Sender: TObject);
begin
  ProgressBar5.Position := StrToIntDef(Edit5.Text, 0);
end;

procedure TForm18.Edit6Change(Sender: TObject);
begin
  ProgressBar6.Position := StrToIntDef(Edit6.Text, 0);
end;

procedure TForm18.Edit7Change(Sender: TObject);
begin
  ProgressBar7.Position := StrToIntDef(Edit7.Text, 0);
end;

procedure TForm18.Edit8Change(Sender: TObject);
begin
  ProgressBar8.Position := StrToIntDef(Edit8.Text, 0);
end;

procedure TForm18.Edit9Change(Sender: TObject);
begin
  ProgressBar9.Position := StrToIntDef(Edit9.Text, 0);
end;

procedure TForm18.FormShow(Sender: TObject);
Var
  Liczba: Integer;
begin

    Form18.Edit1.Text := Trim(Form1.StringGrid1.Cells[5,1]);
    Form18.Edit2.Text := Trim(Form1.StringGrid1.Cells[5,2]);
    Form18.Edit3.Text := Trim(Form1.StringGrid1.Cells[5,3]);
    Form18.Edit4.Text := Trim(Form1.StringGrid1.Cells[5,4]);
    Form18.Edit5.Text := Trim(Form1.StringGrid1.Cells[5,5]);
    Form18.Edit6.Text := Trim(Form1.StringGrid1.Cells[5,6]);
    Form18.Edit7.Text := Trim(Form1.StringGrid1.Cells[5,7]);
    Form18.Edit8.Text := Trim(Form1.StringGrid1.Cells[5,8]);
    Form18.Edit9.Text := Trim(Form1.StringGrid1.Cells[5,9]);
    Form18.Edit10.Text := Trim(Form1.StringGrid1.Cells[5,10]);
    Form18.Edit11.Text := Trim(Form1.StringGrid1.Cells[5,11]);
    Form18.Edit12.Text := Trim(Form1.StringGrid1.Cells[5,12]);
    Form18.Edit13.Text := Trim(Form1.StringGrid1.Cells[5,13]);
    Form18.Edit14.Text := Trim(Form1.StringGrid1.Cells[5,14]);
    Form18.Edit15.Text := Trim(Form1.StringGrid1.Cells[5,15]);
    Form18.Edit16.Text := Trim(Form1.StringGrid1.Cells[5,16]);

  Liczba := StrToIntDef(Edit1.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
        begin
          Form18.Edit1.Text := '0';
          Form18.Checkbox1.Checked := False;
        end
        else
          begin
          Form18.Checkbox1.Checked := True;
          end;

    Liczba := StrToIntDef(Edit2.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
      begin
        Form18.Edit2.Text := '0';
        Form18.Checkbox2.Checked := False;
      end
      else
        begin
          Form18.Checkbox2.Checked := True;
        end;

    Liczba := StrToIntDef(Edit3.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit3.Text := '0';
      Form18.Checkbox3.Checked := False;
    end
      else
        begin
          Form18.Checkbox3.Checked := True;
        end;

    Liczba := StrToIntDef(Edit4.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit4.Text := '0';
      Form18.Checkbox4.Checked := False;
    end
      else
        begin
          Form18.Checkbox4.Checked := True;
        end;

    Liczba := StrToIntDef(Edit5.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit5.Text := '0';
      Form18.Checkbox5.Checked := False;
    end
      else
        begin
          Form18.Checkbox5.Checked := True;
        end;

    Liczba := StrToIntDef(Edit6.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit6.Text := '0';
      Form18.Checkbox6.Checked := False;
    end
      else
        begin
          Form18.Checkbox6.Checked := True;
        end;

    Liczba := StrToIntDef(Edit7.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit7.Text := '0';
      Form18.Checkbox7.Checked := False;
    end
      else
        begin
          Form18.Checkbox7.Checked := True;
        end;

    Liczba := StrToIntDef(Edit8.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit8.Text := '0';
      Form18.Checkbox8.Checked := False;
    end
      else
        begin
          Form18.Checkbox8.Checked := True;
        end;

    Liczba := StrToIntDef(Edit9.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit9.Text := '0';
      Form18.Checkbox9.Checked := False;
    end
      else
        begin
          Form18.Checkbox9.Checked := True;
        end;

    Liczba := StrToIntDef(Edit10.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit10.Text := '0';
      Form18.Checkbox10.Checked := False;
    end
      else
        begin
          Form18.Checkbox10.Checked := True;
        end;

    Liczba := StrToIntDef(Edit11.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit11.Text := '0';
      Form18.Checkbox11.Checked := False;
    end
      else
        begin
          Form18.Checkbox11.Checked := True;
        end;

    Liczba := StrToIntDef(Edit12.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit12.Text := '0';
      Form18.Checkbox12.Checked := False;
    end
      else
        begin
          Form18.Checkbox12.Checked := True;
        end;

    Liczba := StrToIntDef(Edit13.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit13.Text := '0';
      Form18.Checkbox13.Checked := False;
    end
      else
        begin
          Form18.Checkbox13.Checked := True;
        end;

    Liczba := StrToIntDef(Edit14.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit14.Text := '0';
      Form18.Checkbox14.Checked := False;
    end
      else
        begin
          Form18.Checkbox14.Checked := True;
        end;

    Liczba := StrToIntDef(Edit15.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit15.Text := '0';
      Form18.Checkbox15.Checked := False;
    end
      else
        begin
          Form18.Checkbox15.Checked := True;
        end;

    Liczba := StrToIntDef(Edit16.Text, 0);
    if (Liczba < 1) or (Liczba > 127) then
    begin
      Form18.Edit16.Text := '0';
      Form18.Checkbox16.Checked := False;
    end
      else
        begin
          Form18.Checkbox16.Checked := True;
        end;

end;

procedure TForm18.UpDown17Click(Sender: TObject; Button: TUDBtnType);
var
  Liczba: Integer;
begin
  if Checkbox1.Checked then
    begin
        Liczba := StrToIntDef(Edit1.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit1.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit1.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox2.Checked then
    begin
        Liczba := StrToIntDef(Edit2.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit2.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit2.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox3.Checked then
    begin
        Liczba := StrToIntDef(Edit3.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit3.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit3.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox4.Checked then
    begin
        Liczba := StrToIntDef(Edit4.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit4.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit4.Text := IntToStr(Liczba - 1);
    end;

   if Checkbox5.Checked then
    begin
        Liczba := StrToIntDef(Edit5.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit5.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit5.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox6.Checked then
    begin
        Liczba := StrToIntDef(Edit6.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit6.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit6.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox7.Checked then
    begin
        Liczba := StrToIntDef(Edit7.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit7.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit7.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox8.Checked then
    begin
        Liczba := StrToIntDef(Edit8.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit8.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit8.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox9.Checked then
    begin
        Liczba := StrToIntDef(Edit9.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit9.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit9.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox10.Checked then
    begin
        Liczba := StrToIntDef(Edit10.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit10.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit10.Text := IntToStr(Liczba - 1);
    end;

  if Checkbox11.Checked then
    begin
        Liczba := StrToIntDef(Edit11.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit11.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit11.Text := IntToStr(Liczba - 1);
    end;


  if Checkbox12.Checked then
    begin
        Liczba := StrToIntDef(Edit12.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit12.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit12.Text := IntToStr(Liczba - 1);
    end;


  if Checkbox13.Checked then
    begin
        Liczba := StrToIntDef(Edit13.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit13.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit13.Text := IntToStr(Liczba - 1);
    end;


  if Checkbox14.Checked then
    begin
        Liczba := StrToIntDef(Edit14.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit14.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit14.Text := IntToStr(Liczba - 1);
    end;


  if Checkbox15.Checked then
    begin
        Liczba := StrToIntDef(Edit15.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit15.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit15.Text := IntToStr(Liczba - 1);
    end;


   if Checkbox16.Checked then
    begin
        Liczba := StrToIntDef(Edit16.Text, 0);
      if (Button = btNext) and (Liczba < 127) then
        Edit16.Text := IntToStr(Liczba + 1)
      else if (Button = btPrev) and (Liczba > 0) then
        Edit16.Text := IntToStr(Liczba - 1);
    end;

end;


end.
