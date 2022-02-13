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


    procedure InitApp;

    procedure UpdateModelList;

    function CosyEncode(InStr: string): string;
    procedure DownloadAndViewImage(URL: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  AppName: string = 'CosyPad';
  AppVer: string = '1.0.0.0';

  FName_SQL: string = 'sqlite3.dll';
  FName_DB: string = 'mo.db3';
  SelectDummy: string = '--- select ---';

implementation

{$R *.dfm}

uses
  JPEG,
  Data.DB,
  Data.SQLExpr,

  UnitDataModule1,
  UnitAbout;

function EncodeURIComponent(const ASrc: string): UTF8String;
const
  HexMap: UTF8String = '0123456789ABCDEF';

  function IsSafeChar(ch: Integer): Boolean;
  begin
    if (ch >= 48) and (ch <= 57) then Result := True // 0-9
    else if (ch >= 65) and (ch <= 90) then Result := True // A-Z
    else if (ch >= 97) and (ch <= 122) then Result := True // a-z
    else if (ch = 33) then Result := True // !
    else if (ch >= 39) and (ch <= 42) then Result := True // '()*
    else if (ch >= 45) and (ch <= 46) then Result := True // -.
    else if (ch = 95) then Result := True // _
    else if (ch = 126) then Result := True // ~
    else Result := False;
  end;
var
  I, J: Integer;
  ASrcUTF8: UTF8String;
begin
  Result := '';    {Do not Localize}

  ASrcUTF8 := UTF8Encode(ASrc);
  // UTF8Encode call not strictly necessary but
  // prevents implicit conversion warning

  I := 1; J := 1;
  SetLength(Result, Length(ASrcUTF8) * 3); // space to %xx encode every byte
  while I <= Length(ASrcUTF8) do
  begin
    if IsSafeChar(Ord(ASrcUTF8[I])) then
    begin
      Result[J] := ASrcUTF8[I];
      Inc(J);
    end
    else
    begin
      Result[J] := '%';
      Result[J+1] := HexMap[(Ord(ASrcUTF8[I]) shr 4) + 1];
      Result[J+2] := HexMap[(Ord(ASrcUTF8[I]) and 15) + 1];
      Inc(J,3);
    end;
    Inc(I);
  end;

  SetLength(Result, J-1);
end;
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


  DownloadAndViewImage(CosyEncode(params));
end;

procedure TForm1.InitApp;
begin
  Application.Title := AppName;
  Caption := AppName;

  AppFilePath := ExtractFilePath(ParamStr(0));
  SqlDllName := AppFilePath + FName_SQL;
  if not FileExists(SqlDllName) then
    raise Exception.Create(Format('File %s is absent!', [SqlDllName]));
  DatabaseFileName := AppFilePath + FName_DB;





end;


procedure TForm1.ComboBox1Select(Sender: TObject);
begin
  UpdateModelList;
end;

function TForm1.CosyEncode(InStr: string): string;
const
  SCodeCharacters: string = '4Zak0rQzNsXdVEl3S1CTuf7yJ%tmLHwYqoi6Dh9pjMbG2ePUvBW8gIKx5OFcRnA';
var
  sTemp: string;
  sResult: string;
  sEncoded: string;
  iPos: Integer;
  iStepping: Integer;
  i: Integer;
  Index: Integer;
  cb: Byte;
  SCodeCharactersIndex: Integer;

begin
  Randomize;
  iPos := Trunc(17 + Length(SCodeCharacters) * Random());
  iStepping := Trunc(11 + Length(SCodeCharacters) * Random());
  sResult := Format('COSY-EU-100-%u%u', [iPos, iStepping]);
  sEncoded := EncodeURIComponent(InStr);

  sTemp := '';
  for i := 1 to Length(sEncoded) - 1 do
  begin
    cb := Ord(sEncoded[i]);
    case cb of
      40: sTemp := sTemp + '%28';
      41: sTemp := sTemp + '%29';
      42: sTemp := sTemp + '%2A';
      43: sTemp := sTemp + '%20';
      45: sTemp := sTemp + '%2D';
      46: sTemp := sTemp + '%2E';
      95: sTemp := sTemp + '%5F';
    else
      sTemp := sTemp + sEncoded[i];
    end;
  end;

  for i := 0 to Length(sTemp) - 1 do
  begin
    SCodeCharactersIndex := SCodeCharacters.IndexOf(sTemp[i + 1]);
    Index := (iPos + SCodeCharactersIndex) mod SCodeCharacters.Length;
    sResult := sResult + SCodeCharacters[Index + 1];
    iPos := iPos + iStepping;
  end;

  Result := 'https://cosy.bmwgroup.com/h5vcom/cosySec?' + EncodeURIComponent(sResult);
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
  InitApp();

  Memo1.Lines.Clear;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('BMW');
  ComboBox1.Items.Add('MINI');
  ComboBox1.Items.Add('BMW Motorrad');
  ComboBox1.ItemIndex := 0;

  Application.CreateForm(TDataModule1, DM);
  DM.Connect(DatabaseFileName);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  DM.Disconnect;
end;

procedure TForm1.UpdateModelList;
var
  brand: string;
  Query1: TSQLQuery;
  make1, make2: string;
  i: Integer;
  Q: Char;
begin
  Q := #39;

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

  ComboBox2.Items.Clear;
  ComboBox2.Items.Add(SelectDummy);
  ComboBox2.ItemIndex := 0;

  Query1 := DM.SQLQuery1;
  Query1.SQL.Clear;
  Query1.SQL.Add('SELECT DISTINCT [model] FROM [options] WHERE ([make] = :make1) OR ([make] = :make2) ORDER BY [model] ASC');
  Query1.ParamCheck := True;
  DM.AddParam(Query1, 'make1', ftUnknown, make1);
  DM.AddParam(Query1, 'make2', ftUnknown, make2);
  Query1.Open;

  if not Query1.IsEmpty then
  begin
    while not Query1.Eof do
    begin
      ComboBox2.Items.Add(Query1.FieldByName('model').AsString);
      Query1.Next;
    end;
  end;
  Query1.Close;

end;




end.
