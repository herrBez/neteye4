#!/usr/bin/python
# -*- coding: latin-1 -*-

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# or version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# you should have received a copy of the GNU General Public License
# along with this program (or with Nagios);  if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA
#
# (C) Würth Phoenix GmbH
# 3. April 2019: Patrick Zambelli <patrick.zambelli@wuerth-phoenix.com>
# Version 0.1.0

# Scripts to drop all series for a specific tag filter

import os, sys, re
#from optik import OptionParser
from optparse import OptionParser


RET_CODE = 3
RET_STRING = "Unknown"

def get_usage():
   print "Usage: influxdb_cleanup_series.sh -H <hostname>"
   print " "
   print "Please specify the hostname to remove from all series: perfdata, monitoring_perfdata, monitoring_availability. "
   print " "
   sys.exit(RET_CODE)

parser = OptionParser(add_help_option=0)

parser.add_option("-h", "--help", action="callback", callback=get_usage)
parser.add_option("-H", "--hostname", action="store", type="str", dest="hostname", default=False)

(options, args) = parser.parse_args()

hostname = options.hostname

if hostname == False:
   print "Please define a hostname"
   get_usage()
   sys.exit(RET_CODE)

result = re.search(r'[*()!+^&]*\S*', hostname)
if result != None:
   print "Identified use of illegal character"
   sys.exit(RET_CODE)

print "The hostname is " + hostname
sys.exit(RET_CODE)

#The influx queries
# here are the 3 commands you have to launch (on the active node) to delete all data of removed host from influx:
#
#curl -POST 'http://localhost:8086/query?pretty=true' --data-urlencode "db=perfdata" --data-urlencode "q=drop series where host = '1401fm0021';"
#curl -POST 'http://localhost:8086/query?pretty=true' --data-urlencode "db=monitoring_perfdata" --data-urlencode "q=drop series where host = '1401fm0021';"
#curl -POST 'http://localhost:8086/query?pretty=true' --data-urlencode "db=monitoring_outages" --data-urlencode "q=drop series where host = '1401fm0021';"
#
#
