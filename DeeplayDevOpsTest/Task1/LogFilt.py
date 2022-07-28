#!/usr/bin/python
import re

def GetSID(line):
    SID = re.compile(r'\=\/[A-Za-z0-9_-]*\/')
    return SID.search(line)[0]

filesrc = open("log.txt", "r")
file_content = filesrc.read().split("\n")
SIDs = []

sid = ""
for i in file_content:
    if "10.1.192.38" in i:
        sid = GetSID(i)
        SIDs.append(sid[2:len(sid)-1])
print(sorted(SIDs))
filesrc.close()
