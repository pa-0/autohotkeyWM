#persistent
setbatchlines -1
menu, tray, icon, images/autosizer.png
menu, tray, nostandard
menu, tray, add, Edit
menu, tray, add, Exit
gui +hwndhwnd
dllcall("RegisterShellHookWindow", uint, hwnd)
detecthiddenwindows on ; scheduled task
sysget, screen, monitorworkarea
global screenbottom
onmessage(dllcall("RegisterWindowMessage", str, "shellhook"), "shellmessage")
return

edit:
run explorer list.txt
return

shellmessage(wparam, lparam) {
  if wparam = 1 ; HSHELL_WINDOWCREATED
  {
    winget, process, processname, ahk_id %lparam%
    exe := substr(process, 1, strlen(process)-4)
    if exe = StartMenuExperienceHost
      detecthiddenwindows off
    else {
      winwait ahk_id %lparam%
      loop, read, list.txt
      {
        item2 := false
        loop, parse, a_loopreadline, %a_space%
          item%a_index% = %a_loopfield%
        if exe = %item1%
        {
          if item2
          {
            wingetclass class
            if class not in %item2%
              exit
          }
          winmove,,, -7, 0, a_screenwidth+14, screenbottom+7
          winmaximize
        }
      }
    }
  }
}

exit:
exitapp