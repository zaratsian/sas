
import re
import requests
import json
import datetime
import sys
import grovepi
import time

url          = 'http://192.168.1.1:61061/inject/Sensors/CQ1/Data_Stream_Fast'
headers      = {'Content-Type': 'application/xml'}



port_sound          = 2     # port A0   Analog Input
port_light          = 0     # port A1   Analog Input

port_temp           = 6     # port D3   Digital Input
port_ultrasonic     = 5     # port D4   Digital Input


counter       = 1000

last_sound    = 0
last_light    = 0
last_distance = 0
last_temp     = 0
last_humidity = 0

while True:
    #time.sleep(0.10)
    try:
        counter      = counter + 1
        #current_time = re.sub('[ ]+',':',re.sub('\..+','',str(datetime.datetime.now())))
        current_time = re.sub('\..+','',str(datetime.datetime.now()))
        sound           = grovepi.analogRead(port_sound)
        #light           = grovepi.analogRead(port_light)
        #distance        = grovepi.ultrasonicRead(port_ultrasonic) / float(12*2.54)
        #[temp,humidity] = grovepi.dht(port_temp,0)
        #temp = (temp * (9/float(5))) + 32
        
        #if sound <= 0:     
        #    sound = last_sound
        #last_sound = sound
        
        requests.post(url, data=str('''
            <events>
                <event>
                    <opcode>p</opcode>
                    <id key='true'>'''  + str(current_time) + str(counter)  + '''</id>
                    <location>pi107</location>
                    <timestamp>'''      + str(current_time)     + '''</timestamp>
                    <attribute>sound           </attribute>  
                    <value>'''          + str(sound)            + '''</value>
                </event>
            </events>'''), headers=headers)
    except:
        print 'error'
