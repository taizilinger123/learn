# !/usr/bin/env python
# coding:utf-8
import json
from urllib2 import urlopen
from urllib2 import Request
import sys


def jsonfile2dict(filename):
    if None == filename:
        return None
    fp = open(filename, "r")
    dic = json.load(fp)
    fp.close()
    return dic


def upload_data(filename, project):
    req = Request("http://ctsautotest2.sh.intel.com/api/storedata/" + project)
    req.add_header("Content-Type", "application/json")
    r = jsonfile2dict(filename)
    r_json = json.dumps(r).encode('utf-8')
    res = urlopen(req, r_json)
    print("Server response: {0}".format(res.getcode()))


if __name__ == "__main__":
    if len(sys.argv) == 3:
        project = sys.argv[1].strip().lower()
        filename = sys.argv[2]
    else:
        print("Usage: python <program> <torch|theano> <jsonfile>")
        sys.exit(1)
    upload_data(filename, project)
