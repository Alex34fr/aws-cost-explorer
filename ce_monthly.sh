#!/bin/bash
#@lex2020

green=$(tput setaf 2)
blue=$(tput setaf 4)
normal=$(tput sgr0)
CYAN='\033[96m'
MAGENTA='\033[95m'
GREY='\033[90m'
OKBLUE='\033[94m'
OKGREEN='\033[92m'
WARNING='\033[93m'
NC='\033[0m'



echo ""
echo -e "${MAGENTA} 1. Type the AWS profile you want to check :${NC}\n"

echo -e "${OKGREEN} Your AWS profiles configured in your machine are: ${NC}\n"
aws configure list-profiles
echo "For All: type all"
echo ""

read -p '--> YOUR CHOICE : ' select_prof

if [ -n $select_prof ] ; then

echo " "
echo -e "${MAGENTA} 2. Choose the month you want to check for $select_prof :${NC}\n"

echo " "
echo "================== 2020 ================="
echo " "
echo " 01 : January	 	  07 : July"		
echo " 02 : February		  08 : August"	
echo " 03 : March		  09 : September"
echo " 04 : April		  10 : October"
echo " 05 : May 		  11 : November"
echo " 06 : June		  12 : December"
echo " "


else
echo -e "Profile not found"
exit 0

fi

#  read -p "Enter a number between 2 and 5: " number
read -p '-->  Enter the MONTH for which you want the billing(1,2,3...): ' month
  
#format 'month' into 2 decimal number
monthd=$(printf %02d $month)
#nxtmonth=$(($monthd + 1))
  
 if (($monthd >= 01 && $monthd <= 12)); then


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
echo -e "${WARNING}Enter a valid month${NC}\n"
exit 0

fi

#2020
PERIOD='Start=2020-'$monthd-01',End=2020-'$(printf %02d $(($monthd + 1)))'-01'
#2019
#PERIOD='Start=2019-'$monthd-01',End=2019-'$(printf %02d $(($monthd + 1)))'-01'

billing=$(aws --profile $select_prof ce get-cost-and-usage --time-period $PERIOD --granularity MONTHLY --metrics "BlendedCost" --output text |awk 'FNR == 3 {print $2}')



printf "\nBilling of ${green}$select_prof ${normal}for ${green}$MON_STR 2020${normal} =%s\n\n " "${blue}$(printf "%8.2f" "$billing")$ ${normal}"  



