

export DFESP_HOME="/home/dtz001/SASEventStreamProcessingEngine/3.1.0/"
export LD_LIBRARY_PATH="/home/dtz001/SASEventStreamProcessingEngine/3.1.0/lib"


$DFESP_HOME/bin/dfesp_xml_server -model file:////home/dtz001/sas/zprojects/kiva/model.xml -http-admin 61051 -http-pubsub 61052 -messages $DFESP_HOME/etc/xml/messages &


