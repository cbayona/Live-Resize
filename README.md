== Resize images as they appear ==

Suppose you have two folders called "Inbox" and "Outbox". You have something that puts images in Inbox and want them to appear, scaled down, in Outbox.

    powershell -executionpolicy remotesigned
    .\Live-Resize

Note that you need to manually

    Unregister-Event FileCreated

Note that you need to hard-code new dimensions in Live-Resize.ps1 (look for $WidthMap and $HeightMap). Left-hand side is the original dimension, right-hand side is the desired dimension.