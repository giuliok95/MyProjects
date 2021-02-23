# if [ -z $1 ]
# then
# awk -F "," '{ sum += $3} END { print sum }' logs/bob/january.csv
# else awk -F "," '{ sum +=$3 } END { print sum }' logs/bob/$1.csv
# fi
source ./shared.sh
sum_work_hours "bob" $1