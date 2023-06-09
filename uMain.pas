unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Layouts, FMX.Ani;

type
  TfrmMain = class(TForm)
    btnLogin: TButton;
    btnRegister: TButton;
    lblUser: TLabel;
    lblPassword: TLabel;
    edtUser: TEdit;
    edtPassword: TEdit;
    btnClose: TButton;
    btnResetPass: TButton;
    Timer1: TTimer;
    Query: TFDQuery;
    QueryPassword: TFDQuery;
    Layout7: TLayout;
    MostPass1: TButton;
    pnlEncabezado: TPanel;
    Layout1: TLayout;
    Layout2: TLayout;
    StyleBook1: TStyleBook;
    VertScrollBox1: TVertScrollBox;
    pnlFooter: TPanel;
    NameAutor: TLabel;
    Layout3: TLayout;
    procedure btnCloseClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnResetPassClick(Sender: TObject);
    procedure Consulta(textQuery: String);
    procedure MostPass1Click(Sender: TObject);

  //  procedure emailAndpassCorret(email , pass: string ) ;
  private
    { Private declarations }
  public
    { Public declarations }
    correo: string;
  end;

var
  frmMain: TfrmMain;
  contBloqTime: Integer;    // contador de segundos siempre inicia en 0
  intentosFallidos: Integer = 1; // contador de intentos fallidos
  timeBlock: integer;            // tope de cuantos segundos se debe bloquear el boton btnLogin,
                                 // tras el maximo de intentos fallidos

implementation

uses
  uRegister, smsReset, Menu;

{$R *.fmx}

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.btnLoginClick(Sender: TObject);
begin

// hacemos una consulta para ver si existe el correo electronico
// en dado caso que no exista el correo manda un mesanje diciendo que no existe,
// si existe valida el correo junto con la contraseña de ser correcto muestra un
// mensaje de logeo con exito,  de ser lo contrario muestra contraseña incorrecta
//

 // QueryUser.Close;

 Consulta('select Correo from user where Correo = "' +
    edtUser.Text + '";');   // llamamos a la funcion para verificar si existe el usuario

  if Query.IsEmpty then
  begin // si el resultado de la consulta esta vacia...
    ShowMessage('El usuario no esta registrado'); // avisas que no se encontro
  end
  else
  begin

    Consulta('select Correo from user where (Correo = "' +
      edtUser.Text + '") and (contrasena = "' + edtPassword.Text + '");');


    if Query.IsEmpty then
    begin
      if intentosFallidos = 3 then
      begin
        btnLogin.Enabled := False;
        timeBlock := TimeBlock + 5;
        contBloqTime:= 0;
        ShowMessage(Format('Demasiados intentos espere %d segundos o restablezca contraseña',[TimeBlock]));


      end
      else
      begin
        ShowMessage('La contraseña es incorrecta');
        intentosFallidos := IntentosFallidos + 1;
      end;
    end
    else
    begin
      frmMenu.show;
      contBloqTime := 0;
      intentosFallidos := 1;
      timeBlock := 0;
      edtUser.Text:='';
      edtPassword.Text:= '';
    end;




  end;

   Query.Close;
end;

procedure TfrmMain.btnRegisterClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS OR MACOS}
  // Windows specific code here
  frmRegister.ShowModal;
{$ELSE}
  // Android/iOS specific code here
  frmRegister.Show;
{$ENDIF}
       edtUser.Text:='';
      edtPassword.Text:= '';

end;

procedure TfrmMain.btnResetPassClick(Sender: TObject);
begin

      correo := edtUser.Text;
      edtUser.Text:='';
      edtPassword.Text:= '';
      btnLogin.Enabled := true;
      timeBlock := 0;
      intentosFallidos := 1;



{$IFDEF MSWINDOWS OR MACOS}
  // Windows specific code here
  frmSmsReset.ShowModal;
{$ELSE}
  // Android/iOS specific code here
  frmSmsReset.Show;
{$ENDIF}





end;

procedure TfrmMain.Timer1Timer(Sender: TObject);

begin
  Inc(contBloqTime);
  if contBloqTime = timeBlock then
  begin
    btnLogin.Enabled := true;
  end;
end;


// ======================

// esta funcion hace una consulta a la base de datos para verificar que existe un usuario

procedure tfrmMain.Consulta(textQuery: string);
begin

  Query.SQL.clear;
  Query.SQL.Text := textQuery;
  Query.open;

end;




procedure TfrmMain.MostPass1Click(Sender: TObject);
begin
if (edtPassword.Password) then
begin

    edtPassword.Password := False;
    MostPass1.text := '🙈';
  end
  else
  begin

    edtPassword.Password := True;
    MostPass1.text := '🐵';

  end;
end;

end.
