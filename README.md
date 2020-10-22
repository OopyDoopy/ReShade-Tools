# ReShade-Tools
In this repository are a handful of scripts I've written to make life a bit easier for ReShade enthusiasts.  Enjoy!
# Download-Shaders
This PowerShell script downloads all the well known shader repositories from github and organizes them in a reshade-shaders folder for you, fully collapsed under Shaders and Textures folders.  The script is also capable of updating only preexisting shaders, for those that like to maintain a more curated list of shaders but want an easy way to ensure they have the latest versions available.  This script is intended for use with a centralized reshade-shaders folder that you point all games towards, though it can be used for other purposes.

How to use:
  Drop the script in the directory you'd like to create \reshade-shaders\ in.  Right click, "Run with PowerShell", and complete the prompts.
# Install-Reshade
This Bash script enables you to far more easily use reshade from a centralized location.  It should get you most of the way there on Linux installs as well!  This script requires a bit of setup, but once that's done it's a lightning fast way to install reshade for all your games.  
Since I'm not a Linux user (not for gaming anyway), I'll need user feedback for how to improve that experience.

Features:
  * Centralized Reshade dlls deployed via symlinks (update reshade dlls in one location!)
  * Download the latest ReShade dlls straight from the website and extract them to the centralized location.
  * Centralized Presets and Screenshots folder, with subfolders per-game.  No more will you accidentally delete a preset by uninstalling a game.
  * Uses a centralized reshade-shaders folder
  * Sets up your reshade.ini for you based on the above features.

Prerequisites:

  1.) You'll need a means of executing a Bash script (I recommend Git Bash - https://gitforwindows.org/ since it's easy to setup). Install with defaults AND symlink support.
  
  2.) Because Windows tightly manages who can create symlinks, you'll need to do one of the following things for symlink functionality to work (Linux users can ignore this):
  
    A.) (Recommended 1) Execute the script as administrator.  If you can't right click and execute as admin, you'll need to execute the script from an elevated Git Bash terminal.
    
    B.) (Recommended 2) Enable UWP Developer Mode.  To do this, open the start menu and type developer settings.  The option is available there.  For some reason this setting also allows admin accounts to create symlinks.  Security implications are extremely minimal, this is the method I use.
    
    C.) (**NOT** Recommended) Disable User Account Control.  This is a big security no no, only do this if you know what you're doing, and I'm basically including this option only for the people that have disabled it already.
    
  2.) You'll also need 7-Zip (https://www.7-zip.org/) installed.  By default, it's configured to work with the default install path for Windows machines.  If you have 7-Zip setup in your PATH variables, edit the variable at the top of the script to be empty (if you don't know what this means and you're on Windows, ignore it).
  
Initial Setup:

  1.) Open the script in the text editor of your choice (I recommend notepad++, but regular notepad will work fine if that's all you have).
  
  2.) Modify the paths to reflect the directories you'd like to use.  
    *Note: Any paths you include here will be generated for you, the directories don't need to exist in advance.*
    *Note 2: If you use any modified ReShade dlls, you'll need to provide those yourself.*
    
How to use:

  1.) Place the script in the game directory with the game's .exe file.  Double click to execute (assuming Git Bash).
  
  2.) Follow the steps as they pop up in the terminal.
  
  3.) Reshade is installed!
