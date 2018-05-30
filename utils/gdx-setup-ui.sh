#!/bin/bash
# The world's cheapest gdx-setup-ui!!!'

CONFIG=$(zenity --forms         \
    --title="  Create Flixel-GDX project  " \
    --text=" Configure "        \
    --add-entry="Package Name:" \
    --add-entry="Game Name:"    \
    --add-entry="Output Path:"  \
    )
OK=$?

# If user clicked OK
if [[ $OK == 0 ]]; then
    # Get every field
    PACKAGE=$(echo $CONFIG | awk -F "|" '{print $1}')
    NAME=$(echo $CONFIG | awk -F "|" '{print $2}')
    OUTPUT=$(echo $CONFIG | awk -F "|" '{print $3}')
    
    # Replace spaces with underscores
    NAME=${NAME// /_}

    # Validate searching for empty fields
    if [[ ! $PACKAGE =~ [^[:space:]] || ! $NAME =~ [^[:space:]] || ! $OUTPUT =~ [^[:space:]] ]]; then
        zenity --error --text "You need to fill all the fields.";
        $(pwd)gdx-setup-ui.sh
        exit 0
    fi

    # Run the offline-project-generator.sh and show it's progress
    (./gen-project.sh $PACKAGE $NAME $OUTPUT) | zenity --progress \
        --title=" Generating Flixel-GDX project " \
        --text="Doing ..." \
        --width=200 \
        --percentage=0

    # Status message
    if [ "$?" = -1 ] ; then
            zenity --error \
                --title "  Create Flixel-GDX project  " \
                --width=200 \
                --text="An error ocured."
    else
        zenity --info --title "  Create Flixel-GDX project  "\
            --width=200 \
            --text "  Finished Successfully!  ";
    fi
fi
