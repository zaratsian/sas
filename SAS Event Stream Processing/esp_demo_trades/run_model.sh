
export DFESP_HOME="/usr/dz/SASEventStreamProcessingEngine/3.1.0/"
export LD_LIBRARY_PATH="/usr/dz/SASEventStreamProcessingEngine/3.1.0/lib"

/usr/dz/SASEventStreamProcessingEngine/3.1.0/bin/dfesp_xml_server -model file:////usr/dz/SASEventStreamProcessingEngine/3.1.0/examples/xml/trades_xml/model.xml -http-admin 61001 -http-pubsub 61002 -messages /usr/dz/SASEventStreamProcessingEngine/3.1.0/etc/xml/messages &


/usr/dz/SASEventStreamProcessingEngine/3.1.0/bin/dfesp_fs_adapter -k pub -h dfESP://danzaratsian.com:55505/trades_proj/trades_cq/Traders -f /usr/dz/SASEventStreamProcessingEngine/3.1.0/examples/xml/trades_xml/traders.csv -t csv &


/usr/dz/SASEventStreamProcessingEngine/3.1.0/bin/dfesp_fs_adapter -k pub -h dfESP://danzaratsian.com:55505/trades_proj/trades_cq/Trades -f /usr/dz/SASEventStreamProcessingEngine/3.1.0/examples/xml/trades_xml/trades.csv -t csv -d %d/%b/%Y:%H:%M:%S &


