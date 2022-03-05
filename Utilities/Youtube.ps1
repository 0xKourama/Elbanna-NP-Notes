Param(
    $URL,
    $SongName,
    $Artist
)
$Download_Path = "D:\Downloads"
Write-Host -ForegroundColor Cyan "[*] Downloading $SongName by $Artist from $URL"
d:\YoutubeDownloader\youtube-dl.exe $URL -o "$Download_Path\$Artist - $SongName.%(ext)s" -x --audio-format mp3
Write-Host -ForegroundColor Green "[+] $Artist - $SongName saved to $Download_Path"