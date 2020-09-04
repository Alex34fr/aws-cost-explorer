# aws-cost-explorer

Get cost of a specific month for your AWS Accounts using AWS CLI.

This script written in bash was created and validated on MacOs HighSierra 10.13.6 using bash-3.2.

Requirement : you need your AWS credentials/profils already set on your local machine. (~./aws/config and ~/.aws/credentials)

Installation :

1/ Clone this project in your local machine.
2/ chmod + x ce_monthly.sh

Use:

1/ run the script : ./ce_monthly.sh

2/ Select the profile for which you wanna check the bill.

(Note : you can choose to get 'all' your profiles bills in one time.)

3/ Select the month for which you want your bill(s).

4/ In case you selected 'all' a text file will be exported in your "Downloads folder".
