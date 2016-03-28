

import re
import requests
import json
import datetime,time
import sys
#import grovepi
import random


url          = 'http://45.55.207.56:61061/inject/Sensors/CQ1/Data_Stream'
headers      = {'Content-Type': 'application/xml'}


sound       = 245
sound0      = 245

light       = 178
light0      = 178

distance    = 5.1
distance0   = 5.1

temp        = 73.4
temp0       = 73.4

humidity    = 15
humidity0   = 15


def zsimulate(value0,value,range_low,range_high,tolerance):
    if value < range_low:
        value = value + (float(random.randint(1,tolerance*100)) / 100)
    elif value > range_high:
        value = value + (float(random.randint(-tolerance*100,-1)) / 100)
    else:
        value = value + (float(random.randint(-tolerance*100,tolerance*100)) / 100)
    
    return value


port_sound          = 0     # port A0   Analog Input
port_light          = 1     # port A1   Analog Input

port_temp           = 3     # port D3   Digital Input
port_ultrasonic     = 4     # port D4   Digital Input


counter       = 10000

last_sound    = 0
last_light    = 0
last_distance = 0
last_temp     = 0
last_humidity = 0

while True:
    time.sleep(0.25)
    counter         = counter + 1
    current_time    = re.sub('\..+','',str(datetime.datetime.now()))
    sound           = zsimulate(sound0,sound,200,400,5)
    light           = zsimulate(light0,light,160,190,2)
    distance        = zsimulate(distance0,distance,5,15,1)
    temp            = zsimulate(temp0,temp,65,85,1)
    humidity        = zsimulate(humidity0,humidity,1,50,1)
    
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


#ZEND

