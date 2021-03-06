; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
; Download Inno Setup from: http://www.jrsoftware.org/isdl.php to build this setup file

; !!!NOTICE FOR ANYONE TRYING TO BUILD THE SETUP!!!
;
;
; Anywhere below, when building the setup, make sure to replace "C:\Projects\aion_ui" with the actual path where you clone the `aion_ui`
;
; Before using the signtool, Windows 10 SDK should be installed - https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk
; A certificate needs to be added in Tools->Configure Sign Tools->Add
; Name=signtool
; Value="C:\Program Files (x86)\Windows Kits\10\App Certification Kit\signtool.exe"  sign /f "C:\Projects\aion_ui\scripts\cert.pfx" /p superaion /t http://timestamp.verisign.com/scripts/timstamp.dll $f
;
; If the current certificate has expired, a new one can be issued from powershell:
; > New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname aion.network -type CodeSigning
; > certutil -exportPFX ${cert_hash_from_above_certificate} ${path_to_new_pfx_file}


#define MyAppName "AionWallet"
#define MyAppVersion "1.1"
#define MyAppPublisher "Aion"
#define MyAppURL "http://www.aion.network/"
#define MyAppExeName "AionWallet.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{49D782D3-43D8-47F2-914A-3DEA3D29CB62}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf64}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=AionWalletSetup
Compression=lzma
SolidCompression=yes
;PrivilegesRequired=admin
SignTool=signtool $p

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Projects\aion_ui\pack\aion_ui\*"; DestDir: "{app}"; Excludes: "cert.pfx, unzip.exe, cygwin1.dll, cygbz2-1.dll, cygintl-8.dll, wget.exe, tar.exe, Bat_To_Exe.exe, *.zip, "; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "C:\Projects\aion_ui\pack\aion_ui\unzip.exe"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "C:\Projects\aion_ui\pack\aion_ui\cert.pfx"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "C:\Projects\aion_ui\pack\aion_ui\*.dll"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "C:\Projects\aion_ui\pack\aion_ui\wget.exe"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "C:\Projects\aion_ui\pack\aion_ui\native\win\ledger\Aion-HID.zip"; DestDir: "{tmp}";  Flags: deleteafterinstall
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "certutil.exe"; Parameters: "-addstore ""TrustedPublisher"" {tmp}\cert.pfx"; StatusMsg: "Adding trusted publisher..."
Filename: "{tmp}\unzip.exe"; Parameters: "-n ""{tmp}\Aion-HID.zip"" ""-d"" ""{app}\native\win\ledger"""; Flags: runhidden; StatusMsg: "Installing additional resources..."
Filename: "{tmp}\wget.exe"; Parameters: """-nc"" ""--no-check-certificate"" ""--no-cookies"" ""--header"" ""Cookie: oraclelicense=accept-securebackup-cookie"" ""http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jre-10.0.2_windows-x64_bin.exe""  ""-O"" ""{tmp}\java.exe"""; Flags: runhidden; StatusMsg: "Downloading dependenceies..."
Filename: "{tmp}\java.exe"; StatusMsg: "Installing dependencies..."
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "PowerShell.exe"; Parameters: "-windowstyle hidden -Command ""& {{robocopy /MIR '{app}\lib' '{app}\native'}""";

[UninstallDelete]
Type: filesandordirs; Name:"{app}"