# Force using 64 bits powershell
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
Write-Host warning "changing from 32bit to 64bit powershell"
$powershell=join-path $PSHOME.tolower().replace("syswow64","sysnative").replace("system32","sysnative") powershell.exe
if ($myInvocation.Line) {
&"$powershell" -NonInteractive -NoProfile -ExecutionPolicy Bypass $myInvocation.Line
} else {
&"$powershell" -NonInteractive -NoProfile -ExecutionPolicy Bypass -file "$($myInvocation.InvocationName)" $args
}
exit $lastexitcode
}

# Ensure IE is not asking to restore session or go to home page
$ie_autorecover = 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Recovery\'
New-Item -Path $ie_autorecover -force
Set-ItemProperty -Path $ie_autorecover -Name AutoRecover -Value 2 -ErrorAction SilentlyContinue

# Open IE
Stop-Process -Name iexplore -Force -ErrorAction SilentlyContinue;
$ieProcess = Start-Process -Passthru -FilePath "$env:PROGRAMFILES\Internet Explorer\iexplore.exe";
Start-Sleep 20; 
Stop-Process -Name iexplore -Force -ErrorAction SilentlyContinue;
if (Test-Path "${env:PROGRAMFILES(X86)}\Internet Explorer\iexplore.exe") {
$ieProcess32 = Start-Process -Passthru -FilePath "${env:PROGRAMFILES(X86)}\Internet Explorer\iexplore.exe";
Start-Sleep 20; 
Stop-Process -Name iexplore -Force -ErrorAction SilentlyContinue;
}

# Delete this file
#$CurrentScriptFullPathName = $MyInvocation.MyCommand.Definition
#Remove-Item $CurrentScriptFullPathName
exit 0;