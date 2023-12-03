function Convert-ALAC {
    Param($DIR)
    if($null -eq $DIR) {
        Write-Output "Enter a Directory with `"convertALAC <directory>`" "
    }
    else {
        Get-ChildItem -Path $DIR -Filter "*.flac" -r | ForEach-Object { 
            if ($(Find-Cover "$DIR\$_.Directory.Name") -eq $true) {
                ffmpeg -loop 1 -i ".\Cover.png" -i $_ -c:a alac -y "$DIR\$($_.BaseName).m4a"
            }
            else {
                ffmpeg -i $_ -c:a alac -c:v copy -y "$DIR\$($_.BaseName).m4a"
            }
        }
    }
}

function Find-Cover {
    Param($DIR)
    if($null -ne $(Get-ChildItem -Path $DIR -Filter "Cover.png")) {
        return $true
    } 
    else {
        return $false
    }
}