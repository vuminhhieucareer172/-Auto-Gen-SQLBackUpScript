import os
import sys
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

gauth = GoogleAuth()
drive = GoogleDrive(gauth)

########### CHANGE YOUR TARGET HERE #################
targetDirID = ""
########### CHANGE YOUR TARGET HERE #################

fileName = sys.argv[1]
if "," in fileName:
    upload_file_list = fileName.split(",")
else:
    upload_file_list = []
    upload_file_list.append(fileName)

exist_file_list = drive.ListFile({'q': "'{}' in parents and trashed=false".format(targetDirID)}).GetList()

for upload_file in upload_file_list:
    if (not os.path.exists(upload_file)):
        continue

    fileName = os.path.basename(upload_file)
    for file1 in exist_file_list:
        if file1['title'] == fileName:
            file1.Delete()

    gfile = drive.CreateFile({'parents': [{'id': targetDirID}], 'title': fileName})
    gfile.SetContentFile(upload_file)
    gfile.Upload()  # Upload the file.