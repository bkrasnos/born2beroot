#!/bin/bash
ARCH=$(uname -a)
CPU_PHYS=$(grep 'physical id' /proc/cpuinfo | wc -l)
VCPU=$(grep 'processor' /proc/cpuinfo | wc -l)
MEM_USE=$(free --mega | grep 'Mem' | awk '{printf("%d/%dMB (%.2f%%)", $3, $2, $3/$2*100)}')
DISK_USE=$(df --total --block-size=GB | grep 'total' | awk '{printf("%d/%dGB (%d%%)", $3, $2, $5)}')
CPU_LOAD=$(top -bn1 | grep 'Cpu(s):' | cut -c 9- | awk '{printf("%.1f%%", $1)}')
LAST_BOOT=$(who -b | cut -c 23-)
LVM_COUNT=$(lsblk | grep "lvm" | wc -l)
LVM_USE=$(if [ $LVM_COUNT -eq 0 ]; then echo no; else echo yes; fi)
CONNECTION=$(cat /proc/net/sockstat | awk '$1 == "TCP:" {print $3}')
USER_LOG=$(users | wc -w)
IP=$(hostname -I)
MAC=$(ip link | grep 'link/ether' | awk '{printf($2)}')
SUDO=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "
	#Architecture: $ARCH
	#CPU physical : $CPU_PHYS
	#vCPU : $VCPU
	#Memory Usage: $MEM_USE
	#Disk Usage: $DISK_USE
	#CPU load: $CPU_LOAD
	#Last boot: $LAST_BOOT
	#LVM use: $LVM_USE
	#Connections TCP : $CONNECTION ESTABLISHED
	#User log: $USER_LOG
	#Network: IP $IP($MAC)
	#Sudo : $SUDO cmd"
