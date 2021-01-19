#!/bin/#!/usr/bin/env zsh

#PoE Account
accountName=
#PoE charName
charName=

#Digit Grouping for for Pretty Print
#Source : https://stackoverflow.com/questions/9374868/number-formatting-in-bash-with-thousand-separator
LC_ALL=en_US.UTF-8 # comma separator
groupDigits() {
  local decimalMark fractPart
  decimalMark=$(printf "%.1f" 0); decimalMark=${decimalMark:1:1}
  for num; do
    fractPart=${num##*${decimalMark}}; [[ "$num" == "$fractPart" ]] && fractPart=''
    printf "%'.${#fractPart}f\n" "$num" || return
  done
}
#Get Account Characters from API
getCharDataAPI() {
  curl -sS -X GET "https://www.pathofexile.com/character-window/get-characters?accountName=${accountName}" -H  "accept: */*" \
  | ./jq 'map(select(.name | contains ("'$charName'")))' > chardata-db.json
  cp chardata-db.json chardata-init.json
}

#Parse Character data from File use jq - 
parseCharData() {
	echo "$(date +"%Y-%m-%d %H:%M:%S") : parsing $charName from file.."
	charLevel=`./jq  'map(select(.name==("'$charName'"))) | .[] | .level|tonumber' $1''`
	charExp=`./jq  'map(select(.name==("'$charName'"))) | .[] | .experience|tonumber' $1''`
  charExpstr=`groupDigits $charExp`
}

getExpDiff() {
  nextLevelExp=`sed "${nextLevel}q;d" exptable.txt`
  nextLevelExpstr=`groupDigits $nextLevelExp`
  reqExp=`groupDigits $((nextLevelExp - charExp))` # EXP needed to nextLevel
  reqExp2=`groupDigits $((nextLevelExp - currentLevelExp ))` # total EXP to nextLevel
}

#Terminal Outputs
printOutput() {
	echo "------------- Character Stats ------------- \
  \nTime\t:\t$(date +"%Y-%m-%d %H:%M:%S") \
	\nName\t:\t$charName \
  \nLevel\t:\t$charLevel \
  \nExp\t:\t$charExpstr/$nextLevelExpstr|`echo "$reqExp $reqExp2" | awk '{printf"%.2f%%",(1-$1/$2)*100}'` \
  \nTarget\t:\t$reqExp \
	\n-------------------------------------------"
}

#Main Script
getCharDataAPI
#echo "$(date +"%Y-%m-%d %H:%M:%S") : Data stored";
parseCharData chardata-db.json
currentLevelExp=`sed "${charLevel}q;d" exptable.txt`
nextLevel=$((charLevel+1));
getExpDiff
printOutput
# check chardata-init.json is empty or older
