#!/bin/bash
#
#   Synclient settings saver
#
# - Author: Seon Wook Park
# - Date: 31st Oct 2011
#
# Run after changing settings via `synclient`

APPNAME="apply-synclient-settings"
TMPFILE=".synclient.out"
TMPFOLDER=$HOME"/tmp"
USERFILE=$HOME"/.config/synclient_user_settings"
SYNFILE=$HOME"/.config/"$APPNAME".sh"
DPFILE=$HOME"/.config/autostart/"$APPNAME".desktop"

read_synclient_settings(){
  # Remove synclient updating file if it exists
  if [ -e $SYNFILE ]; then
    rm $SYNFILE
  fi

  # Add bash header to new file
  echo "#!/bin/bash" >> $SYNFILE

  # Grab output from synclient
  echo "Grabbing current settings from synclient..."
  synclient -l > $TMPFILE

  # Parse synclient output
  echo "Parsing synclient settings..."
  while read line; do
  if [[ $line =~ ([[:alpha:]]+[0-9]?)[[:space:]]*=[[:space:]]*(-?[0-9\.]+) ]]; then
    echo "synclient "${BASH_REMATCH[1]}"="${BASH_REMATCH[2]} >> $SYNFILE
  fi
  done < $TMPFILE
  rm $TMPFILE
}

read_user_file(){
  if [ -e $SYNFILE ]; then
    rm $SYNFILE
  fi

  echo "#!/bin/bash" >> $SYNFILE

  # Parse user file
  echo "Parsing user file..."
  cat $USERFILE | sed '$s/$/\n/' | while read line; do
  if [[ $line =~ ([[:alpha:]]+[0-9]?)[[:space:]]*=[[:space:]]*(-?[0-9\.]+) ]]; then
    echo "synclient "${BASH_REMATCH[1]}"="${BASH_REMATCH[2]} >> $SYNFILE
  fi
  done
  bash $SYNFILE
}


# Check if synclient is accessible
if [[ `command -v synclient` == '' ]]; then
	echo "Error: synclient is not installed"
	exit
fi

# Change directory to tmp
cd $TMPFOLDER

# Choose updating from current synclient setting or user file
echo "Select read which settings to update:(1/2/3)"
select var in "synclient" "user file" "quit"
do
  case $var in
  "synclient") read_synclient_settings;;
  "user file") read_user_file;;
  "quit") exit 0;;
  esac
  break
done


# Make output file executable
chmod +x $SYNFILE

echo; echo "Settings script created in "$SYNFILE

# Add .desktop for non-KDE DEs
if [ -e $DPFILE ]; then
	rm $DPFILE
fi

echo "[Desktop Entry]" >> $DPFILE
echo "Type=Application" >> $DPFILE
echo "Exec="$SYNFILE >> $DPFILE
echo "Hidden=false" >> $DPFILE
echo "NoDisplay=false" >> $DPFILE
echo "Name=Apply Synclient Settings" >> $DPFILE
echo "Comment=Apply your saved synclient settings" >> $DPFILE
echo "X-GNOME-Autostart-enabled=true" >> $DPFILE

echo "Added script to startup"
