unit GraphWin;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, ComCtrls, Menus, Printers,
  GrfPrim, GrList, GrEPS, EpsDlg, ImgList, InpDlgs, Math, ExtDlgs;

type
  TDrawingTool = (dtPointer, dtLine, dtRectangle, dtEllipse, dtRoundRect, dtText);
  TDrawForm = class(TForm)
    Panel1: TPanel;
    LineButton: TSpeedButton;
    RectangleButton: TSpeedButton;
    EllipseButton: TSpeedButton;
    PenButton: TSpeedButton;
    BrushButton: TSpeedButton;
    PenBar: TPanel;
    BrushBar: TPanel;
    SolidPen: TSpeedButton;
    DashPen: TSpeedButton;
    DotPen: TSpeedButton;
    DashDotPen: TSpeedButton;
    DashDotDotPen: TSpeedButton;
    ClearPen: TSpeedButton;
    PenWidth: TUpDown;
    PenSize: TEdit;
    StatusBar1: TStatusBar;
    ScrollBox1: TScrollBox;
    SolidBrush: TSpeedButton;
    ClearBrush: TSpeedButton;
    PenCol: TSpeedButton;
    BrushCol: TSpeedButton;
    ColorDialog1: TColorDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    EdPaintBox: TPaintBox;
    N2: TMenuItem;
    List1: TMenuItem;
    Clear1: TMenuItem;
    SaveEPS1: TMenuItem;
    SaveDialogEPS: TSaveDialog;
    SelPanel: TPanel;
    LabEdX1: TLabeledEdit;
    UpDown1: TUpDown;
    LabEdY1: TLabeledEdit;
    UpDown2: TUpDown;
    LabEdX2: TLabeledEdit;
    UpDown3: TUpDown;
    LabEdY2: TLabeledEdit;
    UpDown4: TUpDown;
    SetXYSpBtn: TSpeedButton;
    LetterButton: TSpeedButton;
    PointButton: TSpeedButton;
    BotPan: TPanel;
    TopPan: TPanel;
    MiscButton: TSpeedButton;
    ToolPageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ImageList1: TImageList;
    TabSheet5: TTabSheet;
    ToolLineButton: TSpeedButton;
    ToolRectButton: TSpeedButton;
    ToolEllipseButton: TSpeedButton;
    TimesButton: TSpeedButton;
    TimesItalButton: TSpeedButton;
    TimesBoldButton: TSpeedButton;
    SymbolButton: TSpeedButton;
    ToolCircleButton: TSpeedButton;
    ToolArrow1Button: TSpeedButton;
    NetworkButton: TSpeedButton;
    ToolFilledCircleButton: TSpeedButton;
    ToolFilledRectButton: TSpeedButton;
    BrushPenColPan: TPanel;
    PenColPan: TPanel;
    BrushColPan: TPanel;
    PalPan: TPanel;
    ColPan10: TPanel;
    ColPan09: TPanel;
    ColPan08: TPanel;
    ColPan07: TPanel;
    ColPan06: TPanel;
    ColPan05: TPanel;
    ColPan04: TPanel;
    ColPan03: TPanel;
    ColPan02: TPanel;
    ColPan01: TPanel;
    ColPan11: TPanel;
    ColPan12: TPanel;
    ColPan13: TPanel;
    ColPan14: TPanel;
    ColPan15: TPanel;
    ColPan16: TPanel;
    DrawTestPan: TPanel;
    DrawShape: TShape;
    Bevel1: TBevel;
    LbEdGrid: TLabeledEdit;
    UpDnGrid: TUpDown;
    N3: TMenuItem;
    Grid1: TMenuItem;
    Snap1: TMenuItem;
    XSnap1: TMenuItem;
    YSnap1: TMenuItem;
    N4: TMenuItem;
    DrawGrid1: TMenuItem;
    MarkGrid1: TMenuItem;
    BotCPan: TPanel;
    ToolWavyButton: TSpeedButton;
    ToolPolyLineButton: TSpeedButton;
    ToolPolyGonButton: TSpeedButton;
    Tools1: TMenuItem;
    SelGrid1: TMenuItem;
    Pen1: TMenuItem;
    Brush1: TMenuItem;
    Extras1: TMenuItem;
    HelveticaButton: TSpeedButton;
    BrushImageList: TImageList;
    ComBoxBrush: TComboBoxEx;
    SaveBMP1: TMenuItem;
    SaveDialogBMP: TSaveDialog;
    SaveDialogWMF: TSaveDialog;
    SaveWMF1: TMenuItem;
    LabEdAngle: TLabeledEdit;
    AngUpDn: TUpDown;
    HelvItalButton: TSpeedButton;
    HelvBoldButton: TSpeedButton;
    CourierButton: TSpeedButton;
    CourierItalButton: TSpeedButton;
    CourierBoldButton: TSpeedButton;
    CBxEdFill: TCheckBox;
    CurDir: TMenuItem;
    LoadPicture1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    ToolPolyBezierButton: TSpeedButton;
    ToolPolyBezFillButton: TSpeedButton;
    ToolCurve1Button: TSpeedButton;
    ToolFillCurve1Button: TSpeedButton;
    N5: TMenuItem;
    Rescale1: TMenuItem;
    Shift1: TMenuItem;
    ToolCurve2Button: TSpeedButton;
    ToolFillCurve2Button: TSpeedButton;
    N6: TMenuItem;
    PrinterSetup1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
    Print1: TMenuItem;
    LabNotImpl: TLabel;
    procedure PaintMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LineButtonClick(Sender: TObject);
    procedure RectangleButtonClick(Sender: TObject);
    procedure EllipseButtonClick(Sender: TObject);
    procedure PenButtonClick(Sender: TObject);
    procedure BrushButtonClick(Sender: TObject);
    procedure SetPenStyle(Sender: TObject);
    procedure PenSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetBrushStyle(Sender: TObject);
    procedure PenColClick(Sender: TObject);
    procedure BrushColClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure EdPaintBoxPaint(Sender: TObject);
    procedure List1Click(Sender: TObject);
    procedure EdPaintBoxDblClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure SaveEPS1Click(Sender: TObject);
    procedure SetXYSpBtnClick(Sender: TObject);
    procedure LetterButtonClick(Sender: TObject);
    procedure PointButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MiscButtonClick(Sender: TObject);
    procedure TimesButtonClick(Sender: TObject);
    procedure TimesItalButtonClick(Sender: TObject);
    procedure TimesBoldButtonClick(Sender: TObject);
    procedure SymbolButtonClick(Sender: TObject);
    procedure ToolEllipseButtonClick(Sender: TObject);
    procedure ToolCircleButtonClick(Sender: TObject);
    procedure ToolPageControlChange(Sender: TObject);
    procedure ToolLineButtonClick(Sender: TObject);
    procedure ToolArrow1ButtonClick(Sender: TObject);
    procedure ToolFilledCircleButtonClick(Sender: TObject);
    procedure ToolRectButtonClick(Sender: TObject);
    procedure ToolFilledRectButtonClick(Sender: TObject);
    procedure NetworkButtonClick(Sender: TObject);
    procedure ColPanMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGrid1Click(Sender: TObject);
    procedure MarkGrid1Click(Sender: TObject);
    procedure Snap1Click(Sender: TObject);
    procedure ToolWavyButtonClick(Sender: TObject);
    procedure ToolPolyLineButtonClick(Sender: TObject);
    procedure ToolPolyGonButtonClick(Sender: TObject);
    procedure SelGrid1Click(Sender: TObject);
    procedure Pen1Click(Sender: TObject);
    procedure Brush1Click(Sender: TObject);
    procedure Extras1Click(Sender: TObject);
    procedure HelveticaButtonClick(Sender: TObject);
    procedure ComBoxBrushSelect(Sender: TObject);
    procedure SaveBMP1Click(Sender: TObject);
    procedure SaveWMF1Click(Sender: TObject);
    procedure LabEdAngleChange(Sender: TObject);
    procedure HelvItalButtonClick(Sender: TObject);
    procedure HelvBoldButtonClick(Sender: TObject);
    procedure CourierButtonClick(Sender: TObject);
    procedure CourierItalButtonClick(Sender: TObject);
    procedure CourierBoldButtonClick(Sender: TObject);
    procedure CurDirClick(Sender: TObject);
    procedure LoadPicture1Click(Sender: TObject);
    procedure ToolPolyBezierButtonClick(Sender: TObject);
    procedure ToolPolyBezFillButtonClick(Sender: TObject);
    procedure ToolCurve1ButtonClick(Sender: TObject);
    procedure ToolFillCurve1ButtonClick(Sender: TObject);
    procedure Rescale1Click(Sender: TObject);
    procedure Shift1Click(Sender: TObject);
    procedure ToolCurve2ButtonClick(Sender: TObject);
    procedure ToolFillCurve2ButtonClick(Sender: TObject);
    procedure PrinterSetup1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BrushColor, PenColor : TColor;
    ListBrushStyle,
    BrushStyle: TBrushStyle;
    BrushKind : TBrushKind;
    PenStyle: TPenStyle;
    PenWide: Integer;
    Drawing: Boolean;
    Orig: TPoint;
    DrawingTool: TDrawingTool;
    CurrentFile: string;
    CurPrimRef,
    LineRef,RectRef,CircRef : TGrPrimRef;
    CurPrim : TGraphPrim;
    CurText : String;
    CurFont : epsFonts;
    CurAngle : Integer;
    IniPars : Boolean;
    procedure SaveStyles;
    procedure RestoreStyles;

    procedure DrawPic(AControl : TControl; ACanvas : TCanvas;
     NoGrid,Transp,Sel : Boolean);
    procedure NewObject(X, Y : Integer);
    procedure ChangeObject(X, Y : Integer);
    procedure CompleteObject(X, Y : Integer);
    procedure AddIntPoint(X, Y : Integer);
    procedure SetNewPenColor(Color : TColor);
    procedure SetNewBrushColor(Color : TColor);
    procedure SaveFile(const FName : String);
    procedure ReadFile(const FName : String);
    procedure SaveEPSFile(const FName : String);
    procedure ReadListData(Li : integer);
    procedure WriteListData(Li : integer);
    procedure GridXY(var X,Y : integer);
    procedure LimitXY(var X,Y : integer);
    procedure LoadPicture(const FName : String);
    procedure PrintPic;
  end;

var
  DrawForm: TDrawForm;

implementation

uses BMPDlg, Clipbrd;

{$R *.dfm}

procedure TDrawForm.PaintMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Orig := Point(X, Y);
  GridXY(X,Y);
  if Shift = [ssLeft] then
  if CurPrimRef = nil then EdPaintBoxDblClick(Sender)
  else
  if (CurPrimRef = TPrimRotText) and
     (CurText='') then
    begin
     CurText := InputBoxF('Input Box','Enter the text to draw','',
      LetterButton.Font)
    end
  else
  begin
    Drawing := True;
    NewObject(X,Y);
    StatusBar1.Panels[0].Text := Format('Origin: (%d, %d)', [X, Y]);
  end;
end;

procedure TDrawForm.NewObject(X, Y : Integer);
begin
  LimitXY(X,Y);
  GridXY(X,Y);
  if CurPrim <> nil then CurPrim.Destroy;
  with EdPaintBox.Canvas do
  CurPrim := CurPrimRef.Create(X,Y,X,Y,
   Pen.Color,Brush.Color,Pen.Width,Pen.Style,Brush.Style,BrushKind);
  if CurPrimRef = TPrimRotText then
   with CurPrim as TPrimRotText do
   begin
    Text := CurText;
    FntN := CurFont;
    Rot := CurAngle;
   end;
end;


procedure TDrawForm.PaintMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LimitXY(X,Y);
  GridXY(X,Y);
  if Drawing then
  if Shift <> [ssLeft] then
  begin
   CompleteObject(X,Y);
   Drawing := False;
   EdPaintBoxPaint(Sender);
  end
  else
  begin {Right Mouse}
   AddIntPoint(X,Y);
   EdPaintBoxPaint(Sender);
  end;
end;

procedure TDrawForm.CompleteObject(X, Y : Integer);
begin
  if CurPrim <> nil
  then
  begin
   CurPrim.Set2nd(X,Y);
   with ListForm.GrListBox do
    with CurPrim do
    if (Origin.X <> Fin.X) or (Origin.Y <> Fin.Y) then
    begin
     AddItem(CurPrim.PrimCaption,CurPrim);
     ItemIndex := -1;
    end
    else CurPrim.Free;
    CurPrim := nil;
    CurText := '';
   end;
end;

procedure TDrawForm.AddIntPoint(X, Y : Integer);
begin
  if CurPrim <> nil
  then CurPrim.SetInt(X,Y);
end;

procedure TDrawForm.PaintMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Shift = [ssLeft] then
  if Drawing then
  begin
   LimitXY(X,Y);
   GridXY(X,Y);
   ChangeObject(X,Y);
  end;
  StatusBar1.Panels[1].Text := Format('Current: (%d, %d)', [X, Y]);
end;

procedure TDrawForm.ChangeObject(X, Y : Integer);
begin
  if CurPrim <> nil then
  with EdPaintBox do
  begin
   SaveStyles;
   Canvas.Pen.Mode := pmNotXor;
   CurPrim.Draw(Canvas,false);
   CurPrim.ChgLast{Set2nd}(X,Y);
   CurPrim.Draw(Canvas,false);
   Canvas.Pen.Mode := pmCopy;
   RestoreStyles;
  end;
end;


procedure TDrawForm.LineButtonClick(Sender: TObject);
begin
  LineButton.Down := True;
  DrawingTool := dtLine;
  CurPrimRef := LineRef;
  ToolPageControl.ActivePageIndex := 0;
end;

procedure TDrawForm.RectangleButtonClick(Sender: TObject);
begin
  RectangleButton.Down := True;
  DrawingTool := dtRectangle;
  CurPrimRef := RectRef;
  ToolPageControl.ActivePageIndex := 1;
end;

procedure TDrawForm.EllipseButtonClick(Sender: TObject);
begin
  EllipseButton.Down := True;
  DrawingTool := dtEllipse;
  CurPrimRef := CircRef;
  ToolPageControl.ActivePageIndex := 2;

end;

procedure TDrawForm.PenButtonClick(Sender: TObject);
begin
  PenBar.Visible := PenButton.Down;
  Pen1.Checked := PenButton.Down;
end;

procedure TDrawForm.BrushButtonClick(Sender: TObject);
begin
  BrushBar.Visible := BrushButton.Down;
  Brush1.Checked := BrushButton.Down;
end;

procedure TDrawForm.SetPenStyle(Sender: TObject);
begin
  with EdPaintBox.Canvas.Pen do
  begin
    if Sender = SolidPen then Style := psSolid
    else if Sender = DashPen then Style := psDash
    else if Sender = DotPen then Style := psDot
    else if Sender = DashDotPen then Style := psDashDot
    else if Sender = DashDotDotPen then Style := psDashDotDot
    else if Sender = ClearPen then Style := psClear;
    DrawShape.Pen.Style := Style;
  end;
end;

procedure TDrawForm.PenSizeChange(Sender: TObject);
begin
  EdPaintBox.Canvas.Pen.Width := PenWidth.Position;
  DrawShape.Pen.Width := PenWidth.Position;
end;

procedure TDrawForm.FormCreate(Sender: TObject);
begin
  CurPrimRef := TPrimLine;
  LineRef := TPrimLine;
  RectRef := TPrimRect;
  CircRef := TPrimEllipse;
  CurPrim := nil;
  CurText := '';
  CurFont := efRoman;
  IniPars := ParamCount <> 0;
  ListBrushStyle := bsSolid;
  BrushKind := bkTransparent; {transparent}
  ComBoxBrush.ItemIndex := 0;
  CurAngle := 0;

  WinFonts[efRoman] := DrawForm.TimesButton.Font;
  WinFonts[efRomanItal] := DrawForm.TimesItalButton.Font;
  WinFonts[efRomanBold] := DrawForm.TimesBoldButton.Font;
  WinFonts[efSymbol] := DrawForm.SymbolButton.Font;
  WinFonts[efHelvetica] := DrawForm.HelveticaButton.Font;
  WinFonts[efHelvItal] := DrawForm.HelvItalButton.Font;
  WinFonts[efHelvBold] := DrawForm.HelvBoldButton.Font;
  WinFonts[efCourier] := DrawForm.CourierButton.Font;
  WinFonts[efCourierItal] := DrawForm.CourierItalButton.Font;
  WinFonts[efCourierBold] := DrawForm.CourierBoldButton.Font;

 {$IF CompilerVersion > 21}
  FormatSettings.DecimalSeparator := '.';
 {$ELSE}
  DecimalSeparator := '.';
 {$IFEND}
 end;

procedure TDrawForm.SetBrushStyle(Sender: TObject);
begin
  with EdPaintBox.Canvas.Brush do
  begin
    {SetNewBrushColor(Color);}
    if Sender = SolidBrush then BrushKind := bkOpaque
    else if Sender = ClearBrush then BrushKind := bkTransparent
    else if Sender = ComBoxBrush then Style := ListBrushStyle;
    with DrawShape do
    begin
     if BrushKind = bkOpaque then
      Brush.Color := Pen.Color;
     Brush.Style := Style;
    end
  end;
end;

procedure TDrawForm.PenColClick(Sender: TObject);
begin
  ColorDialog1.Color := EdPaintBox.Canvas.Pen.Color;
  if ColorDialog1.Execute then
    SetNewPenColor(ColorDialog1.Color)
end;

procedure TDrawForm.BrushColClick(Sender: TObject);
begin
  ColorDialog1.Color := EdPaintBox.Canvas.Brush.Color;
  if ColorDialog1.Execute then
    SetNewBrushColor(ColorDialog1.Color)
end;

procedure TDrawForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TDrawForm.Open1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    CurrentFile := OpenDialog1.FileName;
    {SaveStyles;}
    ReadFile(CurrentFile);
    {RestoreStyles;}
  end;
end;

procedure TDrawForm.Save1Click(Sender: TObject);
begin
  if CurrentFile <> EmptyStr then
    SaveFile(CurrentFile)
  else SaveAs1Click(Sender);
end;

procedure TDrawForm.Saveas1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    CurrentFile := SaveDialog1.FileName;
    Save1Click(Sender);
  end;
end;

procedure TDrawForm.New1Click(Sender: TObject);
begin
  with NewBMPForm do
  begin
    ActiveControl := WidthEdit;
    WidthEdit.Text := IntToStr(EdPaintBox.Width);
    HeightEdit.Text := IntToStr(EdPaintBox.Height);
    if ShowModal <> idCancel then
    begin
     try
      CurrentFile := EmptyStr;
      EdPaintBox.Width :=StrToInt(WidthEdit.Text);
      EdPaintBox.Height := StrToInt(HeightEdit.Text);
     finally
     end;
    end;
  end;
end;

procedure TDrawForm.Copy1Click(Sender: TObject);
begin
  {Clipboard.Assign(Image.Picture);}
end;

procedure TDrawForm.SaveStyles;
begin
  with EdPaintBox.Canvas do
  begin
    BrushStyle := Brush.Style;
    PenStyle := Pen.Style;
    PenWide := Pen.Width;
    BrushColor := Brush.Color;
    PenColor := Pen.Color
  end;
end;

procedure TDrawForm.RestoreStyles;
begin
  with EdPaintBox.Canvas do
  begin
    Brush.Color := BrushColor;
    Pen.Color := PenColor;
    Brush.Style := BrushStyle;
    Pen.Style := PenStyle;
    Pen.Width := PenWide;
  end;
end;

procedure TDrawForm.EdPaintBoxPaint(Sender: TObject);
begin
 DrawPic(EdPaintBox,EdPaintBox.Canvas,False,False,True);
end;

procedure TDrawForm.DrawPic(AControl : TControl; ACanvas : TCanvas;
  NoGrid,Transp,Sel : Boolean);
var
 i,j,d : integer;
begin
 SaveStyles;
 with AControl,ACanvas do
 begin
   if not Transp then
   begin
    Brush.Color := clWhite;
    Brush.Style := bsSolid;
    Pen.Style := psClear;
    Rectangle(0,0,Width,Height);
   end;
  if NoGrid then d:=0
  else d := UpDnGrid.Position;
  if d > 1 then
   if DrawGrid1.Checked then
   begin
    Pen.Color := clGray;
    Pen.Style := psSolid;
    for i:= 0 to (Width - 1) div d do
    begin
     MoveTo(i*d,0); LineTo(i*d,Height-1);
    end;
    for j:= 0 to (Height - 1) div d do
    begin
     MoveTo(0,j*d); LineTo(Width-1,j*d);
    end;
   end
   else
   if MarkGrid1.Checked then
   begin
    for i:= 0 to (Width - 1) div d do
     for j:= 0 to (Height - 1) div d do
      Pixels[d*i,d*j] := clGray
   end;

 end;
 with ListForm.GrListBox do
 begin
  for i := 0 to Count-1 do
   with Items.Objects[i] as TGraphPrim do
    Draw(ACanvas,Selected[i] and Sel);
  ReadListData(ItemIndex);
 end;
 if CurPrim <> nil
  then CurPrim.Draw(ACanvas,False);
 RestoreStyles;
end;

procedure TDrawForm.List1Click(Sender: TObject);
begin
 ListForm.Visible := List1.Checked
end;

procedure TDrawForm.EdPaintBoxDblClick(Sender: TObject);
var
 i : integer;
begin
 with Orig do
 with ListForm.GrListBox do
 begin
  for i := 0 to Count-1 do
   with Items.Objects[i] as TGraphPrim do
    if Pointed(X,Y) then ItemIndex := i;
 end;
 EdPaintBoxPaint(Sender);
end;

procedure TDrawForm.SaveFile(const FName : String);
var
 i : integer;
 fo : TextFile;
begin
 AssignFile(fo,FName);
 Rewrite(fo);
 with EdPaintBox do
 writeln(fo,Width,' ',Height);
 with ListForm.GrListBox do
 begin
  for i := 0 to Count-1 do
   with Items.Objects[i] as TGraphPrim do
   begin
    WriteText(fo);
   end
 end;
 CloseFile(fo);
 StatusBar1.Panels[2].Text := FName;
end;

procedure TDrawForm.SaveEPSFile(const FName : String);
var
 i : integer;
 fo : TextFile;
begin
 AssignFile(fo,FName);
 Rewrite(fo);
 with EdPaintBox do
 epsWriteHeader(fo,Width,Height,'');
 with ListForm.GrListBox do
 begin
  for i := 0 to Count-1 do
   with Items.Objects[i] as TGraphPrim do
   WriteEps(fo);
 end;
 epsWriteFooter(fo);
 CloseFile(fo);
end;


procedure TDrawForm.Clear1Click(Sender: TObject);
begin
 ListForm.ClearList;
 EdPaintBoxPaint(Sender);
end;

procedure TDrawForm.ReadFile(const FName : String);
var
 fi : TextFile;
 PrimRef : TGrPrimRef;
 W,H : Integer;
 PName : String;
 Prim : TGraphPrim;
begin
 AssignFile(fi,FName);
 reset(fi);
 with ListForm do
 if GrListBox.Count > 0 then
  if MessageDlg('Clear picture?',mtConfirmation,
   [mbYes,mbNo],0) = mrYes then ClearList;
 readln(fi,W,H);
 with EdPaintBox do
 begin
  Width := W; Height := H;
 end;
 repeat
  Readln(fi,PName);
  PrimRef := GrPrimName2Ref(PName);
  if PrimRef <> nil then
  with ListForm.GrListBox do
    begin
     Prim := PrimRef.ReadFromFile(fi);
     with Prim do
     AddItem(PrimCaption,Prim);
     ItemIndex := -1;
    end
 until eof(fi);
 CloseFile(fi);
 StatusBar1.Panels[2].Text := FName;
 EdPaintBoxPaint(Self);
end;


procedure TDrawForm.SaveEPS1Click(Sender: TObject);
begin
 with SaveDialogEPS do
 if Execute then
 begin
   EpsParDlg.Execute;
   SaveEPSFile(FileName);
 end;
end;

procedure TDrawForm.ReadListData(Li : integer);
begin
 if Li <> -1 then
 with ListForm.GrListBox.Items.Objects[Li]
  as TGraphPrim do
 begin
  LabEdX1.Text := IntToStr(Round(Origin.X));
  LabEdY1.Text := IntToStr(Round(Origin.Y));
  LabEdX2.Text := IntToStr(Round(Fin.X));
  LabEdY2.Text := IntToStr(Round(Fin.Y));
 end;

end;

procedure TDrawForm.WriteListData(Li : integer);
var
 eX1,eY1,eX2,eY2 : Integer;
begin
if Li <> -1 then
 begin
  try
   eX1 := StrToInt(LabEdX1.Text);
   eY1 := StrToInt(LabEdY1.Text);
   eX2 := StrToInt(LabEdX2.Text);
   eY2 := StrToInt(LabEdY2.Text);
   with ListForm.GrListBox.Items do
    with Objects[Li] as TGraphPrim do
    begin
     {
     Origin := FPoint(eX1,eY1);
     Set2nd(eX2,eY2);
     }
     MoveScale(eX1,eY1,eX2,eY2);
     if CBxEdFill.Checked then
     with EdPaintBox.Canvas do
     begin
       PenColor := Pen.Color;
       BrushColor := Brush.Color;
       PenWidth := Pen.Width;
       PenStyle := Pen.Style;
       BrushStyle := Brush.Style;
       BrushKind := DrawForm.BrushKind;
     end;
     Strings[Li] := PrimCaption;
    end;
   EdPaintBoxPaint(Self);

  except
   on E: EConvertError do
      ShowMessage(E.ClassName + ^J + E.Message);
  end
 end;
end;


procedure TDrawForm.SetXYSpBtnClick(Sender: TObject);
begin
 with ListForm.GrListBox do
  WriteListData(ItemIndex);
end;

procedure TDrawForm.LetterButtonClick(Sender: TObject);
begin
  LetterButton.Down := True;
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  ToolPageControl.ActivePageIndex := 3;

end;

procedure TDrawForm.PointButtonClick(Sender: TObject);
begin
 DrawingTool := dtPointer;
 CurPrimRef := nil;
end;

procedure TDrawForm.FormActivate(Sender: TObject);
begin
 if IniPars then
 begin
  IniPars := False;
  if FileExists(ParamStr(1)) then
   ReadFile(ParamStr(1));
 end;
end;

procedure TDrawForm.MiscButtonClick(Sender: TObject);
begin
 TopPan.Visible := MiscButton.Down;
 Extras1.Checked := MiscButton.Down;
end;

procedure TDrawForm.TimesButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efRoman;
  LetterButton.Font := TimesButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.TimesItalButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efRomanItal;
  LetterButton.Font := TimesItalButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.TimesBoldButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efRomanBold;
  LetterButton.Font := TimesBoldButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.SymbolButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efSymbol;
  LetterButton.Font := SymbolButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.ToolEllipseButtonClick(Sender: TObject);
begin
  DrawingTool := dtEllipse;
  CurPrimRef := TPrimEllipse;
  CircRef := TPrimEllipse;
  EllipseButton.Down := True;
  EllipseButton.Glyph := ToolEllipseButton.Glyph;
end;

procedure TDrawForm.ToolCircleButtonClick(Sender: TObject);
begin
  DrawingTool := dtEllipse;
  CurPrimRef := TPrimCircle;
  CircRef := TPrimCircle;
  EllipseButton.Down := True;
  EllipseButton.Glyph := ToolCircleButton.Glyph;
end;

procedure TDrawForm.ToolPageControlChange(Sender: TObject);
begin
 case ToolPageControl.ActivePageIndex of
  0 : LineButton.Click;
  1 : RectangleButton.Click;
  2 : EllipseButton.Click;
  3 : LetterButton.Click;
  4 : NetworkButton.Click;
 end
end;

procedure TDrawForm.ToolLineButtonClick(Sender: TObject);
begin
  DrawingTool := dtLine;
  CurPrimRef := TPrimLine;
  LineRef := TPrimLine;
  LineButton.Down := True;
  LineButton.Glyph := ToolLineButton.Glyph;
end;

procedure TDrawForm.ToolArrow1ButtonClick(Sender: TObject);
begin
  DrawingTool := dtLine;
  CurPrimRef := TPrimArrow1;
  LineRef := TPrimArrow1;
  LineButton.Down := True;
  LineButton.Glyph := ToolArrow1Button.Glyph;
end;

procedure TDrawForm.ToolFilledCircleButtonClick(Sender: TObject);
begin
  DrawingTool := dtEllipse;
  CurPrimRef := TPrimFilledCircle;
  CircRef := TPrimFilledCircle;
  EllipseButton.Down := True;
  EllipseButton.Glyph := ToolFilledCircleButton.Glyph;
end;

procedure TDrawForm.ToolRectButtonClick(Sender: TObject);
begin
  DrawingTool := dtRectangle;
  CurPrimRef := TPrimRect;
  RectRef := TPrimRect;
  RectangleButton.Down := True;
  RectangleButton.Glyph := ToolRectButton.Glyph;
end;

procedure TDrawForm.ToolFilledRectButtonClick(Sender: TObject);
begin
  DrawingTool := dtRectangle;
  CurPrimRef := TPrimFilledRect;
  RectRef := TPrimFilledRect;
  RectangleButton.Down := True;
  RectangleButton.Glyph := ToolFilledRectButton.Glyph;
end;

procedure TDrawForm.NetworkButtonClick(Sender: TObject);
begin
  NetworkButton.Down := True;
  DrawingTool := dtRectangle;
  CurPrimRef := RectRef;
  ToolPageControl.ActivePageIndex := 4;
end;

procedure TDrawForm.ColPanMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Sender is TPanel then
 with Sender as TPanel do
  if Shift = [ssLeft] then
   SetNewPenColor(Color)
  else
  if Shift = [ssRight] then
   SetNewBrushColor(Color)
end;


 procedure TDrawForm.SetNewPenColor(Color : TColor);
 begin
   EdPaintBox.Canvas.Pen.Color := Color;
   PenColPan.Color := Color;
   DrawShape.Pen.Color := Color;
   DrawTestPan.Font.Color := Color;
 end;

 procedure TDrawForm.SetNewBrushColor(Color : TColor);
 begin
   EdPaintBox.Canvas.Brush.Color := Color;
   BrushColPan.Color := Color;
   DrawShape.Brush.Color := Color;
 end;

 procedure TDrawForm.GridXY(var X,Y : integer);
 var
  d : integer;
 begin
  d := UpDnGrid.Position;
  if Snap1.Checked then
  if d > 1 then
  begin
   if XSnap1.Checked then
   begin
    X := X + d div 2;
    X := X - X mod d;
   end;
   if YSnap1.Checked then
   begin
    Y := Y + d div 2;
    Y := Y - Y mod d;
   end;
  end;
 end;

 procedure TDrawForm.LimitXY(var X,Y : integer);
 begin
  with EdPaintBox do
  begin
   X := Max(0,Min(X,Width));
   Y := Max(0,Min(Y,Height));
  end;
 end;



procedure TDrawForm.DrawGrid1Click(Sender: TObject);
begin
  if DrawGrid1.Checked then
   MarkGrid1.Checked := False;
  EdPaintBoxPaint(Sender);
end;

procedure TDrawForm.MarkGrid1Click(Sender: TObject);
begin
  if MarkGrid1.Checked then
   DrawGrid1.Checked := False;
  EdPaintBoxPaint(Sender);
end;

procedure TDrawForm.Snap1Click(Sender: TObject);
begin
 XSnap1.Enabled := Snap1.Checked;
 YSnap1.Enabled := Snap1.Checked;
end;

procedure TDrawForm.ToolWavyButtonClick(Sender: TObject);
begin
  DrawingTool := dtLine;
  CurPrimRef := TWavyLine;
  LineRef := TWavyLine;
  LineButton.Down := True;
  LineButton.Glyph := ToolWavyButton.Glyph;
 end;

procedure TDrawForm.ToolPolyLineButtonClick(Sender: TObject);
begin
  DrawingTool := dtLine;
  CurPrimRef := TPolyLine;
  LineRef := TPolyLine;
  LineButton.Down := True;
  LineButton.Glyph := ToolPolyLineButton.Glyph;
end;

procedure TDrawForm.ToolPolyGonButtonClick(Sender: TObject);
begin
  DrawingTool := dtRectangle;
  CurPrimRef := TPolyGon;
  RectRef := TPolyGon;
  RectangleButton.Down := True;
  RectangleButton.Glyph := ToolPolyGonButton.Glyph;
end;

procedure TDrawForm.SelGrid1Click(Sender: TObject);
begin
 SelPanel.Visible := SelGrid1.Checked;
end;

procedure TDrawForm.Pen1Click(Sender: TObject);
begin
  PenButton.Down := Pen1.Checked;
  PenBar.Visible := PenButton.Down;
end;

procedure TDrawForm.Brush1Click(Sender: TObject);
begin
  BrushButton.Down := Brush1.Checked;
  BrushBar.Visible := BrushButton.Down;
end;

procedure TDrawForm.Extras1Click(Sender: TObject);
begin
 MiscButton.Down := Extras1.Checked;
 TopPan.Visible := MiscButton.Down;
end;

procedure TDrawForm.HelveticaButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efHelvetica;
  LetterButton.Font := HelveticaButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.ComBoxBrushSelect(Sender: TObject);
begin
 with ComBoxBrush do
 begin
  case ItemIndex of
   0..7 : {OK}
  else
   ItemIndex := 0;
  end;
  ListBrushStyle := TBrushStyle(ItemIndex);
  SetBrushStyle(ComBoxBrush);
 end
end;

procedure TDrawForm.SaveBMP1Click(Sender: TObject);
var
 Bitmap : TBitmap;
begin
 with SaveDialogBMP do
 if Execute then
 begin
   Bitmap := TBitmap.Create;
   Bitmap.Width := EdPaintBox.Width;
   Bitmap.Height := EdPaintBox.Height;
   DrawPic(EdPaintBox,Bitmap.Canvas,True,False,False);
   Bitmap.SaveToFile(FileName);
   Bitmap.Free
 end;
end;

procedure TDrawForm.SaveWMF1Click(Sender: TObject);
var
 Metafile : TMetafile;
 MetaCanvas : TMetafileCanvas;
 Transp : Boolean;
 Ext : String;
begin
 with SaveDialogWMF do
 if Execute then
 begin
   Metafile := TMetafile.Create;
   Metafile.Width := EdPaintBox.Width;
   Metafile.Height := EdPaintBox.Height;
   Ext := UpperCase(ExtractFileExt(FileName));
   if Ext = '.WMF' then Metafile.Enhanced := False;
   MetaCanvas := TMetafileCanvas.Create(Metafile,0);
   Transp :=  (MessageDlg('Save transparent picture?',
    mtConfirmation, [mbYes,mbNo],0) = mrYes);
   DrawPic(EdPaintBox,MetaCanvas,True,Transp,False);
   MetaCanvas.Free;
   {Destroy -- image transfered to metafile}
   Metafile.SaveToFile(FileName);
   Metafile.Free;
 end;
end;

procedure TDrawForm.LabEdAngleChange(Sender: TObject);
begin
 CurAngle := (AngUpDn.Position + 360) mod 360
end;

procedure TDrawForm.HelvItalButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efHelvItal;
  LetterButton.Font := HelvItalButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.HelvBoldButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efHelvBold;
  LetterButton.Font := HelvBoldButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.CourierButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efCourier;
  LetterButton.Font := CourierButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.CourierItalButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efCourierItal;
  LetterButton.Font := CourierItalButton.Font;
  LetterButton.Down := True;

end;

procedure TDrawForm.CourierBoldButtonClick(Sender: TObject);
begin
  DrawingTool := dtText;
  CurPrimRef := TPrimRotText;
  CurFont := efCourierBold;
  LetterButton.Font := CourierBoldButton.Font;
  LetterButton.Down := True;
end;

procedure TDrawForm.CurDirClick(Sender: TObject);
begin
 ForceCurrentDirectory:= CurDir.Checked
end;

procedure TDrawForm.LoadPicture1Click(Sender: TObject);
begin
 with OpenPictureDialog1 do
 if Execute then LoadPicture({ExtractFileName}(FileName));
 EdPaintBoxPaint(Sender);
end;


procedure TDrawForm.LoadPicture(const FName : String);
var
 Ext : string;
 Pix : TPrimPix;
begin

  try
   Ext := UpperCase(ExtractFileExt(FName));
   with EdPaintBox.Canvas do
   if (Ext = '.JPG') or (Ext = '.JPEG')
   then
    Pix := TPrimJpeg.Create(0,0,0,0,
    0,0,0,psSolid,bsClear,bkTransparent)
   else
    Pix := TPrimBitmap.Create(0,0,0,0,
    clBlack,clWhite,0,psSolid,bsClear,bkTransparent);
   Pix.LoadImage(FName);
   if CurPrim <> nil then CurPrim.Destroy;
   CurPrim := Pix;
   with Pix.Fin do
    CompleteObject(Round(X),Round(Y));
  finally
  end;

end;

procedure TDrawForm.ToolPolyBezierButtonClick(Sender: TObject);
begin
  DrawingTool := dtLine;
  CurPrimRef := TPolyBezier;
  LineRef := TPolyBezier;
  LineButton.Down := True;
  LineButton.Glyph := ToolPolyBezierButton.Glyph;
end;

procedure TDrawForm.ToolPolyBezFillButtonClick(Sender: TObject);
begin
  DrawingTool := dtRectangle;
  CurPrimRef := TPolyBezierFill;
  RectRef := TPolyBezierFill;
  RectangleButton.Down := True;
  RectangleButton.Glyph := ToolPolyBezFillButton.Glyph;
end;

procedure TDrawForm.ToolCurve1ButtonClick(Sender: TObject);
begin
  DrawingTool := dtLine;
  CurPrimRef := TCurve1;
  LineRef := TCurve1;
  LineButton.Down := True;
  LineButton.Glyph := ToolCurve1Button.Glyph;
end;

procedure TDrawForm.ToolFillCurve1ButtonClick(Sender: TObject);
begin
  DrawingTool := dtRectangle;
  CurPrimRef := TFillCurve1;
  RectRef := TFillCurve1;
  RectangleButton.Down := True;
  RectangleButton.Glyph := ToolFillCurve1Button.Glyph;
end;

procedure TDrawForm.ToolCurve2ButtonClick(Sender: TObject);
begin
  DrawingTool := dtLine;
  CurPrimRef := TCurve2;
  LineRef := TCurve2;
  LineButton.Down := True;
  LineButton.Glyph := ToolCurve2Button.Glyph;
end;

procedure TDrawForm.ToolFillCurve2ButtonClick(Sender: TObject);
begin
  DrawingTool := dtRectangle;
  CurPrimRef := TFillCurve2;
  RectRef := TFillCurve2;
  RectangleButton.Down := True;
  RectangleButton.Glyph := ToolFillCurve2Button.Glyph;
end;


procedure TDrawForm.Rescale1Click(Sender: TObject);
var
 i : integer;
 W,H,SX,SY : double;
begin
 with NewBMPForm do
  begin
    ActiveControl := WidthEdit;
    WidthEdit.Text := IntToStr(EdPaintBox.Width);
    HeightEdit.Text := IntToStr(EdPaintBox.Height);
    if ShowModal <> idCancel then
    begin
     try
      W := StrToFloat(WidthEdit.Text);
      H := StrToFloat(HeightEdit.Text);
      SX := W / EdPaintBox.Width;
      SY := H / EdPaintBox.Height;
      EdPaintBox.Width := Ceil(W);
      EdPaintBox.Height := Ceil(H);
      with ListForm.GrListBox do
      for i := 0 to Count-1 do
       with Items.Objects[i] as TGraphPrim do
       begin
        ShiftScale(0,0,SX,SY);
        Items.Strings[i] := PrimCaption;
       end;
      EdPaintBoxPaint(Sender);
     finally
     end;
    end;
  end;

end;

procedure TDrawForm.Shift1Click(Sender: TObject);
var
 i : integer;
 W,H : double;
begin
 with NewBMPForm do
  begin
    ActiveControl := WidthEdit;
    WidthEdit.Text := IntToStr(EdPaintBox.Width);
    HeightEdit.Text := IntToStr(EdPaintBox.Height);
    if ShowModal <> idCancel then
    begin
     try
      W := StrToFloat(WidthEdit.Text);
      H := StrToFloat(HeightEdit.Text);
      EdPaintBox.Width := EdPaintBox.Width + Ceil(W);
      EdPaintBox.Height := EdPaintBox.Height + Ceil(H);
      with ListForm.GrListBox do
      for i := 0 to Count-1 do
       with Items.Objects[i] as TGraphPrim do
       begin
        ShiftScale(W,H,1,1);
        Items.Strings[i] := PrimCaption;
       end;
      EdPaintBoxPaint(Sender);
     finally
     end;
    end;
  end;

end;


procedure TDrawForm.PrinterSetup1Click(Sender: TObject);
begin
 PrinterSetupDialog1.Execute;
end;

procedure TDrawForm.Print1Click(Sender: TObject);
begin
 if PrintDialog1.Execute then PrintPic;
end;

procedure TDrawForm.PrintPic;
var
 Metafile : TMetafile;
 MetaCanvas : TMetafileCanvas;
 W,H,WP,HP : Integer;
 SW,SH : Single;
begin
 Metafile := TMetafile.Create;
 W := EdPaintBox.Width;
 H := EdPaintBox.Height;
 Metafile.Width := W;
 Metafile.Height := H;
 MetaCanvas := TMetafileCanvas.Create(Metafile,0);
 DrawPic(EdPaintBox,MetaCanvas,True,False,False);
 MetaCanvas.Free;
 with Printer do
 begin
  WP := PageWidth;
  HP := PageHeight;
  SW := WP / W;
  SH := HP / H;
  if SH > SW then HP := Trunc(H*SW)
             else WP := Trunc(W*SH);
  BeginDoc;
  Canvas.StretchDraw(Rect(0,0,WP-1,HP-1),Metafile);
  EndDoc;
 end;
 Metafile.Free;
end;


end.
