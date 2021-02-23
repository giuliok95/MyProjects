# if [ -z $1 ]
# then
# awk -F "," '{ sum += $3} END { print sum }' logs/alice/january.csv
# else awk -F "," '{ sum +=$3 } END { print sum }' logs/alice/$1.csv
# fi
source ./shared.sh
sum_work_hours "alice" $1