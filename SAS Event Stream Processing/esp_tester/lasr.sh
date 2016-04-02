

export DFESP_HOME="/opt/SASEventStreamProcessingEngine/3.1.0"
export LD_LIBRARY_PATH="/opt/SASEventStreamProcessingEngine/3.1.0/lib"


$DFESP_HOME/bin/dfesp_lasr_adapter -k sub -h "dfESP://10.38.15.100:61053/project1/cq1/copy1?snapshot=true" -H 10.61.246.30:10010 -t dz_from_esp3 -X $DFESP_HOME/bin/tklasrkey.sh -n true -a 10 &


# REQUIRED
# -k pub | sub
# -h dfESP publish and subscribe standard URL in the form dfESP://host:port/project/continuousquery/window (Note: You can specify multiple URLs.)
#       You must append the following for subscribers:
#       ?snapshot=true|false
#       ?collapse=true|false
# -H Specify the SAS LASR Analytic Server URL in the form “host:port”
# -t Specify the full name of the LASR table
# -X Specifies the path to tklasrkey.sh


# OPTIONAL
# -n true|false Specify whether to create-recreate a LASR table
# -A Specify the number of observations to commit to the server. A value < 0 specifies the time in seconds between auto-commit operations