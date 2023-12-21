import numpy as np

with open("input2.csv", "r") as open_doc:
    lines = [line.replace("\n", "") for line in open_doc.readlines()]
    
"""
with open("TextInputs\\testCases.txt", "r") as open_doc:
    lines = [line.replace("\n", "") for line in open_doc.readlines()]
"""

possibleIDs = []
powerOfGames = []

for line in lines:
    curID = line[5:line.index(":")]
    sets = [item.split(", ") for item in line[line.index(":")+2:].split("; ")]
    #print("Currently parsing:", sets)
    
    maxRGB = {"red": 0, "green":0, "blue":0}
    
    for pull in sets:
        for color in pull:
            amount, color = color.split()
            maxRGB.update({color:max(maxRGB[color], int(amount))})

    #print("Max rgb values:", maxRGB)
        
    powerOfGames.append(np.prod(list(maxRGB.values())))
        
    if maxRGB["red"] <= 12 and maxRGB["green"] <= 13 and maxRGB["blue"] <= 14:
        possibleIDs.append(int(curID))
   
print(len(possibleIDs))
# print(possibleIDs)
print(sum(possibleIDs))
print(sum(powerOfGames))
