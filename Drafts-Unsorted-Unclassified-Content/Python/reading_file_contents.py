fileObj = open(fileName, "r") #opens the file in read mode
words = fileObj.read().splitlines() #puts the file into an array
fileObj.close()