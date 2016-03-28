

import re
import requests
import json
import datetime,time
import sys
#import grovepi
import random


url          = 'http://192.168.101.22:61061/inject/Sensors/CQ1/Data_Stream'
headers      = {'Content-Type': 'application/xml'}


try:
  sound = float(sys.argv[1])
  if sound == 0:
    sound = random.randint(200,230)
except:
  sound = random.randint(200,230)


try:
  light = float(sys.argv[2])
  if light == 0:
    light = random.randint(180,190)
except:
  light = random.randint(180,190)


sound = random.randint(200,230)
sound0      = sound

light0      = light

distance    = float(random.randint(45,55)) / 10
distance0   = distance

temp        = float(random.randint(680,780)) / 10
temp0       = temp

humidity    = random.randint(13,16)
humidity0   = humidity


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


counter         = counter + 1
current_time    = re.sub('\..+','',str(datetime.datetime.now()))
sound           = zsimulate(sound0,sound,50,500,5)
light           = zsimulate(light0,light,10,500,5)
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
            <id key='true'>'''  + str(current_time) + str(counter)     + '''</id>
            <location>Lobby</location>
            <timestamp>'''      + str(current_time)     + '''</timestamp>  
            <sound>'''          + str(sound)            + '''</sound>
            <light>'''          + str(light)            + '''</light>
            <distance>'''       + str(distance)         + '''</distance>
            <temperature>'''    + str(temp)             + '''</temperature>
            <humidity>'''       + str(humidity)         + '''</humidity>
        </event>
    </events>'''), headers=headers)


#ZEND

