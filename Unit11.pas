unit Unit11;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm11 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    FEditingNoteIndex: Integer;
    FUpdatingEdit: Boolean;
    function TicksToMBT(Ticks: Integer): string;
    function MBTToTicks(const S: string): Integer;
    procedure LoadNoteData(ANoteIndex: Integer);
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

uses SekwencerMidi, Unit7;

function TForm11.TicksToMBT(Ticks: Integer): string;
var
  PPQ, Numerator, TicksPerBar: Integer;
  Bar, Beat, Tick: Integer;
begin
  PPQ := Form1.FPPQ;
  Numerator := Form1.FNumerator;

  if PPQ <= 0 then PPQ := 480;
  if Numerator <= 0 then Numerator := 4;

  TicksPerBar := PPQ * Numerator;

  Bar  := (Ticks div TicksPerBar) + 1;
  Beat := ((Ticks mod TicksPerBar) div PPQ);
  Tick := (Ticks mod PPQ);

  Result := Format('%d:%.2d:%.3d', [Bar, Beat, Tick]);
end;

function TForm11.MBTToTicks(const S: string): Integer;
var
  Parts: TArray<string>;
  Bar, Beat, Tick: Integer;
  PPQ, Numerator, TicksPerBar: Integer;
begin
  Result := 0;

  PPQ := Form1.FPPQ;
  Numerator := Form1.FNumerator;

  if PPQ <= 0 then PPQ := 480;
  if Numerator <= 0 then Numerator := 4;

  TicksPerBar := PPQ * Numerator;

  Parts := S.Split([':']);
  if Length(Parts) <> 3 then Exit;

  Bar  := StrToIntDef(Trim(Parts[0]), 1);
  Beat := StrToIntDef(Trim(Parts[1]), 0);
  Tick := StrToIntDef(Trim(Parts[2]), 0);

  // zabezpieczenie
  if Bar < 1 then Bar := 1;
  if Beat < 0 then Beat := 0;
  if Tick < 0 then Tick := 0;

  Dec(Bar); // dopiero teraz odejmujemy 1

  Result := (Bar * TicksPerBar) + (Beat * PPQ) + Tick;

  if Result < 0 then
    Result := 0;
end;

procedure TForm11.LoadNoteData(ANoteIndex: Integer);
begin
  FEditingNoteIndex := ANoteIndex;
  // Wype³niamy pola edycyjne danymi z globalnej tablicy MidiNotes
  //Edit1.Text := TicksToMBT(MidiNotes[ANoteIndex].StartTick);
  //Edit2.Text := IntToStr(MidiNotes[ANoteIndex].Duration);
  //Edit3.Text := IntToStr(MidiNotes[ANoteIndex].Velocity);
end;

procedure TForm11.Button1Click(Sender: TObject);
begin
  Form7.ResetAllModes;
  Form11.Close;
end;

procedure TForm11.Button2Click(Sender: TObject);
begin
  Form7.ResetAllModes; // Wy³¹cza wszystko

  if FEditingNoteIndex <> -1 then
  begin
    // Pobieramy czyste liczby z Twoich Editów
    MidiNotes[FEditingNoteIndex].StartTick := MBTToTicks(Edit1.Text);
    MidiNotes[FEditingNoteIndex].Duration  := StrToIntDef(Edit2.Text, MidiNotes[FEditingNoteIndex].Duration);
    MidiNotes[FEditingNoteIndex].Velocity  := StrToIntDef(Edit3.Text, MidiNotes[FEditingNoteIndex].Velocity);

    // Odœwie¿amy Piano Roll w Unit7
    Form7.DrawGrid2.Invalidate;

    // Zamykamy okno
    Close;
  end;
end;

procedure TForm11.Edit1Change(Sender: TObject);
var
  Ticks: Integer;
begin
  if FUpdatingEdit then Exit;

  // jeœli u¿ytkownik wpisuje czyste ticki (bez :)
  if Pos(':', Edit1.Text) = 0 then
  begin
    Ticks := StrToIntDef(Edit1.Text, 0);

    FUpdatingEdit := True;
    try
      Edit1.Text := TicksToMBT(Ticks);
      Edit1.SelStart := Length(Edit1.Text);
    finally
      FUpdatingEdit := False;
    end;
  end;
end;


procedure TForm11.Edit3Exit(Sender: TObject);
var
  Liczba: Integer;
begin
  if form11.Edit3.Text <> '' then
  begin
    Liczba := StrToIntDef(Form11.Edit3.Text, 0);

    // Sprawdzenie zakresu 1-20
    if (Liczba < 1) or (Liczba > 127) then
    begin
      ShowMessage('WprowadŸ liczbê z zakresu od 1 do 127!');
      Form11.Edit3.SetFocus; // Wraca do pola, aby u¿ytkownik poprawi³ b³¹d
    end;
  end;
end;

end.
