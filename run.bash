#!/usr/bin/env bash
readonly DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $DIR;
set -e
set -u
set -o pipefail
standardIFS="$IFS"
IFS=$'\n\t'
echo "
===========================================
$(hostname) $0 $@
===========================================
"


function usage(){
    echo "
Usage:
    ./$0 [vendorname] [packagename] [colour-one] [colour-two] [colour-three] [colour-four]

    vendorname - theme vendor name
    packagename - theme package name
    colour-* - colour code in hex format (#FFFFFF)
"
}

if (( $# < 5 ))
then
    usage
    exit 1
fi

vendor="$1";
package="$2";
colourOne="$3";
colourTwo="$4";
colourThree="$5";
colourFour="$6";

baseDir="/tmp/themegenerator/"
themefolder="$baseDir/app/design/frontend/$vendor/$package/"

bash -${-//s} ./_createFolders.bash "$baseDir" "$vendor" "$package"

bash -${-//s} ./_createLess.bash "$themefolder" "$colourOne" "$colourTwo" "$colourThree" "$colourFour"

bash -${-//s} ./_createGruntConfig.bash "$baseDir" "$vendor" "$package"

echo ""
echo "Theme created successfully at $baseDir"
echo "To install the theme into your Magento installation:"
echo "- Copy the theme folder to the root of Magento"
echo "- Set the store's theme in Admin > Design > Configuration"
echo "- Run npm install"
echo "- Run grunt exec"
echo "- Run grunt less"