#!/bin/bash
# ---Requirements---
# A means of executing a Bash script (I recommend Git Bash - https://gitforwindows.org/ since it's easy to setup). Install with defaults AND symlink support.
# Without symlink support enabled, the script will simply copy the relevant .dll to the game directory.  The benefit to symlinks is you only have to update your reshade .dlls in one location.
#
# You'll also need 7-Zip (https://www.7-zip.org/) installed.  By default, it's configured to work with the default install path for Windows machines.
# If you choose to install elsewhere, you'll need to modify the sevenzip path below.

# ---ABOUT---
# This script will partially automate setting up reshade in UWP apps using an injector instead of a wrapper.  The injector was made by Crosire.
# You'll need to create a parent location for your shaders and textures by matching the chosen location edited below.  Use my reshade-shaders.ps1 powershell script to download and update shaders.

# Set paths for your reshade shaders and files here WITHOUT trailing slashes

dlls='C:\mods\reshade\reshade-files'					# This is where the script will Download and Extract the reshade DLLs.  Alternatively, this is where you can manually provide them.
mdlls='C:\mods\reshade\reshade-files-mod'				# Location for modified reshade files.  These need to be provided yourself.
shaders='C:\mods\reshade\reshade-shaders\shaders' 			# Please download latest shaders from 'https://github.com/crosire/reshade-shaders/tree/master' or use the 'download-shaders.ps1'
textures='C:\mods\reshade\reshade-shaders\textures' 			# Please download latest shaders from 'https://github.com/crosire/reshade-shaders/tree/master' or use the 'download-shaders.ps1'
presets='C:\mods\reshade\presets' 					# A unique folder will be created on install via the given games name entered during script execution.
screenshots='C:\mods\reshade\screenshots'				# A unique folder will be created on install via the given games name entered during script execution.

injector='C:\mods\reshade\injector'					# Path to keep inject32.exe and inject64.exe

sevenzip='C:\Program Files\7-Zip' 					# Only modify if you have 7-Zip installed to the non-default directory.

# Once the setup above is complete, copy the script to your game directory, double click to run, and follow the prompts.

#------------DO NOT EDIT BELOW HERE -------------

export MSYS=winsymlinks:nativestrict

#Prompt the user to download and extract reshade and injectors to the specificed directories above
printf '\033[8;40;150t' #resizes the window to make text fit better
echo 'Would you like to download and extract the latest official ReShade .dlls to your configured .dll directory?'
echo 'For this to function correctly, you will need 7-Zip installed and properly configured in the script.'
echo '1 = yes 2 = no'
read -r -n 1 download
echo
echo
echo 'Would you like to download the injector executables from reshade.me?'
echo '1 = yes 2 = no'
read -r -n 1 downloadinject
echo
echo
if [ "$download" == "1" ]
then
	curl https://reshade.me/ --output temp.html
	input='.\temp.html'
	string="https://reshade.me$(grep -o "/downloads/.*.exe" $input)"
	curl "$string" --output reshade-setup.exe
	"$sevenzip"'\'7z e -aoa -o$dlls reshade-setup.exe "*.dll"
	rm temp.html
	rm reshade-setup.exe
fi
if [ "$downloadinject" == "1" ]
then
	curl https://reshade.me/downloads/inject32.exe --output 'inject32.exe'
	curl https://reshade.me/downloads/inject64.exe --output 'inject64.exe'
	mkdir -p "$injector"
	mv -f inject32.exe "$injector"
	mv -f inject64.exe "$injector"
fi
echo

#User prompts for setting up associated files.
echo 'Would you like to install Official ReShade or Modded ReShade?'
echo '1 = Official | 2 = Modded'
read -r -n 1 modoroff
echo
echo
if [ "$modoroff" == "2" ]
then
	dlls=$mdlls
fi
echo 'Enter the name of the game.  This is used for creation of the Preset and Screenshots folders.'
read game
echo
echo
echo 'Launch the UWP game and open the task manager.  Locate the .exe from the Details tab.  Type the name here (example: Game.exe)'
read executable
echo
echo

#Create UWP App list for user to check and cleanup when finished.
echo 'Please wait a moment, generating a list of installed UWP apps.'
powershell Get-AppxPackage | grep -E "^PackageFamilyName|^PackageFullName" > UWP-App-List.txt
echo
echo
echo 'List generated.  You will find a file called UWP-App-List.txt in the directory of this script.'
echo 'Open this file and locate the PackageFamilyName for your game.  Copy and paste that into this console and press enter.'
read packagename
echo
echo

#Open the program's appxmanifest.xml and search for the application id
fullpackagename=$(grep -B 1 "$packagename" UWP-App-List.txt | head -1 | sed -r 's/PackageFullName\s+\:\s+//') #grep for user provided packagefamilyname, grab line before it, pass to head to cut off subsequent lines, pass to sed to remove unnecessary text.
appid=$(grep -oP "(?<=<Application Id=\").[a-zA-Z\.]+" 'C:\Program Files\WindowsApps\'"$fullpackagename"'\appxmanifest.xml') #open relevant appxmanifest.xml and regex the app id
echo 'Deleting UWP-App-List.txt now'
rm UWP-App-List.txt

#Check if reshade.ini exists, and if not create it and fill appropriate defaults with user information added to the top of the script.
#Also creates a screenshots folder and also sets reshade to save them there

if [ -e "$presets"'\'"$game"'\reshade.ini' ] 
then
  echo 'File reshade.ini already exists! File has not been modified.'
else
  mkdir -p "$screenshots"'\'"$game"
  mkdir -p "$presets"'\'"$game"
  echo '[GENERAL]
EffectSearchPaths='"$shaders"'
PerformanceMode=0
PreprocessorDefinitions=RESHADE_DEPTH_INPUT_IS_REVERSED=0,RESHADE_DEPTH_INPUT_IS_LOGARITHMIC=0,RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN=0,RESHADE_DEPTH_LINEARIZATION_FAR_PLANE=1000
PresetPath='"$presets"'\'"$game"'\ReshadePreset.ini
PresetTransitionDelay=1000
SkipLoadingDisabledEffects=0
TextureSearchPaths='"$textures"'

[INPUT]
ForceShortcutModifiers=1
InputProcessing=2
KeyEffects=145,0,0,0
KeyNextPreset=0,0,0,0
KeyOverlay=36,0,0,0
KeyPerformanceMode=0,0,0,0
KeyPreviousPreset=0,0,0,0
KeyReload=0,0,0,0
KeyScreenshot=44,0,0,0

[OVERLAY]
ClockFormat=0
FPSPosition=1
NoFontScaling=1
SaveWindowState=0
ShowClock=0
ShowForceLoadEffectsButton=1
ShowFPS=0
ShowFrameTime=0
ShowScreenshotMessage=1
TutorialProgress=4
VariableListHeight=300.000000
VariableListUseTabs=0

[SCREENSHOTS]
ClearAlpha=1
FileFormat=1
FileNamingFormat=0
JPEGQuality=90
SaveBeforeShot=1
SaveOverlayShot=0
SavePath='"$screenshots"'\'"$game"'
SavePresetFile=0

[STYLE]
Alpha=1.000000
ChildRounding=0.000000
ColFPSText=1.000000,1.000000,0.784314,1.000000
EditorFont=ProggyClean.ttf
EditorFontSize=13
EditorStyleIndex=0
Font=ProggyClean.ttf
FontSize=13
FPSScale=1.000000
FrameRounding=0.000000
GrabRounding=0.000000
PopupRounding=0.000000
ScrollbarRounding=0.000000
StyleIndex=2
TabRounding=4.000000
WindowRounding=0.000000' > "$presets"'\'"$game"'\reshade.ini'
fi

#Create reshade preset file and store in presets directory
if [ -e "$presets"'\'"$game"'\ReshadePreset.ini' ]
then
  echo 'File ReshadePreset.ini already exists! File has not been modified.'
else
  touch "$presets"'\'"$game"'\ReshadePreset.ini'
  echo 'PreprocessorDefinitions=
Techniques=
TechniqueSorting=DisplayDepth' > "$presets"'\'"$game"'\ReshadePreset.ini'
fi

#Create symlinks for reshade dll and injector
ln -s -f "$injector"'\inject64.exe' "$presets"'\'"$game"'\inject.exe' #for now, assuming 64 bit application
ln -s -f "$dlls"'\reshade64.dll' "$presets"'\'"$game"'\ReShade64.dll'

#Create script to launch UWP game with the injector.
desktoppath=$(powershell '[Environment]::GetFolderPath("Desktop")')
if [ -e "$desktoppath"'\'"$game"' with Reshade.ps1' ]
then
	echo 'Powershell script to launch the game already exists.  File has not been modified.'
else
	echo 'cd '"$presets"'\'"$game"'
Start-Process -FilePath inject.exe '"$executable"'
Start-Process -FilePath explorer.exe shell:appsFolder\'"$packagename"'!'"$appid" > "$desktoppath"'\'"$game"' with Reshade.ps1'
fi
echo 'Done! Reshade files have been setup and a powershell script to launch the game with reshade has been generated on your Desktop.'
echo 'Press any key to close.'
read -r -n 1 keyinput
exit
