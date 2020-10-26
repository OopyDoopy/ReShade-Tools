#!/bin/bash
# ---Requirements---
# A means of executing a Bash script (I recommend Git Bash - https://gitforwindows.org/ since it's easy to setup). Install with defaults AND symlink support.
# Without symlink support enabled, the script will simply copy the relevant .dll to the game directory.  The benefit to symlinks is you only have to update your reshade .dlls in one location.
#
# You'll also need 7-Zip (https://www.7-zip.org/) installed.  By default, it's configured to work with the default install path for Windows machines.
# If you choose to install elsewhere, you'll need to modify the sevenzip path below.

# ---ABOUT---
# This script is designed to make reshade less cumbersome for general use by storing all files within a global directory.
# You'll need to create a parent location for your shaders and textures by matching the chosen location edited below.  Use my reshade-shaders.ps1 powershell script to download and update shaders.

# Set paths for your reshade shaders and files here WITHOUT trailing slashes

dlls='C:\mods\reshade\reshade-files'						# This is where the script will Download and Extract the reshade DLLs.  Alternatively, this is where you can manually provide them.
mdlls='C:\mods\reshade\reshade-files-mod'				# Location for modified reshade files.  These need to be provided yourself.
shaders='C:\mods\reshade\reshade-shaders\shaders' 		# Please download latest shaders from 'https://github.com/crosire/reshade-shaders/tree/master' or use the 'download-shaders.ps1'
textures='C:\mods\reshade\reshade-shaders\textures' 		# Please download latest shaders from 'https://github.com/crosire/reshade-shaders/tree/master' or use the 'download-shaders.ps1'
presets='C:\mods\reshade\presets' 						# A unique folder will be created on install via the given games name entered during script execution.
screenshots='E:\screenshots'				# A unique folder will be created on install via the given games name entered during script execution.

sevenzip='C:\Program Files\7-Zip\' 					# Only modify if you have 7-Zip installed to the non-default directory.  This is the only path that should have a trailing slash.

# Once the setup above is complete, copy the script to your game directory, double click to run, and follow the prompts.

#------------DO NOT EDIT BELOW HERE -------------

export MSYS=winsymlinks:nativestrict

#Prompt the user to download and extract reshade to the specificed directory above
printf '\033[8;40;100t' #resizes the window to make text fit better
echo 'Would you like to download and extract the latest official ReShade .dlls to your configured .dll directory?'
echo 'For this to function correctly, you will need 7-Zip installed and properly configured in the script.'
echo '1 = yes 2 = no'
read -r -n 1 download
echo
if [ "$download" == "1" ]
then
	curl https://reshade.me/ --output temp.html
	input='.\temp.html'
	string="https://reshade.me$(grep -o "/downloads/.*.exe" $input)"
	curl "$string" --output reshade-setup.exe
	"$sevenzip"7z e -aoa -o$dlls reshade-setup.exe "*.dll"
	rm temp.html
	rm reshade-setup.exe
fi
echo 'Would you like to install Official ReShade or Modded ReShade?'
echo '1 = Official | 2 = Modded'
read -r -n 1 modoroff
echo
if [ "$modoroff" == "2" ]
then
	dlls=$mdlls
fi
echo 'Enter the name of the game.  This is used for creation of the Preset and Screenshots folders'
read game
echo

#Figure out if the file is 32 or 64 bit
bit="$(file *.exe)"

case $bit in
	*PE32+*)
	bit="64"
	echo '64 bit application detected'
	;;
	
	*)
	bit="32"
	echo '32 bit application detected'
	;;
esac

#Figure out which file name is needed then copies and renames the file appropriately

echo 'Select the API the game uses. 1 = dx8/dx9 | 2 = dx10/11/12 | 3 = opengl | 4 = vulkan'
read -r -n 1 api
echo
case $api in
	1)
	if [ "$bit" -eq "32" ]
	then
		ln -s -f "$dlls"'\ReShade32.dll' d3d9.dll
	else
		ln -s -f "$dlls"'\ReShade64.dll' d3d9.dll
	fi
	;;
	
	2)
	if [ "$bit" -eq "32" ]
	then
		ln -s -f "$dlls"'\ReShade32.dll' dxgi.dll
	else
		ln -s -f "$dlls"'\ReShade64.dll' dxgi.dll
	fi
	;;
	
	3)
	if [ "$bit" -eq "32" ]
	then
		ln -s -f "$dlls"'\ReShade32.dll' opengl32.dll
	else
		ln -s -f "$dlls"'\ReShade64.dll' opengl32.dll
	fi
	;;
	4)
	echo 'Ensure you have Reshade for Vulkan installed globally, this script will take care of the rest.'
	;;
	*)
	echo 'Invalid input, press any key to close'
	read -r -n 1 keyinput
	exit
	;;
esac

#Check if reshade.ini exists, and if not create it and fill appropriate defaults with user information added to the top of the script.
#Also creates a screenshots folder and also sets reshade to save them there

if [ -e 'reshade.ini' ] 
then
  echo 'File reshade.ini already exists! File has not been modified.'
else
  mkdir -p "$screenshots"'\'"$game"
  echo > 'reshade.ini'
  echo '[GENERAL]
EffectSearchPaths='"$shaders"'
PerformanceMode=0
PreprocessorDefinitions=
PresetPath=CurrentPresetPath='"$presets"'\'"$game"'\ReshadePreset.ini
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
WindowRounding=0.000000' > 'reshade.ini'
fi
if [ -e "$presets"'\'"$game"'\ReshadePreset.ini' ]
then
  echo 'File ReshadePreset.ini already exists! File has not been modified.'
else
  mkdir -p "$presets"'\'"$game"
  touch "$presets"'\'"$game"'\ReshadePreset.ini'
  echo 'PreprocessorDefinitions=
Techniques=
TechniqueSorting=DisplayDepth' > "$presets"'\'"$game"'\ReshadePreset.ini'
fi
echo 'Done! Press any key to close.'
read -r -n 1 keyinput
exit
