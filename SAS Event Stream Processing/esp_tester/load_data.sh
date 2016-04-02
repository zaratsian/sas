
export DFESP_HOME="/opt/SASEventStreamProcessingEngine/3.1.0/"
export LD_LIBRARY_PATH="/opt/SASEventStreamProcessingEngine/3.1.0/lib"

$DFESP_HOME/bin/dfesp_fs_adapter -k pub -h dfESP://10.38.12.36:61053/project1/cq1/source1 -f /usr/dz/esp_tester/data.csv -t csv &
