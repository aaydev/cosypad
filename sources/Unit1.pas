unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ExtCtrls,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdHTTP,
  IdBaseComponent, IdComponent, Vcl.ActnList, Vcl.StdActns, System.Actions,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ComCtrls, Vcl.Imaging.GIFImg, Vcl.Menus,
  Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ComboBoxMake: TComboBox;
    LabelMake: TLabel;
    LabelModel: TLabel;
    ComboBoxModel: TComboBox;
    ComboBoxPaint: TComboBox;
    LabelColor: TLabel;
    ComboBoxFabric: TComboBox;
    LabelOptions: TLabel;
    CheckListBoxOptions: TCheckListBox;
    LabelUpholstery: TLabel;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    FileExit1: TFileExit;
    FileSaveAs1: TFileSaveAs;
    Action1: TAction;
    StatusBar1: TStatusBar;
    Action2: TAction;
    Panel3: TPanel;
    ComboBoxView: TComboBox;
    LabelViews: TLabel;
    Panel4: TPanel;
    Image1: TImage;
    ButtonResetOptions: TButton;
    Image2: TImage;
    PopupMenu1: TPopupMenu;
    SaveAs1: TMenuItem;
    PanelDebug: TPanel;
    ButtonUpdate: TButton;
    MemoRequest: TMemo;
    LabelDebug: TLabel;
    ActionDebug: TAction;
    procedure ButtonUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxMakeSelect(Sender: TObject);
    procedure ComboBoxModelSelect(Sender: TObject);
    procedure ButtonResetOptionsClick(Sender: TObject);
    procedure ComboBoxPaintSelect(Sender: TObject);
    procedure ComboBoxFabricSelect(Sender: TObject);
    procedure CheckListBoxOptionsClick(Sender: TObject);
    procedure ComboBoxViewSelect(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FileSaveAs1Accept(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure ActionDebugExecute(Sender: TObject);
  private
    { Private declarations }
    UpdateRequestHalted: Boolean;

    AppFilePath: string;
    SqlDllName: string;
    DatabaseFileName: string;

    function InitApp: Boolean;
    procedure UpdateModelList;
    procedure UpdatePaintList;
    procedure UpdateFabricList;
    procedure UpdateOptionList;
    procedure ResetOptionSelection;

    procedure UpdateRequest;


    procedure DownloadAndViewImage(URL: string);
    procedure UpdateImage;

    function GetValuedCode(const ACode: string): string;
    function GetOptionString(AOptionList: TStrings): string;


  public
    { Public declarations }
  end;

  TMakes = (makeBMW, makeMINI, makeMOTO);

var
  Form1: TForm1;

const
  AppName: string = 'CosyPad';
  AppVer: string = '1.0.0.0';

  FName_SQL: string = 'sqlite3.dll';
  FName_DB: string = 'mo.db3';

  CosyServiceURL: string = 'https://cosy.bmwgroup.com/h5vcom/cosySec?';

resourcestring
  ErrFileIsAbsent = 'File is absent!';


implementation

{$R *.dfm}

uses
  Data.DB,
  Data.SQLExpr,
  Cosy,
  UnitDataModule1,
  UnitAbout;


procedure TForm1.Action1Execute(Sender: TObject);
begin
  UpdateRequest;
  UpdateImage;
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

procedure TForm1.ActionDebugExecute(Sender: TObject);
begin
  ActionDebug.Checked := not ActionDebug.Checked;
  PanelDebug.Visible := ActionDebug.Checked;
end;

procedure TForm1.ButtonUpdateClick(Sender: TObject);
begin
  UpdateImage;
end;

procedure TForm1.ButtonResetOptionsClick(Sender: TObject);
begin
  ResetOptionSelection;
  UpdateImage;
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

  ComboBoxMake.Items.Clear;
  ComboBoxMake.Items.Add('BMW');
  ComboBoxMake.Items.Add('MINI');
  ComboBoxMake.Items.Add('BMW Motorrad');
  ComboBoxMake.ItemIndex := 0;

  ComboBoxView.ItemIndex := 0;

  ComboBoxModel.Clear;
  ComboBoxPaint.Clear;
  ComboBoxFabric.Clear;
  CheckListBoxOptions.Clear;
  MemoRequest.Clear;

  UpdateRequestHalted := False;

  ActionDebug.Checked := False;
  PanelDebug.Visible := ActionDebug.Checked;

  Result := True;
end;


procedure TForm1.CheckListBoxOptionsClick(Sender: TObject);
begin
  UpdateRequest;
  UpdateImage;
end;

procedure TForm1.ComboBoxFabricSelect(Sender: TObject);
begin
  UpdateRequest;
  UpdateImage;
end;

procedure TForm1.ComboBoxMakeSelect(Sender: TObject);
begin
  UpdateModelList;
end;

procedure TForm1.ComboBoxModelSelect(Sender: TObject);
begin
  UpdateRequestHalted := True;
  UpdatePaintList;
  UpdateFabricList;
  UpdateOptionList;
  UpdateRequestHalted := False;
  UpdateRequest;
  UpdateImage;
end;

procedure TForm1.ComboBoxPaintSelect(Sender: TObject);
begin
  UpdateRequest;
  UpdateImage;
end;

procedure TForm1.ComboBoxViewSelect(Sender: TObject);
begin
  UpdateRequest;
  UpdateImage;
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


procedure TForm1.FileSaveAs1Accept(Sender: TObject);
begin
  Image1.Picture.SaveToFile(FileSaveAs1.Dialog.FileName);
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

  MemoRequest.Lines.Clear;

  Application.CreateForm(TDataModule1, DM);
  DM.Connect(DatabaseFileName);

  ComboBoxMake.ItemIndex := 0;
  ComboBoxMake.OnSelect(Self);

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

  case ComboBoxMake.ItemIndex of
    Integer(TMakes.makeBMW): begin
      make1 := 'BMW';
      make2 := 'BMWI';
    end;
    Integer(TMakes.makeMINI): begin
      make1 := 'BMW-MINI';
      make2 := make1;
    end;
    Integer(TMakes.makeMOTO): begin
      make1 := 'BMW-MOT';
      make2 := make1;
    end;
  end;

  Cursor := crHourGlass;
  DM.GetModelList(make1, make2, ComboBoxModel.Items);
  Cursor := crDefault;
  ComboBoxModel.ItemIndex := 0;
  ComboBoxModel.OnSelect(Self);
  ComboBoxView.ItemIndex := 0;
end;

function TForm1.GetValuedCode(const ACode: string): string;
var
  i: Integer;
begin
  Result := ACode;
  i := Pos(': ', ACode);
  if i > 0 then
    Result := Copy(Result, 1, i - 1);
end;

procedure TForm1.UpdatePaintList;
begin
  Cursor := crHourGlass;
  DM.GetPaintList(GetValuedCode(ComboBoxModel.Items[ComboBoxModel.ItemIndex]), ComboBoxPaint.Items);
  Cursor := crDefault;
  ComboBoxPaint.ItemIndex := 0;
end;

procedure TForm1.UpdateFabricList;
begin
  Cursor := crHourGlass;
  DM.GetFabricList(GetValuedCode(ComboBoxModel.Items[ComboBoxModel.ItemIndex]), ComboBoxFabric.Items);
  Cursor := crDefault;
  ComboBoxFabric.ItemIndex := 0;
end;

procedure TForm1.UpdateOptionList;
begin
  Cursor := crHourGlass;
  DM.GetOptionList(GetValuedCode(ComboBoxModel.Items[ComboBoxModel.ItemIndex]), CheckListBoxOptions.Items);
  Cursor := crDefault;
  CheckListBoxOptions.ItemIndex := 0;
end;

procedure TForm1.ResetOptionSelection;
begin
  CheckListBoxOptions.CheckAll(cbUnchecked);
  UpdateRequest;
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
begin
  FileSaveAs1.Execute;
end;

procedure TForm1.UpdateRequest;
var
  Params: TCosyParams;
  CheckedItems: TStrings;
  OptionString: string;
  POVString: string;
  i: Integer;
begin
  if UpdateRequestHalted then
    Exit;

  // build option list string
  CheckedItems := TStringList.Create;
  for i := 0 to CheckListBoxOptions.Items.Count - 1 do
  begin
    if CheckListBoxOptions.Checked[i] then
      CheckedItems.Add(CheckListBoxOptions.Items.Strings[i]);
  end;
  OptionString := GetOptionString(CheckedItems);
  CheckedItems.Free;

  POVString := ComboBoxView.Items[ComboBoxView.ItemIndex];
  POVString := StringReplace(POVString ,' ', '', [rfReplaceAll]);
  POVString := UpperCase(POVString);

  with Params do
  begin
    BKGND := 0;
    LANG := 1;
    CLIENT := 'ECOM';
    POV := POVString;
    RESP := 'jpeg,err_beauty';
    WIDTH := Image1.Width;
    QUALITY := 80;
    VEHICLE := GetValuedCode(ComboBoxModel.Items[ComboBoxModel.ItemIndex]);
    BRAND := GetCosyBrand(ComboBoxMake.ItemIndex);
    MARKET := 'RU';
    PAINT := GetValuedCode(ComboBoxPaint.Items[ComboBoxPaint.ItemIndex]);
    FABRIC := GetValuedCode(ComboBoxFabric.Items[ComboBoxFabric.ItemIndex]);
    SA := OptionString;
  end;

  MemoRequest.Text := BuildParamString(Params);
end;

function TForm1.GetOptionString(AOptionList: TStrings): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to AOptionList.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + ',';
    Result := Result+ 'S' + GetValuedCode(AOptionList.Strings[i]);
  end;
end;

procedure TForm1.UpdateImage;
begin
  try
    DownloadAndViewImage(CosyServiceURL + Cosy.EncodeStr(MemoRequest.Lines.Text));
    Image2.Visible := False;
    Image1.Visible := True;
  except
    on E:Exception do
    begin
      Image1.Visible := False;
      Image2.Visible := True;
      Image1.Picture := nil;
    end;
  end;
end;


end.
