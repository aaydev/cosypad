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
  end;

var
  DM: TDataModule1;

implementation

uses
  System.Variants;

{%CLASSGROUP 'Vcl.Controls.TControl'}

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

end.
