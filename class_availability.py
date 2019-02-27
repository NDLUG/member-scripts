#!/usr/bin/env python3
from bs4 import BeautifulSoup
import requests
import time
from twilio.rest import Client

# A script to notify you by text when a class opens up.
# Uses Twilio, so you'll have to set up a twilio account and get the corresponding info there

# get token and sid from Twilio
sid = ''
tok = ''
# phone no to recv texts at
my_num='+1xxxxxxxxxx'
# phone no from twilio to send texts from, make sure to set up first
t_num='+1 yyy-yyy-yyyy'

marked=set()
# dictionary mapping to crns
crns = {'Course Name':'12345', 'Other Course Name':'54321'}
# Change according to the term, to see formatting, look at links of the type https://class-search-secure.nd.edu/reg/srch/[...] for an example class.
term_str = '201820'
# Sometimes need to change threshold if a course has a certain number of seats that are reserved.
threshold = 0

while True:
  for course, crn in crns.items():
    if crn in marked:
      time.sleep(1)
      continue
    html = requests.get('https://class-search-secure.nd.edu/reg/srch/ClassSearchServlet?CRN={}&TERM={}'.format(crn, term_str)).text
    s = BeautifulSoup(html, "html.parser")
    number = int(s.find_all('td')[5].text)
    if number > threshold:
      print("!!!!!!!!!!!! FOUND")
      c = Client(sid, tok)
      c.api.account.messages.create(to=my_num, from_=t_num, body='{} just opened up, {} spots,  CRN={}'.format(course, number, crn))
      marked.add(crn)
    else:
      print("{} found so far".format(len(marked)))
    time.sleep(1)
