
#!/bin/bash
set -e

function showHelp {
    echo "Not enough parameters! "
    echo "Try like this: "
    echo "./gen-project.sh [package_name] [game_name] [output_folder]"
    echo "Don't use spaces. Package name separated by dots and all lowercase."
    echo "It echoes porcentage of completion numbers to be used with zenity."
    echo ""
}

# Refactors the keys in the current directory
function refactor {
    # HC hardcoded values in the project
    HC_PACKAGE=com.rombosaur.game
    HC_GAME_NAME=flixelgame

    FILES=$(find . -type f | grep -v \.png)
    for FILE in $FILES; do
        sed -i "s/$HC_PACKAGE/$PACKAGE/g"       $FILE 
        sed -i "s/$HC_GAME_NAME/$GAME_NAME/g"   $FILE 
    done;
}

# Creates the package dir structure and moves the files there
# deleting the old package dir structure
# $1 the path of the specific project (core, android, desktop)
function createPackageDirs {
    ORI_PATH=$(echo $HC_PACKAGE | tr . /)  # Replaces dots with slashes
    PACKAGE_PATH=$(echo $PACKAGE | tr . /) # Replaces dots with slashes

    mkdir -p $1/src/$PACKAGE_PATH/              # Creates the package dir structure
    mv $1/src/$ORI_PATH/* $1/src/$PACKAGE_PATH/ # Moves from $ORI_PATH to the new dir structure
    find . -type d -empty -delete               # Deletes empty folders
}

# -------------------------------- #
# Procedure 
# -------------------------------- #
if [ $# -ne 3 ]; then
    showHelp
    exit 0
fi
PACKAGE=$1
GAME_NAME=$2
OUTPUT_FOLDER=$3

# Unpack project.zip
# echo "Unpacking projects.zip..."
ZIP_FOLDER_NAME=projects
unzip $ZIP_FOLDER_NAME.zip >/dev/null && cd $ZIP_FOLDER_NAME && echo "10"


# echo "Processing Desktop Project...";
refactor && echo "20"
createPackageDirs android   && echo "40" 
createPackageDirs core      && echo "60"
createPackageDirs desktop   && echo "80"


# echo "Moving folders..."
cd ..
mv $ZIP_FOLDER_NAME $OUTPUT_FOLDER/$GAME_NAME && echo "100"
