## Täienda kasutajate loomise skript nii, et parool ei ole kõikidele valmistatud ühte moodi, vaid igale kasutajale genereeritakse eraldi parool. Kokkuvõttav info kasutaja kohta - tema kasutajatunnus ja genereeritud parool tuleb salvestada faili nimega kasutajanimi.csv

# Funktsioon juhusliku parooli genereerimiseks
function Generate-Password {
    param (
        [int]$length = 12
    )
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()"
    $password = -join ((65..90) + (97..122) + (48..57) + (33..47) | Get-Random -Count $length | ForEach-Object { [char]$_ })
    return $password
}

# Palub kasutajal sisestada eesnimi ja perenimi
$Eesnimi = Read-Host "Sisestage kasutaja eesnimi (ainult ladina tähed)"
$Perenimi = Read-Host "Sisestage kasutaja perenimi (ainult ladina tähed)"

# Loob täisnime ees- ja perekonnanimest
$FullName = "$Eesnimi $Perenimi"

# Määrab kasutajanime
$Kasutajanimi = "$Eesnimi.$Perenimi"

# Kontrollib, kas kasutaja on juba AD-s olemas
$User = Get-ADUser -Filter {SamAccountName -eq $Kasutajanimi}

if ($User) {
    # Kui kasutaja on olemas, kuvab teate
    Write-Host "Kasutaja $FullName on juba olemas AD-s."
} else {
    # Kui kasutajat ei ole, loob uue kasutaja
    $Parool = Generate-Password 12
    $KasutajaParool = ConvertTo-SecureString $Parool -AsPlainText -Force
    New-ADUser -SamAccountName $Kasutajanimi -UserPrincipalName "$Kasutajanimi@domeen.local" -Name $FullName -GivenName $Eesnimi -Surname $Perenimi -AccountPassword $KasutajaParool -Enabled $true -Path "CN=Users,DC=domeen,DC=local"

    # Salvesta kasutaja info CSV-faili
    $UserInfo = [PSCustomObject]@{
        Kasutajanimi = $Kasutajanimi
        Parool       = $Parool
    }
    $UserInfo | Export-Csv -Path "$Kasutajanimi.csv" -NoTypeInformation -Append

    # Teavitab kasutajat, et konto on loodud ja info salvestatud
    Write-Host "Kasutajakonto $FullName on edukalt loodud AD-s."
    Write-Host "Kasutaja info salvestatud faili: $Kasutajanimi.csv"
}
