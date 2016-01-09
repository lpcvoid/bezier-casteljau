object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Swoosh Bezier-Casteljau test'
  ClientHeight = 435
  ClientWidth = 714
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object plotImage: TImage
    Left = 0
    Top = 0
    Width = 714
    Height = 435
    Align = alClient
    OnClick = plotImageClick
    ExplicitWidth = 492
    ExplicitHeight = 209
  end
end
