# get the current month's cost report from AWS  
  
assuming you're not using a consolidated account (just one account without any organizations)
  
you will need python3, and awscli installed and configured!    
  
1. `$ git clone PATH-TO-THIS-REPO aws-cost-report`  
  
2. `$ cd aws-cost-report`   
  
3. `$ chmod a+x cost-report.py`  
  
4. `$ cp cost-report.py /usr/local/bin/cost-report`  

5. `$ which cost-report`  
if all went well you will see the command, if so:  
  
6. `$ cost-report`
