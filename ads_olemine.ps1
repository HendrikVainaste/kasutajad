## Kontrolli, et kasutaja juba olemas AD-s

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
	    $KasutajaParool = ConvertTo-SecureString "Parool1!" -AsPlainText -Force	
	    New-ADUser -SamAccountName $Kasutajanimi -UserPrincipalName "$Kasutajanimi@domeen.local" -Name $FullName -GivenName $Eesnimi -Surname $Perenimi -AccountPassword $KasutajaParool -Enabled $true -Path "CN=Users,DC=domeen,DC=local"

    # Teavitab kasutajat, et konto on loodud
	    Write-Host "Kasutajakonto $FullName on edukalt loodud AD-s."
	}
