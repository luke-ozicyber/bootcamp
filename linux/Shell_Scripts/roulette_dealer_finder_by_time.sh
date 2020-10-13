# roulette_dealer_finder_by_time.sh
# Author: Luke Vassallo
# Date: Saturday, 1 August 2020

# SYNOPSIS: ./roulette_dealer_finder_by_time.sh MMDD HHAM|HHPM 

cat Normalised_Dealer_Schedule | sed 's/:00:00,//g' | grep $1 | grep $2 | awk -F , '{print $4}'
