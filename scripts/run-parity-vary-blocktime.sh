function chapter {
    echo 
    echo
    echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    echo @@@ $1
    echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
}  

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo; echo "\"${last_command}\" command filed with exit code $?."' EXIT
#


chapter "parity - vary blocktime"
echo

PARITY_VERSION=v2.3.4

BLOCKTIMES="32 16 8 4 2 1"

cp networks/parity-configure.sh networks/parity-configure_BACKUP.sh

for BT in $BLOCKTIMES; do
    
    chapter "BLOCKTIME $BT seconds"
    cp networks/parity-configure_BACKUP.sh networks/parity-configure.sh
    sed -i "s/BLOCKTIME=10/BLOCKTIME="$BT"/" networks/parity-configure.sh
    # cat networks/parity-configure.sh | grep BLOCKTIME
    networks/parity-configure-aura.sh $PARITY_VERSION
    CH_TXS=20000 CH_THREADING="threaded2 20" ./run.sh "Parity-aura-BT"$BT"s" parity

done

cp networks/parity-configure_BACKUP.sh networks/parity-configure.sh


chapter "composite script ending here"
echo see folder results/runs/
echo


# switch off the trap
set +e
trap '' EXIT
