unit Menu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.DialogService, FMX.TabControl,
  FMX.Edit, FMX.ListBox, FMX.DateTimeCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Notification;

type
  TfrmMenu = class(TForm)
    pnlEncabezado: TPanel;
    btnClose: TButton;
    VertScrollBox1: TVertScrollBox;
    pnlFooter: TPanel;
    NameAutor: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    StyleBook1: TStyleBook;
    Panel1: TPanel;
    Panel3: TPanel;
    ListBox1: TListBox;
    Label2: TLabel;
    Edit1: TEdit;
    Panel2: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    DateEdit1: TDateEdit;
    Button1: TButton;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Button2: TButton;
    Layout1: TLayout;
    Label14: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    Label15: TLabel;
    Layout4: TLayout;
    Label16: TLabel;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Button3: TButton;
    Label17: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    ListBox2: TListBox;
    NotificationCenter1: TNotificationCenter;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TabItem1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Layout3Resize(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TabItem2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMenu: TfrmMenu;
  closeOK: boolean;

implementation
{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}


uses
uRegister, uMain;

procedure TfrmMenu.btnCloseClick(Sender: TObject);
begin
close;
end;

procedure TfrmMenu.Button1Click(Sender: TObject);
var Notification: TNotification;
var DateText: string;
begin
  if ((Edit1.Text<>'')and(Edit2.text<>'')and(Edit3.Text<>'')and(Edit4.Text<>'')and(Edit5.Text<>'')) then
  begin

  DateText := DateToStr(DateEdit1.Date);

  frmMain.Query.SQL.clear;
  frmMain.Query.ExecSQL('INSERT INTO venta(estatus,rfc,idproducto,precio,cantidad) VALUES("'+edit3.Text+'","'+Edit1.Text+'","'+Edit2.Text+'","'+Edit5.Text+'","'+Edit4.Text+' ");');

  //Muestra notificacion local cuando se crea una venta
  Notification := NotificationCenter1.CreateNotification;
    try
      Notification.Name := 'MyNotification';
      Notification.AlertBody := '¡Venta realizada correctamente!';
      Notification.EnableSound := True;
      NotificationCenter1.ScheduleNotification(Notification);
    finally
      Notification.Free;
    end;
  end
  else
    ShowMessage('¡Llena todos los campos!')
end;

procedure TfrmMenu.Button2Click(Sender: TObject);
begin
if ((Edit6.Text<>'')and(Edit7.Text<>'')and(Edit8.Text<>'')and(Edit9.Text<>'')and(Edit10.Text<>'')) then
  begin
    frmMain.Query.SQL.clear;
    frmMain.Query.ExecSQL('INSERT INTO cliente(nombre,rfc,direccion) VALUES("'+edit7.Text+'","'+edit6.Text+'","'+edit8.Text+' ");');
    frmMain.Query.ExecSQL('INSERT INTO cliente_num(numero,observaciones,rfc) VALUES("'+edit9.Text+'","'+edit10.Text+'","'+edit6.Text+'");');
  end
  else
    ShowMessage('¡Llena todos los campos!')
end;

procedure TfrmMenu.Button3Click(Sender: TObject);
begin
  if ((Edit11.Text <> '') and (Edit12.Text <> '') and (Edit13.Text <> '')) then
  begin
    frmMain.Query.SQL.clear;
    frmMain.Query.ExecSQL('INSERT INTO producto(idproducto,descripcion,precio) VALUES("'+edit11.Text+'","'+edit13.Text+'","'+edit12.Text+' ");');
  end
  else
     ShowMessage('Llena todos los campos')
end;

procedure TfrmMenu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  msg: string;

begin

  if not(CloseOk) then
  begin

    msg := '⚠ Precaución ⚠'+ sLineBreak + sLineBreak+'¿Desea salir al login? ';
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

procedure TfrmMenu.Layout3Resize(Sender: TObject);
begin
Layout2.Size.Width := frmMenu.Width/2;
Layout3.Size.Width := frmMenu.Width/2;
end;



procedure TfrmMenu.TabItem1Click(Sender: TObject);
begin
  ListBox1.Items.Clear;

  frmMain.Query.Active := false;
  frmMain.Query.SQL.Text := 'Select rfc , nombre , direccion FROM cliente';
  frmMain.Query.Active := True;
  While not frmMain.Query.Eof do
  begin
    ListBox1.Items.Add('RFC: '+frmMain.Query.Fields[0].Text + '  |Nombre: ' + frmMain.Query.Fields[1].Text  + '  |Dicc: ' + frmMain.Query.Fields[2].Text);
    frmMain.Query.Next;
  end;

end;

procedure TfrmMenu.TabItem2Click(Sender: TObject);
begin
begin

  ListBox2.Items.Clear;

  frmMain.Query.Active := false;
  frmMain.Query.SQL.Text := 'Select idproducto , descripcion , precio FROM producto';
  frmMain.Query.Active := True;
  While not frmMain.Query.Eof do
  begin
    ListBox2.Items.Add('idproducto: '+frmMain.Query.Fields[0].Text + '  |descripcion: ' + frmMain.Query.Fields[1].Text  + '  |precio: ' + frmMain.Query.Fields[2].Text);
    frmMain.Query.Next;
  end;

end;
end;

end.
