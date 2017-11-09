#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

set -eu

if [[ "$(id -u)" != "0" ]]; then
        echo "Error: must run with root"
        exit 1
fi

############################################################
#
#       变量
#
############################################################
FUNCTION_DIR="/usr/local/lib"

HOLD_FUNCTION="myfn_standard"

############################################################
#
#       函数
#
############################################################
remove()
{
        local DIR="$1"
        local FILE=
        local FILE_PATH=
        
        for FILE in "$@"; do
                
                if [[ "$FILE" == "$1" ]]; then
                        continue 1
                fi
                
                FILE_PATH="${DIR}/${FILE}"
                
                if [[ -f "$FILE_PATH" ]]; then
                        rm -rf "$FILE_PATH"
                        echo "remove: ${FILE_PATH}"
                fi
                
        done
}

############################################################
#
#       操作
#
############################################################
remove "$FUNCTION_DIR" ${HOLD_FUNCTION}

############################################################
#
#       结束
#
############################################################
