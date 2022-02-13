unit UnitAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TFormAbout = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Label5: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
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

procedure TFormAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  Caption := 'About ' + AppName;
  Label2.Caption := AppName + ' v' + AppVer;
  Label5.Visible := False;
  Memo1.Visible := False;
  Height := 138;
end;

procedure TFormAbout.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', PWideChar('mailto: alexey.anisimov@gmail.com'),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TFormAbout.Label4Click(Sender: TObject);
begin
  if not Memo1.Visible then
  begin
    Memo1.Visible := True;
    Height := 440;
    Button1.Caption := 'I agree';
  end;
end;

end.
