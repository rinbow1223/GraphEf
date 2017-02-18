unit GrList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TListForm = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    GrListBox: TListBox;
    Panel2: TPanel;
    DelSpBtn: TSpeedButton;
    BackSpBtn: TSpeedButton;
    FrontSpBtn: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure GrListBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DelSpBtnClick(Sender: TObject);
    procedure BackSpBtnClick(Sender: TObject);
    procedure FrontSpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LastSelection : Integer;
    procedure ClearList;
  end;

var
  ListForm: TListForm;

implementation

{$R *.dfm}

 uses GraphWin;

procedure TListForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caHide;
 DrawForm.List1.Checked := False;
end;

procedure TListForm.FormDestroy(Sender: TObject);
begin
 ClearList;
end;

procedure TListForm.GrListBoxClick(Sender: TObject);
begin
 with GrListBox do
 begin
  if ItemIndex = LastSelection
  then ItemIndex := -1;
  LastSelection := ItemIndex;
 end;
 DrawForm.EdPaintBoxPaint(Sender);
end;

procedure TListForm.FormCreate(Sender: TObject);
begin
 LastSelection := -1;
end;

procedure TListForm.DelSpBtnClick(Sender: TObject);
begin
 with GrListBox do
  if ItemIndex <> -1 then
  begin
   Items.Objects[ItemIndex].Free;
   DeleteSelected;
   DrawForm.EdPaintBoxPaint(Sender);
  end;

end;

procedure TListForm.BackSpBtnClick(Sender: TObject);
begin
 with GrListBox do
  if ItemIndex <> -1 then
  begin
   Items.Move(ItemIndex,0);
   DrawForm.EdPaintBoxPaint(Sender);
  end;
end;

procedure TListForm.FrontSpBtnClick(Sender: TObject);
begin
with GrListBox do
  if ItemIndex <> -1 then
  begin
   Items.Move(ItemIndex,Count-1);
   DrawForm.EdPaintBoxPaint(Sender);
  end;
end;

procedure TListForm.ClearList;
var
 i : integer;
begin
 with GrListBox do
 begin
  for i := 0 to Count-1 do
   Items.Objects[i].Free;
  Clear;
 end
end;


end.
