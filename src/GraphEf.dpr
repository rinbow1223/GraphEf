program GraphEf;

uses
  Forms,
  GraphWin in 'GraphWin.pas' {DrawForm},
  BMPDlg in 'BMPDlg.pas' {NewBMPForm},
  GrfPrim in 'GrfPrim.pas',
  GrList in 'GrList.pas' {ListForm},
  GrEPS in 'GrEPS.pas',
  EpsDlg in 'EpsDlg.pas' {EPSParDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDrawForm, DrawForm);
  Application.CreateForm(TNewBMPForm, NewBMPForm);
  Application.CreateForm(TListForm, ListForm);
  Application.CreateForm(TEPSParDlg, EPSParDlg);
  Application.Run;
end.
