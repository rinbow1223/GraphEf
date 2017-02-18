object ListForm: TListForm
  Left = 570
  Top = 123
  Width = 184
  Height = 204
  BorderStyle = bsSizeToolWin
  Caption = 'List'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 160
    Width = 176
    Height = 17
    Panels = <>
    SimplePanel = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 176
    Height = 160
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
    object GrListBox: TListBox
      Left = 1
      Top = 34
      Width = 174
      Height = 125
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = GrListBoxClick
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 174
      Height = 33
      Align = alTop
      TabOrder = 1
      object DelSpBtn: TSpeedButton
        Left = 4
        Top = 4
        Width = 45
        Height = 25
        Caption = '&Delete'
        Flat = True
        OnClick = DelSpBtnClick
      end
      object BackSpBtn: TSpeedButton
        Left = 56
        Top = 4
        Width = 41
        Height = 25
        Caption = '&Back'
        Flat = True
        OnClick = BackSpBtnClick
      end
      object FrontSpBtn: TSpeedButton
        Left = 104
        Top = 4
        Width = 41
        Height = 25
        Caption = '&Front'
        Flat = True
        OnClick = FrontSpBtnClick
      end
    end
  end
end
