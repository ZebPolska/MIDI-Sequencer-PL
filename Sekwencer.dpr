program Sekwencer;

uses
  Vcl.Forms,
  Vcl.Imaging.jpeg,
  Winapi.Windows,
  SekwencerMidi in 'SekwencerMidi.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  Unit6 in 'Unit6.pas' {Form6},
  Unit7 in 'Unit7.pas' {Form7},
  Unit8 in 'Unit8.pas' {Form8},
  Unit11 in 'Unit11.pas' {Form11},
  Unit12 in 'Unit12.pas' {Form12},
  Unit15 in 'Unit15.pas' {Form15},
  Unit16 in 'Unit16.pas' {Form16},
  S775Ins in 'S775Ins.pas',
  Unit5 in 'Unit5.pas' {Form5},
  Unit10 in 'Unit10.pas' {Form10},
  Unit17 in 'Unit17.pas' {Form17},
  Unit18 in 'Unit18.pas' {Form18},
  Unit19 in 'Unit19.pas' {Splash};

{$R *.res}

begin

  Splash := TSplash.Create(nil);
  Splash.Show;
  Splash.Update;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm15, Form15);
  Application.CreateForm(TForm16, Form16);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm17, Form17);
  Application.CreateForm(TForm18, Form18);
  Sleep(3000);
  Splash.Hide;
  Splash.Free;

  Application.Run;
end.
