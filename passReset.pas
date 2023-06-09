unit passReset;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Layouts,RegularExpressions
  , FMX.DialogService;

type
  TfrmPassReset = class(TForm)
    lblTextCode: TLabel;
    editCode: TEdit;
    btnCode: TButton;
    editResetPass: TEdit;
    lblResetPass: TLabel;
    btnRestablecer: TButton;
    QueryReset: TFDQuery;
    pnlEncabezado: TPanel;
    btnRegresar: TButton;
    Layout4: TLayout;
    Layout7: TLayout;
    MostPass1: TButton;
    Layout6: TLayout;
    btnInfo: TButton;
    Layout8: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblPassVery: TLabel;
    edtPassVery: TEdit;
    pnlFooter: TPanel;
    NameAutor: TLabel;
    VertScrollBox1: TVertScrollBox;
    procedure btnCodeClick(Sender: TObject);
    procedure btnRestablecerClick(Sender: TObject);

    procedure MostPass1Click(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure editResetPassChangeTracking(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRegresarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Layout7Click(Sender: TObject);
  private
    { Private declarations }
    function ValidatePassword(const Password: string): Boolean;
  public
    { Public declarations }
  end;

var
  frmPassReset: TfrmPassReset;
  validar : boolean;
  CloseOk : boolean;

implementation
uses

smsReset, uRegister, uMain;

{$R *.fmx}

procedure TfrmPassReset.btnCodeClick(Sender: TObject);
begin
  if editCode.text = IntToStr(frmSmsReset.codigo) then
  begin
    editCode.Enabled := false;
    btnCode.Enabled := false;
    lblTextCode.Enabled := false;

    Layout4.Enabled := True;
    Layout4.Visible := True;



  end
  else
  begin
  showmessage('Codigo incorrecto');

  end;



end;

procedure TfrmPassReset.btnInfoClick(Sender: TObject);
begin
  showmessage
    ('La contraseña debe de ser mayor a 8 caracteres, y debe contener lo siguiente '
    + ': una letra mayuscula, una letra minuscula, un numero y un caracter especial.');
end;

procedure TfrmPassReset.btnRegresarClick(Sender: TObject);
begin
close;
end;

procedure TfrmPassReset.btnRestablecerClick(Sender: TObject);
begin

  if (editResetPass.text <> '') and (edtPassVery.text <> '') then
  begin

    if validar = false then
    begin

      showmessage('La contraseña no cumple con los requisitos');

    end
    else
    begin
      if editResetPass.text <> edtPassVery.text then
      begin
        showmessage('La contraseña no coincide');

      end
      else
      begin

        frmMain.Query.SQL.clear;
      frmMain.Query.ExecSQL('update user set contrasena = "' + editResetPass.text +
        '" where Correo = "' + frmSmsReset.correo + '";');
      showmessage('se ha restablecido la contraseña, inicie sesion');



{$IFDEF MSWINDOWS OR MACOS}
      // Windows specific code here
      frmMain.ShowModal;
{$ELSE}
      // Android/iOS specific code here
      closeOK:= True;
      frmMain.Show;
{$ENDIF}


      end;
    end;
  end
  else
    showmessage('Asegurate de llenar todos los campos');

  frmMain.Query.close;

end;

procedure TfrmPassReset.editResetPassChangeTracking(Sender: TObject);
begin
validar := ValidatePassword(editResetPass.Text);
end;

procedure TfrmPassReset.FormClose(Sender: TObject; var Action: TCloseAction);
begin
frmMain.Show;
end;

procedure TfrmPassReset.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

// CloseQuery

var
  msg: string;

begin

  if not(CloseOk) then
  begin

    msg := '⚠ Precaución ⚠'+ sLineBreak + sLineBreak+'¿Está seguro de abandonar la recuperacion de contraseña? ';
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

procedure TfrmPassReset.FormShow(Sender: TObject);
begin
closeOk:= False;
  editCode.Enabled := True;
  btnCode.Enabled := True;
  lblTextCode.Enabled := True;
  Layout4.Enabled := false;
  Layout4.Visible := false;
  editResetPass.text := '';
  edtPassVery.text := '';
  editCode.text := '';
end;

procedure TfrmPassReset.Layout7Click(Sender: TObject);
begin

end;

//
// UPDATE employees
// SET city = 'Toronto',
// state = 'ON',
// postalcode = 'M5P 2N7'
// WHERE
// employeeid = 4;


procedure TfrmPassReset.MostPass1Click(Sender: TObject);
begin
if (editResetPass.Password) then
begin

    editResetPass.Password := false;
    edtPassVery.Password := false;
    MostPass1.text := '🙈';
  end
  else
  begin

    editResetPass.Password := True;
    edtPassVery.Password := True;
    MostPass1.text := '🐵';

  end;


end;






function TfrmpassReset.ValidatePassword(const Password: string): Boolean;

var
mayuscula : Boolean;
  longuitud: Boolean;
  minuscula: Boolean;
  numero: Boolean;
  caracter: Boolean;

begin

  var
  cMayus := 0;
  var
  cMinus := 0;
  var
  cDig := 0;
  var
  cEsp := 0;

  for var I := 0 to (Length(Password) - 1) do
  begin
    var
    c := Password.chars[I];
    case c of

      'A' .. 'Z':
        inc(cMayus);
      'a' .. 'z':
        inc(cMinus);
      '0' .. '9':
        inc(cDig);
    else
      inc(cEsp);
    end;

  end;

  if cMinus > 0 then
  begin
    Label2.TextSettings.FontColor := TAlphaColorRec.Green;
    minuscula := True;
  end
  else
  begin
    Label2.TextSettings.FontColor := TAlphaColorRec.Crimson;
    minuscula := false;
  end;

  if cMayus > 0 then
  begin
    Label1.TextSettings.FontColor := TAlphaColorRec.Green;
    mayuscula := True;
  end
  else
  begin
    Label1.TextSettings.FontColor := TAlphaColorRec.Crimson;
    mayuscula := false;
  end;

  if cEsp > 0 then
  begin
    Label4.TextSettings.FontColor := TAlphaColorRec.Green;
    caracter := True;

  end
  else
  begin
    Label4.TextSettings.FontColor := TAlphaColorRec.Crimson;
    caracter := false;
  end;

  if cDig > 0 then
  begin
    Label3.TextSettings.FontColor := TAlphaColorRec.Green;
    numero := True;
  end
  else
  begin
    Label3.TextSettings.FontColor := TAlphaColorRec.Crimson;
    numero := false;
  end;

  if Length(Password) >= 8 then
  begin
    Label5.TextSettings.FontColor := TAlphaColorRec.Green;
    longuitud := True;
  end
  else
  begin
    Label5.TextSettings.FontColor := TAlphaColorRec.Crimson;
    longuitud := false;
  end;

  if (minuscula) and (mayuscula) and (numero) and (caracter) and (longuitud)
  then
    Result := True
  else
    Result := false;

end;

end.
