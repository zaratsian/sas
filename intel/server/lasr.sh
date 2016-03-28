

export DFESP_HOME="/home/dtz001/sas/SASEventStreamProcessingEngine/3.1.0"
export LD_LIBRARY_PATH="/home/dtz001/sas/SASEventStreamProcessingEngine/3.1.0/lib"


$DFESP_HOME/bin/dfesp_lasr_adapter -k sub -h "dfESP://192.168.10.200:61083/Sensors/CQ1/Data_Stream?snapshot=true" -H 10.38.15.213:10010 -t hps.danz1 -X $DFESP_HOME/bin/tklasrkey.sh -n true -a 5 -A 5