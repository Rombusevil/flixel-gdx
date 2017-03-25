# How to Build

Build instructions under **GNU/Linux**

1. Clone this repo.
1. Run _ant -f fetch.xml_. It will download the latest libgdx-nightly-latest.zip
1. Extract the libgdx-nightly-latest.zip that the previous command downloaded
1. Run _update-libgdx.sh [path to the extracted libgdx nightly latests]_
1. Copy _android.jar_ from your android SDK path into the repo folder.
1. Run _ant_

Jar files should be on the _dist_ folder.