object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 643
  ClientWidth = 1093
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 465
    Height = 593
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 6
      Width = 25
      Height = 13
      Caption = 'Make'
    end
    object Label2: TLabel
      Left = 153
      Top = 5
      Width = 28
      Height = 13
      Caption = 'Model'
    end
    object Label3: TLabel
      Left = 9
      Top = 49
      Width = 25
      Height = 13
      Caption = 'Color'
    end
    object Label4: TLabel
      Left = 9
      Top = 147
      Width = 37
      Height = 13
      Caption = 'Options'
    end
    object Label5: TLabel
      Left = 9
      Top = 101
      Width = 52
      Height = 13
      Caption = 'Upholstery'
    end
    object Label7: TLabel
      Left = 9
      Top = 298
      Width = 62
      Height = 13
      Caption = 'User request'
    end
    object ComboBox1: TComboBox
      Left = 7
      Top = 24
      Width = 138
      Height = 21
      TabOrder = 0
      Text = 'ComboBox1'
      OnSelect = ComboBox1Select
    end
    object ComboBox2: TComboBox
      Left = 151
      Top = 24
      Width = 306
      Height = 21
      TabOrder = 1
      Text = 'ComboBox1'
    end
    object ComboBox3: TComboBox
      Left = 9
      Top = 68
      Width = 448
      Height = 21
      TabOrder = 2
      Text = 'ComboBox1'
    end
    object ComboBox4: TComboBox
      Left = 7
      Top = 120
      Width = 450
      Height = 21
      TabOrder = 3
      Text = 'ComboBox1'
    end
    object CheckListBox1: TCheckListBox
      Left = 7
      Top = 169
      Width = 450
      Height = 116
      ItemHeight = 13
      TabOrder = 4
    end
    object Button1: TButton
      Left = 9
      Top = 550
      Width = 89
      Height = 25
      Caption = 'Refresh'
      TabOrder = 5
      OnClick = Button1Click
    end
    object Memo1: TMemo
      Left = 9
      Top = 317
      Width = 448
      Height = 220
      Lines.Strings = (
        'Memo1')
      TabOrder = 6
    end
  end
  object Panel2: TPanel
    Left = 465
    Top = 25
    Width = 628
    Height = 593
    Align = alClient
    ParentBackground = False
    TabOrder = 1
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 626
      Height = 61
      Align = alTop
      Color = clWindow
      TabOrder = 0
      object Label6: TLabel
        Left = 8
        Top = 5
        Width = 22
        Height = 13
        Caption = 'View'
      end
      object ComboBox5: TComboBox
        Left = 6
        Top = 24
        Width = 146
        Height = 21
        TabOrder = 0
        Text = 'ComboBox1'
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 62
      Width = 626
      Height = 530
      Align = alClient
      Color = clWindow
      ParentBackground = False
      TabOrder = 1
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 624
        Height = 528
        Align = alClient
        ExplicitLeft = 5
        ExplicitTop = -3
      end
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1093
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 618
    Width = 1093
    Height = 25
    AutoHint = True
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = True
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 600
    Top = 352
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = FileSaveAs1
                ImageIndex = 30
              end
              item
                Action = FileExit1
                ImageIndex = 43
              end>
            Caption = '&File'
          end
          item
            Items = <
              item
                Action = Action2
                Caption = '&About'
              end>
            Caption = '&Help'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 592
    Top = 248
    StyleName = 'Platform Default'
    object FileSaveAs1: TFileSaveAs
      Category = 'File'
      Caption = 'Save &As...'
      Hint = 'Save As|Saves the active file with a new name'
      ImageIndex = 30
    end
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
    object Action1: TAction
      Category = 'Action'
      Caption = '&Refresh'
    end
    object Action2: TAction
      Category = 'Help'
      Caption = 'About'
      OnExecute = Action2Execute
    end
  end
end
