' ==============================================================================
' AndroPrint Server - Silent Background Launcher
' Starts Node.js Watchdog silently in background (0 window mode)
' ==============================================================================

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get project directory
strScriptPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
strProjectRoot = objFSO.GetParentFolderName(strScriptPath)

' Path to watchdog script
strWatchdogPath = strFSOCombine(strScriptPath, "watchdog.js")

' Command line to execute node watchdog silently
strCmd = "node """ & strWatchdogPath & """"

' Change current directory to project root and run silently (0 = hidden)
objShell.CurrentDirectory = strProjectRoot
objShell.Run strCmd, 0, False

Function strFSOCombine(strPath1, strPath2)
    strFSOCombine = objFSO.BuildPath(strPath1, strPath2)
End Function
