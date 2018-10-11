#!/bin/bash

function checkENV()
{
    condition=${1}
    ps -ef | grep "jar" | grep "adminservice" | grep "${condition}" || exit 1
    ps -ef | grep "jar" | grep "configservice" | grep "${condition}" || exit 1
}



# portal
if [[ -n "${PORTAL_DB}" ]];then
    ps -ef |grep jar |grep portal || exit 1
fi

# dev
if [[ -n "${DEV_DB}" ]];then
    checkENV dev
fi

# fat
if [[ -n "${FAT_DB}" ]];then
    checkENV fat
fi

# uat
if [[ -n "${UAT_DB}" ]];then
    checkENV uat
fi

# pro
if [[ -n "${PRO_DB}" ]];then
    checkENV pro
fi
