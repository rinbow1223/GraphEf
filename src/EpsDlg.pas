unit EpsDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs,
  GrEps;

type
  TEPSParDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    LbEdDX: TLabeledEdit;
    LbEdDY: TLabeledEdit;
    GroupBox2: TGroupBox;
    LbEdSX: TLabeledEdit;
    LbEdSY: TLabeledEdit;
    LbEdSLinW: TLabeledEdit;
    ColorChkBx: TCheckBox;
    ClipBndChkBx: TCheckBox;
    LangLevRGr: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute : Boolean;
  end;

var
  EPSParDlg: TEPSParDlg;

implementation

{$R *.dfm}


 function TEPSParDlg.Execute : Boolean;
 begin
  Result := False;
  LBEdDX.Text := Format(epsNum,[epsDX]);
  LBEdDY.Text := Format(epsNum,[epsDY]);
  LBEdSX.Text := Format(epsNum,[epsScaleX]);
  LBEdSY.Text := Format(epsNum,[epsScaleY]);
  LBEdSLinW.Text := Format(epsNum,[epsLinWidthScale]);
  ColorChkBx.Checked := not epsGray;
  ClipBndChkBx.Checked := epsClipBounds;
  LangLevRGr.ItemIndex := epsLangLevel - 1;
  if ShowModal = mrOK then
  begin
   try
    epsDX := StrToFloat(LBEdDX.Text);
    epsDY := StrToFloat(LBEdDY.Text);
    epsScaleX := StrToFloat(LBEdSX.Text);
    epsScaleY := StrToFloat(LBEdSY.Text);
    epsLinWidthScale := StrToFloat(LBEdSLinW.Text);
    epsGray := not ColorChkBx.Checked;
    epsClipBounds := ClipBndChkBx.Checked;
    epsLangLevel := LangLevRGr.ItemIndex + 1;
    Result := True;
   except
   on E: EConvertError do
      ShowMessage(E.ClassName + ^J + E.Message);
   end
  end;

 end;


end.
