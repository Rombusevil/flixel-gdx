#!/bin/bash
set -e

function showHelp {
    echo "Download the libgdx-nightly-latest.zip and extract it somewhere"
    echo "Then run this script with it's path as first argument."
    echo "It will update the projects.zip with the jars in the libgdx folder."
    echo "Try like this: "
    echo "./update-libgdx.sh [libgdx-nightly-latest_extracted_path]"
    echo ""
}

# $1=project folder, $2=libgdx folder
function updateLibs {
    NEEDED_FILES=$(find $1/libs/ -type f | cut -d'/' -f 3,4,5)
    for FILE in $NEEDED_FILES; do
        if [[ $FILE == "flixel-"* || $FILE == "tween-engine"* ]]; then
            echo "Ignoring $FILE jar...";
        else
            GREPEAR=""
            # Handles the files in the armeabi and armeabi-v7a folders
            if [[ $FILE == *"/"*  ]]; then 
                GREPEAR=$(echo $FILE | awk -F "/" '{print $1}')
                FILE=$(echo $FILE | awk -F "/" '{print $2}')
                
                # Searchs for the file and greps for the folder
                UPDATED_FILE=$(find $2 -name $FILE | grep $GREPEAR/)
            else
                UPDATED_FILE=$(find $2 -name $FILE)
            fi

            # Copies the file to the project folder
            cp $UPDATED_FILE $1/libs/$GREPEAR 
        fi
    done;
}


# -------------------------------- #
# Procedure 
# -------------------------------- #
if [ $# -ne 1 ]; then
    showHelp
    exit 0
fi

echo "Welcome to the offline libgdx updater!"
echo ""

echo "Unzipping projects.zip..."
unzip projects.zip >/dev/null

# Names of the unziped folders
PRJ_AND=flixelgame-android
PRJ_CORE=flixelgame
PRJ_DESKTOP=flixelgame-desktop

# Copy libs to the projects folders
echo "Updating libs..."
LIBGDX=$1
updateLibs $PRJ_AND $LIBGDX
updateLibs $PRJ_CORE $LIBGDX
updateLibs $PRJ_DESKTOP $LIBGDX

echo "Done!"
