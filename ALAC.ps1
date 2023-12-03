
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

    <#
    
    .DESCRIPTION
    Convert-ALAC converts all FLAC files in the specified folder (Recursively)

    .PARAMETER DIR
    The DIR parameter specifies the directory to crawl for FLAC files to convert to ALAC.
    If there is no specified directory then the help screen is displayed
    
    .EXAMPLE
    PS> Get-ChildItem
        example1.flac
        example2.flac (Simplified Get-ChildItem output)
    PS> Convert-ALAC "C:\Users\user\Downloads"
    (A bunch of FFMPEG output)
    PS> Get-ChildItem
        example1.m4a
        example2.m4a
        
    #>
}

function Find-Cover {
    Param($DIR)
    if($null -ne $(Get-ChildItem -Path $DIR -Filter "Cover.png")) {
        return $true
    } 
    else {
        return $false
    }

    <#
        .DESCRIPTION
        Find-Cover is used as a sub-function to Convert-ALAC to simplify the process of transcoding files that have Cover art as a sibling file.
        While it can be used on its own, it shouldn't be

        .PARAMETER DIR
        The DIR parameter while similar in name to the DIR parameter from Convert-ALAC is not the same in that $_ wildcard for Get-ChildItem | ForEach-Object,
        does not contain the directory in its name

        .EXAMPLE
        PS> Get-ChildItem "C:\Users\user\Downloads\"
            example1.flac
            example2.flac
            Cover.png
        PS> Find-Cover "C:\Users\user\Downloads\"
            True
    #>
}