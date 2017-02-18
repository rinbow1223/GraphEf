unit GrEPS;

interface
 uses SysUtils, Math, zlib;

type
 epsFonts = (efRoman,efRomanItal,efRomanBold,efSymbol,efHelvetica,
  efHelvItal,efHelvBold,efCourier,efCourierItal,efCourierBold);

 Doubles = array of Double;

const
 epsNum = '%.5g ';

var
 epsCreator : String = 'GrEPS';
 epsDX : double = 0;
 epsDY : double = 0;
 epsScaleX : double = 1;
 epsScaleY : double = 1;
 epsLinWidthScale : double = 1;
 WinMaxX : Double = 0;
 WinMaxY : Double = 0;
 epsNCircSeg : Integer = 40;
 epsCircAsPath : Boolean = False;
 epsGray : Boolean = true;
 epsDashes : array[0..4] of
  string = ('','8 4','3 4','8 4 3 4','8 4 3 4 3 4');
 epsFontName : array [epsFonts] of String
  = ('/Times-Roman','/Times-Italic','/Times-Bold',
   '/Symbol','/Helvetica',
   '/Helvetica-Oblique','/Helvetica-Bold',
   '/Courier','/Courier-Oblique','/Courier-Bold');
 epsDashProc : string = 'newpath '+epsNum+epsNum+'moveto %d {'
  +epsNum+epsNum+'rlineto '+epsNum+epsNum+
  'rmoveto } repeat stroke';
 DashStep : Integer = 8;
 AdjustDash : Boolean = True;
 epsLangLevel : Integer = 1;
 MaxEpsLangLev : Integer = 3;
 epsClipBounds : Boolean = False;

 procedure epsWriteHeader(var fo : TextFile;
  X,Y : Double; const Title : String);
 procedure epsWriteFooter(var fo : TextFile);
 function RGB2Gray(R,G,B : double) : double;
 procedure epsSetColor(var fo : TextFile; RGB : Longint);
 {use ColorToRGB }
 procedure epsPenWidth(var fo : TextFile; PW : Double);
 procedure epsPenDash(var fo : TextFile; ND : Integer);

 procedure epsDrawLine(var fo : TextFile; X1,Y1,X2,Y2 : Double);
 procedure epsDrawRect(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Fill : Boolean);
 procedure epsDrawEllipse(var fo : TextFile; X1,Y1,X2,Y2 : Double;
    Brush : Integer);
 procedure epsDrawEllipsePath(var fo : TextFile; X1,Y1,X2,Y2 : Double;
    Brush : Integer);
 procedure epsDrawEll(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Fill,Close : Boolean);
 procedure epsDrawEllEx(var fo : TextFile; X1,Y1,X2,Y2 : Double;
    Brush : Integer);
 function epsString(const S : String) : String;
 procedure epsDrawString(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  const S : String; fn : epsFonts);
 procedure epsDrawStringAng(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  const S : String; fn : epsFonts; Ang : Double);
 procedure epsDrawPath(var fo : TextFile;
  Path : array of Double; Fill,Close : Boolean);
 procedure PathBounds(const Pts : array of Double; var X1,Y1,X2,Y2 : Double);
 procedure epsDrawPathEx(var fo : TextFile;
  const Path : array of Double; Brush : Integer;
  Close : Boolean);
 procedure epsDrawRectEx(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Brush : Integer);
 procedure epsGrayBitmap(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; C321 : Boolean; var PicArray);
 procedure epsColorBitmap(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; var PicArray);
 procedure epsBitmap(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; var PicArray);
 procedure epsJPEG(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height,Len : Integer; GrayScale : Boolean; var PicArray);
 procedure epsMonoBitmap(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; var PicArray);
 procedure epsDrawCurve(var fo : TextFile;
  Path : array of Double; Fill,Close : Boolean);
 procedure epsDrawCurveEx(var fo : TextFile;
  const Path : array of Double; Brush : Integer;
  Close : Boolean);
 procedure epsBMPX(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height,Len : Integer; GrayScale,Transp,Compress : Boolean;
  MaskColor : longword; var PicArray);
 procedure epsBitmapEx(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; Transp,Compress : Boolean;
  MaskColor : longword; var PicArray);

 function Bezier2Polygon(D : array of Double; N : Integer) : Doubles;

 procedure epsClipRect(var fo : TextFile; X1,Y1,X2,Y2 : Double);


implementation

 function epsX(X : Double) : Double;
 begin
  epsX := epsDX+epsScaleX*X
 end;

 function epsY(Y : Double) : Double;
 begin
  epsY := (epsDY+epsScaleY*(WinMaxY-Y));
 end;



 procedure epsWriteHeader(var fo : TextFile;
  X,Y : Double; const Title : String);
 begin
  WinMaxX := X;
  WinMaxY := Y;
  if epsLangLevel = 1 then
   writeln(fo,'%!PS-Adobe-2.0 EPSF-2.0')
  else
   writeln(fo,'%!PS-Adobe-3.0 EPSF-3.0');
  if Title <> '' then
   writeln(fo,'%%Title: ',Title);
  writeln(fo,'%%Creator: ',epsCreator);
  if epsLangLevel > 1 then
    writeln(fo,'%%LanguageLevel: ',epsLangLevel);
  writeln(fo,'%%BoundingBox: ',Trunc(epsDX),' ',Trunc(epsDY),' ',
   Ceil(epsDX+X*epsScaleX),' ',Ceil(epsDY+Y*epsScaleY));
  writeln(fo,'%%EndComments');
  writeln(fo,'gsave');
  if epsClipBounds then
   epsClipRect(fo,Trunc(epsDX),Trunc(epsDY),
     Ceil(epsDX+X*epsScaleX),Ceil(epsDY+Y*epsScaleY));
 end;

 procedure epsWriteFooter(var fo : TextFile);
 begin
  writeln(fo,'grestore');
  writeln(fo,'showpage');
  writeln(fo,'%%Trailer');
 end;

 function RGB2Gray(R,G,B : double) : double; overload;
 begin
  RGB2Gray := 0.3*R+0.59*G+0.11*B
 end;

 function RGB2Gray(R,G,B : byte) : byte; overload;
 begin
  RGB2Gray := Trunc(0.3*R+0.59*G+0.11*B)
 end;

 function DCol(C : byte) : double;
 begin
  if C <> 255 then
   DCol := C/256
  else DCol := 1
 end;

 procedure epsPrepDash(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  DashKind : integer);
 var
  X,Y,W,H,D : Double;
  nd : Integer;
 begin
  D := DashStep*epsScaleX;
  X := epsX(X1);
  Y := epsY(Y1);
  W := epsX(X2)-X;
  H := epsY(Y2)-Y;
  if W < 0 then
  begin
   W := -W; X := X-W;
  end;
  if H < 0 then
  begin
   H := -H; Y := Y-H;
  end;

  if AdjustDash then
  begin
   W := W+(X-Floor(X/D)*D);
   X := Floor(X/D)*D;
   H := H+(Y-Floor(Y/D)*D);
   if DashKind = 3 then H:=Ceil(H/D)*D;
   Y := Floor(Y/D)*D;
  end;

  case DashKind of
   1 {==} : writeln(fo,Format(epsDashProc,
    [X,Y,Ceil(H/D),W,0.,-W,D]));
   2 {||} : writeln(fo,Format(epsDashProc,
    [X,Y,Ceil(W/D),0.,H,D,-H]));
   3 {\\} : writeln(fo,Format(epsDashProc,
    [X-H,Y,Ceil((W+H)/D),H,H,-H+D,-H]));
   4 {//} : writeln(fo,Format(epsDashProc,
    [X,Y,Ceil((W+H)/D),-H,H,H+D,-H]));
  end;
 end;

 procedure epsPrepDashBrush(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Brush : integer);
 begin
   case Brush of
    2 : epsPrepDash(fo,X1,Y1,X2,Y2,1);
    3 : epsPrepDash(fo,X1,Y1,X2,Y2,2);
    4 : epsPrepDash(fo,X1,Y1,X2,Y2,4);
    5 : epsPrepDash(fo,X1,Y1,X2,Y2,3);
    6 : begin
         epsPrepDash(fo,X1,Y1,X2,Y2,1);
         epsPrepDash(fo,X1,Y1,X2,Y2,2);
        end;
    7 : begin
         epsPrepDash(fo,X1,Y1,X2,Y2,3);
         epsPrepDash(fo,X1,Y1,X2,Y2,4);
        end;
   end;
 end;

 procedure SetMinMax(Val : Double; var Mn,Mx : Double);
 begin
  if Val < Mn then Mn := Val
   else if Val > Mx then Mx := Val;
 end;

 procedure PathBounds(const Pts : array of Double; var X1,Y1,X2,Y2 : Double);
 var
  i : integer;
 begin
  for i := 0 to Length(Pts) div 2 - 1 do
  if i = 0 then
  begin
   X1 := Pts[0]; Y1 := Pts[1];
   X2 := X1; Y2 := Y1;
  end
  else
  begin
   SetMinMax(Pts[2*i],X1,X2);
   SetMinMax(Pts[2*i+1],Y1,Y2);
  end;
 end;

 procedure epsSetColor(var fo : TextFile; RGB : Longint);
 var
  Col : array[0..3] of byte absolute RGB;
 begin
  if epsGray then
   writeln(fo,Format(epsNum+'setgray',
    [RGB2Gray(DCol(Col[0]),DCol(Col[1]),DCol(Col[2]))]))
  else
   writeln(fo,Format(epsNum+epsNum+epsNum+'setrgbcolor',
    [DCol(Col[0]),DCol(Col[1]),DCol(Col[2])]))

 end;

 procedure epsPenWidth(var fo : TextFile; PW : Double);
 begin
  writeln(fo,Format(epsNum+'setlinewidth',
   [PW*epsLinWidthScale]))
 end;

 procedure epsPenDash(var fo : TextFile; ND : Integer);
 begin
  ND := Min(Max(ND,0),4);
  writeln(fo,'[',epsDashes[ND],'] 0 setdash');
 end;


 procedure epsDrawLine(var fo : TextFile; X1,Y1,X2,Y2 : Double);
 begin
  writeln(fo,Format('newpath '+epsNum+epsNum+
   'moveto '+epsNum+epsNum+'lineto stroke',
   [epsX(X1),epsY(Y1),epsX(X2),epsY(Y2)]))
 end;

 procedure epsDrawRect(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Fill : Boolean);
 begin
  epsDrawPath(fo,[X1,Y1,X1,Y2,X2,Y2,X2,Y1],Fill,True);
 end;

 procedure epsDrawRectEx(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Brush : Integer);
 begin
  epsDrawPathEx(fo,[X1,Y1,X1,Y2,X2,Y2,X2,Y1],Brush,True);
 end;

 procedure epsNewPath(var fo : TextFile; Path : array of Double);
  var
  i : integer;
 begin
  write(fo,'newpath ');
  for i := 0 to Length(Path) div 2 - 1 do
  begin
   write(fo,Format(epsNum+epsNum,
    [epsX(Path[2*i]),epsY(Path[2*i+1])]));
   if i = 0 then writeln(fo,'moveto')
            else writeln(fo,'lineto')
  end;
 end;

 procedure epsClipRect(var fo : TextFile; X1,Y1,X2,Y2 : Double);
 begin
  epsNewPath(fo,[X1,Y1,X1,Y2,X2,Y2,X2,Y1]);
  writeln(fo,'clip')
 end;

 procedure epsDrawPath(var fo : TextFile;
  Path : array of Double; Fill,Close : Boolean);
 begin
  epsNewPath(fo,Path);
  if Close then
   if not Fill then writeln(fo,'closepath');
  if Fill then
   if Close then writeln(fo,'fill') else
          else writeln(fo,'stroke');
 end;

 procedure epsDrawPathEx(var fo : TextFile;
  const Path : array of Double; Brush : Integer;
  Close : Boolean);
 var
  X1,Y1,X2,Y2 : Double;
 begin
  if Brush <= 1 then
   epsDrawPath(fo,Path,Brush=0,Close)
  else
  begin
   writeln(fo,'gsave');
   epsDrawPath(fo,Path,true,false);
   writeln(fo,'clip');
   PathBounds(Path,X1,Y1,X2,Y2);
   epsPrepDashBrush(fo,X1,Y1,X2,Y2,Brush);
   writeln(fo,'grestore');
  end;
 end;

 procedure epsDrawEll(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Fill,Close : Boolean);
 var
  DX,DY,R,Sy,CX,CY,CX0,CY0 : Double;
  IsCirc : Boolean;
 const
  ErrS = 0.001;
 begin
  CX := EpsX((X1 + X2) / 2);
  CY := EpsY((Y1 + Y2) / 2);
  CX0 := CX;
  CY0 := CY;
  DX := Abs(epsScaleX*(X2 - X1));
  DY := Abs(epsScaleY*(Y2 - Y1));
  Sy := DY / DX;
  R := DX / 2;
  IsCirc := (Abs(Sy-1) < ErrS);
  writeln(fo,'newpath');
  if not IsCirc then
  begin
   CX0 := 0; CY0 := 0;
   writeln(fo,Format(epsNum+epsNum+'translate',[CX,CY]));
   writeln(fo,Format('1 '+epsNum+'scale',[Sy]));
  end;
  writeln(fo,Format(epsNum+epsNum+epsNum+'0 360 arc',[CX0,CY0,R]));
  if not IsCirc then
  begin
   writeln(fo,Format('1 '+epsNum+'scale',[1/Sy]));
   writeln(fo,Format(epsNum+epsNum+'translate',[-CX,-CY]));
  end;
  if Close then
   if not Fill then writeln(fo,'closepath');
  if Fill then
   if Close then writeln(fo,'fill') else
          else writeln(fo,'stroke');
 end;

 procedure epsDrawEllEx(var fo : TextFile; X1,Y1,X2,Y2 : Double;
    Brush : Integer);
 begin
  writeln(fo,'gsave');
  if Brush <= 1 then
   epsDrawEll(fo,X1,Y1,X2,Y2,Brush=0,true)
  else
  begin
   epsDrawEll(fo,X1,Y1,X2,Y2,true,false);
   writeln(fo,'clip');
   epsPrepDashBrush(fo,X1,Y1,X2,Y2,Brush);
  end;
  writeln(fo,'grestore');
 end;

 procedure epsDrawEllipse(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Brush : Integer);
 begin
  if epsCircAsPath then
   epsDrawEllipsePath(fo,X1,Y1,X2,Y2,Brush)
  else
   epsDrawEllEx(fo,X1,Y1,X2,Y2,Brush);

 end;


 procedure epsDrawEllipsePath(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Brush : Integer);
 var
  i : integer;
  Xc,Yc,Xs,Ys,Xd,Yd : Double;
  DPoints : Doubles;
 begin
  Xc := (X1+X2)/2;
  Yc := (Y1+Y2)/2;
  Xs := (X1-X2)/2;
  Ys := (Y1-Y2)/2;
  SetLength(DPoints,2*epsNCircSeg);
  for i := 0 to epsNCircSeg-1 do
  begin
   DPoints[2*i]:= Xc+Xs*sin(2*Pi*i/epsNCircSeg);
   DPoints[2*i+1]:= Yc+Ys*cos(2*Pi*i/epsNCircSeg);
  end;
  epsDrawPathEx(fo,DPoints,Brush,True);
  DPoints := nil;
 end;

 function OctNum(num,dig : integer) : String;
 var
  i : integer;
 begin
  Result := '';
  for i := 1 to dig do
  begin
   Result := chr(num mod 8 + ord('0'))+Result;
   num := num div 8;
  end
 end;

 function epsString(const S : String) : String;
 var
  i : integer;
 begin
  Result := '';
  for i := 1 to length(S) do
   case S[i] of
    #0 .. #31,
    #128 .. #255 : Result:=Result+'\'+OctNum(ord(S[i]),3);
    '\' : Result:=Result+'\\';
    '(' : Result:=Result+'\(';
    ')' : Result:=Result+'\)';
   else
    result := Result+S[i]
  end;
 end;

 procedure epsDrawString(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  const S : String; fn : epsFonts);
 begin
  Writeln(fo,Format(epsFontName[fn]+' findfont '+epsNum
   +'scalefont setfont',[epsX(Y2)-epsX(Y1)]));
  Writeln(fo,Format(epsNum+epsNum+'moveto',
   [epsX(X1),epsY(Y2)]));
  Writeln(fo,'('+epsString(S)+') show');
 end;

 procedure epsDrawStringAng(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  const S : String; fn : epsFonts; Ang : Double);
 begin
  if Ang <> 0 then
  begin
   Writeln(fo,'gsave');
  end;
  Writeln(fo,Format(epsFontName[fn]+' findfont '+epsNum
   +'scalefont setfont',[epsX(Y2)-epsX(Y1)]));
  Writeln(fo,Format(epsNum+epsNum+'moveto',
   [epsX(X1+sin(Ang*Pi/180)*(Y2-Y1)),
    epsY(Y1+cos(Ang*Pi/180)*(Y2-Y1))]));
  if Ang <> 0 then
  begin
   Writeln(fo,Format('%g rotate',[Ang]));
  end;
  Writeln(fo,'('+epsString(S)+') show');
  if Ang <> 0 then
  begin
   Writeln(fo,'grestore');
  end
 end;

procedure HexBtArray(var fo : TextFile; L,W : Integer; var Bytes);
var
 B : array[0..MaxInt-1] of byte absolute Bytes;
 i,j : integer;
begin
 for i := 0 to L-1 do
 begin
  for j := 0 to W-1 do
  write(fo,IntToHex(B[i*W+j],2));
  Writeln(fo);
 end;
end;

procedure HexBtArrayL(var fo : TextFile; L : Integer; var Bytes);
var
 B : array[0..MaxInt-1] of byte absolute Bytes;
 i,j : integer;
const
 RowLen = 36;
begin
 for i := 0 to L-1 do
 begin
  write(fo,IntToHex(B[i],2));
  if (i mod RowLen = RowLen-1) or (i=L-1)
  then Writeln(fo);
 end;
end;

procedure HexBt321Array(var fo : TextFile; L,W : Integer; var Bytes);
var
 B : array[0..MaxInt-1] of byte absolute Bytes;
 i,j : integer;
begin
 for i := 0 to L-1 do
 begin
  for j := 0 to W-1 do
  write(fo,IntToHex(RGB2Gray(B[3*(i*W+j)],B[3*(i*W+j)+1],B[3*(i*W+j)+2]),2));
  Writeln(fo);
 end;
end;


procedure epsGrayBitmap(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; C321 : Boolean; var PicArray);
begin
 writeln(fo,'gsave');
 writeln(fo,Format('/picstr %d string def',[width]));
 writeln(fo,Format(epsNum+epsNum+'translate',
  [epsX(X1),epsY(Y2)]));
 writeln(fo,Format(epsNum+epsNum+'scale',
  [epsScaleX*(X2-X1),epsScaleY*(Y2-Y1)]));
 writeln(fo,Format('%d %d %d',[width,height,8]));
 writeln(fo,Format('[%d 0 0 %d 0 %d]',[width,-height,height]));
 writeln(fo,'{currentfile picstr readhexstring pop}');
 writeln(fo,'image');
 if C321 then HexBt321Array(fo,height,width,PicArray)
         else HexBtArray(fo,height,width,PicArray);
 writeln(fo,'grestore');
end;

procedure epsBitmap(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; var PicArray);
begin
 if epsGray then epsGrayBitmap(fo,X1,Y1,X2,Y2,Width,Height,true,PicArray)
            else epsColorBitmap(fo,X1,Y1,X2,Y2,Width,Height,PicArray)
end;

procedure epsColorBitmap(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; var PicArray);
begin
 writeln(fo,'gsave');
 writeln(fo,Format('/picstr %d string def',[3*width]));
 writeln(fo,Format(epsNum+epsNum+'translate',
  [epsX(X1),epsY(Y2)]));
 writeln(fo,Format(epsNum+epsNum+'scale',
  [epsScaleX*(X2-X1),epsScaleY*(Y2-Y1)]));
 writeln(fo,Format('%d %d %d',[width,height,8]));
 writeln(fo,Format('[%d 0 0 %d 0 %d]',[width,-height,height]));
 writeln(fo,'{currentfile picstr readhexstring pop}');
 writeln(fo,'false 3');
 writeln(fo,'colorimage');
 HexBtArray(fo,3*height,width,PicArray);
 writeln(fo,'grestore');
end;



 procedure epsJPEG(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height,Len : Integer; GrayScale : Boolean; var PicArray);
 begin
  writeln(fo,'gsave');
  writeln(fo,Format(epsNum+epsNum+'translate',
   [epsX(X1),epsY(Y2)]));
  writeln(fo,Format(epsNum+epsNum+'scale',
   [epsScaleX*(X2-X1),epsScaleY*(Y2-Y1)]));
  if not GrayScale then
   writeln(fo,'/DeviceRGB setcolorspace')
  else
   writeln(fo,'/DeviceGray setcolorspace');
  writeln(fo,'<<');
  writeln(fo,'   /ImageType 1');
  writeln(fo,
      Format('   /Width %d',[Width]));
  writeln(fo,
      Format('   /Height %d',[Height]));
  writeln(fo,
      Format('   /ImageMatrix [%d 0 0 %d 0 %d]',
      [width,-height,height]));
  if not GrayScale then
   writeln(fo,'   /Decode [ 0 1 0 1 0 1 ]')
  else
   writeln(fo,'   /Decode [ 0 1 ]');
  writeln(fo,'   /BitsPerComponent 8');
  writeln(fo,'   /DataSource currentfile');
  writeln(fo,'      /ASCIIHexDecode filter');
  writeln(fo,'      /DCTDecode filter');
  writeln(fo,'>>');
  writeln(fo,'image');
  HexBtArrayL(fo,Len,PicArray);
  writeln(fo,'grestore');
end;

procedure epsMonoBitmap(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; var PicArray);
var
 w8 : integer;
begin
 w8 := (width+7) div 8;
 writeln(fo,'gsave');
 writeln(fo,Format('/picstr %d string def',[w8]));
 writeln(fo,Format(epsNum+epsNum+'translate',
  [epsX(X1),epsY(Y2)]));
 writeln(fo,Format(epsNum+epsNum+'scale',
  [epsScaleX*(X2-X1),epsScaleY*(Y2-Y1)]));
 writeln(fo,Format('%d %d %d',[width,height,1]));
 writeln(fo,Format('[%d 0 0 %d 0 %d]',[width,-height,height]));
 writeln(fo,'{currentfile picstr readhexstring pop}');
 writeln(fo,'image');
 HexBtArray(fo,height,w8,PicArray);
 writeln(fo,'grestore');
end;

procedure epsDrawCurve(var fo : TextFile;
  Path : array of Double; Fill,Close : Boolean);
 var
  i,j : integer;
 begin
  write(fo,'newpath ');
  write(fo,Format(epsNum+epsNum,
    [epsX(Path[0]),epsY(Path[1])]));
  writeln(fo,'moveto');
  for i := 0 to (Length(Path)-2) div 6 - 1 do
  begin
   for j := 0 to 2 do
    write(fo,Format(epsNum+epsNum,
     [epsX(Path[6*i+2*j+2]),epsY(Path[6*i+2*j+3])]));
   writeln(fo,'curveto')
  end;
  if Close then
   if not Fill then writeln(fo,'closepath');
  if Fill then
   if Close then writeln(fo,'fill') else
          else writeln(fo,'stroke');
 end;

 procedure epsDrawCurveEx(var fo : TextFile;
  const Path : array of Double; Brush : Integer;
  Close : Boolean);
 var
  X1,Y1,X2,Y2 : Double;
 begin
  if Brush <= 1 then
   epsDrawCurve(fo,Path,Brush=0,Close)
  else
  begin
   writeln(fo,'gsave');
   epsDrawCurve(fo,Path,true,false);
   writeln(fo,'clip');
   PathBounds(Path,X1,Y1,X2,Y2);
   epsPrepDashBrush(fo,X1,Y1,X2,Y2,Brush);
   writeln(fo,'grestore');
  end;
 end;

 function Bezier2Polygon(D : array of Double; N : Integer) : Doubles;
 var
  i,j,k,l,l2 : integer;
  t : double;
 begin
  l := length(D) div 2;
  k := (l-1) div 3;
  l := k * 3 + 1;
  l2 := k*N+1;
  SetLength(Result,2*l2);
  for i := 0 to k-1 do
   for j := 0 to N do
   begin
    t := 1 - j / N;
    Result[2*(i*N+j)] := D[6*i]*t*t*t+D[6*i+2]*3*t*t*(1-t)
      +D[6*i+4]*3*t*(1-t)*(1-t)+D[6*i+6]*(1-t)*(1-t)*(1-t);
    Result[2*(i*N+j)+1] := D[6*i+1]*t*t*t+D[6*i+3]*3*t*t*(1-t)
      +D[6*i+5]*3*t*(1-t)*(1-t)+D[6*i+7]*(1-t)*(1-t)*(1-t);
   end;
 end;

 procedure epsBMPX(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height,Len : Integer; GrayScale,Transp,Compress : Boolean;
  MaskColor : longword; var PicArray);
 begin
  writeln(fo,'gsave');
  writeln(fo,Format(epsNum+epsNum+'translate',
   [epsX(X1),epsY(Y2)]));
  writeln(fo,Format(epsNum+epsNum+'scale',
   [epsScaleX*(X2-X1),epsScaleY*(Y2-Y1)]));
  if not GrayScale then
   writeln(fo,'/DeviceRGB setcolorspace')
  else
   writeln(fo,'/DeviceGray setcolorspace');
  writeln(fo,'<<');
  if not Transp then
   writeln(fo,'   /ImageType 1')
  else
  begin
   writeln(fo,'   /ImageType 4');
   write(fo,'   /MaskColor [');
   if GrayScale then
    write(fo,MaskColor mod 256)
   else
    write(fo,MaskColor mod $100,' ',
     MaskColor div $100 mod $100,' ',
     MaskColor div $10000 mod $100);
    writeln(fo,']')
  end;
  writeln(fo,
      Format('   /Width %d',[Width]));
  writeln(fo,
      Format('   /Height %d',[Height]));
  writeln(fo,
      Format('   /ImageMatrix [%d 0 0 %d 0 %d]',
      [width,-height,height]));
  if not GrayScale then
   writeln(fo,'   /Decode [ 0 1 0 1 0 1 ]')
  else
   writeln(fo,'   /Decode [ 0 1 ]');
  writeln(fo,'   /BitsPerComponent 8');
  writeln(fo,'   /DataSource currentfile');
  writeln(fo,'      /ASCIIHexDecode filter');
  if Compress then
   writeln(fo,'      /FlateDecode filter');
  writeln(fo,'>>');
  writeln(fo,'image');
  HexBtArrayL(fo,Len,PicArray);
  writeln(fo,'grestore');
 end;

 procedure epsBitmapEx(var fo : TextFile; X1,Y1,X2,Y2 : Double;
  Width,Height : Integer; Transp,Compress : Boolean;
  MaskColor : longword; var PicArray);
 type
  ByteArray = array[0..MaxInt-1] of byte;
 var
  B : ByteArray absolute PicArray;
  P1 : ^ByteArray;
  P : Pointer;
  i,Len,l1 : integer;
 begin
  Len := Width*Height;

  if not (Transp or Compress) then
   epsBitmap(fo,X1,Y1,X2,Y2,Width,Height,PicArray)
  else
  begin
   if epsGray then
   begin
    GetMem(P1,Len);
    for i := 0 to Len-1 do
    P1^[i] := RGB2Gray(B[3*i],B[3*i+1],B[3*i+2]);
   end
   else P1 := @PicArray;
   if not epsGray then Len := Len*3;
   l1 := Len;
   if Compress then
   begin
    {$IF CompilerVersion > 19}
    ZCompress(P1,l1,P,Len);
    {$ELSE}
    CompressBuf(P1,l1,P,Len);
    {$IFEND}
    if epsGray then FreeMem(P1)
   end
   else P:=P1;
   epsBMPX(fo,X1,Y1,X2,Y2,Width,Height,Len,epsGray,
    Transp,Compress,MaskColor,P^);
   if Compress or epsGray then FreeMem(P);
  end
 end;




end.
