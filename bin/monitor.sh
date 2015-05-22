
#!/bin/bash

INTERFACES=`netstat -i | grep BMRU | grep -Eo '^[^ ]+' | paste -d " " - - - - - - - - - - - -`

declare -a arr=($INTERFACES)
declare -a OCTETOSRX=()
declare -a OCTETOSTX=()

for i in "${arr[@]}"
do   
   if [ -f /sys/class/net/${i}/statistics/rx_bytes ]; then 
	RX=`cat /sys/class/net/${i}/statistics/rx_bytes`
   	TX=`cat /sys/class/net/${i}/statistics/tx_bytes`
   else
	RX=0
	TX=0
   fi
   if [ -z "$RX" ]; then
	RX=0
   fi
   if [ -z "$TX" ]; then
	TX=0
   fi   
   #echo "Obtendo dado inicial para a interface $i $RX $TX..."   
   OCTETOSRX+=("$RX")
   OCTETOSTX+=("$TX")
done

#echo "Obtendo dado de cpu inicial..."
read cpu a b c previdle rest < /proc/stat
prevtotal=$((a+b+c+previdle))  
sleep 1
#echo "Obtendo dado de cpu final..."
read cpu a b c idle rest < /proc/stat
total=$((a+b+c+idle))

#echo "Obtendo quantidade de cpus..."
CPUQTT=`nproc`

CPU=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))

DISCOARRTMP=`df | tail -n +2` 
declare -a DISCOARR=()
while read -r line; do
    declare -a campos=($line)
    DISCOARR+=("{\"name\": \"${campos[0]}\", \"total\": ${campos[1]},\"used\": ${campos[2]} }")
done <<< "${DISCOARRTMP}"

MEMORIATMP=`free | head -n 2 | tail -n 1`
declare -a MEMORIA=($MEMORIATMP)

echo -ne "{\"interfaces\":["
let QTTOCTETS=${#OCTETOSRX[@]}-1
for (( i = 0 ; i < ${#OCTETOSRX[@]} ; i=$i+1 ));
    do
		echo -ne "{\"name\": \"${arr[${i}]}\", \"rx\": ${OCTETOSRX[${i}]}, \"tx\": ${OCTETOSTX[${i}]} }"
		if [ "$i" -lt "$QTTOCTETS" ]; then
			echo -ne ","
		fi
    done
echo -ne "],"
echo -ne "\"discos\":["
let QTTDISCOS=${#DISCOARR[@]}-1
for (( i = 0 ; i < ${#DISCOARR[@]} ; i=$i+1 ));
    do
		echo -ne "$DISCOARR"
		if [ "$i" -lt "$QTTDISCOS" ]; then
			echo -ne ","
		fi
    done
echo -ne "],"
echo -ne "\"processor\": {\"load\": $CPU, \"processors\": $CPUQTT },"
echo -ne "\"memoria\": { \"total\": ${MEMORIA[1]}, \"used\": ${MEMORIA[2]} }"
echo "}"