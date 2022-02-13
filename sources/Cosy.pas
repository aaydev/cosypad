unit Cosy;

interface

function EncodeStr(AString: string): string;

implementation

uses
  System.SysUtils;

const
  KeyCodeCharacters: string =
    '4Zak0rQzNsXdVEl3S1CTuf7yJ%tmLHwYqoi6Dh9pjMbG2ePUvBW8gIKx5OFcRnA';

function EncodeURI(const ASrc: string): string;
const
  HexMap: UTF8String = '0123456789ABCDEF';

  function IsSafeChar(ch: Integer): Boolean;
  begin
    if (ch >= 48) and (ch <= 57) then
      Result := True // 0-9
    else if (ch >= 65) and (ch <= 90) then
      Result := True // A-Z
    else if (ch >= 97) and (ch <= 122) then
      Result := True // a-z
    else if (ch = 33) then
      Result := True // !
    else if (ch >= 39) and (ch <= 42) then
      Result := True // '()*
    else if (ch >= 45) and (ch <= 46) then
      Result := True // -.
    else if (ch = 95) then
      Result := True // _
    else if (ch = 126) then
      Result := True // ~
    else
      Result := False;
  end;

var
  i, j: Integer;
  ASrcUTF8: UTF8String;
  ResultUTF8: UTF8String;
begin
  Result := '';
  ResultUTF8 := ''; // Do not Localize

  ASrcUTF8 := UTF8Encode(ASrc);
  // UTF8Encode call not strictly necessary but
  // prevents implicit conversion warning

  i := 1;
  j := 1;
  SetLength(ResultUTF8, Length(ASrcUTF8) * 3); // space to %xx encode every byte
  while i <= Length(ASrcUTF8) do
  begin
    if IsSafeChar(Ord(ASrcUTF8[i])) then
    begin
      ResultUTF8[j] := ASrcUTF8[i];
      Inc(j);
    end
    else
    begin
      ResultUTF8[j] := '%';
      ResultUTF8[j + 1] := HexMap[(Ord(ASrcUTF8[i]) shr 4) + 1];
      ResultUTF8[j + 2] := HexMap[(Ord(ASrcUTF8[i]) and 15) + 1];
      Inc(j, 3);
    end;
    Inc(i);
  end;

  SetLength(ResultUTF8, j - 1);
  Result := string(ResultUTF8);
end;

function EncodeStr(AString: string): string;
var
  I: Integer;
  Index: Integer;
  iPos: Integer;
  iStepping: Integer;
  CodeCharactersIndex: Integer;

  EncodedStr: string;
  TempStr: string;

  cb: Byte;

begin
  Result := '';
  EncodedStr := EncodeURI(AString);

  Randomize;
  iPos := Trunc(17 + Length(KeyCodeCharacters) * Random());
  iStepping := Trunc(11 + Length(KeyCodeCharacters) * Random());
  Result := Format('COSY-EU-100-%u%u', [iPos, iStepping]);

  TempStr := '';
  for I := 1 to Length(EncodedStr) - 1 do
  begin
    cb := Ord(EncodedStr[I]);
    case cb of
      40:
        TempStr := TempStr + '%28';
      41:
        TempStr := TempStr + '%29';
      42:
        TempStr := TempStr + '%2A';
      43:
        TempStr := TempStr + '%20';
      45:
        TempStr := TempStr + '%2D';
      46:
        TempStr := TempStr + '%2E';
      95:
        TempStr := TempStr + '%5F';
    else
      TempStr := TempStr + EncodedStr[I];
    end;
  end;

  for I := 0 to Length(TempStr) - 1 do
  begin
    CodeCharactersIndex := KeyCodeCharacters.IndexOf(TempStr[I + 1]);
    Index := (iPos + CodeCharactersIndex) mod KeyCodeCharacters.Length;
    Result := Result + KeyCodeCharacters[Index + 1];
    iPos := iPos + iStepping;
  end;

  Result := EncodeURI(Result);
end;

end.
