# Dealer_Lookup.sh
# Author: Luke Vassallo
# Date: Saturday, 1 August 2020

# SYNOPSIS: ./Dealer_Lookup.sh MMDD HH:MM:SS AM|PM 



cat Normalised_Dealer_Schedule | grep $1 | grep $2 | grep $3 | awk -F , '{print $1, $2, $3, $5}'

