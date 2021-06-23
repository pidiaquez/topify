#!/bin/bash
# pidiaquez @ DSE 2021-06-23  topify reads top.out from multidump.sh prints hex threadid from pids with high cpu
# apply 2 filters
# filter TOP 5 pid/therads from each top round 
# filter only threads which had cpu > 10%  

FILE=top.out
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist."
    echo " need top.out genereted by multidump.sh"
    echo "  https://support.datastax.com/hc/en-us/article_attachments/202166479/multidump.sh "
    exit 0
fi
# filter TOP 5 pid/therads from each top round 
grep -A5 " PID USER" top.out | grep -v " PID USER" | awk {'print $9" "$1'} > topify1
cat topify1 | grep -v "--" - > topify2
declare -i cpuvalint
while read -r line;
do
   cpuval=$(echo "$line"| awk {'print $1'});
   cpuvalint=$(echo "$cpuval"| awk -F"." {'print $1'})
   pidval=$(echo "$line"| awk {'print $2'});
#  filter only threads which had cpu > 10%  
if [ $cpuvalint -gt 10 ]
then
   pidvalhex=$(echo "obase=16;  $pidval" | bc)
   echo "cpu $cpuval pid $pidval thread nixpid 0x$pidvalhex";
fi
done < topify2
