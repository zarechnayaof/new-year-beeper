unit uMain;

interface

uses
  Winapi.Windows,
//  Winapi.Messages,
  System.SysUtils,
//  System.Variants,
  System.Classes,
//  Vcl.Graphics,
//  Vcl.Controls,
  Vcl.Forms,
//  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Controls, Vcl.Buttons, Vcl.Menus;

type
  TUpdateEvent = procedure(Sender: TObject; const LabelText: string) of object;
  TTask = class;


  TForm1 = class(TForm)
    Label1: TLabel;
    lblTime: TLabel;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    btnExit: TMenuItem;
    SpeedButton1: TSpeedButton;
    menuBtnPlay: TMenuItem;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayIcon1Click(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    t: TTask;
    procedure upDate(Sender: TObject; const LabelText: string);
  public
    { Public declarations }
  end;


  TTask = class(TThread)
  private
    FLock: Boolean;   // блокировка создается в начале проигрывания и освобождается вконце
    FLastHour: Word;  // Час когда играла мелодия последний раз
    next: TTime;
    dt: TDate;
    FUpdater: TUpdateEvent;
    function Time2Text(const tm: TTime): string;
    function getTimeLeftString: string;
    procedure PlaySound();
  protected
    procedure Execute(); override;
  public
    constructor Create(const PlayOnStart: boolean = False); overload;
    destructor Destroy(); override;
    procedure Play();
  published
    property TimeLeftStr: string read getTimeLeftString;
    property OnUpdate: TUpdateEvent read FUpdater write FUpdater;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
  t:= TTask.Create;
  t.OnUpdate:= upDate;
end;
procedure TForm1.FormDestroy(Sender: TObject);
begin
  t.Free;
end;
procedure TForm1.FormShow(Sender: TObject);
begin
  Label1.Caption:= 'До следующего проигрывания:';
  lblTime.Caption:= '';
end;
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  t.Play;
end;
procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Application.Restore;
end;
procedure TForm1.btnExitClick(Sender: TObject);
begin
  if Self.Showing then Self.Hide;
  Self.Close;
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Self.Showing then begin
    Action:= caNone;
    Application.Minimize;
  end else begin
    Action:= caFree;
  end;
end;
procedure TForm1.upDate(Sender: TObject; const LabelText: string);
begin
  lblTime.Caption:= LabelText;
end;



{ TTask }
constructor TTask.Create(const PlayOnStart: boolean);
var
  h, m, s, ms: Word;
begin
  inherited Create(False);
  Priority:= tpLowest;
  FreeOnTerminate:= False;

  if not PlayOnStart then begin
    DecodeTime(Now, h, m, s, ms);
    FLastHour:= h;
  end;
end;
destructor TTask.Destroy;
begin
  Self.Terminate;
  inherited;
end;
procedure TTask.Execute;
var
  h, m, s, ms: Word;
begin
  while not Terminated do begin
    sleep(500);

    dt:= Date();
    DecodeTime(Now, h, m, s, ms);
    if h < 23 then begin
      next:= EncodeTime(h+1, 0, 0, 0);
    end else begin
      next:= EncodeTime(0, 0, 0, 0);
      dt:= dt + 1;
    end;
    if Assigned(FUpdater) then FUpdater(Self, getTimeLeftString);

    if FLastHour = h then Continue;

    FLastHour:= h;
    PlaySound;
    FLastHour:= h;
  end;
end;
function TTask.getTimeLeftString: string;
begin
  Result:= Time2Text((dt + next) - Now);
end;
procedure TTask.Play;
begin
  FLastHour:= 25;    // Полюбому не равно текущему часу, а значит поток запустит проигрыш
end;
procedure TTask.PlaySound;

  procedure refrenSolo();
  begin
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Sleep(300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Sleep(300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(783, 300);
    Winapi.Windows.Beep(523, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(261, 300);
    Winapi.Windows.Beep(293, 300);
    Winapi.Windows.Beep(329, 300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(698, 300);
    Sleep(300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Sleep(300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(587, 300);
    Sleep(300);
    Winapi.Windows.Beep(783, 300);
    Sleep(300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Sleep(300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Sleep(300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(783, 300);
    Winapi.Windows.Beep(523, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(261, 300);
    Winapi.Windows.Beep(293, 300);
    Winapi.Windows.Beep(329, 300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(698, 300);
    Sleep(300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(659, 300);
    Sleep(300);
    Winapi.Windows.Beep(783, 300);
    Winapi.Windows.Beep(783, 300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(523, 600);
    Sleep(600);
  end;
  procedure coupleSolo();
  begin
    Winapi.Windows.Beep(392, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(523, 300);
    Winapi.Windows.Beep(392, 600);
    Sleep(300 * 2);
    Winapi.Windows.Beep(392, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(523, 300);
    Winapi.Windows.Beep(440, 600);
    Sleep(600);
    Winapi.Windows.Beep(440, 300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(783, 600);
    Sleep(600);
    Winapi.Windows.Beep(880, 300);
    Winapi.Windows.Beep(880, 300);
    Winapi.Windows.Beep(783, 300);
    Winapi.Windows.Beep(622, 300);
    Winapi.Windows.Beep(659, 600);
    Sleep(600);
    Winapi.Windows.Beep(392, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(523, 300);
    Winapi.Windows.Beep(392, 600);
    Sleep(600);
    Winapi.Windows.Beep(392, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(523, 300);
    Winapi.Windows.Beep(440, 600);
    Sleep(600);
    Winapi.Windows.Beep(440, 300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(659, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(783, 600);
    Sleep(600);
    Winapi.Windows.Beep(880, 300);
    Winapi.Windows.Beep(783, 300);
    Winapi.Windows.Beep(698, 300);
    Winapi.Windows.Beep(587, 300);
    Winapi.Windows.Beep(523, 600);
    Sleep(600);
  end;

begin
  if FLock then Exit;
  if Assigned(FUpdater) then FUpdater(Self, 'Сейчас играет');
  FLock:= true;
  try
    refrenSolo();
    coupleSolo();
  finally
    FLock:= False;
  end;
end;
function TTask.Time2Text(const tm: TTime): string;
var
  h, min, sec, ms: Word;
  minStr, secStr: string;
begin
  DecodeTime(tm, h, min, sec, ms);

  if Trunc(min) in [11, 12, 13, 14] then begin
    minStr:= Format('%d минут', [min]);
  end else if (Trunc(min) mod 10) = 1 then begin
    minStr:= Format('%d минута', [min]);
  end else if (Trunc(min) mod 10) in [2, 3, 4] then begin
    minStr:= Format('%d минуты', [min]);
  end else minStr:= Format('%d минут', [min]);

  if Trunc(sec) in [11, 12, 13, 14] then begin
    secStr:= Format('%d секунд', [sec]);
  end else if (Trunc(sec) mod 10) = 1 then begin
    secStr:= Format('%d секунда', [sec]);
  end else if (Trunc(sec) mod 10) in [2, 3, 4] then begin
    secStr:= Format('%d секунды', [sec]);
  end else secStr:= Format('%d секунд', [sec]);

  Result:= Format('%s %s', [minStr, secStr]);
end;


end.
