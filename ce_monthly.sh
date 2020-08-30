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
echo "================== 2020 =================="
echo " "
echo " 01 : January	 	  07 : July"		
echo " 02 : February		  08 : August"	
echo " 03 : March		  09 : September"
echo " 04 : April		  10 : October"
echo " 05 : May 		  11 : November"
echo " 06 : June		  12 : December"
echo " "
read -p '-->  Enter the MONTH for which you want the billing( 01, 02...) ' month


if [[ "$month" = "01" ]] ; then
  MON_STR=January
elif [[ "$month" = "02" ]] ; then
  MON_STR=February
elif [[ "$month" = "03" ]] ; then
  MON_STR=March
elif [[ "$month" = "04" ]] ; then
  MON_STR=April
elif [[ "$month" = "05" ]] ; then
  MON_STR=May
elif [[ "$month" = "06" ]] ; then
  MON_STR=June
elif [[ "$month" = "07" ]] ; then
  MON_STR=July
elif [[ "$month" = "08" ]] ; then
  MON_STR=August
elif [[ "$month" = "09" ]] ; then
  MON_STR=September
elif [[ "$month" = "10" ]] ; then
  MON_STR=October
elif [[ "$month" = "11" ]] ; then
  MON_STR=November
elif [[ "$month" = "12" ]] ; then
  MON_STR=December
fi

PERIOD='Start=2020-'$month'-01,End=2020-'0$(($month + 1))'-01'

billing=$(aws --profile $select_prof ce get-cost-and-usage --time-period $PERIOD --granularity MONTHLY --metrics "BlendedCost" --output text |awk 'FNR == 3 {print $2}')

printf "Billing of ${green}$select_prof ${normal}for ${green}$MON_STR 2020${normal} =%s\n " "${blue}$(printf "%8.2f\n" "$billing")$ ${normal}"

else
		echo "Profile not found"

fi

