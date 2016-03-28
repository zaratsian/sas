

export DFESP_HOME="/home/dtz001/sas/SASEventStreamProcessingEngine/3.1.0"
export LD_LIBRARY_PATH="/home/dtz001/sas/SASEventStreamProcessingEngine/3.1.0/lib"


$DFESP_HOME/bin/dfesp_smtp_adapter -h "dfESP://104.236.5.72:61062/Sensors/CQ1/Light_Alerts?snapshot=true?collapse=true" -m smtp.mail.com -u dannyocean11@mail.com -d dan.zaratsian@sas.com

