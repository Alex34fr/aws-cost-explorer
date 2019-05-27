#!/usr/bin/env python
import subprocess
import json
import datetime
import locale

months = {"01":"January", "02":"February", "03":"March", "04":"April", "05":"May", "06":"June", "07":"July", "08":"August", "09":"September", "10":"October", "11":"November", "12":"December"}
datem = datetime.datetime.today().strftime("%Y-%m")
dateparts = datem.split("-")
year = dateparts[0]
month = dateparts[1]
nextdateparts = (datetime.date.today() + datetime.timedelta(1*365/12)).isoformat().split("-")
nextyear = nextdateparts[0]
nextmonth = nextdateparts[1]
cmd = 'aws ce get-cost-and-usage --time-period Start={}-{}-01,End={}-{}-01 --granularity MONTHLY --metrics "UnblendedCost"'
output = subprocess.check_output(cmd.format(year, month, nextyear, nextmonth), shell=True)
output = output.decode('utf-8')
output = json.loads(output)
amount = output['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']
amount = float(amount)
locale.setlocale(locale.LC_ALL, 'en_US')
price = locale.currency( amount, grouping = True )
print("AWS Costs for Current Month ("+months[month]+"):", price)
