

export DFESP_HOME="/home/dtz001/sas/SASEventStreamProcessingEngine/3.1.0"
export LD_LIBRARY_PATH="/home/dtz001/sas/SASEventStreamProcessingEngine/3.1.0/lib"


$DFESP_HOME/bin/dfesp_xml_server -model C:\Users\dazara\Dropbox\sas\esp\projects\intel\gateway\model.xml -http-admin 61061 -http-pubsub 61062 -pubsub 61063 -messages $DFESP_HOME/etc/xml/messages -loglevel esp=trace &


