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
    ./$0 [basedir] [vendorname] [packagename]
"
}

if (( $# < 3 ))
then
    usage
    exit 1
fi


basedir="$1";
vendor="$2";
package="$3";

themefolder="$basedir/app/design/frontend/$vendor/$package/"

if [[ ! -d ${basedir} ]]
then
    echo "Creating base directory at $basedir"
    mkdir $basedir
fi

if [[ ! -d ${themefolder} ]]
then
    echo "Creating theme folder at $themefolder"
    mkdir --parents $themefolder
fi


if [[ ! -f ${themefolder}/registration.php ]]
then
    echo "Creating registration.php"
    cat << EOF > ${themefolder}/registration.php
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::THEME,
    'frontend/$vendor/$package',
    __DIR__
);

EOF
fi

if [[ ! -f ${themefolder}/theme.xml ]]
then
    echo "Creating theme.xml"
    cat << EOF > ${themefolder}/theme.xml

<theme xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/theme.xsd">
    <title>$vendor $package</title>
    <parent>Magento/blank</parent>
</theme>

EOF
fi
