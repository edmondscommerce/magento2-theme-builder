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

if [[ ! -f ${basedir}/Gruntfile.js ]]
then
    echo "Creating Gruntfile"
    cat << EOF > ${basedir}/Gruntfile.js
/**
 * Copyright © Magento, Inc. All rights reserved.
 * See COPYING.txt for license details.
 */

// For performance use one level down: 'name/{,*/}*.js'
// If you want to recursively match all subfolders, use: 'name/**/*.js'

module.exports = function (grunt) {
    'use strict';

    var _ = require('underscore'),
        path = require('path'),
        filesRouter = require('./dev/tools/grunt/tools/files-router'),
        configDir = './dev/tools/grunt/configs',
        tasks = grunt.file.expand('./dev/tools/grunt/tasks/*'),
        themes;

        filesRouter.set('themes', 'dev/tools/grunt/configs/themes');
        themes = filesRouter.get('themes');

    tasks = _.map(tasks, function(task){ return task.replace('.js', '') });
    tasks.push('time-grunt');
    tasks.forEach(function (task) {
        require(task)(grunt);
    });

    require('load-grunt-config')(grunt, {
        configPath: path.join(__dirname, configDir),
        init: true,
        jitGrunt: {
            staticMappings: {
                usebanner: 'grunt-banner'
            }
        }
    });

    _.each({
        /**
         * Assembling tasks.
         * ToDo: define default tasks.
         */
        default: function () {
            grunt.log.subhead('I\'m default task and at the moment I\'m empty, sorry :/');
        },

        /**
         * Production preparation task.
         */
        prod: function (component) {
            var tasks = [
                'less',
                'autoprefixer',
                'cssmin',
                'usebanner'
            ].map(function(task){
                return task + ':' + component;
            });

            if (typeof component === 'undefined') {
                grunt.log.subhead('Tip: Please make sure that u specify prod subtask. By default prod task do nothing');
            } else {
                grunt.task.run(tasks);
            }
        },

        /**
         * Refresh themes.
         */
        refresh: function () {
            var tasks = [
                'clean',
                'exec:all'
            ];
            _.each(themes, function(theme, name) {
                tasks.push('less:' + name);
            });
            grunt.task.run(tasks);
        },

        /**
         * Documentation
         */
        documentation: [
            'replace:documentation',
            'less:documentation',
            'styledocco:documentation',
            'usebanner:documentationCss',
            'usebanner:documentationLess',
            'usebanner:documentationHtml',
            'clean:var',
            'clean:pub'
        ],

        'legacy-build': [
            'mage-minify:legacy'
        ],

        spec: function (theme) {
            var runner = require('./dev/tests/js/jasmine/spec_runner');

            runner.init(grunt, { theme: theme });

            grunt.task.run(runner.getTasks());
        }
    }, function (task, name) {
        grunt.registerTask(name, task);
    });
};

EOF
fi

if [[ ! -f ${basedir}/grunt-config.json ]]
then
    echo "Creating grunt config"
    cat << EOF > ${basedir}/grunt-config.json
{
    "themes": "dev/tools/grunt/configs/custom-themes"
}
EOF
fi


if [[ ! -d ${basedir}/dev/tools/grunt/configs ]]
then
    echo "Creating grunt config folder"
    mkdir --parents ${basedir}/dev/tools/grunt/configs
fi

if [[ ! -f ${basedir}/dev/tools/grunt/configs/custom-themes.js ]]
then
    echo "Creating custom theme config"
    cat << EOF > ${basedir}/dev/tools/grunt/configs/custom-themes.js
module.exports = {
    $vendor$package: {
        area: 'frontend',
        name: '$vendor/$package',
        locale: 'en_GB',
        files: [
            'css/styles-m',
            'css/styles-l'
        ],
        dsl: 'less'
    }
}
EOF
fi

if [[ ! -f ${basedir}/package.json ]]
then
    echo "Creating package.json"
    cat << EOF > ${basedir}/package.json
{
    "name": "magento2",
    "author": "Magento Commerce Inc.",
    "description": "Magento2 node modules dependencies for local development",
    "license": "(OSL-3.0 OR AFL-3.0)",
    "repository": {
        "type": "git",
        "url": "https://github.com/magento/magento2.git"
    },
    "homepage": "http://magento.com/",
    "devDependencies": {
        "glob": "~7.1.1",
        "grunt": "~1.0.1",
        "grunt-autoprefixer": "~3.0.4",
        "grunt-banner": "~0.6.0",
        "grunt-continue": "~0.1.0",
        "grunt-contrib-clean": "~1.0.0",
        "grunt-contrib-connect": "~1.0.2",
        "grunt-contrib-cssmin": "~2.0.0",
        "grunt-contrib-imagemin": "~1.0.1",
        "grunt-contrib-jasmine": "~1.0.0",
        "grunt-contrib-less": "~1.4.1",
        "grunt-contrib-watch": "~1.0.0",
        "grunt-eslint": "~19.0.0",
        "grunt-exec": "~2.0.0",
        "grunt-jscs": "~3.0.1",
        "grunt-replace": "~1.0.1",
        "grunt-styledocco": "~0.3.0",
        "grunt-template-jasmine-requirejs": "~0.2.3",
        "grunt-text-replace": "~0.4.0",
        "imagemin-svgo": "~5.2.1",
        "load-grunt-config": "~0.19.2",
        "morgan": "~1.5.0",
        "node-minify": "~2.0.3",
        "path": "~0.12.7",
        "serve-static": "~1.7.1",
        "squirejs": "~0.2.1",
        "strip-json-comments": "~2.0.1",
        "time-grunt": "~1.0.0",
        "underscore": "~1.7.0"
    }
}
EOF
fi