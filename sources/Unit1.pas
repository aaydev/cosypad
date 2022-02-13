unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ExtCtrls,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdHTTP,
  IdBaseComponent, IdComponent, Vcl.ActnList, Vcl.StdActns, System.Actions,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label3: TLabel;
    ComboBox4: TComboBox;
    Label4: TLabel;
    CheckListBox1: TCheckListBox;
    Label5: TLabel;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    FileExit1: TFileExit;
    FileSaveAs1: TFileSaveAs;
    Action1: TAction;
    StatusBar1: TStatusBar;
    Action2: TAction;
    Button1: TButton;
    Panel3: TPanel;
    ComboBox5: TComboBox;
    Label6: TLabel;
    Panel4: TPanel;
    Image1: TImage;
    Memo1: TMemo;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
  private
    { Private declarations }
    AppFilePath: string;
    SqlDllName: string;
    DatabaseFileName: string;

    function InitApp: Boolean;
    procedure UpdateModelList;
    procedure DownloadAndViewImage(URL: string);
  public
    { Public declarations }
  end;

  TMakes = (none, BMW, MINI, MOTO);

var
  Form1: TForm1;

const
  AppName: string = 'CosyPad';
  AppVer: string = '1.0.0.0';

  FName_SQL: string = 'sqlite3.dll';
  FName_DB: string = 'mo.db3';

  CosyServiceURL: string = 'https://cosy.bmwgroup.com/h5vcom/cosySec?';

resourcestring
  SelectDummy = '--- select ---';
  ErrFileIsAbsent = 'File is absent!';


implementation

{$R *.dfm}

uses
  JPEG,
  Data.DB,
  Data.SQLExpr,
  Cosy,
  UnitDataModule1,
  UnitAbout;


procedure TForm1.Action2Execute(Sender: TObject);
begin
  with TFormAbout.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  params: string;

  param_width: Integer;



begin

   param_width := Image1.Width;




  params := 'BKGND=0&LANG=1&CLIENT=ECOM&POV=FRONT&RESP=jpeg,err_beauty&WIDTH=' + IntToStr(param_width) + '&QUALITY=80' +
    '&VEHICLE=GV81&BRAND=WBBM&MARKET=RU&paint=P0X1D&fabric=FZBEJ&sa=S01A1,S01CR,S01N0,S02NH,S02T4,' +
    'S02VB,S02VC,S02VH,S02VW,S0322,S0323,S033T,S0358,S03DS,S0402,S0428,S0453,S04A2,S04FM,S04GQ,S04HA,' +
    'S04HB,S04ML,S04NB,S0548,S05AC,S05AU,S05AZ,S05DN,S06AE,S06AF,S06AK,S06C3,S06F1,S06NW,S06U3,S06UD,' +
    'S0710,S0715,S071C,S0760,S0778,S07CG,S07M9,S07NH,S0842,S0891,S08KK,S08LR,S08S3,S08TF,S08TL,S08TR,' +
    'S0XC4,S0XD5,S0ZH2';


  //params := Memo1.Lines.Text;


  DownloadAndViewImage(CosyServiceURL + Cosy.EncodeStr(params));
end;

function TForm1.InitApp: Boolean;
begin
  Result := False;
  Application.Title := AppName;
  Caption := AppName;

  AppFilePath := ExtractFilePath(ParamStr(0));
  SqlDllName := AppFilePath + FName_SQL;
  if not FileExists(SqlDllName) then
  begin
    TaskMessageDlg(ErrFileIsAbsent, SqlDllName,
                    mtError, [mbOK], 0);
    Exit;
  end;

  DatabaseFileName := AppFilePath + FName_DB;
  Result := True;
end;


procedure TForm1.ComboBox1Select(Sender: TObject);
begin
  UpdateModelList;
end;



procedure TForm1.DownloadAndViewImage(URL: string);
var
  MS: TMemoryStream;
  JPEGImage: TJPEGImage;
  IdHTTP1: TIdHTTP;
begin
  MS := TMemoryStream.Create;
  MS.Clear;

  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvSSLv23;
  IdHTTP1 := TIdHTTP.Create;
  IdHTTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;

  JPEGImage := TJPEGImage.Create;

  try
    IdHTTP1.Get(URL, MS);
    MS.Position := 0;
    JPEGImage.LoadFromStream(MS);
    Image1.Picture.Assign(JPEGImage);
  finally
    JPEGImage.Free;
    MS.Free;
    IdHTTP1.Free;
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  Visible := False;

  if not InitApp then
  begin
    Application.Terminate;
    Exit;
  end;

  Memo1.Lines.Clear;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('BMW');
  ComboBox1.Items.Add('MINI');
  ComboBox1.Items.Add('BMW Motorrad');
  ComboBox1.ItemIndex := 0;

  Application.CreateForm(TDataModule1, DM);
  DM.Connect(DatabaseFileName);

  Visible := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Assigned(DM) then
    DM.Disconnect;
end;

procedure TForm1.UpdateModelList;
var
  brand: string;
  make1, make2: string;
begin

  case ComboBox1.ItemIndex of
    0: brand := 'WBBM';
    1: brand := 'WBMI';
    2: brand := 'WBABM';
  end;

  case ComboBox1.ItemIndex of
    0: begin
      make1 := 'BMW';
      make2 := 'BMWI';
    end;
    1: begin
      make1 := 'BMW-MINI';
      make2 := make1;
    end;
    2: begin
      make1 := 'BMW-MOT';
      make2 := make1;
    end;
  end;


  DM.GetModels(make1, make2, ComboBox2.Items);
  ComboBox2.Items.Insert(0, SelectDummy);
  ComboBox2.ItemIndex := 0;

end;




end.
