#!/bin/bash
#Author: Vito Colella
#How to use
#Create a file hostname.txt inside the directory with association machine user free_ram% free_cpu% free_fs%
#Create a file token.txt with telegram bot api token
#Create a file dist_list.txt with telegram_id to contact
#Example hostname.txt:host1 Vito 5 5 20
#                                         host2 Vito 10 10 50
#Example token.txt:aaaabbbbbcccc
#Example dist_list.txt: 12334
#                                           45566

function get_variables(){
        basedir=$(dirname $0)
        machine=$(echo $line | awk '{print $1}')
        user=$(echo $line | awk '{print $2}')
        free_ram_perc=$(echo $line | awk '{print $3}')
        free_cpu_perc=$(echo $line | awk '{print $4}')
        free_fs=$(echo $line | awk '{print $5}')
        busy_fs=$((100 - ${free_fs}))
}

function check_variables(){
        check_var=0
        if [[ ${free_ram_perc} -lt 0 ]] || [[ ${free_ram_perc} -gt 100 ]]
        then
                echo "Ram percentage value is not valid"
                check_var=1
        fi
        if [[ ${free_cpu_perc} -lt 0 ]] || [[ ${free_cpu_perc} -gt 100 ]]
        then
                echo "Cpu percentage value is not valid"
                check_var=1
        fi
        if [[ ${busy_fs} -lt 0 ]] || [[ ${busy_fs} -gt 100 ]]
        then
                echo "Free fs value is not valid"
                check_var=1
        fi
}

function check_alive(){
        ping -c 1 ${machine}
        alive=$?
}

function check_ram(){
        ret_ram=0
        mem_info=$(ssh -n ${user}@${machine} "cat /proc/meminfo | egrep 'MemTotal|MemAvailable'")
        total_mem=$(echo ${mem_info} | awk '{print $2}')
        free_mem=$(echo ${mem_info} | awk '{print $5}')
        free_perc=$((100*free_mem/total_mem))
        echo "free ram is: "${free_perc}
        if [[ ${free_ram_perc} -gt ${free_perc} ]]
        then
                ret_ram=1
        fi
}

function check_cpu(){
        ret_cpu=0
        cpu_info=$(ssh -n ${user}@${machine} "vmstat | tail -1")
        free_cpu=$(echo ${cpu_info} | awk '{print $15}')
        echo "free cpu is: "${free_cpu}
        if [[ ${free_cpu_perc} -gt ${free_cpu} ]]
        then
                ret_cpu=1
        fi
}

function check_fs(){
        ret_fs=0
        fs_info=$(ssh -n ${user}@${machine} "df -Ph" | awk "0 + \$5 >= ${busy_fs} { print }")
        echo "fs_info: "$fs_info
        if [[ ! -z ${fs_info} ]]
        then
                ret_fs=1
        fi
}

function report(){
        if [[ ${ret_ram} -eq 1 ]]
        then
                echo "Free ram percentage is: " ${free_perc} >>${basedir}/log.txt
        fi
        if [[ ${ret_cpu} -eq 1 ]]
        then
                echo "Free cpu percentage is: " ${free_cpu} >>${basedir}/log.txt
        fi
        if [[ ${ret_fs} -eq 1 ]]
        then
                echo "Full filesystems are: " ${fs_info} >>${basedir}/log.txt
        fi
}

function send_alert(){
        if [[ -s ${basedir}/log.txt ]]
        then
		token=$(cat ${basedir}/token.txt)
                message=$(cat ${basedir}/log.txt)
                url="https://api.telegram.org/bot${token}/sendMessage"
                cat ${basedir}/dist_list.txt | while read id
                do
                        curl -s -X POST ${url} -d chat_id=${id} -d text=${message}
                done
        fi
}

###################################################################
#main
###################################################################
cat ${basedi}r/hostname.txt | while read line
do
        echo $line
        check_variables
        get_variables
        if [[ ${check_var} -eq 0 ]]
        then
                >${basedir}/log.txt
                check_alive
                echo $alive
                if [[ ${alive} -eq 0 ]]
                then
                        check_ram
                        check_cpu
                        check_fs
                else
                        echo "Machine ${machine} doesn't respond to ping" >${basedir}/log.txt
                fi
                report
                send_alert
        fi
        echo "controllo della macchina ${machine} terminato"
done
