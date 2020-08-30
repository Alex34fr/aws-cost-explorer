#!/bin/bash
#@lex2020

profname=$1

getbill () {
billing=$(aws --profile $profname ce get-cost-and-usage --time-period Start=2020-07-01,End=2020-08-01 --granularity MONTHLY --metrics "BlendedCost")

echo $billing

}
