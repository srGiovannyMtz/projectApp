unit uRegister;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Layouts, FMX.Colors, FMX.Objects, RegularExpressions , FMX.DialogService;

type
  TfrmRegister = class(TForm)
    lblApellidoP: TLabel;
    lblNumero: TLabel;
    lblCorreo: TLabel;
    lblPassword: TLabel;
    edtName: TEdit;
    edtApellidoP: TEdit;
    edtNum: TEdit;
    edtCorreo: TEdit;
    edtPassword: TEdit;
    edtApellidoM: TEdit;
    btnRegresar: TButton;
    lblName: TLabel;
    lblApellidoM: TLabel;
    db: TFDConnection;
    tblUser: TFDTable;
    pnlEncabezado: TPanel;
    StyleBook1: TStyleBook;
    layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
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
    btnSave: TButton;
    pnlFooter: TPanel;
    NameAutor: TLabel;
    VertScrollBox2: TVertScrollBox;
    procedure btnRegresarClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    procedure FormResize(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure MostPass1Click(Sender: TObject);
    procedure edtPasswordChangeTracking(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);



  private
    { Private declarations }
    function ValidatePassword(const Password: string): Boolean;
  public
    { Public declarations }

  end;

var
  frmRegister: TfrmRegister;
  dbFileName: String;
  validar: boolean;
  closeOK:Boolean;

implementation

{$R *.fmx}

uses

  System.IOUtils, uMain; // Para hacer uso de TPath



procedure TfrmRegister.btnInfoClick(Sender: TObject);
begin
ShowMessage('La contraseña debe de ser mayor a 8 caracteres, y debe contener lo siguiente '+
': una letra mayuscula, una letra minuscula, un numero y un caracter especial.');
end;



procedure TfrmRegister.btnRegresarClick(Sender: TObject);
begin
  close;
end;





procedure TfrmRegister.btnSaveClick(Sender: TObject);
begin

  frmMain.Consulta('select Correo from user where Correo = "' +
    edtCorreo.Text + '";');

  if (edtName.Text <> '') and (edtApellidoP.Text <> '') and
    (edtApellidoM.Text <> '') and (edtPassword.Text <> '') and
    (edtCorreo.Text <> '') and (edtPassVery.Text <> '') and (edtNum.Text <> '')
  then
  begin

    if not frmMain.Query.isEmpty then
    begin
      ShowMessage('El usuario no se encuentra disponible');
    end
    else
    begin
      if validar = false then
      begin

        ShowMessage('La contraseña no cumple con los requisitos');

      end
      else
      begin
        if edtPassword.Text <> edtPassVery.Text then
        begin
          ShowMessage('La contraseña no coincide');

        end
        else
        if length(edtNum.Text) = 10 then

        begin
          try

            tblUser.insert;
            tblUser.FieldByName('Nombres').value := edtName.Text;
            tblUser.FieldByName('apellidoP').value := edtApellidoP.Text;
            tblUser.FieldByName('apellidoM').value := edtApellidoM.Text;
            tblUser.FieldByName('numero').value := edtNum.Text;
            tblUser.FieldByName('Correo').value := edtCorreo.Text;
            tblUser.FieldByName('contrasena').value := edtPassword.Text;
            tblUser.post;
            ShowMessage('Su registro fue un exito, ahora inicie sesion');

            edtName.Text := '';
            edtApellidoP.Text := '';
            edtApellidoM.Text := '';
            edtNum.Text := '';
            edtCorreo.Text := '';
            edtPassword.Text := '';
            edtPassVery.Text := '';

            closeOK := True;

            close;

          except
            on E: EDatabaseError do
            begin
              ShowMessage('El nombre de usuario no se encuentra disponible');
              tblUser.Cancel
            end;

          end;
        end
        else
        showMessage('Errror en el numero telefonico, Asegurece que sea un numero existente')

      end;
    end;
  end
  else
    ShowMessage('Asegurese de llenar todos los campos');

  frmMain.Query.close;
end;



procedure TfrmRegister.edtPasswordChangeTracking(Sender: TObject);

begin
validar := ValidatePassword(edtPassword.Text);

end;


procedure TfrmRegister.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

// CloseQuery

var
  msg: string;

begin

  if not(CloseOk) then
  begin

    msg := '⚠ Precaución ⚠'+ sLineBreak + sLineBreak+'¿Está seguro de abandonar el registro, los datos proporcionados no se guardaran? ';
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

procedure TfrmRegister.FormCreate(Sender: TObject);
begin

  // ubicacion de la bd
{$IF DEFINED(MSWINDOWS)}
  // windows
  dbFileName := 'C:\Users\Giova\Documents\Embarcadero\Studio\Projects\appDeLoggeo\dbLogeo.db';
{$ELSE}
  // Android, iOS, Mac
  dbFileName := TPath.Combine(TPath.GetDocumentsPath, 'dbLogeo.db');
{$ENDIF}
  db.Params.Database := dbFileName;
      db.Connected := true;
      tblUser.Active := true;
end;


procedure TfrmRegister.FormResize(Sender: TObject);
begin
Layout2.Size.Width := frmRegister.Width/2;
Layout3.Size.Width := frmRegister.Width/2;

end;

procedure TfrmRegister.FormShow(Sender: TObject);
begin
closeOk:= False;
end;

procedure TfrmRegister.MostPass1Click(Sender: TObject);
begin


if (edtPassword.Password) then
begin

    edtPassword.Password := False;
    MostPass1.text := '🙈';
          edtPassVery.Password := False;;
  end
  else
  begin

    edtPassword.Password := True;
    MostPass1.text := '🐵';
        edtPassVery.Password := True;

  end;





end;


function TfrmRegister.ValidatePassword(const Password: string): Boolean;
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
