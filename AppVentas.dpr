program AppVentas;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain},
  uRegister in 'uRegister.pas' {frmRegister},
  smsReset in 'smsReset.pas' {frmSmsReset},
  passReset in 'passReset.pas' {frmPassReset},
  vkbdhelper in '..\OnKeyboardShow\OnKeyboardShow\vkbdhelper.pas',
  Menu in 'Menu.pas' {frmMenu};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.CreateForm(TfrmSmsReset, frmSmsReset);
  Application.CreateForm(TfrmPassReset, frmPassReset);
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.Run;
end.

