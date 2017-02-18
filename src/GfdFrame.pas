unit GfdFrame;

interface

uses
  GrfPrim,GrEPS,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  
  TGfdBox = class(TFrame)
    DrawBox: TPaintBox;
    Roman: TLabel;
    RomanItal: TLabel;
    RomanBold: TLabel;
    Symbol: TLabel;
    Helvetica: TLabel;
    HelvItal: TLabel;
    HelvBold: TLabel;
    Courier: TLabel;
    CourierItal: TLabel;
    CourierBold: TLabel;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawBoxPaint(Sender: TObject);
  private
    { Private declarations }
    Items : TStringList;
    procedure AddPrim(Prim : TGraphPrim);
    procedure ClearList;
  public
    { Public declarations }
    procedure SaveEPS(FileName : String);
    procedure SaveGED(FileName : String);
    procedure ReadGED(FileName : String);
    procedure geClear;
    procedure geLine(X1,Y1,X2,Y2 : Number; Color : TColor;
     Width : Number = 1; Style : TPenStyle = psSolid);
    procedure geArrow(X1,Y1,X2,Y2 : Number; Color : TColor;
     Width : Number = 1; Style : TPenStyle = psSolid);
    procedure geRect(X1,Y1,X2,Y2 : Number; Color : TColor;
     Width : Number = 1; Style : TPenStyle=psSolid);
    procedure geBar(X1,Y1,X2,Y2 : Number; Color : TColor);
    procedure geFillRect(X1,Y1,X2,Y2 : Number; PenColor,BrushColor : TColor;
     PenWidth : Number; PenStyle : TPenStyle; BrushStyle : TBrushStyle;
     BrushKind : TBrushKind = bkTransparent);
    procedure geCircle(X,Y,R : Number; Color : TColor;
     Width : Number = 1; Style : TPenStyle = psSolid);
    procedure geDisk(X,Y,R : Number; Color : TColor);
    procedure geFillCircle(X,Y,R : Number; PenColor,BrushColor : TColor;
     PenWidth : Number; PenStyle : TPenStyle; BrushStyle : TBrushStyle;
     BrushKind : TBrushKind = bkTransparent);
    procedure geEllipse(X1,Y1,X2,Y2 : Number; Color : TColor;
     Width : Number = 1; Style : TPenStyle = psSolid);
    procedure geFillEllipse(X1,Y1,X2,Y2 : Number; PenColor,BrushColor : TColor;
     PenWidth : Number; PenStyle : TPenStyle; BrushStyle : TBrushStyle;
     BrushKind : TBrushKind = bkTransparent);
    procedure gePolyLine(Points : TFPoints; Color : TColor;
     Width : Number = 1; Style : TPenStyle = psSolid);
    procedure gePolyGon(Points : TFPoints; PenColor,BrushColor : TColor;
     PenWidth : Number; PenStyle : TPenStyle; BrushStyle : TBrushStyle;
     BrushKind : TBrushKind = bkTransparent);
    procedure geText(sText : string;
     X,Y,H : Number; Color : TColor; fnt : epsFonts = efRoman);
    procedure geTextRot(sText : string;
     X,Y,H,Angle : Number; Color : TColor; fnt : epsFonts);
    procedure geBitmap(X1,Y1,X2,Y2 : Number; const FileName : String);
  end;

  {TODO Image: see PRLM2.PDF pp 224,225}

implementation

{$R *.dfm}


 constructor TGfdBox.Create(AOwner: TComponent);
 begin
  inherited;
  Items := TStringList.Create;
  WinFonts[efRoman] := Roman.Font;
  WinFonts[efRomanItal] := RomanItal.Font;
  WinFonts[efRomanBold] := RomanBold.Font;
  WinFonts[efSymbol] := Symbol.Font;
  WinFonts[efHelvetica] := Helvetica.Font;
  WinFonts[efHelvItal] := HelvItal.Font;
  WinFonts[efHelvBold] := HelvBold.Font;
  WinFonts[efCourier] := Courier.Font;
  WinFonts[efCourierItal] := CourierItal.Font;
  WinFonts[efCourierBold] := CourierBold.Font;
 end;


 destructor TGfdBox.Destroy;
 begin
  ClearList;
  Items.Free;
  inherited
 end;

 procedure TGfdBox.ClearList;
 var
  i : integer;
 begin
  if Items <> nil then
  begin
   with Items do
   for i := 0 to Count-1 do
    Objects[i].Free;
   Items.Clear;
  end;
 end;

 procedure TGfdBox.AddPrim(Prim : TGraphPrim);
 begin
  Items.AddObject(Prim.PrimCaption,Prim);
 end;

 procedure TGfdBox.SaveEPS(FileName : String);
 var
  i : integer;
  fo : TextFile;
 begin
  AssignFile(fo,FileName);
  Rewrite(fo);
  with DrawBox do
  epsWriteHeader(fo,Width,Height,'');
  if Items <> nil then
  with Items do
  begin
   for i := 0 to Count-1 do
    with Objects[i] as TGraphPrim do
    WriteEps(fo);
  end;
  epsWriteFooter(fo);
  CloseFile(fo);
 end;

 procedure TGfdBox.SaveGED(FileName : String);
 var
  i : integer;
  fo : TextFile;
 begin
  AssignFile(fo,FileName);
  Rewrite(fo);
  Writeln(fo,Width,' ',Height);
  if Items <> nil then
  with Items do
  begin
   for i := 0 to Count-1 do
    with Objects[i] as TGraphPrim do
     WriteText(fo);
  end;
  CloseFile(fo);
 end;

procedure TGfdBox.ReadGED(FileName : String);
var
 fi : TextFile;
 PrimRef : TGrPrimRef;
 W,H : Integer;
 PName : String;
 Prim : TGraphPrim;
begin
 AssignFile(fi,FileName);
 reset(fi);
 readln(fi,W,H);
 with DrawBox do
 begin
  Width := W; Height := H;
 end;
 repeat
  Readln(fi,PName);
  if PName = 'Line' then PrimRef := TPrimLine
  else
  if PName = 'Rectangle' then PrimRef := TPrimRect
  else
  if PName = 'Ellipse' then PrimRef := TPrimEllipse
  else
  if PName = 'Text' then PrimRef := TPrimRotText
  else
  if PName = 'SimpleArrow' then PrimRef := TPrimArrow1
  else
  if PName = 'WavyLine' then PrimRef := TWavyLine
  else
  if PName = 'PolyLine' then PrimRef := TPolyLine
  else
  if PName = 'Polygon' then PrimRef := TPolyGon
  else
  if PName = 'Bitmap' then PrimRef := TPrimBitmap
  else
  PrimRef := nil;
  if PrimRef <> nil then
    begin
     Prim := PrimRef.ReadFromFile(fi);
     AddPrim(Prim);
    end
 until eof(fi);
 CloseFile(fi);
 DrawBoxPaint(Self);
end;


 procedure TGfdBox.DrawBoxPaint(Sender: TObject);
 var
  i : integer;
 begin
 with DrawBox.Canvas do
 begin
  Brush.Color := clWhite;
  Brush.Style := bsSolid;
  FillRect(Classes.Rect(0,0,Width,Height));
  if Items <> nil then
  with Items do
  for i := 0 to Count-1 do
   with Items.Objects[i] as TGraphPrim do
    Draw(DrawBox.Canvas,false);

  end;
 end;

 procedure TGfdBox.geClear;
 begin
  ClearList;
  DrawBoxPaint(Self);
 end;

 procedure TGfdBox.geLine(X1,Y1,X2,Y2 : Number; Color : TColor;
     Width : Number; Style : TPenStyle);
 begin
  AddPrim(TPrimLine.Create(X1,Y1,X2,Y2,Color,0,Width,Style,
   bsSolid,bkTransparent));
  DrawBoxPaint(Self);
 end;

 procedure TGfdBox.geArrow(X1,Y1,X2,Y2 : Number; Color : TColor;
     Width : Number; Style : TPenStyle);
 begin
  AddPrim(TPrimArrow1.Create(X1,Y1,X2,Y2,Color,0,Width,Style,
   bsSolid,bkTransparent));
  DrawBoxPaint(Self);
 end;


 procedure TGfdBox.geRect(X1,Y1,X2,Y2 : Number; Color : TColor;
     Width : Number; Style : TPenStyle);
 begin
  AddPrim(TPrimRect.Create(X1,Y1,X2,Y2,Color,0,Width,Style,
   bsClear,bkTransparent));
  DrawBoxPaint(Self);
 end;

 procedure TGfdBox.geBar(X1,Y1,X2,Y2 : Number; Color : TColor);
 begin
  AddPrim(TPrimRect.Create(X1,Y1,X2,Y2,Color,Color,1,psClear,
   bsSolid,bkTransparent));
  DrawBoxPaint(Self);
 end;

 procedure TGfdBox.geFillRect(X1,Y1,X2,Y2 : Number; PenColor,BrushColor : TColor;
     PenWidth : Number; PenStyle : TPenStyle; BrushStyle : TBrushStyle;
     BrushKind : TBrushKind);
 begin
  AddPrim(TPrimRect.Create(X1,Y1,X2,Y2,PenColor,BrushColor,PenWidth,
   PenStyle,BrushStyle,BrushKind));
  DrawBoxPaint(Self);
 end;

 procedure TGfdBox.geCircle(X,Y,R : Number; Color : TColor;
     Width : Number; Style : TPenStyle);
 begin
  AddPrim(TPrimCircle.Create(X-R,Y-R,X+R,Y+R,Color,Color,Width,
   Style,bsClear,bkTransparent));
  DrawBoxPaint(Self);
 end;

 procedure TGfdBox.geDisk(X,Y,R : Number; Color : TColor);
 begin
  AddPrim(TPrimCircle.Create(X-R,Y-R,X+R,Y+R,Color,Color,1,psClear,
   bsSolid,bkTransparent));
  DrawBoxPaint(Self);
 end;

 procedure TGfdBox.geFillCircle(X,Y,R : Number; PenColor,BrushColor : TColor;
     PenWidth : Number; PenStyle : TPenStyle; BrushStyle : TBrushStyle;
     BrushKind : TBrushKind);
 begin
  AddPrim(TPrimCircle.Create(X-R,Y-R,X+R,Y+R,PenColor,BrushColor,PenWidth,
   PenStyle,BrushStyle,BrushKind));
  DrawBoxPaint(Self);
 end;

 procedure TGfdBox.geEllipse(X1,Y1,X2,Y2 : Number; Color : TColor;
     Width : Number; Style : TPenStyle);
 begin
  AddPrim(TPrimEllipse.Create(X1,Y1,X2,Y2,Color,0,Width,Style,
   bsClear,bkTransparent));
  DrawBoxPaint(Self);
 end;


 procedure TGfdBox.geFillEllipse(X1,Y1,X2,Y2 : Number; PenColor,BrushColor : TColor;
     PenWidth : Number; PenStyle : TPenStyle; BrushStyle : TBrushStyle;
     BrushKind : TBrushKind);
 begin
  AddPrim(TPrimEllipse.Create(X1,Y1,X2,Y2,PenColor,BrushColor,PenWidth,
   PenStyle,BrushStyle,BrushKind));
  DrawBoxPaint(Self);
 end;


  procedure TGfdBox.gePolyLine(Points : TFPoints; Color : TColor;
     Width : Number; Style : TPenStyle);
  var
   PLine : TPolyLine;
   i : integer;
  begin
   PLine := TPolyLine.Create(Points[0].X,Points[0].Y,Points[1].X,Points[1].Y,
    Color,0,Width,Style,bsSolid,bkTransparent);
   for i := 2 to Length(Points)-1 do
    PLine.SetInt(Points[i].X,Points[i].Y);
   AddPrim(PLine);
   DrawBoxPaint(Self);
  end;

  procedure TGfdBox.gePolyGon(Points : TFPoints; PenColor,BrushColor : TColor;
     PenWidth : Number; PenStyle : TPenStyle; BrushStyle : TBrushStyle;
     BrushKind : TBrushKind);
  var
   PGon : TPolyGon;
   i : integer;
  begin
   PGon := TPolyGon.Create(Points[0].X,Points[0].Y,Points[1].X,Points[1].Y,
   PenColor,BrushColor,PenWidth,PenStyle,BrushStyle,BrushKind);
   for i := 2 to Length(Points)-1 do
    PGon.SetInt(Points[i].X,Points[i].Y);
   AddPrim(PGon);
   DrawBoxPaint(Self);
  end;


  procedure TGfdBox.geText(sText : string;
     X,Y,H : Number; Color : TColor; fnt : epsFonts);
  var
   PrText : TPrimText;
  begin
   PrText := TPrimText.Create(X,Y,X+H,Y+H,Color,0,1,psSolid,
    bsSolid,bkTransparent);
   PrText.Text := sText;
   PrText.FntN := fnt;
   AddPrim(PrText);
   DrawBoxPaint(Self);
  end;

  procedure TGfdBox.geTextRot(sText : string;
     X,Y,H,Angle : Number; Color : TColor; fnt : epsFonts);
  var
   PrText : TPrimRotText;
  begin
   PrText := TPrimRotText.Create(X,Y,X+H,Y+H,Color,0,1,psSolid,
    bsSolid,bkTransparent);
   PrText.Text := sText;
   PrText.FntN := fnt;
   PrText.Rot := Angle;
   AddPrim(PrText);
   DrawBoxPaint(Self);
  end;

  procedure TGfdBox.geBitmap(X1,Y1,X2,Y2 : Number; const FileName : String);
  var
   PrBmp : TPrimBitmap;
  begin
   PrBmp := TPrimBitMap.Create(X1,Y1,X2,Y2,clBlack,clWhite,1,
   psSolid,bsClear,bkTransparent);
   PrBmp.LoadImage(FileName);
   AddPrim(PrBmp);
   DrawBoxPaint(Self);
  end;

end.
