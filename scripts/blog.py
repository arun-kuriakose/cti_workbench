import json
import os

with open('$INSTALLATION_DIR/conf/feeds.json') as jsn:
  data = json.load(jsn)
  for r in data['feeds']:
    fo = open('rssfeeds.txt','a')
    fo.write(r['rss']   +os.linesep)
    fo.close()
