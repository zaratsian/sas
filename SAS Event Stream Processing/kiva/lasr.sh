

export DFESP_HOME="/home/dtz001/SASEventStreamProcessingEngine/3.1.0"
export LD_LIBRARY_PATH="/home/dtz001/SASEventStreamProcessingEngine/3.1.0/lib"


$DFESP_HOME/bin/dfesp_lasr_adapter -k sub -h "dfESP://45.55.207.56:61053/Project_1/Continuous_Query_1/Source_1?snapshot=true" -H 10.38.15.53:10010 -t hps.danz1 -X $DFESP_HOME/bin/tklasrkey.sh -n true -a 5 -A 5
