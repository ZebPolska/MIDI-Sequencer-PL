unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ShellAPI;

type
  TForm6 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
begin
Form6.Close;
end;

procedure TForm6.Image1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://instrumentyklawiszowe.com', nil, nil, SW_SHOWNORMAL);
end;

procedure TForm6.Label10Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://instrumentyklawiszowe.com', nil, nil, SW_SHOWNORMAL);
end;

end.
