
#######################################################################################################################
#
#   Downlaod SAS Download Manager
#
#######################################################################################################################
http://image1.unx.sas.com/tools/esdclient/clientdownload.php?path=/usr/local/www/data/web/installdepot/exe/esdclient/current/lax/www&file=esdclient__94360__lax__xx__web__1



#######################################################################################################################
#
#   Run the SAS Download Manager
#   Referece the "Order Number" and "Installation Key" within the SAS ESD Software Order Email
#
#######################################################################################################################
cp /tmp/esdclient__94360__lax__xx__web__1 ~/.
cd ~/.
./esdclient__94360__lax__xx__web__1 -- -console

# NOTE: Within the SAS Download Manager, you can place the software in a directory of your choice.



#######################################################################################################################
#
#   Install SAS Software
#
#######################################################################################################################
cd </directory/where/you/installed_sas>  # This is from the above step.
./setup.sh -console




#ZEND
