unit Unit17;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.WinXPanels;

type
  TForm17 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    CardPanel1: TCardPanel;
    RadioGroup1: TRadioGroup;
    Note: TCard;
    KeyAfter: TCard;
    Controller: TCard;
    Patch: TCard;
    ChannelAfter: TCard;
    Wheel: TCard;
    RPN: TCard;
    NRPN: TCard;
    SysBank: TCard;
    SysData: TCard;
    Text: TCard;
    Lyrics: TCard;
    MCI: TCard;
    Expression: TCard;
    Hairpin: TCard;
    Chord: TCard;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    ComboBox2: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    ComboBox3: TComboBox;
    Label8: TLabel;
    Edit5: TEdit;
    ComboBox4: TComboBox;
    Label9: TLabel;
    ComboBox5: TComboBox;
    Label10: TLabel;
    Label12: TLabel;
    ComboBox6: TComboBox;
    Label13: TLabel;
    Edit6: TEdit;
    Label14: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label15: TLabel;
    Edit9: TEdit;
    Label17: TLabel;
    Label11: TLabel;
    Edit10: TEdit;
    Label16: TLabel;
    Edit11: TEdit;
    Edit12: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Edit13: TEdit;
    Label20: TLabel;
    Edit14: TEdit;
    Label21: TLabel;
    Edit15: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Edit17: TEdit;
    Edit18: TEdit;
    ComboBox7: TComboBox;
    Label24: TLabel;
    Label25: TLabel;
    ComboBox8: TComboBox;
    Label26: TLabel;
    ComboBox9: TComboBox;
    Edit16: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit16Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form17: TForm17;

implementation

{$R *.dfm}

uses unit8, sekwencermidi;


procedure TForm17.Button2Click(Sender: TObject);
begin
  Form17.Close;
end;

procedure TForm17.Edit16Change(Sender: TObject);
begin
  if SameText(Edit16.Text, 'Note') then
      begin
        RadioGroup1.ItemIndex := 0;
      end;

  if SameText(Edit16.Text, 'KeyAfter') then
      begin
        RadioGroup1.ItemIndex := 1;
      end;

  if SameText(Edit16.Text, 'Controller') then
      begin
        RadioGroup1.ItemIndex := 2;
      end;

  if SameText(Edit16.Text, 'Patch') then
      begin
        RadioGroup1.ItemIndex := 3;
      end;

  if SameText(Edit16.Text, 'ChannelAfter') then
      begin
        RadioGroup1.ItemIndex := 4;
      end;

  if SameText(Edit16.Text, 'Wheel') then
      begin
        RadioGroup1.ItemIndex := 5;
      end;

  if SameText(Edit16.Text, 'RPN') then
      begin
        RadioGroup1.ItemIndex := 6;
      end;

  if SameText(Edit16.Text, 'NRPN') then
      begin
        RadioGroup1.ItemIndex := 7;
      end;

  if SameText(Edit16.Text, 'SysBank') then
      begin
        RadioGroup1.ItemIndex := 8;
      end;

  if SameText(Edit16.Text, 'SysData') then
      begin
        RadioGroup1.ItemIndex := 9;
      end;

  if SameText(Edit16.Text, 'Text') then
      begin
        RadioGroup1.ItemIndex := 10;
      end;

  if SameText(Edit16.Text, 'Lyrics') then
      begin
        RadioGroup1.ItemIndex := 11;
      end;

  if SameText(Edit16.Text, 'MCI') then
      begin
        RadioGroup1.ItemIndex := 12;
      end;

  if SameText(Edit16.Text, 'Expression') then
      begin
        RadioGroup1.ItemIndex := 13;
      end;

  if SameText(Edit16.Text, 'Hairpin') then
      begin
        RadioGroup1.ItemIndex := 14;
      end;

  if SameText(Edit16.Text, 'Chord') then
      begin
        RadioGroup1.ItemIndex := 15;
      end;
end;

procedure TForm17.FormCreate(Sender: TObject);
begin
  RadioGroup1.Update;
end;

procedure TForm17.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    0: CardPanel1.ActiveCard := note;
    1: CardPanel1.ActiveCard := keyafter;
    2: CardPanel1.ActiveCard := Controller;
    3: CardPanel1.ActiveCard := Patch;
    4: CardPanel1.ActiveCard := ChannelAfter;
    5: CardPanel1.ActiveCard := Wheel;
    6: CardPanel1.ActiveCard := RPN;
    7: CardPanel1.ActiveCard := NRPN;
    8: CardPanel1.ActiveCard := SysBank;
    9: CardPanel1.ActiveCard := SysData;
    10: CardPanel1.ActiveCard := Text;
    11: CardPanel1.ActiveCard := Lyrics;
    12: CardPanel1.ActiveCard := MCI;
    13: CardPanel1.ActiveCard := Expression;
    14: CardPanel1.ActiveCard := Hairpin;
    15: CardPanel1.ActiveCard := Chord;
  end;

  if RadioGroup1.ItemIndex = 0 then
      begin
        Edit16.Text := 'Note';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Color := clWindow;
        Edit19.ReadOnly := False;

        Edit20.Color := clWindow;
        Edit20.ReadOnly := False;

        Edit21.Color := clWindow;
        Edit21.ReadOnly := False;

        Edit22.Text := '';
        Edit22.Color := cl3DLight;
        Edit22.ReadOnly := True;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;
      end;

   if RadioGroup1.ItemIndex = 1 then
      begin
        Edit16.Text := 'KeyAfter';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Color := clWindow;
        Edit19.ReadOnly := False;

        Edit20.Color := clWindow;
        Edit20.ReadOnly := false;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        Edit22.Text := '';
        Edit22.Color := cl3DLight;
        Edit22.ReadOnly := True;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;
      end;

  if  RadioGroup1.ItemIndex = 2 then
      begin
        Edit16.Text := 'Controller';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

         //Edit19.Text := '';
        Edit19.Color := clWindow;
        Edit19.ReadOnly := False;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        //Edit22.Text := '';
        Edit22.Color := clWindow;
        Edit22.ReadOnly := False;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;

      end;

  if  RadioGroup1.ItemIndex = 3 then
      begin
        Edit16.Text := 'Patch';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        //Edit19.Text := '';
        Edit19.Color := clWindow;
        Edit19.ReadOnly := False;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        //Edit22.Text := '';
        Edit22.Color := clWindow;
        Edit22.ReadOnly := False;

        //Edit23.Text := '';
        Edit23.Color := clWindow;
        Edit23.ReadOnly := False;
      end;

  if RadioGroup1.ItemIndex = 4 then
      begin
        Edit16.Text := 'ChannelAfter';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        //Edit22.Text := '';
        Edit22.Color := clWindow;
        Edit22.ReadOnly := False;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;
      end;

  if  RadioGroup1.ItemIndex = 5 then
      begin
        Edit16.Text := 'Wheel';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        //Edit22.Text := '';
        Edit22.Color := clWindow;
        Edit22.ReadOnly := False;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;
      end;

  if RadioGroup1.ItemIndex = 6 then
      begin
        Edit16.Text := 'RPN';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        //Edit22.Text := '';
        Edit22.Color := clWindow;
        Edit22.ReadOnly := False;

        //Edit23.Text := '';
        Edit23.Color := clWindow;
        Edit23.ReadOnly := False;
      end;

  if RadioGroup1.ItemIndex = 7 then
      begin
        Edit16.Text := 'NRPN';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        //Edit22.Text := '';
        Edit22.Color := clWindow;
        Edit22.ReadOnly := False;

        //Edit23.Text := '';
        Edit23.Color := clWindow;
        Edit23.ReadOnly := False;
      end;

  if  RadioGroup1.ItemIndex = 8 then
      begin
        Edit16.Text := 'SysBank';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        //Edit19.Text := '';
        Edit19.Color := clWindow;
        Edit19.ReadOnly := False;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        Edit22.Text := '';
        Edit22.Color := cl3DLight;
        Edit22.ReadOnly := True;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;
      end;

  if RadioGroup1.ItemIndex = 9 then
      begin
        Edit16.Text := 'SysData';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        Edit22.Text := '';
        Edit22.Color := cl3DLight;
        Edit22.ReadOnly := True;

        //Edit23.Text := '';
        Edit23.Color := clWindow;
        Edit23.ReadOnly := False;
      end;

  if  RadioGroup1.ItemIndex = 10 then
      begin
        Edit16.Text := 'Text';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        Edit22.Text := '';
        Edit22.Color := cl3DLight;
        Edit22.ReadOnly := True;

        //Edit23.Text := '';
        Edit23.Color := clWindow;
        Edit23.ReadOnly := False;
      end;

  if  RadioGroup1.ItemIndex = 11 then
      begin
        Edit16.Text := 'Lyrics';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        Edit22.Text := '';
        Edit22.Color := cl3DLight;
        Edit22.ReadOnly := True;

        //Edit23.Text := '';
        Edit23.Color := clWindow;
        Edit23.ReadOnly := False;
      end;

  if  RadioGroup1.ItemIndex = 12 then
      begin
        Edit16.Text := 'MCI';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        Edit22.Text := '';
        Edit22.Color := cl3DLight;
        Edit22.ReadOnly := True;

        //Edit23.Text := '';
        Edit23.Color := clWindow;
        Edit23.ReadOnly := False;
      end;

  if  RadioGroup1.ItemIndex = 13 then
      begin
        Edit16.Text := 'Expression';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        //Edit20.Text := '';
        Edit20.Color := clWindow;
        Edit20.ReadOnly := False;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        Edit22.Text := '';
        Edit22.Color := cl3DLight;
        Edit22.ReadOnly := True;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;
      end;

  if  RadioGroup1.ItemIndex = 14 then
      begin
        Edit16.Text := 'Hairpin';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        //Edit22.Text := '';
        Edit22.Color := clWindow;
        Edit22.ReadOnly := False;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;
      end;

  if  RadioGroup1.ItemIndex = 15 then
      begin
        Edit16.Text := 'Chord';
        Edit16.Color := cl3DLight;
        Edit16.ReadOnly := True;

        Edit19.Text := '';
        Edit19.Color := cl3DLight;
        Edit19.ReadOnly := True;

        Edit20.Text := '';
        Edit20.Color := cl3DLight;
        Edit20.ReadOnly := True;

        Edit21.Text := '';
        Edit21.Color := cl3DLight;
        Edit21.ReadOnly := True;

        //Edit22.Text := '';
        Edit22.Color := clWindow;
        Edit22.ReadOnly := False;

        Edit23.Text := '';
        Edit23.Color := cl3DLight;
        Edit23.ReadOnly := True;
      end;

end;

end.
