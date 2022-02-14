unit UnitDataModule1;

interface

uses
  System.SysUtils,
  System.Classes,

  System.Generics.Collections,
  System.Generics.Defaults,

  Data.DB,
  Data.SqlExpr,
  Data.DbxSqlite,
  Data.FMTBcd;

type
  TDataModule1 = class(TDataModule)
    SQLConnection1: TSQLConnection;
    SQLQuery1: TSQLQuery;
  private
    { Private declarations }
    procedure GetManufacturerOptionList(AModel: string; AType: string; AStrings: TStrings);
  public
    { Public declarations }
    procedure Connect(const FileName: string);
    procedure Disconnect;
    procedure AddParam(ASQLQuery: TSQLQuery;
                        const AParam: string;
                        const AFieldType: TFieldType;
                        const AValue: OleVariant);

    procedure GetModelList(AMake1: string; AMake2: string; AStrings: TStrings);
    procedure GetPaintList(AModel: string; AStrings: TStrings);
    procedure GetFabricList(AModel: string; AStrings: TStrings);
    procedure GetOptionList(AModel: string; AStrings: TStrings);
  end;

var
  DM: TDataModule1;

implementation

uses
  System.Variants;

{$R *.dfm}

procedure TDataModule1.Connect(const FileName: string);
begin
  SQLConnection1.Connected := False;
  SQLConnection1.ConnectionName := 'SQLITECONNECTION';
  SQLConnection1.DriverName := 'Sqlite';
  SQLConnection1.LoginPrompt:= False;
  SQLConnection1.Params.Clear;
  SQLConnection1.Params.AddPair('DriverName', 'Sqlite');
  SQLConnection1.Params.Values['Database'] := FileName;
  SQLConnection1.Connected := True;
end;

procedure TDataModule1.Disconnect;
begin
  if SQLConnection1 <> nil then
    SQLConnection1.Connected := False;
end;

procedure TDataModule1.AddParam(ASQLQuery: TSQLQuery;
                    const AParam: string;
                    const AFieldType: TFieldType;
                    const AValue: OleVariant);
var
  Param: TParam;
begin
  Param := ASQLQuery.ParamByName(AParam);
  Param.DataType := AFieldType;
  Param.Clear;
  Param.Bound := True;
  Param.Value := AValue;
end;

procedure TDataModule1.GetModelList(AMake1: string; AMake2: string; AStrings: TStrings);
var
  Query1: TSQLQuery;
  SingleMake: Boolean;
  s1: string;
  s2: string;
begin
  SingleMake := (AMake2 = '') or (AMake1 = AMake2);
  AStrings.Clear;
  Query1 := SQLQuery1;
  Query1.SQL.Clear;
  Query1.SQL.Add('SELECT DISTINCT [code], [description]');
  Query1.SQL.Add('FROM [models]');
  Query1.SQL.Add('WHERE ([make] = :make1)');
  if not SingleMake then
    Query1.SQL.Add('OR ([make] = :make2)');
  Query1.SQL.Add('ORDER BY [code]');

  Query1.ParamCheck := True;
  DM.AddParam(Query1, 'make1', ftUnknown, AMake1);
  if not SingleMake then
    DM.AddParam(Query1, 'make2', ftUnknown, AMake2);
  Query1.Open;

  if not Query1.IsEmpty then
  begin
    while not Query1.Eof do
    begin
      s1 := Query1.FieldByName('code').AsString;
      s2 := Query1.FieldByName('description').AsString;
      if s2 <> '' then
        s1 := s1 + ': ' + s2;
      AStrings.Add(s1);
      Query1.Next;
    end;
  end;
  Query1.Close;
end;

procedure TDataModule1.GetManufacturerOptionList(AModel: string; AType: string; AStrings: TStrings);
var
  Query1: TSQLQuery;
  s1: string;
  s2: string;
begin
  AStrings.Clear;
  Query1 := SQLQuery1;
  Query1.SQL.Clear;
  Query1.SQL.Add('SELECT DISTINCT [code], [description]');
  Query1.SQL.Add('FROM [options]');
  Query1.SQL.Add(Format('WHERE ([model] = :model) AND ([type] = ''%s'')', [AType]));
  Query1.SQL.Add('ORDER BY [code]');

  Query1.ParamCheck := True;
  DM.AddParam(Query1, 'model', ftUnknown, AModel);
  Query1.Open;

  if not Query1.IsEmpty then
  begin
    while not Query1.Eof do
    begin
      s1 := Query1.FieldByName('code').AsString;
      s2 := Query1.FieldByName('description').AsString;
      if s2 <> '' then
        s1 := s1 + ': ' + s2;
      AStrings.Add(s1);
      Query1.Next;
    end;
  end;
  Query1.Close;
end;

procedure TDataModule1.GetPaintList(AModel: string; AStrings: TStrings);
begin
  GetManufacturerOptionList(AModel, 'P', AStrings);
end;

procedure TDataModule1.GetFabricList(AModel: string; AStrings: TStrings);
begin
  GetManufacturerOptionList(AModel, 'F', AStrings);
end;

procedure TDataModule1.GetOptionList(AModel: string; AStrings: TStrings);
begin
  GetManufacturerOptionList(AModel, 'S', AStrings);
end;


end.
