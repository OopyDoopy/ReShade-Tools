#----------------------FUNCTIONS BEGIN HERE-------------------------

function extractShaders{
	foreach ($file in Get-ChildItem .\temp238698092)
	{
		if(($file.Name -match '\.fx') -or ($file.name -match '\.cfg'))
		{
			if(($user -eq 2) -AND (Test-Path -path ".\reshade-shaders\Shaders\$file" -PathType Leaf)){
				Move-Item -Path $file.FullName -Destination .\temp238698092\Shaders
			}
			elseif ($user -eq 1){
				Move-Item -Path $file.FullName -Destination .\temp238698092\Shaders
			}
		}	  
	}
}

function extractTextures{
	foreach ($file in Get-ChildItem .\temp238698092)
	{
		if(($file.Name -match '\.png') -or ($file.name -match '\.dds') -or ($file.name -match '\.bmp') -or ($file.name -match '\.jp*g'))
		{
			if(($user -eq 2) -AND (Test-Path -path ".\reshade-shaders\Shaders\$file" -PathType Leaf)){
				Move-Item -Path $file.FullName -Destination .\temp238698092\Textures
			}
			elseif ($user -eq 1){
				Move-Item -Path $file.FullName -Destination .\temp238698092\Textures
			}
		}  
	}
}

#----------------------FUNCTIONS END HERE----------------------------

#Create reshade-shaders directory
[int]$user = Read-Host -Prompt "1 = Update existing and install new shaders | 2 = Update existing shaders"
if(($user -ne 1) -and ($user -ne 2)){
	Read-Host -Prompt "Invalid input, press enter to exit script"
	Exit
}
if(!(Test-Path -path "temp238698092" -PathType Container)){New-Item -Path ".\" -Name "temp238698092" -ItemType "directory"}
if(!(Test-Path -path "reshade-shaders" -PathType Container)){New-Item -Path ".\" -Name "reshade-shaders" -ItemType "directory"}
if(!(Test-Path -path "reshade-shaders\Shaders" -PathType Container)){New-Item -Path ".\" -Name "reshade-shaders\Shaders" -ItemType "directory"}
if(!(Test-Path -path "reshade-shaders\Textures" -PathType Container)){New-Item -Path ".\" -Name "reshade-shaders\Textures" -ItemType "directory"}

#Ask user if they want to download all shaders or select repositories
[int]$user1 = 1
if ($user -eq 1){ #if user just wants to update shaders, don't prompt for repos
	$user1 = Read-Host -Prompt "1 = Download all repos | 2 = Select repos to download"
	if(($user1 -ne 1) -and ($user1 -ne 2)){
		Read-Host -Prompt "Invalid input, press enter to exit script"
		Exit
	}
}

#Variables for extra required folder shenanigans
[bool]$FXShaders = 1
[bool]$legacy = 1

#Download repositories
$client = new-object System.Net.WebClient
	Write-Outpute-Output "Downloading respositories, please wait"
	if($user1 -eq 2){Write-Output "Select repos to download: 1 = Yes | 0 = No"}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "qUINT") -eq 1)){$client.DownloadFile("https://github.com/martymcmodding/qUINT/archive/master.zip",".\temp238698092\quint.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Crosire") -eq 1)){$client.DownloadFile("https://github.com/crosire/reshade-shaders/archive/slim.zip",".\temp238698092\slim.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Crosire Legacy") -eq 1)){$client.DownloadFile("https://github.com/crosire/reshade-shaders/archive/master.zip",".\temp238698092\legacy.zip")}
		else{$legacy = 0}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "SweetFX") -eq 1)){$client.DownloadFile("https://github.com/CeeJayDK/SweetFX/archive/master.zip",".\temp238698092\sweetfx.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "prod80") -eq 1)){$client.DownloadFile("https://github.com/prod80/prod80-ReShade-Repository/archive/master.zip",".\temp238698092\prod80.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Depth3D") -eq 1)){$client.DownloadFile("https://github.com/BlueSkyDefender/Depth3D/archive/master.zip",".\temp238698092\depth3d.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "AstrayFX") -eq 1)){$client.DownloadFile("https://github.com/BlueSkyDefender/AstrayFX/archive/master.zip",".\temp238698092\astrayfx.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "OtisFX") -eq 1)){$client.DownloadFile("https://github.com/FransBouma/OtisFX/archive/master.zip",".\temp238698092\otisfx.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Pirate") -eq 1)){$client.DownloadFile("https://github.com/Heathen/Pirate-Shaders/archive/master.zip",".\temp238698092\pirate.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Brussell1") -eq 1)){$client.DownloadFile("https://github.com/brussell1/Shaders/archive/master.zip",".\temp238698092\brussell1.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Daodan317081") -eq 1)){$client.DownloadFile("https://github.com/Daodan317081/reshade-shaders/archive/master.zip",".\temp238698092\daodan.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Fubax") -eq 1)){$client.DownloadFile("https://github.com/Fubaxiusz/fubax-shaders/archive/master.zip",".\temp238698092\fubax.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "FXShaders") -eq 1)){$client.DownloadFile("https://github.com/luluco250/FXShaders/archive/master.zip",".\temp238698092\fxshaders.zip")}
		else{$FXShaders = 0}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Radegast FFXIV") -eq 1)){$client.DownloadFile("https://github.com/Radegast-FFXIV/reshade-shaders/archive/master.zip",".\temp238698092\radegast.zip")}
	if(($user1 -eq 1) -or ((Read-Host -Prompt "Lunacy") -eq 1)){$client.DownloadFile("https://github.com/LordOfLunacy/Insane-Shaders/archive/master.zip",".\temp238698092\lunacy.zip")}

#Unzip all archives, delete zips, and move all folders that should be preserved
if($legacy -eq 1){ #Because these shaders aren't maintained, extract and move this first so that subsequent repos can overwrite
	Get-ChildItem '.\temp238698092' -Filter legacy.zip | Expand-Archive -DestinationPath '.\temp238698092' -Force
	Remove-Item .\temp238698092\legacy.zip
	Remove-Item .\temp238698092\reshade-shaders-master\shaders\mxao.fx
	extractShaders
	extractTextures
}
Get-ChildItem '.\temp238698092' -Filter *.zip | Expand-Archive -DestinationPath '.\temp238698092' -Force
Remove-Item .\temp238698092\*.zip

#Maintain Exceptions
#Handle FXShaders requirements
if($FXShaders -eq 1){
    if((!(Test-Path -path "reshade-shaders\Shaders\FXShaders" -PathType Container)) -and ($user -eq 1) ){
		New-Item -Path ".\" -Name "reshade-shaders\Shaders\FXShaders" -ItemType "directory"
    }
    extractShaders
}

#Remove Lord of Lunacy jank
Get-ChildItem .\temp238698092 -Recurse | Where-Object{$_.Name -Match "DevShaders"} | Remove-Item -Recurse
Get-ChildItem .\temp238698092 -Recurse | Where-Object{$_.Name -Match "OldShaders"} | Remove-Item -Recurse

#Keep correct ReShade.fxh/ReShadeUI.fxh (some repositories have old ones for some reason)
Move-Item -Path .\temp238698092\reshade-shaders-slim\Shaders\ReShade*.fxh -Destination .\reshade-shaders\Shaders -Force
Get-ChildItem .\temp238698092 -Recurse | Where-Object{$_.Name -Match "ReShade*.fxh"} | Remove-Item

#Move licenses to their own folder and rename them to be identifiable
if(!(Test-Path -path "reshade-shaders\LICENSES" -PathType Container)){New-Item -Path ".\reshade-shaders" -Name "LICENSES" -ItemType "directory"}
[int]$licensenum = 0
foreach ($file in Get-ChildItem .\temp238698092 -Recurse)
{
    if($file.Name -match 'LICENSE')
    {
        $licensenum++
        if(($user -eq 2) -AND (Test-Path -path ".\reshade-shaders\Shaders\$file" -PathType Leaf)){
			Rename-Item -Path $file.FullName -NewName "LICENSE$licensenum"
			$newdir = $file.FullName + $licensenum
            Move-Item -Path $newdir -Destination .\reshade-shaders\LICENSES -Force
        }
        elseif ($user -eq 1){
			Rename-Item -Path $file.FullName -NewName "LICENSE$licensenum"
			$newdir = $file.FullName + $licensenum
            Move-Item -Path $newdir -Destination .\reshade-shaders\LICENSES -Force
            
        }
    }  
}

#Collapse folder structure
Get-ChildItem .\temp238698092 -Recurse | `
    Where-Object { $_.PSIsContainer -eq $False } | `
    ForEach-Object {Move-Item -Path $_.FullName -Destination .\temp238698092 -Force}

#Move shaders to shaders folder, move textures to textures folder, delete remaining garbage
New-Item -Path ".\temp238698092" -Name "Shaders" -ItemType "directory"
New-Item -Path ".\temp238698092" -Name "Textures" -ItemType "directory"

extractShaders
extractTextures

Remove-Item .\temp238698092\*.*

#Move to reshade-shaders
Move-Item -Path ".\temp238698092\Shaders\*" -Destination .\reshade-shaders\Shaders -Force
Move-Item -Path ".\temp238698092\Textures\*" -Destination .\reshade-shaders\Textures -Force
Remove-Item .\temp238698092 -Recurse

Read-Host -Prompt "Shaders successfully installed/updated.  Press Enter to exit"
