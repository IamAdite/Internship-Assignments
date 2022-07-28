#!/usr/bin/python
import sys
import subprocess
import re

# function that removes escape sequence
def escape_ansi(line):  
    ansi_escape =re.compile(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]')
    return ansi_escape.sub('', line)

numbers = ['0','1','2','3','4','5','6','7','8','9']

RAWoutput = subprocess.check_output(["semgrep", "--config", "./config.yaml", sys.argv[1]]).decode("UTF-8").split("\n") 

dirout = {}

fileOut = open(sys.argv[2], 'w')

number = []
for i in RAWoutput:
    i = i.replace(" ", "")
    if sys.argv[1][2:] in i:
        currdir = escape_ansi(i) 
        number = []
    if len(i) > 0 and i[0] in numbers: #if the line contains line number of vulnarabilty
        vuln = i[i.find("┆")+1:]
        file_src = open(currdir, "r")
        file_content = file_src.read().split("\n")
        for j in file_content: #couinting columns
            column = 1
            for k in j:
                if k == " ":
                    column+=1
                elif k == '\t':
                    column+=8
                else:
                    break
            j = j.replace(" ","")
            if escape_ansi(vuln) in escape_ansi(j):
                break
        pair = [int(i[:i.find("┆")]),column] # forming a pair of line&column
        number.append(pair)
        dirout[currdir] = number
        file_src.close()

count = 1
for key in dirout:
    fileOut.write(f"{count}. {key} | At: ")
    for i in dirout[key]:
        fileOut.write(f"{i[0]}-{i[1]}; ")
    fileOut.write("\n")
    count+=1

fileOut.close()