sum_work_hours(){
name=$1
month=$2
if [ -z $month ]
then month='january'
fi
file="logs/$name/$month.csv"
if [ ! -f $file ]
then
echo "no such file: $file"
exit
fi
awk -F "," '{ sum += $3 } END { print sum }' $file
 }