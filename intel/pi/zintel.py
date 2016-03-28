


import re
import requests
import json
import datetime,time
import sys
import grovepi


try:
    gateway = sys.argv[1]
except:
    gateway = '192.168.1.1'


url          = 'http://104.236.5.72:61061/inject/Sensors/CQ1/Data_Stream'
headers      = {'Content-Type': 'application/xml'}




port_sound          = 0     # port A0   Analog Input
port_light          = 1     # port A1   Analog Input

port_temp           = 5     # port D3   Digital Input
port_ultrasonic     = 6     # port D4   Digital Input


counter       = 0

last_sound    = 0
last_light    = 0
last_distance = 0
last_temp     = 0
last_humidity = 0

while True:
    time.sleep(0.25)
    try:
        counter      = counter + 1
        #current_time = re.sub('[ ]+',':',re.sub('\..+','',str(datetime.datetime.now())))
        current_time = re.sub('\..+','',str(datetime.datetime.now()))
        sound           = grovepi.analogRead(port_sound)
        light           = grovepi.analogRead(port_light)
        distance        = grovepi.ultrasonicRead(port_ultrasonic) / float(12*2.54)
        [temp,humidity] = grovepi.dht(port_temp,0)
        temp = (temp * (9/float(5))) + 32
        
        if sound <= 0:
            sound = last_sound
        last_sound = sound
        
        if light <= 0:
            light = last_light
        last_light = light
        
        if distance <= 0:
            distance = last_distance
        last_distance = distance
        
        if temp <= 0:
            temp = last_temp
        last_temp = temp
        
        if humidity <= 0:
            humidity = last_humidity
        last_humidity = humidity
        
        requests.post(url, data=str('''
            <events>
                <event>
                    <opcode>p</opcode>
                    <id key='true'>'''  + str(current_time)     + '''</id>
                    <location>pi106</location>
                    <timestamp>'''      + str(current_time)     + '''</timestamp>  
                    <sound>'''          + str(sound)            + '''</sound>
                    <light>'''          + str(light)            + '''</light>
                    <distance>'''       + str(distance)         + '''</distance>
                    <temperature>'''    + str(temp)             + '''</temperature>
                    <humidity>'''       + str(humidity)         + '''</humidity>
                </event>
            </events>'''), headers=headers)
    except:
        print 'error'

#ZEND

