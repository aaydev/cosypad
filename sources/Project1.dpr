program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitAbout in 'UnitAbout.pas' {FormAbout},
  UnitDataModule1 in 'UnitDataModule1.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.Run;
end.
