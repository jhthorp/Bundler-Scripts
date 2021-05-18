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
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
SCRIPT_DIR () {
  # Determine the exectuable directory (DIR)
  declare DIR_SRC="${BASH_SOURCE%/*}"
  if [[ ! -d "${DIR_SRC}" ]];
  then
    DIR_SRC="${PWD}";
  fi

  # Convert any relative paths into absolute paths
  DIR_SRC=$(cd ${DIR_SRC}; printf %s. "$PWD")
  DIR_SRC=${DIR_SRC%?}

  # Copy over the DIR source and remove the temporary variable
  echo "${DIR_SRC}"
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
  declare -r srcDir=${1}
  declare -r completeBundleName=${2-"Bundle"}

  declare -r CUR_DIR=$(SCRIPT_DIR)
  declare -r srcPath="${CUR_DIR}/.."
  declare -r bundlesDir="./_bundles"
  declare -r utilsDir="./Utility-Scripts"

  # Clenup the previous bundle
  rm -rf "${bundlesDir}/${utilsDir##*/}" 2> /dev/null
  rm -f "${bundlesDir}/${utilsDir##*/}.zip" 2> /dev/null

  # Create the Utilities Bundle
  $(create_bundle_dir \
    "${srcPath}" \
    "${utilsDir}" \
    "${bundlesDir}" \
    "${utilsDir##*/}" \
    'LICENSE*' \
    true \
  )
  $(create_bundle_dir \
    "${srcPath}" \
    "${utilsDir}" \
    "${bundlesDir}" \
    "${utilsDir##*/}" \
    '*.sh' \
    true \
  )

  # Zip up the bundle and move it up a level
  $(cd "${bundlesDir}/${utilsDir##*/}" && 
    zip -rq "${utilsDir##*/}" . && 
    mv "${utilsDir##*/}.zip" ../ \
  )

  # Clenup the previous bundle
  rm -rf "${bundlesDir}/${srcDir##*/}" 2> /dev/null
  rm -f "${bundlesDir}/${srcDir##*/}.zip" 2> /dev/null

  # Create the Requested Bundle
  $(create_bundle_dir \
    "${srcPath}" \
    "${srcDir}" \
    "${bundlesDir}" \
    "${srcDir##*/}" \
    'LICENSE*' \
    true \
  )
  $(create_bundle_dir \
    "${srcPath}" \
    "${srcDir}" \
    "${bundlesDir}" \
    "${srcDir##*/}" \
    '*.sh' \
    true \
  )

  # Zip up the bundle and move it up a level
  $(cd "${bundlesDir}/${srcDir##*/}" && 
    zip -rq "${srcDir##*/}" . && 
    mv "${srcDir##*/}.zip" ../ \
  )

  # Clenup the previous bundle
  rm -rf "${bundlesDir}/${completeBundleName}" 2> /dev/null
  rm -f "${bundlesDir}/${completeBundleName}.zip" 2> /dev/null

  # # Create the Complete Bundle
  $(create_bundle_dir \
    "${srcPath}" \
    "${bundlesDir}/${utilsDir##*/}" \
    "${bundlesDir}" \
    "${completeBundleName}" \
    '*' \
    true \
  )
  $(create_bundle_dir \
    "${srcPath}" \
    "${bundlesDir}/${srcDir##*/}" \
    "${bundlesDir}" \
    "${completeBundleName}" \
    '*' \
    true \
  )

  # # Zip up the bundle and move it up a level
  $(cd "${bundlesDir}/${bundlesDir##*/}" && 
    zip -rq "${completeBundleName##*/}" . && 
    mv "${completeBundleName##*/}.zip" ../ \
  )

  # Clenup the intermediate directories
  rm -rf "${bundlesDir}/${utilsDir##*/}" 2> /dev/null
  rm -rf "${bundlesDir}/${srcDir##*/}" 2> /dev/null
  rm -rf "${bundlesDir}/${bundlesDir##*/}" 2> /dev/null
  rm -rf "${bundlesDir}/${completeBundleName}" 2> /dev/null
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