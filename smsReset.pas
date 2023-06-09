unit smsReset;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Math, FMX.DialogService

{$IFDEF Android}
  /// Helpers for Android implementations by FMX.
    , FMX.Helpers.Android
  // Java Native Interface permite a programas
  // ejecutados en la JVM interactue con otros lenguajes.
    , Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net,
  Androidapi.JNI.JavaTypes, Androidapi.Helpers
  // Obtiene datos de telefonia del dispositivo
    , Androidapi.JNI.Telephony, FMX.Layouts;
{$ELSE}
    ;
{$ENDIF}

type
  TfrmSmsReset = class(TForm)
    txtResetInst: TText;
    edtCorreoReset: TEdit;
    CheckBox1: TCheckBox;
    lblCorreoReset: TLabel;
    QueryCorreoValidar: TFDQuery;
    QueryValidarNum: TFDQuery;
    NumReset: TLabel;
    edtNumReset: TEdit;
    btnSendCode: TButton;
    pnlEncabezado: TPanel;
    btnRegresar: TButton;
    pnlFooter: TPanel;
    NameAutor: TLabel;
    VertScrollBox1: TVertScrollBox;

    procedure SendSMS(target, message: string);
    procedure CheckBox1Change(Sender: TObject);
    procedure btnSendCodeClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnRegresarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    codigo: integer;
    MessageSms: string;
    correo: string;
    CloseOk: Boolean;

  end;

var
  frmSmsReset: TfrmSmsReset;

implementation

uses
  uMain, uRegister, passReset;

{$R *.fmx}

procedure TfrmSmsReset.btnRegresarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmSmsReset.btnSendCodeClick(Sender: TObject);

begin
  // hacemos una consulta para ver si existe el correo electronico
  // en dado caso que no exista el correo manda un mesanje diciendo que no existe,
  // si existe valida el correo junto con la contraseña de ser correcto muestra un
  // mensaje de logeo con exito,  de ser lo contrario muestra contraseña incorrecta
  //

  frmMain.Query.SQL.clear;
  frmMain.Query.SQL.Text := 'select Correo from user where Correo = "' +
    edtCorreoReset.Text + '";';
  frmMain.Query.open;

  if frmMain.Query.IsEmpty then
  begin // si el resultado de la consulta esta vacia...
    ShowMessage('El usuario no esta registrado'); // avisas que no se encontro
  end
  else
  begin
    frmMain.Query.SQL.clear;
    frmMain.Query.SQL.Text := 'select Correo from user where (Correo = "' +
      edtCorreoReset.Text + '") and (numero = "' + edtNumReset.Text + '");';
    frmMain.Query.open;

    if frmMain.Query.IsEmpty then
    begin
      ShowMessage('El numero poroporcionado no se encuentra vinvulado a la cuenta');
    end
    else
    begin
      codigo := RandomRange(10000, 99999);
      MessageSms := 'su codigo de recuperacion es: ' + IntToStr(codigo);
      SendSMS(edtNumReset.Text, MessageSms);
      correo := edtCorreoReset.Text;

      edtCorreoReset.Text := '';
      edtNumReset.Text := '';

{$IFDEF MSWINDOWS OR MACOS}
      // Windows specific code here
      frmPassReset.ShowModal;
{$ELSE}
      // Android/iOS specific code here
      closeOk:= True;
      frmPassReset.Show;
{$IFEND}
    end;
  end;
  frmMain.Query.close;
end;

procedure TfrmSmsReset.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.IsChecked then
  begin
    edtCorreoReset.Enabled := True;
  end
  else
    edtCorreoReset.Enabled := false;

end;



procedure TfrmSmsReset.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
// CloseQuery

var
  msg: string;

begin

  if not(CloseOk) then
  begin

    msg := '⚠ Precaución ⚠'+ sLineBreak + sLineBreak+'¿Está seguro de cancelar la recuperacion de contraseña? ';
    TDialogService.MessageDialog(msg // mensaje del dialogo
      , TMsgDlgType.mtConfirmation // tipo de dialogo
      , [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo] // botones
      , TMsgDlgBtn.mbNo // default button
      , 0 // help context
      ,
      procedure(const AResult: TModalResult)
      begin
        case AResult of

          mrYES:
            begin

              CloseOk := True;
              close;

{$IFDEF ANDROID}
{$ENDIF}
            end;
          mrNO:
            begin

{$IFDEF ANDROID}
              CloseOk := false;

{$ENDIF}
            end;
        end;

      end);
  end;
  CanClose := CloseOk;
end;

procedure TfrmSmsReset.FormShow(Sender: TObject);
begin

  CloseOk := false;
  edtCorreoReset.Text := frmMain.correo;
  edtCorreoReset.Enabled := false;
              CheckBox1.IsChecked := false;
end;

procedure TfrmSmsReset.SendSMS(target, message: string);
var
  smsManager: JSmsManager; // declarar administrador de mensajes
  smsTo: JString; // variable destinatario del SMS
begin
  try
    // inicializar administrador de mensajes
    smsManager := TJSmsManager.JavaClass.getDefault;
    // convertir target a tipo Jstring tipo de dato usado por JNI
    smsTo := StringToJString(target);
    // pasar parametros a administrador para enviar mensaje
    smsManager.sendTextMessage(smsTo, nil, StringToJString(message), nil, nil);
    ShowMessage('Mensaje de recupercacion enviado');
  except
    on E: Exception do
      ShowMessage(E.ToString);
  end;
end;

end.
