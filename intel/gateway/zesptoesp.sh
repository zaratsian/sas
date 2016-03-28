

export DFESP_HOME="/home/dtz001/sas/SASEventStreamProcessingEngine/3.1.0"
export LD_LIBRARY_PATH="/home/dtz001/sas/SASEventStreamProcessingEngine/3.1.0/lib"


$DFESP_HOME/bin/dfesp_esp_adapter -s "dfESP://192.168.1.3:61063/Project1/CQ1/Source1?snapshot=true?collapse=true" -p dfESP://192.168.1.2:61083/Project1/CQ1/Source1


