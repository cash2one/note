import os;
import shutil;
import re;

def getFileInfo(indent, fileDir):
	strRes = ''
	filelist = os.listdir(fileDir) 
	filelist.sort()
	for file in filelist:
		nextDir = os.path.join(fileDir, file)
		if os.path.isdir(nextDir): 
			strRes += indent + '<Folder Name="' + file + '">' + '\n'
			strRes += getFileInfo(indent + '  ', nextDir)
			strRes += indent + '</Folder>' + '\n'
			continue
		if re.match("^.+\.(png|jpg)$", file, re.I) != None:
			strRes += indent + '<Image Name="' + file + '" />' + '\n'
			continue
		if re.match("^.+\.csd$", file, re.I) != None:
			strRes += indent + '<Project Name="' + file + '" />' + '\n'
			continue
		# .ttf
		strRes += indent + '<File Name="' + file + '" />' + '\n'
	return strRes

def initCssFile():
	strRes = '<Solution>' + '\n'
	strRes += '  <PropertyGroup Name="meishi" Version="2.0.6.0" Type="CocosStudio" />' + '\n'
	strRes += '  <SolutionFolder>' + '\n'
	strRes += '    <Group ctype="ResourceGroup">' + '\n'
	strRes += '      <RootFolder Name=".">' + '\n'
	strRes += getFileInfo('        ', 'cocosstudio')
	strRes += '      </RootFolder>' + '\n'
	strRes += '    </Group>' + '\n'
	strRes += '  </SolutionFolder>' + '\n'
	strRes += '</Solution>' + '\n'
	return strRes


output = open('meishi.ccs', 'w')
try:
	output.write(initCssFile())
	# output.writelines(initCssFile())
finally:
	output.close()

