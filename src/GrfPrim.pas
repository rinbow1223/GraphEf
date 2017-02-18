unit GrfPrim;

interface

uses
 GrEPS,
 Windows, Classes, Graphics, SysUtils, Math, Jpeg;

var
 WinFonts : array[epsFonts] of TFont;

const
 grfNum = '%.12g';
 ComprAllBmp : Boolean = False;


type

 Number = Double;


 TFPoint = packed record
  X: Number;
  Y: Number;
 end;

 TFPoints = array of TFPoint;

 TPoints = array of TPoint;

 TBrushKind = (bkTransparent,bkOpaque);

 TGraphPrim = class
  Origin,Fin : TFPoint;
  PenColor,BrushColor : TColor;
  BrushKind : TBrushKind;
  PenWidth : Number;
  PenStyle : TPenStyle;
  BrushStyle : TBrushStyle;
  PrimName : String;
  Complete : Boolean;
  constructor Create(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); virtual;
  constructor ReadFromFile(var fi : TextFile); virtual;
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); virtual;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); virtual; abstract;
  function Pointed(X, Y : Number) : Boolean; virtual; abstract;
  function BoxPointed(X, Y : Number) : Boolean;
  function ElLinePointed(X, Y : Number) : Boolean;
  function EndPointed(X, Y : Number) : Boolean;
  procedure Set2nd(X, Y : Number); virtual;
  procedure WriteText(var fo : TextFile); virtual;
  procedure WriteEps(var fo : TextFile); virtual; abstract;
  function PrimCaption : String; virtual;
  function SetInt(X, Y : Number) : Boolean; virtual;
  procedure SetBrushAttr(Canvas : TCanvas; Selected : Boolean); virtual;
  procedure SetPenAttr(Canvas : TCanvas; Selected : Boolean); virtual;
  procedure MoveScale(X0,Y0,X1,Y1 : Number); virtual;
  procedure ShiftScale(DX,DY,SX,SY : Number); virtual;
  function EPSLevReq : Integer; virtual;
  procedure ChgLast(X, Y : Number); virtual;
 end;

 TGrPrimRef = class of TGraphPrim;

 TPrimLine = class(TGraphPrim)
   procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  function Pointed(X, Y : Number) : Boolean; override;
  procedure WriteEps(var fo : TextFile); override;
 end;

 TPrimRect = class(TGraphPrim)
   procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  function Pointed(X, Y : Number) : Boolean; override;
  procedure WriteEps(var fo : TextFile); override;
 end;

 TPrimFilledRect = class(TPrimRect)
   procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
 end;

 TPrimEllipse = class(TGraphPrim)
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  function Pointed(X, Y : Number) : Boolean; override;
  procedure WriteEps(var fo : TextFile); override;
 end;

 TPrimCircle = class(TPrimEllipse)
  procedure Set2nd(X, Y : Number); override;
 end;

 TPrimFilledCircle = class(TPrimCircle)
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
 end;


 TPrimText = class(TGraphPrim)
  Text : String;
  FntN : epsFonts;
  constructor ReadFromFile(var fi : TextFile); override;
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  function Pointed(X, Y : Number) : Boolean; override;
  procedure WriteText(var fo : TextFile); override;
  procedure WriteEps(var fo : TextFile); override;
  function PrimCaption : String; override;
 end;

 TPrimRotText = class(TGraphPrim)
  Text : String;
  FntN : epsFonts;
  Rot : Number;
  constructor ReadFromFile(var fi : TextFile); override;
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  function Pointed(X, Y : Number) : Boolean; override;
  procedure WriteText(var fo : TextFile); override;
  procedure WriteEps(var fo : TextFile); override;
  function PrimCaption : String; override;
 end;

 TPrimArrow1 = class(TGraphPrim)
  TickPar : Number;
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  function Pointed(X, Y : Number) : Boolean; override;
  procedure WriteEps(var fo : TextFile); override;
  function CalcTickLen : Number; virtual;
  procedure TickCoord(var T1,T2 : TFPoint); virtual;
  procedure CalcTickCoord(Angle : Double; B,E : TFPoint; var T1,T2 : TFPoint);
 end;

 TPrimMult = class(TGraphPrim)
  Filled : Boolean;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  procedure WriteEps(var fo : TextFile); override;
  function CalcArray : Doubles; virtual; abstract;
 end;

 TWavyLine = class(TPrimMult)
  APar : Number;
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function Pointed(X, Y : Number) : Boolean; override;
  function CalcArray : Doubles; override;
 end;

 TPolyLine = class(TPrimMult)
  Data : Doubles;
  CanDoub : Boolean;
  constructor ReadFromFile(var fi : TextFile); override;
  procedure WriteText(var fo : TextFile); override;
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function Pointed(X, Y : Number) : Boolean; override;
  procedure Set2nd(X, Y : Number); override;
  procedure MoveScale(X0,Y0,X1,Y1 : Number); override;
  procedure ShiftScale(DX,DY,SX,SY : Number); override;
  function CalcArray : Doubles; override;
  function SetInt(X, Y : Number) : Boolean; override;
  procedure ChgLast(X, Y : Number); override;
 end;

 TPolyGon = class(TPolyLine)
   procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function Pointed(X, Y : Number) : Boolean; override;
 end;


TPrimPix = class(TPrimRect)
  FName : String;
  constructor ReadFromFile(var fi : TextFile); override;
  function LoadImage(const FileName : String) : Boolean; virtual;
  function LoadImageSz(const FileName : String; OrigSize : Boolean) : Boolean;
   virtual; abstract;
 end;

 TPrimBitmap = class(TPrimPix)
  isBmp : Boolean;
  Pix : TPicture;
  function Compr : Boolean;
  function Transp : Boolean;
  destructor Destroy; override;
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function LoadImageSz(const FileName : String;
   OrigSize : Boolean) : Boolean; override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  procedure WriteText(var fo : TextFile); override;
  procedure WriteEps(var fo : TextFile); override;
  function EPSLevReq : Integer; override;
 end;


 TPrimJpeg = class(TPrimPix)
  Jpg : TJPEGImage;
  RawData : record L : Integer; P : Pointer; end;
  destructor Destroy; override;
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function LoadImageSz(const FileName : String;
   OrigSize : Boolean) : Boolean; override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  procedure WriteText(var fo : TextFile); override;
  procedure WriteEps(var fo : TextFile); override;
  function EPSLevReq : Integer; override;
 end;

 TPolyBezier = class(TPolyLine)
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  procedure Draw(Canvas : TCanvas; Selected : Boolean); override;
  procedure WriteEps(var fo : TextFile); override;
 end;

 TPolyBezierFill = class(TPolyBezier)
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function Pointed(X, Y : Number) : Boolean; override;
 end;

 TCurve1 = class(TPolyBezier)
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function CalcArray : Doubles; override;
 end;

 TFillCurve1 = class(TCurve1)
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function Pointed(X, Y : Number) : Boolean; override;
 end;

 TCurve2 = class(TPolyBezier)
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function CalcArray : Doubles; override;
 end;

 TFillCurve2 = class(TCurve2)
  procedure DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind); override;
  function Pointed(X, Y : Number) : Boolean; override;
 end;



 function PrimDist(X1, Y1, X2, Y2 : Number) : Double; overload;
 function PrimDist(P1, P2 : TFPoint) : Double; overload;
 function RoundDoubles(D : array of Double) : TPoints;
 function FPoint(X,Y : Number) : TFPoint;
 function PolySeg(P : TPoints; Beg,Len : integer) : TPoints;


 function GrPrimName2Ref(const PName : String) : TGrPrimRef;

implementation


type
 bytes4 = array[0..3] of byte;

 function PrimDist(X1, Y1, X2, Y2 : Number) : Double;
 begin
  PrimDist := sqrt(Sqr(X1-X2)+Sqr(Y1-Y2))
 end;

 function PrimDist(P1, P2 : TFPoint) : Double;
 begin
  PrimDist := sqrt(Sqr(P1.X-P2.X)+Sqr(P1.Y-P2.Y))
 end;

 function RoundDoubles(D : array of Double) : TPoints;
 var
  i,n : integer;
 begin
  n := Length(D) div 2;
  SetLength(Result,n);
  for i := 0 to n-1 do
   Result[i] := Point(Round(D[2*i]),Round(D[2*i+1]));
 end;

 function PolySeg(P : TPoints; Beg,Len : integer) : TPoints;
 var
  i : integer;
 begin
  SetLength(Result,Len);
  for i := 0 to Len-1 do
   Result[i] := P[Beg+i]
 end;



 function FPoint(X,Y : Number) : TFPoint;
 begin
  Result.X := X;
  Result.Y := Y;
 end;



{ TGraphPrim }
 constructor TGraphPrim.Create(X, Y, X2, Y2 : Number; PC,BC : TColor;
  PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited Create;
  DataCreate(X,Y,X2,Y2,PC,BC,PW,PS,BS,BK);
  Complete := False;
 end;

 constructor TGraphPrim.ReadFromFile(var fi : TextFile);
 var
  OX,OY,FX,FY,PW : Number;
  PC,BC,PS,BS,BK : Integer;
 begin
  inherited Create;
  readln(fi,OX,OY,FX,FY);
  readln(fi,PW,PC,BC,PS,BS);
  BK := BS div $1000;
  BS := BS mod $1000;
  DataCreate(OX,OY,FX,FY,
   TColor(PC),TColor(BC),PW,TPenStyle(PS),TBrushStyle(BS),TBrushKind(BK));
  Complete := True;
 end;


 procedure TGraphPrim.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
  PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  Origin.X := X;
  Origin.Y := Y;
  Fin.X := X2;
  Fin.Y := Y2;
  PenColor := PC;
  BrushColor := BC;
  PenWidth := PW;
  PenStyle := PS;
  BrushStyle := BS;
  BrushKind := BK;
 end;

 procedure TGraphPrim.SetBrushAttr(Canvas : TCanvas; Selected : Boolean);
 begin
  with Canvas do
  begin
   if (BrushKind = bkTransparent) {or (BrushStyle=bsSolid)} then
   begin
    Brush.Color := BrushColor;
    Brush.Style := BrushStyle;
    SetBkMode(Handle,transparent)
   end
   else
   begin
    Brush.Color := PenColor;
    Brush.Style := BrushStyle;
    SetBkColor(Handle,BrushColor);
    SetBkMode(Handle,Opaque);
   end;
  end;
 end;

 procedure TGraphPrim.SetPenAttr(Canvas : TCanvas; Selected : Boolean);
 begin
 with Canvas do
  begin
   if Selected then
    Pen.Color := clRed
   else
   Pen.Color := PenColor;
   Pen.Style := PenStyle;
   Pen.Width := Ceil(PenWidth);
  end;
 end;

 procedure TGraphPrim.Set2nd(X, Y : Number);
 begin
  Fin.X := X;
  Fin.Y := Y;
  Complete := True;
 end;

 procedure TGraphPrim.WriteText(var fo : TextFile);
 begin
   writeln(fo,PrimName);
   writeln(fo,Format(grfNum+' '+grfNum+' '+grfNum+' '+grfNum,
    [Origin.X,Origin.Y,Fin.X,Fin.Y]));
   writeln(fo,Format(grfNum+' $%x $%x %d %d',
     [PenWidth,Ord(PenColor),Ord(BrushColor),
     Ord(PenStyle),Ord(BrushStyle)+Ord(BrushKind)*$1000]));
 end;

 function TGraphPrim.PrimCaption : String;
 begin
  PrimCaption := Format(
   '%s (('+grfNum+','+grfNum+'),('+grfNum+','+grfNum+'))',
      [PrimName,Origin.X,Origin.Y,Fin.X,Fin.Y])
 end;


 function TGraphPrim.BoxPointed(X, Y : Number) : Boolean;
 begin
  BoxPointed := (X > Origin.X) and (Y > Origin.Y)
   and (X < Fin.X) and (Y < Fin.Y);
 end;

 function TGraphPrim.ElLinePointed(X, Y : Number) : Boolean;
 var
  l1,l2 : double;
 begin
  l1 := PrimDist(Origin,Fin);
  l2 := PrimDist(Origin.X,Origin.Y,X,Y)+PrimDist(Fin.X,Fin.Y,X,Y);
  ElLinePointed := (l2 - l1) <= 1 ;
 end;

 function TGraphPrim.EndPointed(X, Y : Number) : Boolean;
 begin
  EndPointed := (Sqr(X-Origin.X)+Sqr(Y-Origin.Y) < 10)
   or (Sqr(X-Fin.X)+Sqr(Y-Fin.Y) < 10)
 end;

 function TGraphPrim.SetInt(X, Y : Number) : Boolean;
 begin
  Set2nd(X,Y);
  SetInt := False;
 end;

 procedure TGraphPrim.MoveScale(X0,Y0,X1,Y1 : Number);
 begin
  Origin.X := X0;
  Origin.Y := Y0;
  Set2nd(X1,Y1);
 end;

 procedure TGraphPrim.ShiftScale(DX,DY,SX,SY : Number);
 begin
  Origin.X := DX + SX*Origin.X;
  Origin.Y := DY + SY*Origin.Y;
  Set2nd(DX + Fin.X*SX, DY + Fin.Y*SY);
 end;

 function TGraphPrim.EPSLevReq : Integer;
 begin
  EPSLevReq := 1;
 end;

 procedure TGraphPrim.ChgLast(X, Y : Number);
 begin
  Set2nd(X,Y);
 end;


{ TPrimLine }

 procedure TPrimLine.DataCreate;
 begin
  inherited;
  PrimName := 'Line';
 end;

 procedure TPrimLine.Draw(Canvas : TCanvas; Selected : Boolean);
 begin
  with Canvas do
  begin
   SetPenAttr(Canvas,Selected);
   with Origin do MoveTo(Round(X),Round(Y));
   with Fin do LineTo(Round(X),Round(Y));
  end;
 end;

 function TPrimLine.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := ElLinePointed(X,Y);
 end;


 procedure TPrimLine.WriteEps(var fo : TextFile);
 begin
  if PenStyle <> psClear then
  begin
   epsSetColor(fo,ColorToRGB(PenColor));
   epsPenWidth(fo,PenWidth);
   epsPenDash(fo,Ord(PenStyle));
   epsDrawLine(fo,Origin.X,Origin.Y,Fin.X,Fin.Y);
  end;
 end;


{ TPrimRect }

 procedure TPrimRect.DataCreate;
 begin
  inherited;
  PrimName := 'Rectangle';
 end;


 procedure TPrimRect.Draw(Canvas : TCanvas; Selected : Boolean);
 begin
  with Canvas do
  begin
   SetPenAttr(Canvas,Selected);
   SetBrushAttr(Canvas,Selected);
   {Rectangle(Origin.X,Origin.Y,Fin.X,Fin.Y);}
   {Using polygon due to win error with filling rect}
   Polygon([Point(Round(Origin.X),Round(Origin.Y)),
    Point(Round(Origin.X),Round(Fin.Y)),
    Point(Round(Fin.X),Round(Fin.Y)),
    Point(Round(Fin.X),Round(Origin.Y))])
  end;
 end;

 function TPrimRect.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := BoxPointed(X,Y);
 end;

 procedure TPrimRect.WriteEps(var fo : TextFile);
 begin
  if BrushStyle <> bsClear then
  begin
   epsSetColor(fo,ColorToRGB(BrushColor));
   if BrushStyle <> bsSolid then
   begin
    epsPenWidth(fo,1);
    epsPenDash(fo,0);
   end;
   if (BrushKind <> bkTransparent) {and (BrushStyle<>bsSolid)} then
   begin
    epsDrawRectEx(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,0);
    epsSetColor(fo,ColorToRGB(PenColor));
   end;
   epsDrawRectEx(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,ord(BrushStyle));
  end;
  if PenStyle <> psClear then
  begin
   epsSetColor(fo,ColorToRGB(PenColor));
   epsPenWidth(fo,PenWidth);
   epsPenDash(fo,Ord(PenStyle));
   epsDrawRect(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,false);
  end;
 end;

{ TPrimFilledRect }

 procedure TPrimFilledRect.DataCreate;
 begin
  inherited DataCreate(X,Y,X2,Y2,PC,PC{!},PW,PS,bsSolid,bkTransparent);
 end;


{ TPrimEllipse }
 procedure TPrimEllipse.DataCreate;
 begin
  inherited;
  PrimName := 'Ellipse';
 end;


 procedure TPrimEllipse.Draw(Canvas : TCanvas; Selected : Boolean);
 begin
  with Canvas do
  begin
   SetPenAttr(Canvas,Selected);
   SetBrushAttr(Canvas,Selected);
   Ellipse(Round(Origin.X),Round(Origin.Y),
    Round(Fin.X),Round(Fin.Y));
  end;
 end;

 function TPrimEllipse.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := BoxPointed(X,Y);
 end;

 procedure TPrimEllipse.WriteEps(var fo : TextFile);
 begin
  if BrushStyle <> bsClear then
  begin
   epsSetColor(fo,ColorToRGB(BrushColor));
   if BrushStyle <> bsSolid then
   begin
    epsPenWidth(fo,1);
    epsPenDash(fo,0);
   end;
   if (BrushKind <> bkTransparent) {and (BrushStyle<>bsSolid)} then
   begin
    epsDrawEllipse(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,0);
    epsSetColor(fo,ColorToRGB(PenColor));
   end;
   epsDrawEllipse(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,ord(BrushStyle));
  end;
  if PenStyle <> psClear then
  begin
   epsSetColor(fo,ColorToRGB(PenColor));
   epsPenWidth(fo,PenWidth);
   epsPenDash(fo,Ord(PenStyle));
   epsDrawEllipse(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,-1);
  end;
 end;


{ TPrimCircle }

  procedure TPrimCircle.Set2nd(X, Y : Number);
  var
   delta : Number;
  begin
   delta := X-Origin.X;
   if abs(Y-Origin.Y) > abs(delta)
    then delta := Y-Origin.Y;
   inherited Set2nd(Origin.X+delta,Origin.Y+delta);
  end;

{ TPrimFilledCircle }

 procedure TPrimFilledCircle.DataCreate;
 begin
  inherited DataCreate(X,Y,X2,Y2,PC,PC{!},PW,PS,bsSolid,bkTransparent);
 end;


{ TPrimText }


 constructor TPrimText.ReadFromFile(var fi : TextFile);
 var
  nf : Integer;
 begin
  inherited;
  readln(fi,Text);
  readln(fi,nf);
  FntN := epsFonts(nf);
 end;

 procedure TPrimText.DataCreate;
 begin
  inherited;
  PrimName := 'Text';
  Text := '';
  FntN := efRoman;
 end;

 procedure TPrimText.Draw(Canvas : TCanvas; Selected : Boolean);
 begin
  with Canvas do
  begin
   SetPenAttr(Canvas,Selected);
   SetBrushAttr(Canvas,Selected);
   Font := WinFonts[FntN];
   Font.Color := Pen.Color;
   Font.Size := Round(Fin.Y-Origin.Y)*3 div 4;
   {SetTextAlign(Handle,TA_BOTTOM);}
   SetBkMode(Handle,Transparent);
   TextOut(Round(Origin.X),Round(Origin.Y),Text);
   with TextExtent(Text) do
    Fin.X := Origin.X+cx;
   {
   Brush.Style := bsClear;
   Rectangle(Origin.X,Origin.Y,Fin.X,Fin.Y);
   }
  end;
 end;

 function TPrimText.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := BoxPointed(X,Y);
 end;


  procedure TPrimText.WriteText(var fo : TextFile);
  begin
   inherited;
   writeln(fo,Text);
   writeln(fo,Ord(FntN));
  end;

  procedure TPrimText.WriteEps(var fo : TextFile);
  begin
   epsSetColor(fo,ColorToRGB(PenColor));
   epsDrawString(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,Text,
    epsFonts(FntN));
  end;

  function TPrimText.PrimCaption : String;
  begin
   PrimCaption := inherited PrimCaption
    + ' "'+Text+'"'
  end;

{ TPrimRotText }


 constructor TPrimRotText.ReadFromFile(var fi : TextFile);
 var
  nf : Integer;
 begin
  inherited;
  readln(fi,Text);
  Rot := 0;
  read(fi,nf);
  if eoln(fi) then readln(fi) else readln(fi,rot);
  FntN := epsFonts(nf);
 end;

 procedure TPrimRotText.DataCreate;
 begin
  inherited;
  PrimName := 'Text';
  Text := '';
  FntN := efRoman;
  Rot := 0;
 end;

 procedure TPrimRotText.Draw(Canvas : TCanvas; Selected : Boolean);
 var
  lf: LOGFONT;
 begin
  with Canvas do
  begin
   SetPenAttr(Canvas,Selected);
   SetBrushAttr(Canvas,Selected);
   Font := WinFonts[FntN];

   {SetTextAlign(Handle,TA_BOTTOM);}
   SetBkMode(Handle,Transparent);
   Font.Color := Pen.Color;
   Font.Size := Round(Fin.Y-Origin.Y)*3 div 4;
   FillChar(lf, SizeOf(lf), 0);
   lf.lfHeight := Font.Height;
   lf.lfEscapement := Round(10 * Rot);
   lf.lfOrientation := Round(10 * Rot);
   if fsItalic in Font.Style then lf.lfItalic := 1;
   if fsBold in Font.Style then lf.lfWeight := FW_SemiBold;
   if fsUnderline in Font.Style then lf.lfUnderline := 1;
   if fsStrikeOut in Font.Style then lf.lfStrikeOut := 1;
   lf.lfCharSet := Font.Charset;
   StrCopy(lf.lfFaceName,PChar(Font.Name));
   Font.Handle := CreateFontIndirect(lf);

   TextOut(Round(Origin.X),Round(Origin.Y),Text);
   {
   with TextExtent(Text) do
   begin
    Fin.X := Origin.X+cx;
    Fin.Y := Origin.Y+cy;
   end;
   }
  end;
 end;

 function TPrimRotText.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := BoxPointed(X,Y);
 end;


 procedure TPrimRotText.WriteText(var fo : TextFile);
 begin
  inherited;
  writeln(fo,Text);
  writeln(fo,Format('%d '+grfNum,[Ord(FntN),Rot]));
 end;

 procedure TPrimRotText.WriteEps(var fo : TextFile);
 begin
  epsSetColor(fo,ColorToRGB(PenColor));
  epsDrawStringAng(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,Text,
   epsFonts(FntN),Rot);
 end;

 function TPrimRotText.PrimCaption : String;
 begin
  PrimCaption := inherited PrimCaption
   + ' "'+Text+'"'
 end;


{ TPrimArrow1 }

 procedure TPrimArrow1.DataCreate;
 begin
  inherited;
  PrimName := 'SimpleArrow';
  TickPar := 20;
 end;


 procedure TPrimArrow1.Draw(Canvas : TCanvas; Selected : Boolean);
 var
  T1,T2 : TFPoint;
 begin
  with Canvas do
  begin
   SetPenAttr(Canvas,Selected);
   with Origin do MoveTo(Round(X),Round(Y));
   with Fin do LineTo(Round(X),Round(Y));
   Pen.Style := psSolid;
   TickCoord(T1,T2);
   with T1 do MoveTo(Round(X),Round(Y));
   with Fin do LineTo(Round(X),Round(Y));
   with T2 do LineTo(Round(X),Round(Y));
  end;
 end;

 function TPrimArrow1.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := ElLinePointed(X,Y);
 end;

 procedure TPrimArrow1.WriteEps(var fo : TextFile);
 var
  T1,T2 : TFPoint;
 begin
  epsSetColor(fo,ColorToRGB(PenColor));
  epsPenWidth(fo,PenWidth);
  if PenStyle <> psClear then
  begin
   epsPenDash(fo,Ord(PenStyle));
   epsDrawLine(fo,Origin.X,Origin.Y,Fin.X,Fin.Y);
  end;
  epsPenDash(fo,0);
  TickCoord(T1,T2);
  epsDrawPath(fo,[T1.X,T1.Y,Fin.X,Fin.Y,T2.X,T2.Y],false,false);
  {
  epsDrawLine(fo,T1.X,T1.Y,Fin.X,Fin.Y);
  epsDrawLine(fo,T2.X,T2.Y,Fin.X,Fin.Y);
  }
 end;

 function TPrimArrow1.CalcTickLen : Number;
 var
  dL : double;
 begin
  dl := sqrt(sqr(Origin.X-Fin.X)+sqr(Origin.Y-Fin.Y));
  if dl > TickPar then CalcTickLen := TickPar / 4
             else CalcTickLen := dl / 5
 end;

 procedure TPrimArrow1.CalcTickCoord(Angle : Double; B,E : TFPoint;
  var T1,T2 : TFPoint);
 var
  P : TFPoint;
  c,L,phi : double;
 begin
  P.X := E.X-B.X;
  P.Y := E.Y-B.Y;
  with P do
  begin
   L := sqrt(sqr(X)+sqr(Y));
   if L = 0 then c := 0 else
    c := X/L;
  end;
  phi := arccos(c);
  if P.Y < 0 then phi := 2*Pi-phi;
  T1.X := E.X-CalcTickLen*cos(phi-Angle);
  T1.Y := E.Y-CalcTickLen*sin(phi-Angle);
  T2.X := E.X-CalcTickLen*cos(phi+Angle);
  T2.Y := E.Y-CalcTickLen*sin(phi+Angle);
 end;

 procedure TPrimArrow1.TickCoord(var T1,T2 : TFPoint);
 begin
  CalcTickCoord(Pi/8,Origin,Fin,T1,T2);
 end;


{ TPrimMult }

 procedure TPrimMult.Draw(Canvas : TCanvas; Selected : Boolean);
 begin
  with Canvas do
  begin
   SetPenAttr(Canvas,Selected);
   SetBrushAttr(Canvas,Selected);
   if Filled then
    PolyGon(RoundDoubles(CalcArray))
   else
    PolyLine(RoundDoubles(CalcArray));
  end;
 end;

 procedure TPrimMult.WriteEps(var fo : TextFile);
 begin
  if Filled and (BrushStyle <> bsClear) then
  begin
   epsSetColor(fo,ColorToRGB(BrushColor));
   if BrushStyle <> bsSolid then
   begin
    epsPenWidth(fo,1);
    epsPenDash(fo,0);
   end;
   if (BrushKind <> bkTransparent) {and (BrushStyle<>bsSolid)} then
   begin
    epsDrawPathEx(fo,CalcArray,0,true);
    epsSetColor(fo,ColorToRGB(PenColor));
   end;
   epsDrawPathEx(fo,CalcArray,ord(BrushStyle),true);
  end;
  if PenStyle <> psClear then
  begin
   epsSetColor(fo,ColorToRGB(PenColor));
   epsPenWidth(fo,PenWidth);
   epsPenDash(fo,Ord(PenStyle));
   epsDrawPath(fo,CalcArray,false,Filled);
  end;
 end;

{ TWavyLine }

 procedure TWavyLine.DataCreate;
 begin
  inherited;
  PrimName := 'WavyLine';
  APar := 12;
  Filled := False;
 end;

 function TWavyLine.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := ElLinePointed(X,Y);
 end;

 function TWavyLine.CalcArray : Doubles;
 var
  X,Y,L,dl : Double;
  n,m,i : Integer;
 begin
  L := PrimDist(Origin,Fin);
  if L = 0 then SetLength(Result,0)
  else
  begin
   X := (Fin.X - Origin.X)/L;
   Y := (Fin.Y - Origin.Y)/L;
   n := Ceil(L / APar);
   dl := L/n;
   m := 12 * n;
   SetLength(Result,2*m+2);
   for i := 0 to m do
   begin
    Result[2*i] := Origin.X+X*i*L/m+Y*sin(2*Pi*n*i/m)*dl/5;
    Result[2*i+1] := Origin.Y+Y*i*L/m-X*sin(2*Pi*n*i/m)*dl/5;
   end;
  end;
 end;

{ TPolyLine }


 constructor TPolyLine.ReadFromFile(var fi : TextFile);
 var
  i,n : Integer;
 begin
  inherited;
  readln(fi,n);
  SetLength(Data,n);
  for i := 0 to n div 2 -1 do
   Readln(fi,Data[2*i],Data[2*i+1]);
 end;

 procedure TPolyLine.WriteText(var fo : TextFile);
 var
  i : Integer;
 begin
  inherited WriteText(fo);
  writeln(fo,Length(Data));
  for i := 0 to Length(Data) div 2 - 1 do
  writeln(fo,Format(grfNum+' '+grfNum,[Data[2*i],Data[2*i+1]]));
 end;

 procedure TPolyLine.DataCreate;
 begin
  inherited;
  PrimName := 'PolyLine';
  Filled := False;
  CanDoub := False;
  SetLength(Data,4);
  Data[0] := Origin.X;
  Data[1] := Origin.Y;
  Data[2] := Fin.X;
  Data[3] := Fin.Y;
 end;

 function TPolyLine.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := EndPointed(X,Y)

  {TODO track all segments}
 end;

 procedure TPolyLine.Set2nd(X, Y : Number);
 begin
  Inherited;
  Data[High(Data)-1] := X;
  Data[High(Data)] := Y;
  if (not CanDoub) and (Length(Data) > 2)
   and (Data[High(Data)-3] = X)
   and (Data[High(Data)-2] = Y)
  then
   SetLength(Data,Length(Data)-2);
 end;

 function TPolyLine.CalcArray : Doubles;
 begin
  CalcArray := Data;
 end;

 function TPolyLine.SetInt(X, Y : Number) : Boolean;
 begin
  SetLength(Data,Length(Data)+2);
  Data[High(Data)-1] := X;
  Data[High(Data)] := Y;
  SetInt := True;
 end;

 procedure TPolyLine.MoveScale(X0,Y0,X1,Y1 : Number);
 var
  SX,SY : Number;
  i : integer;
 begin
  SX := Fin.X - Origin.X;
  if SX=0 then SX:=1 else
  SX := (X1-X0)/SX;
  SY := Fin.Y - Origin.Y;
  if SY=0 then SY:=1 else
   SY := (Y1-Y0)/SY;
  for i := 0 to Length(Data) div 2 - 1 do
  with Origin do
  begin
   Data[2*i] := X0 + SX*(Data[2*i]-X);
   Data[2*i+1] := Y0 + SY*(Data[2*i+1]-Y);
  end;

  Origin := FPoint(Data[0],Data[1]);
  Fin := FPoint(Data[Length(Data)-2],Data[Length(Data)-1]);
  {Direct assigned used, because Set2nd in inherited
   produces error for last point in Data}
  {inherited;}
 end;

 procedure TPolyLine.ShiftScale(DX,DY,SX,SY : Number);
 var
  i : integer;
 begin
  for i := 0 to Length(Data) div 2 - 1 do
  with Origin do
  begin
   Data[2*i] := DX + SX*Data[2*i];
   Data[2*i+1] := DY + SY*Data[2*i+1];
  end;

  Origin := FPoint(Data[0],Data[1]);
  Fin := FPoint(Data[Length(Data)-2],Data[Length(Data)-1]);
  {Direct assigned used again...}
  {inherited;}
 end;

 procedure TPolyLine.ChgLast(X,Y : Number);
 begin
  Fin.X := X;
  Fin.Y := Y;
  Data[High(Data)-1] := X;
  Data[High(Data)] := Y;
 end;


{ TPolyGon }

 procedure TPolyGon.DataCreate;
 begin
  inherited;
  PrimName := 'Polygon';
  Filled := True;
 end;

 function InPolygon(var Data : Doubles; X, Y : Number) : Boolean;
 var
  Reg : HRGN;
  i,n : integer;
  Points : array of Integer;
 begin
  {Pointed := EndPointed(X,Y)}
  n := Length(Data);
  SetLength(Points,n);
  for i := 0 to n-1 do
   Points[i] := Round(Data[i]);
  Reg := CreatePolygonRgn(Points[0],n div 2,ALTERNATE {WINDING});
  InPolygon := PtInRegion(Reg,Round(X),Round(Y));
  DeleteObject(Reg);
  Points := nil;
 end;

 function TPolyGon.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := InPolygon(Data,X,Y);
 end;

{ TPrimPix }

 constructor TPrimPix.ReadFromFile(var fi : TextFile);
 begin
  inherited;
  readln(fi,FName);
  if FName <> '' then LoadImageSz(FName,False);
 end;

 function TPrimPix.LoadImage(const FileName : String) : Boolean;
 begin
  LoadImageSz(FileName,True);
 end;

{ TPrimBitmap }

 procedure TPrimBitmap.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
  PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited;
  PrimName := 'Bitmap';
  FName := '';
  isBmp := true;
 end;

 destructor TPrimBitmap.Destroy;
 begin
  Pix.Free;
  inherited;
 end;


 function TPrimBitmap.LoadImageSz(const FileName : String;
  OrigSize : Boolean) : Boolean;
 var
  Ext : String;
  Meta : TMetafile;
 begin
   result := false;
   try
    Ext := UpperCase(ExtractFileExt(FileName));
    if (Ext ='.WMF') or (Ext ='.EMF')
    then
     isBmp := false;
    Pix := TPicture.Create;
    Pix.LoadFromFile(FileName);
    if OrigSize then
    begin
     Fin.X := Origin.X + Pix.Width;
     Fin.Y := Origin.Y + Pix.Height;
    end;
    FName := FileName;
    result := True;
   finally
   end;
 end;

 procedure TPrimBitmap.Draw(Canvas : TCanvas; Selected : Boolean);
 begin
  if Pix <> nil then
  begin
   if (Transp) then
   with Pix do
   begin
    Graphic.Transparent := true;
    if isBmp then
    with Bitmap do
     TransparentColor := BrushColor
   end;
   Canvas.StretchDraw(Rect(Round(Origin.X),Round(Origin.Y),
                    Round(Fin.X),Round(Fin.Y)),Pix.Graphic);
   if Selected then inherited;
  end
  else inherited;
 end;


 procedure TPrimBitmap.WriteText(var fo : TextFile);
 begin
  inherited;
  writeln(fo,FName);
 end;

 procedure ReadPixData(var PixCanvas : TCanvas;
  var P : PByteArray;  var W,H,Len : Integer);
 var
  b4 : bytes4;
  i,j,k : integer;
 begin
   Len := H*W*3;
   GetMem(P,Len);
   for i := 0 to H-1 do
    for j := 0 to W-1 do
     begin
      b4 := bytes4(PixCanvas.Pixels[j,i]);
      k := (i * W + j) * 3;
      P^[k] := b4[0];
      P^[k+1] := b4[1];
      P^[k+2] := b4[2];
     end;
 end;

 procedure ReadMonoPixData(var PixCanvas : TCanvas;
  var P : PByteArray;  var W,H,Len,W8 : Integer);
 var
  b4 : bytes4;
  i,j,k,bit : integer;
  begin
   w8 := (W+7) div 8;
   Len := H*W8;
   GetMem(P,Len);
   for i := 0 to H-1 do
   begin
    bit := 128;
    for j := 0 to W-1 do
     begin
      b4 := bytes4(PixCanvas.Pixels[j,i]);
      k := (i * W8 + (j div 8));
      if j mod 8 = 0 then
       P^[k] := $FF;
      if b4[0] = 0 then P^[k]:=P^[k] XOR bit;
      bit := bit div 2;
      if bit = 0 then bit := 128;
     end;
    end;
  end;


 procedure TPrimBitmap.WriteEps(var fo : TextFile);
 var
  P : PByteArray;
  H,W,L,w8 : integer;
  PixCanvas : TCanvas;
  NewBmp : TBitmap;
  isMono : Boolean;
 begin
  H := Pix.Height;
  W := Pix.Width;
  isMono := false;
  if isBmp then
   begin
    PixCanvas := Pix.Bitmap.Canvas;
    if not (Compr or Transp) then
     isMono := Pix.Bitmap.Monochrome;
   end
  else
  begin
    NewBmp := TBitmap.Create;
    NewBmp.Width :=  W;
    NewBmp.Height := H;
    with NewBmp do
     Canvas.StretchDraw(Rect(0,0,Width-1,Height-1),Pix.Graphic);
    PixCanvas := NewBmp.Canvas;
  end;
  if isMono then
  begin
   ReadMonoPixData(PixCanvas,P,W,H,L,W8);
  end
  else
  begin
   ReadPixData(PixCanvas,P,W,H,L);
  end;
  if not isBmp then NewBmp.Destroy;
  if isMono then
   epsMonoBitmap(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,W,H,P^)
  else
   epsBitmapEx(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,W,H,
    Transp,Compr,BrushColor,P^);
  FreeMem(P);
 end;

 function TPrimBitmap.EPSLevReq : Integer;
 begin
  if Compr or Transp
  then EPSLevReq := 3
  else EPSLevReq := 1;
 end;

 function TPrimBitmap.Compr : Boolean;
 begin
  Result := (BrushStyle=bsCross)
   or ComprAllBmp
 end;

 function TPrimBitmap.Transp : Boolean;
 begin
  Result := (PenStyle=psClear)
 end;



{ TPrimJpeg }


 procedure TPrimJpeg.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
  PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited;
  PrimName := 'Jpeg';
  FName := '';
  RawData.L := 0; RawData.P := nil;
 end;


 destructor TPrimJpeg.Destroy;
 begin
  Jpg.Free;
  with RawData do
  if P <> nil then FreeMem(P);
  inherited;
 end;


 function TPrimJpeg.LoadImageSz(const FileName : String;
  OrigSize : Boolean) : Boolean;
 var
  F : File;
 begin
   result := false;
   try
    Jpg := TJPEGImage.Create;
    Jpg.LoadFromFile(FileName);
    if OrigSize then
    begin
     Fin.X := Origin.X + Jpg.Width;
     Fin.Y := Origin.Y + Jpg.Height;
    end;
    FName := FileName;
    with RawData do
    begin
     AssignFile(F,FName);
     Reset(F,1);
     L := FileSize(F);
     GetMem(P,L);
     BlockRead(F,P^,L);
     CloseFile(F);
    end;
    result := True;
   finally
   end;
 end;

 procedure TPrimJpeg.Draw(Canvas : TCanvas; Selected : Boolean);
 begin
  if Jpg <> nil then
  begin
   Canvas.StretchDraw(Rect(Round(Origin.X),Round(Origin.Y),
                    Round(Fin.X),Round(Fin.Y)),Jpg);
   if Selected then inherited;
  end
  else inherited;
 end;


 procedure TPrimJpeg.WriteText(var fo : TextFile);
 begin
  inherited;
  writeln(fo,FName);
 end;


 procedure TPrimJpeg.WriteEps(var fo : TextFile);
 var
  H,W : integer;
 begin
  H := Jpg.Height;
  W := Jpg.Width;
  epsJPEG(fo,Origin.X,Origin.Y,Fin.X,Fin.Y,W,H,
  RawData.L,Jpg.GrayScale,RawData.P^);
 end;

 function TPrimJpeg.EPSLevReq : Integer;
 begin
  EPSLevReq := 2;
 end;


{ TPolyBezier }

 procedure TPolyBezier.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited;
  PrimName := 'PolyBezier';
  Filled := False;
 end;

 procedure DrawPartBezier(Canvas : TCanvas; Points : TPoints;
  Complete : Boolean);
 var
  i,n,len : integer;
 begin
  len := Length(Points);
  n := (len - 1) div 3 * 3 + 1;
  Canvas.PolyBezier(PolySeg(Points,0,n));

  if (not Complete) and (n < len) then
   Canvas.PolyLine(PolySeg(Points,n-1,len-n+1));
  {
  for i := n-1 to len-1 do
   Canvas.Rectangle(Points[i].X-1,Points[i].Y-1,
    Points[i].X+1,Points[i].Y+1);}
 end;

 procedure TPolyBezier.Draw(Canvas : TCanvas; Selected : Boolean);
 begin
  if (Data=nil) or (Length(Data) <= 2) then Exit;
  with Canvas do
  begin
   SetPenAttr(Canvas,Selected);
   SetBrushAttr(Canvas,Selected);
   if Filled then
    Canvas.Polygon(RoundDoubles(Bezier2Polygon(CalcArray,10)))
   else
    DrawPartBezier(Canvas,RoundDoubles(CalcArray),Complete);
  end;
 end;

 procedure TPolyBezier.WriteEps(var fo : TextFile);
 begin
  if (Data=nil) or (Length(Data) <= 2) then Exit;
  if Filled and (BrushStyle <> bsClear) then
  begin
   epsSetColor(fo,ColorToRGB(BrushColor));
   if BrushStyle <> bsSolid then
   begin
    epsPenWidth(fo,1);
    epsPenDash(fo,0);
   end;
   if (BrushKind <> bkTransparent) {and (BrushStyle<>bsSolid)} then
   begin
    epsDrawCurveEx(fo,CalcArray,0,true);
    epsSetColor(fo,ColorToRGB(PenColor));
   end;
   epsDrawCurveEx(fo,CalcArray,ord(BrushStyle),true);
  end;
  if PenStyle <> psClear then
  begin
   epsSetColor(fo,ColorToRGB(PenColor));
   epsPenWidth(fo,PenWidth);
   epsPenDash(fo,Ord(PenStyle));
   epsDrawCurve(fo,CalcArray,false,Filled);
  end;
 end;

{ TPolyBezierFill }

 procedure TPolyBezierFill.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited;
  PrimName := 'PolyBezierFill';
  Filled := True;
 end;


 function TPolyBezierFill.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := InPolygon(Data,X,Y);
 end;


{ TCurve1 }

 function GenCurve1(var Data : Doubles; Closed,Crv1eq : Boolean) : Doubles;
 var
  len,l2,i,i0,i1,im,ip : integer;
  X1,Y1,X2,Y2,X3,Y3,A,B,C,R,P : Double;
 begin
  Result := nil;
  if (Data = nil) or (Length(Data)<2) then Exit;
  P := 0.5;
  len := Length(Data) div 2;
  l2 := (len-1)*3+1;

  i0:=1; i1 := len-2;
  if Closed then
   begin i0:=0; i1 := len-1;
    if len > 2 then l2 := l2+3;
   end;
  SetLength(Result,2*l2);
  if len >2 then
  for i := i0 to i1 do
  begin
   X2 := Data[2*i];   Y2 := Data[2*i+1];
   im := i-1; ip:=i+1;
   if i=0 then im := len-1;
   if i=len-1 then ip:=0;
   X1 := Data[2*im]; Y1 := Data[2*im+1];
   X3 := Data[2*ip]; Y3 := Data[2*ip+1];
   if Crv1eq then R := 0.5 else
   begin
    A := Sqr(X2-X1)+Sqr(Y2-Y1);
    B := Sqr(X3-X2)+Sqr(Y3-Y2);
    C := Sqr(X3-X1)+Sqr(Y3-Y1);
    if C=0 then R := 0.5 else
     R := (1+(B-A)/C)/2;
   end;
   Result[6*i]:=X2; Result[6*i+1] :=Y2;
   Result[6*i+2]:=X2+P*R*(X3-X1);
    Result[6*i+3]:=Y2+P*R*(Y3-Y1);
   Result[6*im+4]:=X2+P*(R-1)*(X3-X1);
    Result[6*im+5]:=Y2+P*(R-1)*(Y3-Y1);
  end;
  if Closed then
  begin
   if len = 2 then
    begin
     Result[0] := Data[0];
     Result[1] := Data[1];
     Result[2] := (2*Data[0]+Data[2])/3;
     Result[3] := (2*Data[1]+Data[3])/3;
     Result[4] := (Data[0]+2*Data[2])/3;
     Result[5] := (Data[1]+2*Data[3])/3;
     Result[6] := Data[2];
     Result[7] := Data[3];
    end
    else
    begin
     Result[2*l2-2] := Result[0];
     Result[2*l2-1] := Result[1]
    end
  end
  else
  begin
    Result[0] := Data[0]; Result[1] := Data[1];
    Result[2*l2-2] := Data[2*len-2];
       Result[2*l2-1] := Data[2*len-1];
    if len = 2 then
    begin
     Result[2] := (2*Data[0]+Data[2])/3;
     Result[3] := (2*Data[1]+Data[3])/3;
     Result[4] := (Data[0]+2*Data[2])/3;
     Result[5] := (Data[1]+2*Data[3])/3;
    end
    else
    begin
     Result[2] := Result[4]; Result[3] := Result[5];
     Result[2*l2-4] := Result[2*l2-6];
       Result[2*l2-3] := Result[2*l2-5]
    end;
  end
 end;

 procedure TCurve1.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited;
  PrimName := 'Curve1';
 end;

 function TCurve1.CalcArray : Doubles;
 begin
  CalcArray := GenCurve1(Data,Filled,false);
 end;

{ TFillCurve1 }

 procedure TFillCurve1.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited;
  PrimName := 'FillCurve1';
  Filled := True;
 end;

 function TFillCurve1.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := InPolygon(Data,X,Y);
 end;

{TCurve2}

 procedure TCurve2.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited;
  PrimName := 'Curve2';
 end;

 function TCurve2.CalcArray : Doubles;
 begin
  CalcArray := GenCurve1(Data,Filled,true);
 end;

{ TFillCurve2 }

 procedure TFillCurve2.DataCreate(X, Y, X2, Y2 : Number; PC,BC : TColor;
   PW : Number; PS : TPenStyle; BS : TBrushStyle; BK : TBrushKind);
 begin
  inherited;
  PrimName := 'FillCurve2';
  Filled := True;
 end;

 function TFillCurve2.Pointed(X, Y : Number) : Boolean;
 begin
  Pointed := InPolygon(Data,X,Y);
 end;



{ }

 function GrPrimName2Ref(const PName : String) : TGrPrimRef;
 begin
  if PName = 'Line' then Result := TPrimLine
  else
  if PName = 'Rectangle' then Result := TPrimRect
  else
  if PName = 'Ellipse' then Result := TPrimEllipse
  else
  if PName = 'Text' then Result := TPrimRotText
  else
  if PName = 'SimpleArrow' then Result := TPrimArrow1
  else
  if PName = 'WavyLine' then Result := TWavyLine
  else
  if PName = 'PolyLine' then Result := TPolyLine
  else
  if PName = 'Polygon' then Result := TPolyGon
  else
  if PName = 'Bitmap' then Result := TPrimBitmap
  else
  if PName = 'Jpeg' then Result := TPrimJpeg
  else
  if PName = 'PolyBezier' then Result := TPolyBezier
  else
  if PName = 'PolyBezierFill' then Result := TPolyBezierFill
  else
  if PName = 'Curve1' then Result := TCurve1
  else
  if PName = 'FillCurve1' then Result := TFillCurve1
  else
  if PName = 'Curve2' then Result := TCurve2
  else
  if PName = 'FillCurve2' then Result := TFillCurve2
  else
  Result := nil;
 end;

end.
