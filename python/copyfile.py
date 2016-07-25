import os;
import shutil;
import re;

def myRename(searchPath, savePath, suffix):
	filelist = os.listdir(searchPath) 
	for fileName in filelist:
		oldDir = os.path.join(searchPath, fileName)
		if os.path.isdir(oldDir): 
			if oldDir == savePath: 
				print "ignore", oldDir
				continue
			myRename(oldDir, savePath, suffix)
			continue
		matchObj = re.match("^.+\." + suffix + "$", fileName)
		# arrFilePara = os.path.splitext(fileName)
		# print arrFilePara[0],arrFilePara[1]
		if matchObj is None:
			print "ignore", oldDir
			continue
		matchObj = re.match('^([1-9]\d{4})', fileName)
		if matchObj is None:
			continue
		if not os.path.exists(savePath):
			os.makedirs(savePath)
		newFileName = matchObj.group(1) + "." + suffix
		newDir = os.path.join(savePath, newFileName)
		print "copy", oldDir, "to", newDir
		shutil.copy(oldDir, newDir)
		# os.rename(oldDir, newDir)

myRename(".", ".\\res", "ogg")
