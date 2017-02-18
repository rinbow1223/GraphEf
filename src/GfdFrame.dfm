object GfdBox: TGfdBox
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  TabOrder = 0
  object DrawBox: TPaintBox
    Left = 0
    Top = 0
    Width = 443
    Height = 277
    Align = alClient
    OnPaint = DrawBoxPaint
  end
  object Roman: TLabel
    Left = 8
    Top = 0
    Width = 6
    Height = 14
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object RomanItal: TLabel
    Left = 16
    Top = 0
    Width = 7
    Height = 14
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = [fsItalic]
    ParentFont = False
    Visible = False
  end
  object RomanBold: TLabel
    Left = 24
    Top = 0
    Width = 6
    Height = 13
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Symbol: TLabel
    Left = 32
    Top = 0
    Width = 8
    Height = 13
    Caption = 'F'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Symbol'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Helvetica: TLabel
    Left = 40
    Top = 0
    Width = 6
    Height = 14
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object HelvItal: TLabel
    Left = 48
    Top = 0
    Width = 7
    Height = 14
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Visible = False
  end
  object HelvBold: TLabel
    Left = 56
    Top = 0
    Width = 6
    Height = 14
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Courier: TLabel
    Left = 64
    Top = 0
    Width = 7
    Height = 14
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object CourierItal: TLabel
    Left = 72
    Top = 0
    Width = 7
    Height = 15
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsItalic]
    ParentFont = False
    Visible = False
  end
  object CourierBold: TLabel
    Left = 80
    Top = 0
    Width = 7
    Height = 14
    Caption = 'F'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
end
