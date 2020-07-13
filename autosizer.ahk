#persistent
setbatchlines -1

; scheduled task
detecthiddenwindows on
setworkingdir %a_scriptdir%

menu, tray, tip, AutoSizer
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit

sysget, n, monitorworkarea
global nbottom

filename = apps.txt
attribute := fileexist(filename)
if !attribute
{
  fileappend,, %filename%
  msgbox,, AutoSizer, A text file named 'apps' was automatically created.`nAdd one executable filename per line.
  run explorer %filename%
}

gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
msgnumber := dllcall("RegisterWindowMessage", str, "shellhook")
onmessage(msgnumber, "shellmessage")
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winget, process, processname, ahk_id %lparam%
    exe := substr(process, 1, strlen(process)-4)
    if exe = StartMenuExperienceHost
    {
      detecthiddenwindows off
      exit
    }
    global filename
    winwait ahk_id %lparam%
    fileread, contents, %filename%
    apps := strreplace(contents, "`r`n", ",")
    if exe in %apps%
    {
      wingetclass class
      if exe = explorer
      {
        if class != cabinetwclass
          exit
      }
      if exe = notepad++
      {
        if class = nppprogressclass
          exit
      }
      winmove,,, -7, 0, a_screenwidth+14, nbottom+7
      winmaximize
    }
  }
}

edit:
run explorer %filename%
return

exit:
exitapp