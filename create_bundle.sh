#!/bin/bash
################################################################################
#                                Create Bundle                                 #
#                                                                              #
#             This script will export a single function that will              #
#          create an archived bundle from a given directory including          #
#                              all utility scripts                             #
################################################################################
#       Copyright © 2020 - 2021, Jack Thorp and associated contributors.       #
#                                                                              #
#    This program is free software: you can redistribute it and/or modify      #
#    it under the terms of the GNU General Public License as published by      #
#    the Free Software Foundation, either version 3 of the License, or         #
#    any later version.                                                        #
#                                                                              #
#    This program is distributed in the hope that it will be useful,           #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of            #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
#    GNU General Public License for more details.                              #
#                                                                              #
#    You should have received a copy of the GNU General Public License         #
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.    #
################################################################################

################################################################################
#                                 SCRIPT SETUP                                 #
################################################################################
#===============================================================================
# This section will store some "Process Global" variables into a stack that
# fully supports nesting into the upcoming includes so that these variables
# are correctly held intact.
#
# The following variables are currently being stored:
#    0 - SOURCING_INVOCATION - Boolean - If the script was sourced not invoked
#    1 - DIR - String - The script's directory path
#===============================================================================
# Get the global stack if it exists
if [ -z ${stack_vars+x} ]; 
then 
  declare stack_vars=(); 
fi

# Determine the BASH source (SOURCING_INVOCATION)
(return 0 2>/dev/null) &&
stack_vars[${#stack_vars[@]}]=1 || 
stack_vars[${#stack_vars[@]}]=0

# Determine the exectuable directory (DIR)
DIR_SRC="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR_SRC}" ]];
then
  DIR_SRC="${PWD}";
fi

# Convert any relative paths into absolute paths
DIR_SRC=$(cd ${DIR_SRC}; printf %s. "$PWD")
DIR_SRC=${DIR_SRC%?}

# Copy over the DIR source and remove the temporary variable
stack_vars[${#stack_vars[@]}]=${DIR_SRC}
unset DIR_SRC

# Add Functional Aliases
SOURCING_INVOCATION () { echo "${stack_vars[${#stack_vars[@]}-2]}"; }
DIR () { echo "${stack_vars[${#stack_vars[@]}-1]}"; }

################################################################################
#                               SCRIPT INCLUDES                                #
################################################################################
. "$(DIR)/create_bundle_dir.sh"

################################################################################
#                                  FUNCTIONS                                   #
################################################################################
#===============================================================================
# This function will convert a relative path into an absolute path.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - relPath] A relative path
#
# OUTPUTS:
#   absPath - The absolute path
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
REL_TO_ABS_PATH () {
  local relPath="${1}"

  # Convert any relative paths into absolute paths
  local TMP_ABS_PATH=$(cd ${relPath}; printf %s. "$PWD")
  TMP_ABS_PATH=${TMP_ABS_PATH%?}

  # Return the absolute path
  echo "${TMP_ABS_PATH}"
}

#===============================================================================
# This function will grab this script's working directory as an absolute path.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - N/A] N/A
#
# OUTPUTS:
#   scriptDir - The absolute script directory path
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
SCRIPT_DIR () {
  # Determine the exectuable directory (DIR)
  local TMP_DIR_SRC="${1}"
  if [[ ! -d "${TMP_DIR_SRC}" ]];
  then
    TMP_DIR_SRC="${PWD}";
  fi

  echo $(REL_TO_ABS_PATH "${TMP_DIR_SRC}")
}

#===============================================================================
# This function will create an archived bundle from a given directory including 
# all utility scripts.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - srcDir] The source directory
#   [2 - completeBundleName] The name for the output bundle
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
create_bundle ()
{
  local srcDir="$(REL_TO_ABS_PATH ${1})"
  local completeBundleName=${2-"Bundle"}

  local SCRIPT_SRC="${BASH_SOURCE%/*}"
  local CUR_DIR=$(SCRIPT_DIR ${SCRIPT_SRC})
  local srcPath=$(REL_TO_ABS_PATH "${CUR_DIR}/..")
  local bundlesDir="_bundles"
  local utilsDir="Utility-Scripts"
  local bundlesPath="${srcPath}/${bundlesDir}"
  local utilsPath="${srcPath}/${utilsDir}"

  # Cleanup the previous bundle
  rm -rf "${bundlesPath}/${utilsDir##*/}" 2> /dev/null
  rm -f "${bundlesPath}/${utilsDir##*/}.zip" 2> /dev/null

  # Create the Utilities Bundle
  $(create_bundle_dir \
    "$(REL_TO_ABS_PATH ${srcPath})" \
    "./${utilsDir}" \
    "./${bundlesDir}" \
    "${utilsDir##*/}" \
    'LICENSE*' \
    true \
  )
  $(create_bundle_dir \
    "$(REL_TO_ABS_PATH ${srcPath})" \
    "./${utilsDir}" \
    "./${bundlesDir}" \
    "${utilsDir##*/}" \
    '*.sh' \
    true \
  )

  # Zip up the bundle and move it up a level
  $(cd "${bundlesPath}/${utilsDir##*/}" && 
    zip -rq "${utilsDir##*/}" . && 
    mv "${utilsDir##*/}.zip" ../ \
  )

  # Cleanup the previous bundle
  rm -rf "${bundlesPath}/${srcDir##*/}" 2> /dev/null
  rm -f "${bundlesPath}/${srcDir##*/}.zip" 2> /dev/null

  # Create the Requested Bundle
  $(create_bundle_dir \
    "$(REL_TO_ABS_PATH ${srcPath})" \
    "./${srcDir##*/}" \
    "./${bundlesDir}" \
    "${srcDir##*/}" \
    'LICENSE*' \
    true \
  )
  $(create_bundle_dir \
    "$(REL_TO_ABS_PATH ${srcPath})" \
    "./${srcDir##*/}" \
    "./${bundlesDir}" \
    "${srcDir##*/}" \
    '*.sh' \
    true \
  )

  # Zip up the bundle and move it up a level
  $(cd "${bundlesPath}/${srcDir##*/}" && 
    zip -rq "${srcDir##*/}" . && 
    mv "${srcDir##*/}.zip" ../ \
  )

  # Cleanup the previous bundle
  rm -rf "${bundlesPath}/${completeBundleName}" 2> /dev/null
  rm -f "${bundlesPath}/${completeBundleName}.zip" 2> /dev/null

  # Create the Complete Bundle
  local TMP_BUNDLE_DIR="_bundle"
  $(create_bundle_dir \
    "$(REL_TO_ABS_PATH ${bundlesPath}/${utilsDir##*/})" \
    "./${utilsDir##*/}" \
    "../${TMP_BUNDLE_DIR}" \
    "${completeBundleName}" \
    '*' \
    true \
  )
  $(create_bundle_dir \
    "$(REL_TO_ABS_PATH ${bundlesPath}/${srcDir##*/})" \
    "./${srcDir##*/}" \
    "../${TMP_BUNDLE_DIR}" \
    "${completeBundleName}" \
    '*' \
    true \
  )

  # Zip up the bundle and move it up a level
  $(cd "${bundlesPath}/${TMP_BUNDLE_DIR}" && 
    zip -rq "${completeBundleName##*/}" . && 
    mv "${completeBundleName##*/}.zip" ../ \
  )

  # Cleanup the intermediate directories
  rm -rf "${bundlesPath}/${utilsDir##*/}" 2> /dev/null
  rm -rf "${bundlesPath}/${srcDir##*/}" 2> /dev/null
  rm -rf "${bundlesPath}/${completeBundleName}" 2> /dev/null
  rm -rf "${bundlesPath}/${TMP_BUNDLE_DIR}" 2> /dev/null
}

################################################################################
#                               SCRIPT EXECUTION                               #
################################################################################
#===============================================================================
# This section will execute if the script is invoked from the terminal rather 
# than sourced into another script as a function.  If the first parameter is 
# "auto_skip" then any prompts will be bypassed.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [ALL] All arguments are passed into the script's function except the first 
#         if it is "auto_skip".
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
if [ $(SOURCING_INVOCATION) = 0 ];
then
  # Print a copyright/license header
  cat << EOF
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| Copyright © 2020 - 2021, Jack Thorp and associated contributors.  |
|          This program comes with ABSOLUTELY NO WARRANTY.          |
|   This is free software, and you are welcome to redistribute it   |
|                     under certain conditions.                     |
|        See the GNU General Public License for more details.       |
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF

  if [ "${1}" = "auto_skip" ]
  then
    # Remove the auto_skip parameter
    shift

    # Start the script
    create_bundle "${@}"
  else
    # Start the script
    create_bundle "${@}"
  fi
fi

################################################################################
#                                SCRIPT TEARDOWN                               #
################################################################################
#===============================================================================
# This section will remove the "Process Global" variables from the stack
#===============================================================================
unset stack_vars[${#stack_vars[@]}-1] # DIR
unset stack_vars[${#stack_vars[@]}-1] # SOURCING_INVOCATION