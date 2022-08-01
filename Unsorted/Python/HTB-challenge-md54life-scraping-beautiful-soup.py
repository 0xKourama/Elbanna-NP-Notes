import requests
from bs4 import BeautifulSoup
import hashlib

url = "http://188.166.148.4:31436/"

for i in range(100):
        g = requests.get(url = url)
        soup = BeautifulSoup(g.text, 'html.parser')
        mystring = soup.h3.string
        phpsessid = g.cookies.get_dict()['PHPSESSID']
        mymd5 = hashlib.md5(mystring.encode('utf-8')).hexdigest()
        stuff = {'hash':f"{mymd5}"}
        cookies = {'PHPSESSID':f"{phpsessid}"}
        p = requests.post(url, data = stuff, cookies = cookies)
        soup2 = BeautifulSoup(p.text, 'html.parser')
        print (soup2.p.string)