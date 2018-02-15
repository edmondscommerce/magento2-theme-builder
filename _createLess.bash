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
    ./$0 [themedir] [colour-one] [colour-two] [colour-three] [colour-four]
"
}

if (( $# < 5 ))
then
    usage
    exit 1
fi

themefolder="$1";
colourOne="$2";
colourTwo="$3";
colourThree="$4";
colourFour="$5";

lessdir=${themefolder}/web/css/source;

if [[ ! -d $lessdir ]]
then
    echo "Creating css source folder"
    mkdir --parents $lessdir
fi

if [[ ! -f ${lessdir}/_extend.less ]]
then
    echo "Creating extend less file"
    cat << EOF > ${lessdir}/_extend.less
//@magento_import '_global_extend.less';
//@magento_import '_header_extend.less';
//@magento_import '_navigation_extend.less';
EOF
fi

if [[ ! -f ${lessdir}/_global_extend.less ]]
then
    echo "Creating global less file"
    cat << EOF > ${lessdir}/_global_extend.less
@colour-one: $colourOne;
@colour-two: $colourTwo;
@colour-three: $colourThree;
@colour-four: $colourFour;


@button-primary__background: @colour-one;
@button-primary__border: 1px solid @colour-one;
@button-primary__hover__background: darken(@colour-one, 10%);
@button-primary__hover__border: 1px solid darken(@colour-one, 10%);

@link__color: @colour-one;
@link__hover__color: darken(@colour-one, 10%);
EOF
fi


if [[ ! -f ${lessdir}/_header_extend.less ]]
then
    echo "Creating header less file"
    cat << EOF > ${lessdir}/_header_extend.less
.page-header {
  background: @colour-one;
  color: @colour-three;
  a {
    color: @colour-three;
  }
  ul.dropdown {
    color: @primary__color;
    a {
      color: @primary__color;
    }
  }

  @media (max-width: @screen__m) {
    .logo {
      min-height: 50px;
      line-height: 50px;
      img {
        vertical-align: middle;
        display: inline-block;
      }
    }
  }

  .nav-toggle::before {
    color: @colour-three;
  }

  .panel.wrapper {
    border-bottom: none;
  }


  .block-search {
    .label::before {
      color:@colour-three;
    }
    .form.minisearch {
      .control {
        input {
          border: none;
          &::-webkit-input-placeholder {
            color: @primary__color;
          }
          &::-moz-placeholder {
            color: @primary__color;
          }
          &:-ms-input-placeholder {
            color: @primary__color;

          }
        }
      }
    }
  }

  .minicart-wrapper {
    .action.showcart::before {
      color: @colour-three;
    }
  }

}
EOF
fi

if [[ ! -f ${lessdir}/_header_extend.less ]]
then
    echo "Creating header less file"
    cat << EOF > ${lessdir}/_header_extend.less
@navigation-desktop__background: @colour-one;
@navigation-desktop-level0-item__color: @colour-three;
@submenu-desktop-item__color: @primary__color;

@navigation-desktop-level0-item__color: @colour-three;
@navigation-desktop-level0-item__active__border-width: 0;
@navigation-desktop-level0-item__active__background: @colour-four;
@navigation-desktop-level0-item__active__color: @colour-three;
@navigation-desktop-level0-item__active__border-color: @colour-two;

@media(min-width: @screen__m) {
  .nav-sections {
    background-color: @colour-one;
  }
}
EOF
fi



if [[ ! -f ${lessdir}/_navigation_extend.less ]]
then
    echo "Creating navigation less file"
    cat << EOF > ${lessdir}/_navigation_extend.less
@navigation-desktop__background: @colour-one;
@navigation-desktop-level0-item__color: @colour-three;
@submenu-desktop-item__color: @primary__color;

@navigation-desktop-level0-item__color: @colour-three;
@navigation-desktop-level0-item__active__border-width: 0;
@navigation-desktop-level0-item__active__background: @colour-four;
@navigation-desktop-level0-item__active__color: @colour-three;
@navigation-desktop-level0-item__active__border-color: @colour-two;

@media(min-width: @screen__m) {
  .nav-sections {
    background-color: @colour-one;
  }
}
EOF
fi