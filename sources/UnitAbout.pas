unit UnitAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg;

type
  TFormAbout = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ImageLogo: TImage;
    LabelEmail: TLabel;
    LabelAppTitle: TLabel;
    LabelCopyright: TLabel;
    LabelPleaseReadThis: TLabel;
    MemoLicenseText: TMemo;
    ButtonOk: TButton;
    procedure LabelEmailClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

uses
  ShellAPI,
  Unit1;

procedure TFormAbout.ButtonOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  Caption := 'About ' + AppName;
  LabelAppTitle.Caption := AppName + ' v' + AppVer;
  LabelEmail.Caption := Chr($61) + Chr($6c) + Chr($65) + Chr($78) +
    Chr($65) + Chr($79) + Chr($2e) + Chr($61) + Chr($6e) + Chr($69) +
    Chr($73) + Chr($69) + Chr($6d) + Chr($6f) + Chr($76) + Chr($40) +
    Chr($67) + Chr($6d) + Chr($61) + Chr($69) + Chr($6c) + Chr($2e) +
    Chr($63) + Chr($6f) + Chr($6d);
  LabelCopyright.Caption := 'Copyright © 2022 Alexey Anisimov';
  MemoLicenseText.Visible := True;
end;

procedure TFormAbout.LabelEmailClick(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', PWideChar('mailto: ' + LabelEmail.Caption),
    nil, nil, SW_SHOWNORMAL);
end;

end.
