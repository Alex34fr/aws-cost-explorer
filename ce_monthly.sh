#!/bin/bash
#@lex2020
#Get the AWS monthly cost for one (or all) of your configured profile(s) 

#Variables
red=$(tput setaf 1)
green=$(  tput setaf 2)
blue=$(tput setaf 4)
normal=$(tput sgr0)
MAGENTA='\033[95m'
OKGREEN='\033[92m'
ERROR='\033[9m'
NC='\033[0m'
path_output=/Users/$(printenv USER)/Downloads

# choose the profil:

echo ""
echo -e "${MAGENTA} 1. Choose the AWS profile you want to check :${NC}\n"
echo -e "${OKGREEN} AWS profiles configured in your machine are: ${NC}\n"

# display your profiles list:
aws configure list-profiles > profil_list.txt
prof_list='profil_list.txt'
nbline=$(cat profil_list.txt | wc -l)
# reading each line
n=1
while read line; do
echo "$n. $line"
n=$((n+1))
done < $prof_list

echo "ALL.To select all profiles: type 'all'"
echo ""

read -p '==> Enter the profile number of your choice (1,2,...,ALL): ' select_prof

# check if selected profil exists or selection is "all":

if [[ "$select_prof" -ge 1 && "$select_prof" -le "$nbline" ]] || [[ "$select_prof" = [aA]ll || "$select_prof" = "ALL" ]] ; then

# choose the year:

echo " "
echo -e "${MAGENTA} 2. Choose the YEAR for which you want to check the billing :${NC}\n"
read -p '==>   Enter the YEAR for which you want the billing (2019,2020...): ' year

if [[ -n "$year" ]] && [[ "$year" = 2019 || "$year" = 2020 ]] ; then

# choose the month:
echo " "
echo -e "${MAGENTA} 3. Choose the MONTH for which you want to check the billing :${NC}\n"

echo " "
echo "============== $year =============="
echo " "
echo " 1 : January         7 : July"   
echo " 2 : February        8 : August" 
echo " 3 : March           9 : September"
echo " 4 : April          10 : October"
echo " 5 : May            11 : November"
echo " 6 : June           12 : December"
echo " "

read -p '==>   Enter the MONTH for which you want the billing (1,2,3...11,12): ' month

else
printf "${red} Wrong year input, please try again...${NC}\n"
exit 0
fi

# check if selected profil exists or selection is "all":

if [[ "${#month}" -le 2 ]] && [[ "$month" -ge 1 && "$month" -le 12 ]] ; then

monthd=$(printf %02d $month)

if [[ "$monthd" = "01" ]] ; then
  MON_STR=January
elif [[ "$monthd" = "02" ]] ; then
  MON_STR=February
elif [[ "$monthd" = "03" ]] ; then
  MON_STR=March
elif [[ "$monthd" = "04" ]] ; then
  MON_STR=April
elif [[ "$monthd" = "05" ]] ; then
  MON_STR=May
elif [[ "$monthd" = "06" ]] ; then
  MON_STR=June
elif [[ "$monthd" = "07" ]] ; then
  MON_STR=July
elif [[ "$monthd" = "08" ]] ; then
  MON_STR=August
elif [[ "$monthd" = "09" ]] ; then
  MON_STR=September
elif [[ "$monthd" = "10" ]] ; then
  MON_STR=October
elif [[ "$monthd" = "11" ]] ; then
  MON_STR=November
elif [[ "$monthd" = "12" ]] ; then
  MON_STR=December
fi

else
printf "${red} Wrong month selection, please try again...${NC}\n"
exit 0
fi 

else

printf "${red} Wrong profile selection, please try again...${NC}\n"
exit 0
fi

# case for December:
if [[ "$monthd" = "12" ]] ; then
nxtmonth=01
endyear=$(( $year + 1 ))

else
nxtmonth=$(printf %02d $(( $month + 1 )))
monthd=$(printf %02d $month)
endyear=$year
fi

# 'all profiles' case:

if [[ "$select_prof" = [aA]ll || "$select_prof" = "ALL" ]] ; then

echo " 
===============================================================
        Billing for all AWS accounts on $MON_STR $year
==============================================================="
> $path_output/AWS_billing_all_${MON_STR}_${year}.txt

 # reading each line of profiles_list:
n=1
while read line; do
profile=$(head -$n $prof_list | tail -1)
PERIOD='Start='$year'-'$monthd'-01,End='$endyear'-'$nxtmonth'-01'

bloc_profile=$(grep -i -A 3 "profile "$(head -$((n+1)) $prof_list | tail -1)"" ~/.aws/config)

printf "\n$n. ${blue}$profile : ${normal}\n "

# get monthly cost of each profile:
billing=$(aws --profile $profile ce get-cost-and-usage --time-period $PERIOD --granularity MONTHLY --metrics "BlendedCost" --output text |awk 'FNR == 3 {print $2}')

echo "$n. $profile for $MON_STR $year = $(printf "$%.2f\n" "$billing")" >> $path_output/AWS_billing_all_${MON_STR}_${year}.txt

# check if profile using MFA:
if  echo "$bloc_profile" | grep -q "mfa_serial"  ; then

printf "\n Bill for ${green}$profile ${normal}in ${green}$MON_STR $year${normal} = %s\n " "${blue}$(printf "$%.2f" "$billing") ${normal}"

printf "\n ${red}>> Next profile ($(head -$((n+1)) $prof_list | tail -1)) uses MFA so please wait 30s for a new MFA code on your Authenticator Device...${normal}
     
     "
sleep 30

else
printf "\n Bill for ${green}$profile ${normal}in ${green}$MON_STR $year${normal} = %s\n " "${blue}$(printf "$%.2f" "$billing") ${normal}"
fi

n=$((n+1)) 
done < $prof_list

printf "\n${MAGENTA}*** INFO ***    GET-COST for All your accounts ended successfully! 
*** INFO ***    You can find your bills summarize in ${red}$path_output/AWS_billing_all_${MON_STR}_${year}.txt\n ${normal}

"
# clear your aws cache:
rm -r ~/.aws/cli/cache
else

# single profile case:

profile=$(head -"$select_prof" $prof_list | tail -1)

PERIOD='Start='$year'-'$monthd'-01,End='$endyear'-'$nxtmonth'-01'
billing=$(aws --profile $profile ce get-cost-and-usage --time-period $PERIOD --granularity MONTHLY --metrics "BlendedCost" --output text |awk 'FNR == 3 {print $2}')

printf "\nBilling of ${blue}$profile ${normal}for ${green}$MON_STR $year${normal} = %s\n\n " "${blue}$(printf "$%.2f\n" "$billing") ${normal}"

fi

exit 0