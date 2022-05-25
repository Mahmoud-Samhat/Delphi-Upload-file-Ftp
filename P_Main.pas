unit P_Main;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, ComCtrls, idUri, IdExplicitTLSClientServerBase, IdFTP, idFTPCommon,
  Vcl.ExtCtrls, Vcl.ToolWin, Vcl.BaseImageCollection, Vcl.ImageCollection,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList;
type
  TF_Main = class(TForm)
    OpenDialog1: TOpenDialog;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    Edit4: TEdit;
    Label8: TLabel;
    Edit3: TEdit;
    Label10: TLabel;
    Label9: TLabel;
    Edit2: TEdit;
    Edit1: TEdit;
    Label7: TLabel;
    Label1: TLabel;
    IdFTP1: TIdFTP;
    IL_ToolBar: TVirtualImageList;
    IC_ToolBar: TImageCollection;
    IL_File: TImageList;
    IL_Masks: TImageList;
    BoxSecureMode: TPanel;
    ToolBar: TToolBar;
    BtnNew: TToolButton;
    BtnSeparator1: TToolButton;
    BtnUp: TToolButton;
    BtnSeparator2: TToolButton;
    BtnMasks: TToolButton;
    BtnSeparator3: TToolButton;
    BtnExecute: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    BtnCustomization: TToolButton;
    ToolButton4: TToolButton;
    Panel1: TPanel;
    ProgressBar2: TProgressBar;
    Bevel1: TBevel;
    ToolButton1: TToolButton;
    ToolButton5: TToolButton;
    procedure IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure BtnExecuteClick(Sender: TObject);
    procedure BtnMasksClick(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnCustomizationClick(Sender: TObject);
  private
    fDownloadBytes: Int64;
  public
    { Public declarations }
  end;
var
  F_Main: TF_Main;
implementation
{$R *.dfm}
procedure TF_Main.BtnCustomizationClick(Sender: TObject);
begin
  if IdFTP1.Connected then
    IdFTP1.Disconnect;

  Close;
end;

procedure TF_Main.BtnExecuteClick(Sender: TObject);
begin
  IdFTP1.Host := Edit1.Text;
  IdFTP1.Username := Edit2.Text;
  IdFTP1.Password := Edit3.Text;
  IdFTP1.Connect;
  if Edit4.Text <> '' then
    IdFTP1.ChangeDir(Edit4.Text);
end;

procedure TF_Main.BtnMasksClick(Sender: TObject);
begin
  if IdFTP1.Connected then
    IdFTP1.Disconnect;
end;

procedure TF_Main.BtnNewClick(Sender: TObject);
begin
  // Choose file to upload
  if OpenDialog1.Execute then
  begin
    Label1.Caption := OpenDialog1.FileName;
  end;
end;

procedure TF_Main.BtnUpClick(Sender: TObject);
var
  URI: TidUri;
begin
  if IdFTP1.Connected then
  begin
    Memo1.Clear;
    URI := TidUri.Create(OpenDialog1.FileName); // Get file name
    IdFTP1.TransferType := ftBinary;
    IdFTP1.Put(OpenDialog1.FileName, URI.Document); // Upload file
    URI.Free; // Free Uri component
  end
  else
    ShowMessage('Not connected');

end;

procedure TF_Main.IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  Memo1.Lines.Add(AStatusText); // Status of upload
end;
procedure TF_Main.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  tempbar: TProgressBar;
begin
  Memo1.Lines.Add('Uploading... ' + IntToStr(Integer(AWorkMode)) +
    IntToStr(AWorkCount));
  tempbar := ProgressBar2;
  if AWorkMode = wmRead then
    tempbar := ProgressBar2;
  tempbar.Position := AWorkCount;
  Application.ProcessMessages;
end;
procedure TF_Main.IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
var
  tempbar: TProgressBar;
  aMax: Integer;
begin
  tempbar := ProgressBar2;
  aMax := AWorkCountMax;
  if AWorkMode = wmRead then
  begin
    tempbar := ProgressBar2;
    aMax := fDownloadBytes;
  end;
  tempbar.Position := 0;
  tempbar.Max := aMax;
end;
procedure TF_Main.IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
var
  tempbar: TProgressBar;
begin
  tempbar := ProgressBar2;
  if AWorkMode = wmRead then
    tempbar := ProgressBar2;
  tempbar.Position := tempbar.Max;
end;
end.
