program NYSound;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title:= 'Новогоднее настроение';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
