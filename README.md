Watch a folder and resize images (in PowerShell)
================================================

Suppose you have two folders called "Inbox" and "Outbox". You have something that puts images in Inbox and want them to appear, scaled down, in Outbox.

    powershell -executionpolicy remotesigned
    .\Live-Resize

Caveat: Does not clean up
-------------------------

You need to manually

    Unregister-Event FileCreated

when you want to stop.

Caveat: Hard-coded output dimensions
------------------------------------

You need to hard-code new dimensions in `Live-Resize.ps1` (look for `$WidthMap` and `$HeightMap`). Left-hand side is the original dimension, right-hand side is the desired dimension.

Caveat: Listens for create events, not "write close"
----------------------------------------------------

This script only works with applications that do their writing in a temporary location and then move the completed file into place. If the application creates the file in Inbox and then writes the content, the watcher will see an empty file and the resizing operation will fail.

Sadly, `FileSystemWatcher` does not support anything like `inotify`'s `close_write` event that only gets fired when a file is closed after it has been opened for writing. There are workarounds that are all both tedious and error-prone and I won't implement any of them.