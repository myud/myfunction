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
URL1="https://gitee.com/mydownload/myfunction/raw/master"
URL2="src"
FUNCTION_DIR="/usr/local/lib"
HOLD_FUNCTION="myfn_standard"

############################################################
#
#       函数
#
############################################################
download()
{
        local DIR="$1"
        local URL1="$2"
        local URL2="$3"
        local FILE=
        local FILE_PATH=
        local NUM=
        
        mkdir -p ${DIR}
        
        for FILE in "$@"; do
                
                if [[ "$FILE" == "$1" ]] || [[ "$FILE" == "$2" ]] || [[ "$FILE" == "$3" ]]; then
                        continue 1
                fi
                
                FILE_PATH="${DIR}/${FILE}"
                
                if [[ -f "$FILE_PATH" ]]; then
                        rm -rf "$FILE_PATH"
                fi
                
                for (( NUM=0; NUM < 10; NUM++ )); do
                        
                        if [[ -s "$FILE_PATH" ]] \
                        && (  ! grep "^<title>" "$FILE_PATH" &> /dev/null ) \
                        && (  ! grep "^404" "$FILE_PATH" &> /dev/null ); then
                                break 1
                        else
                                curl -sSo "$FILE_PATH" ${URL1}/${URL2}/${FILE}
                        fi
                        
                done
                
                if [[ "$NUM" == "10" ]]; then
                        echo "Error: ${FILE} download failed"
                        exit 1
                fi
                
                if [[ "$DIR" == "/usr/local/bin" ]]; then
                        chmod 755 "$FILE_PATH"
                fi
                
                echo "download: ${FILE}"
                
        done
}

############################################################
#
#       操作
#
############################################################
download "$FUNCTION_DIR" "$URL1" "$URL2" ${HOLD_FUNCTION}

############################################################
#
#       结束
#
############################################################
