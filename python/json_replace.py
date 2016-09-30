import json
import sys
import os


try:
	fin = open(sys.argv[1], 'r+')
	#dict = json.load(fin) #success
	dict = json.loads(fin.read())
	fin.close()
	dict[sys.argv[3]] = sys.argv[4]
	fout = open(sys.argv[2], 'w+')
	#json.dump(dict, fout) #failure
	fout.write(json.dumps(dict))
	fout.close()
	print "change file: \"" + sys.argv[2] + "\": "
	print sys.argv[3] + " = " + sys.argv[4]
	print "ok"
except Exception,e:
	print "error: "
	print e




#json_replace.py oldfile newfile key value 
