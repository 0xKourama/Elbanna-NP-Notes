Param(
    $URL,
    $SongName,
    $Artist
)
d:\Downloads\youtube-dl.exe $URL -o "d:\Downloads\$Artist - $SongName.%(ext)s" -x --audio-format mp3