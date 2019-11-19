#!/usr/bin/env python3
from bs4 import BeautifulSoup
import requests
import time
import argparse

# A script to notify you by text or email when a class opens up.
# Uses Twilio only for text notifications, so you'll have to set up a twilio account and get the corresponding info there
# For email notifications, an SMTP email server must be installed, e.g. https://www.hostinger.com/tutorials/how-to-install-and-setup-mail-server-on-ubuntu/
# Will notify when course has opened/closed

parser = argparse.ArgumentParser()
parser.add_argument("-e", "--use_email", help="Use email instead of SMS for notifications", action="store_true")
args = parser.parse_args()

if args.use_email:
  import smtplib
  from email.message import EmailMessage
  ## CONFIG FOR EMAIL
  from_email = "admin@localhost"
  to_email = "me@example.com"
else:
  ## CONFIG FOR SMS
  from twilio.rest import Client
  # get token and sid from Twilio
  sid = ''
  tok = ''
  # phone no to recv texts at
  my_num='+1xxxxxxxxxx'
  # phone no from twilio to send texts from, make sure to set up first
  t_num='+1 yyy-yyy-yyyy'


marked=set()
# TODO: dictionary mapping to crns, make sure you get the correct CRNs or this won't work
crns = {'Machine Learning':'25687', 'Modern Web Development':'28730'}
# TODO: Change according to the term, to see formatting, look at links of the type https://class-search-secure.nd.edu/reg/srch/[...] for an example class.
term_str = '201920'
# Sometimes need to change threshold if a course has a certain number of seats that are reserved.
threshold = 0
msg = None

while True:
  for course, crn in crns.items():
    if crn in marked:
      time.sleep(1)
    html = requests.get('https://class-search-secure.nd.edu/reg/srch/ClassSearchServlet?CRN={}&TERM={}'.format(crn, term_str)).text
    s = BeautifulSoup(html, "html.parser")
    number = int(s.find_all('td')[5].text)
    if number > threshold and crn not in marked:
      print("!!!!!!!!!!!! FOUND")
      if args.use_email:
        msg = EmailMessage()
        msg.set_content('{} just opened up, {} spots,  CRN={}'.format(course, number, crn))
        msg['Subject'] = 'Course {} Opened up!'.format(course)
      else:
        c = Client(sid, tok)
        c.api.account.messages.create(to=my_num, from_=t_num, body='{} just opened up, {} spots,  CRN={}'.format(course, number, crn))
      marked.add(crn)
    elif number <= threshold and crn in marked:
      marked.remove(crn)
      if args.use_email:
        msg = EmailMessage()
        msg.set_content('{} just closed, {} spots left,  CRN={}'.format(course, number, crn))
        msg['Subject'] = 'Course {} closed'.format(course)
      else:
        c = Client(sid, tok)
        c.api.account.messages.create(to=my_num, from_=t_num, body='{} just closed, {} spots left,  CRN={}'.format(course, number, crn))

    if msg != None:
      msg['From'] = from_email
      msg['To'] = to_email
      s = smtplib.SMTP('localhost')
      s.send_message(msg)
      s.quit()
      msg = None
    
    time.sleep(1)
