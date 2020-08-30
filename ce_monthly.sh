#!/bin/bash
#@lex2020
#V.3.0

RED='\033[0;31m'
CYAN='\033[96m'
MAGENTA='\033[95m'
GREY='\033[90m'
OKBLUE='\033[94m'
OKGREEN='\033[92m'
WARNING='\033[93m'
FAIL='\033[91m'
NC='\033[0m'


#printf "I ${RED}LOVE ${NC}BASH\n"

#list_prof=$(aws configure list-profiles --output json)

list=$(aws configure list-profiles)
echo $list > list.txt

echo -e "${MAGENTA}Choose the AWS profile you want to check :${NC}\n"

#aws configure list-profiles
#read -p '-->  Enter profile you want to check: ' select_prof

echo "AWS Profiles List : "
echo ""
aws configure list-profiles
echo "For All: type all"
echo ""


read -p '--> YOUR CHOICE : ' select_prof

if [ -n $select_prof ] ; then

#read -p '-->  Enter profile you want to check: ' profile
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
read -p '-->  Enter the month for which you want the billing( 01, 02...) ' month


PERIOD='Start=2020-'$month'-01,End=2020-'0$(($month + 1))'-01'

billing=$(aws --profile $select_prof ce get-cost-and-usage --time-period $PERIOD --granularity MONTHLY --metrics "BlendedCost" --output text |awk 'FNR == 3 {print $2}')

printf "Billing of $select_prof for $month:  %s\n " "$(printf "%8.2f\n" "$billing")$ "

else
		echo "Profile not found"

fi

