

import re
import requests
import random
import datetime,time
import sys

host    = '10.38.12.36'

url     = 'http://' + str(host) + ':61051/inject/project1/cq1/source1'
headers = {'Content-Type': 'application/xml'}



try:
  field_value = sys.argv[1]
except:
  field_value = 'test'


data    = '''
<events>
    <event>
        <opcode>i</opcode>
        <ID key='true'>'''    +  str(random.randint(0,100000))                                + '''</ID>
        <Timestamp>'''        +  str(re.sub('\..+','',str(datetime.datetime.now())))  + '''</Timestamp>
        <Field>'''            +  str(random.randint(0,100000)) + ' ' + str(field_value)       + '''</Field>
    </event>
</events>
'''

data = data.strip()

inject = requests.post(url, data=data, headers=headers)
inject
inject.content

#ZEND

