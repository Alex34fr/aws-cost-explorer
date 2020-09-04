#!/bin/bash
#@lex2020


#Variables
red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
normal=$(tput sgr0)
MAGENTA='\033[95m'
OKGREEN='\033[92m'
ERROR='\033[9m'
NC='\033[0m'
path_output=/Users/$(printenv USER)/Downloads

#choose the profil:

echo ""
echo -e "${MAGENTA} 1. Type the AWS profile you want to check :${NC}\n"
echo -e "${OKGREEN} AWS profiles configured in your machine are: ${NC}\n"

#display your profiles list:
aws configure list-profiles > profil_list.txt
prof_list='profil_list.txt'
nbline=$(cat profil_list.txt | wc -l)

n=1
while read line; do
#reading each line
echo "$n. $line"
n=$((n+1))
done < $prof_list
echo "ALL.To select all profiles: type 'all'"
echo ""

read -p '==> YOUR CHOICE : ' select_prof

#check if selected profil exists or selection is "all" :

 if [[ "$select_prof" -ge 1 && "$select_prof" -le "$nbline" ]] || [[ "$select_prof" = "all" || "$select_prof" = "ALL" ]] ; then

# choose the month:
echo " "
echo -e "${MAGENTA} 2. Choose the month for which you want to check the billing for $select_prof :${NC}\n"

echo " "
echo "============== 2020 =============="
echo " "
echo " 1 : January         7 : July"   
echo " 2 : February        8 : August" 
echo " 3 : March           9 : September"
echo " 4 : April          10 : October"
echo " 5 : May            11 : November"
echo " 6 : June           12 : December"
echo " "

read -p '==>   Enter the MONTH for which you want the billing (1,2,3...11,12): ' month


if [[ "$month" = "1" ]] ; then
  MON_STR=January
elif [[ "$month" = "2" ]] ; then
  MON_STR=February
elif [[ "$month" = "3" ]] ; then
  MON_STR=March
elif [[ "$month" = "4" ]] ; then
  MON_STR=April
elif [[ "$month" = "5" ]] ; then
  MON_STR=May
elif [[ "$month" = "6" ]] ; then
  MON_STR=June
elif [[ "$month" = "7" ]] ; then
  MON_STR=July
elif [[ "$month" = "8" ]] ; then
  MON_STR=August
elif [[ "$month" = "9" ]] ; then
  MON_STR=September
elif [[ "$month" = "10" ]] ; then
  MON_STR=October
elif [[ "$month" = "11" ]] ; then
  MON_STR=November
elif [[ "$month" = "12" ]] ; then
  MON_STR=December
fi

else

printf "${red} Wrong selection, please try again...${NC}\n"
exit 0

fi

# all profiles case
if [[ "$select_prof" = "all" || "$select_prof" = "ALL" ]] ; then
echo " 
===============================================================
        Billing for all AWS accounts on $MON_STR 2020
==============================================================="
> $path_output/AWS_billing_all_${MON_STR}_2020.txt
n=1
while read line; do
# reading each line of profiles_list
profile=$(head -$n $prof_list | tail -1)
PERIOD='Start=2020-0'$month'-01,End=2020-'0$(($month + 1))'-01'
billing=$(aws --profile $profile ce get-cost-and-usage --time-period $PERIOD --granularity MONTHLY --metrics "BlendedCost" --output text |awk 'FNR == 3 {print $2}')

echo "$n. $profile for $MON_STR 2020 = $(printf "$%.2f\n" "$billing")" >> $path_output/AWS_billing_all_${MON_STR}_2020.txt

printf "\n$n. ${green}$profile ${normal}for ${green}$MON_STR 2020${normal} = %s\n " "${blue}$(printf "$%.2f" "$billing") ${normal}"
n=$((n+1)) 
done < $prof_list

else

#single profile case
profile=$(head -"$select_prof" $prof_list | tail -1)
#2020
PERIOD='Start=2020-0'$month'-01,End=2020-'0$(($month + 1))'-01'
#2019
#PERIOD='Start=2019-0'$month'-01,End=2019-'0$(($month + 1))'-01'

billing=$(aws --profile $profile ce get-cost-and-usage --time-period $PERIOD --granularity MONTHLY --metrics "BlendedCost" --output text |awk 'FNR == 3 {print $2}')
printf "\nBilling of ${blue}$profile ${normal}for ${green}$MON_STR 2020${normal} = %s\n\n " "${blue}$(printf "$%.2f\n" "$billing") ${normal}"

fi
exit 0