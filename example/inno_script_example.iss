#define MyAppName "example pos"
#define MyAppVersion "1.5"
#define MyAppPublisher "example Inc."
#define MyAppURL "https://www.example.tn/"
#define MyAppExeName "pos.exe"

[Setup]
AppId={{***********-****-****-****-****}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\mpos
DisableProgramGroupPage=yes
OutputDir=.\installer
OutputBaseFilename=mysetup
SetupIconFile=D:\a\example_flutter\example_flutter\example\assets\icon\ico.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\a\example_flutter\example_flutter\example\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\a\example_flutter\example_flutter\example\build\windows\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\a\example_flutter\example_flutter\example\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
