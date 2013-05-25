[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")

$Inbox = Resolve-Path "Inbox"
$Filter = "*.jpg"
$Watcher = New-Object IO.FileSystemWatcher $Inbox, $Filter -Property @{IncludeSubdirectories = $false;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'} 

$Unused = Register-ObjectEvent $Watcher Created -SourceIdentifier FileCreated -Action {
  $WidthMap = @{  4288 = 1626; 2848 = 717 }
  $HeightMap = @{ 2848 = 1080; 4288 = 1080 }

  $InputFile = $Event.SourceEventArgs.FullPath
  $OutputFile = Join-Path (Resolve-Path "Outbox") $Event.SourceEventArgs.Name

  Write-Host ""
  Write-Host "=== NEW FILE ==="
  Write-Host "New Input File:", $InputFile
  Write-Host "Output File:", $OutputFile

  $InputImage = [System.Drawing.Image]::FromFile($InputFile)

  $InputWidth = $InputImage.Width
  $InputHeight = $InputImage.Height

  Write-Host "Input Width:", $InputWidth
  Write-Host "Input Height:", $InputHeight

  $OutputWidth = $WidthMap.$InputWidth
  $OutputHeight = $HeightMap.$InputHeight

  Write-Host "Output Width:", $OutputWidth
  Write-Host "Output Height:", $OutputHeight

  $OutputImage = New-Object System.Drawing.Bitmap $OutputWidth, $OutputHeight

  $Graphics = [System.Drawing.Graphics]::FromImage($OutputImage)
  $Graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $Graphics.DrawImage($InputImage, 0, 0, $OutputWidth, $OutputHeight) 

  $ImageFormat = $InputImage.RawFormat
  $InputImage.Dispose()     
  $OutputImage.Save($OutputFile,$ImageFormat)
  $OutputImage.Dispose()

  Write-Host "SUCCESS"
  Write-Host ""
}

Write-Host "Now Watching for $Filter in $Inbox ('Unregister-Event FileCreated' to stop)"