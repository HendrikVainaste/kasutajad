## Loo uus skript, mis palub kasutaja sisestada kasutaja ees- ja perenimi, nimi võib praegu koosneda ainult ladina sümbolitest. 


# Palub kasutajal sisestada eesnimi ja perenimi
	$Eesnimi = Read-Host "Sisestage kasutaja eesnimi (ainult ladina tähed)"
	$Perenimi = Read-Host "Sisestage kasutaja perenimi (ainult ladina tähed)"

# Loob täisnime ees- ja perekonnanimest
	$FullName = "$Eesnimi $Perenimi"

# Määrab parooli
	$KasutajaParool = ConvertTo-SecureString "Parool1!" -AsPlainText -Force

# Loob uue kohaliku kasutaja
	New-LocalUser "kasutaja2" -Password $KasutajaParool -FullName $FullName -Description "Local Account - kasutaja2"

# Teavitab kasutajat, et konto on loodud
	Write-Host "Kasutajakonto on edukalt loodud. Täisnimi: $FullName"	﻿


