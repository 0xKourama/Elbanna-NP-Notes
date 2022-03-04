Param(
    $URL,
    $SongName,
    $Artist
)
d:\YoutubeDownloader\youtube-dl.exe $URL -o "d:\Downloads\$Artist - $SongName.%(ext)s" -x --audio-format mp3