
export DFESP_HOME="/opt/SASEventStreamProcessingEngine/3.1.0"
export LD_LIBRARY_PATH="/opt/SASEventStreamProcessingEngine/3.1.0/lib"

$DFESP_HOME/bin/dfesp_xml_server -model file:////usr/dz/esp_tester/model.xml http-admin 61051 -http-pubsub 61052 -pubsub 61053 -d %Y-%m-%d %H:%M:%S -messages $DFESP_HOME/etc/xml/messages &