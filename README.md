# magento2-theme-builder
## By [Edmonds Commerce](https://www.edmondscommerce.co.uk)

Bash script to generate a Magento theme based on colour parameters

## Overview

Given a list of branding colours, generates an entire theme structure based on those colours

- _createFolders.bash sets up the theme folders and boilerplate files
- _createGruntConfig.bash sets up the config for development compilation of the less
- _createLess.bash sets up the less files based on the colours passed into the script

## Usage

Format:

    bash run.bash [vendorname] [packagename] [colour-one] [colour-two] [colour-three] [colour-four]
    
Example:

    bash run.bash "EdmondsCommerce" "My2018Theme" "#CC0000" "#0000CC" "#FFFFFF" "#333333"
