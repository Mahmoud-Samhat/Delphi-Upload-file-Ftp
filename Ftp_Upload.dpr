program Ftp_Upload;
uses
  Forms,
  P_Main in 'P_Main.pas' {F_Main},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.Title := 'Upload files using FTP';
  Application.CreateForm(TF_Main, F_Main);
  Application.Run;
end.
