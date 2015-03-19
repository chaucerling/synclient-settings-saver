
This script creates a bash script which re-applies your current synclient settings on startup.  
You can also create a file `$HOME/.config/synclient_user_settings`, to re-applies the settinng in it on startup.
This file should be like https://gist.github.com/chaucerling/876090ff2f53a8a7eb88

The startup script is created in `$HOME/.config/apply-synclient-settings.sh`.  
The startup entry is created in `$HOME/.config/autostart/apply-synclient-settings.desktop`.

###Install & Usage
```Bash
# download
wget https://raw.githubusercontent.com/chaucerling/synclient-settings-saver/master/update-synclient-settings.sh

# run
./update-synclient-settings.sh
bash update-synclient-settings.sh

# select
Select read which settings to update:(1/2/3)
1) synclient
2) user file
3) quit
```
### synclient usage
Edit your synclient settings by using `synclient setting=value`.  
To view all settings and values, run
```Bash
	synclient -l
```
To set the value of MinSpeed to 0.1 for example, do
```Bash
	synclient MinSpeed=0.1
```
After completing all changes, run this script to save the settings.

