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
  public
    { Public declarations }
    procedure Connect(const FileName: string);
    procedure Disconnect;
    procedure AddParam(ASQLQuery: TSQLQuery;
                        const AParam: string;
                        const AFieldType: TFieldType;
                        const AValue: OleVariant);

    procedure GetModels(AMake1: string; AMake2: string; AStrings: TStrings);

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

procedure TDataModule1.GetModels(AMake1: string; AMake2: string; AStrings: TStrings);
var
  Query1: TSQLQuery;
  SingleMake: Boolean;
begin
  AStrings.Clear;
  Query1 := SQLQuery1;
  Query1.SQL.Clear;

  SingleMake := (AMake2 = '') or (AMake1 = AMake2);
  if SingleMake then
    Query1.SQL.Add('SELECT DISTINCT [model] FROM [options] WHERE [make] = :make1 ORDER BY [model] ASC')
  else
    Query1.SQL.Add('SELECT DISTINCT [model] FROM [options] WHERE ([make] = :make1) OR ([make] = :make2) ORDER BY [model] ASC');

  Query1.ParamCheck := True;
  DM.AddParam(Query1, 'make1', ftUnknown, AMake1);
  if not SingleMake then
    DM.AddParam(Query1, 'make2', ftUnknown, AMake2);
  Query1.Open;

  if not Query1.IsEmpty then
  begin
    while not Query1.Eof do
    begin
      AStrings.Add(Query1.FieldByName('model').AsString);
      Query1.Next;
    end;
  end;
  Query1.Close;
end;

end.
