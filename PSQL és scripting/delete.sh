#!/bin/bash
#
# delete.sh delete-todo <todo-id>
# delete.sh delete-done
#
# Usage:
#    delete.sh delete-todo 99
#    delete.sh delete-done
#

deltod() {
    psql -d todosh <<eof
    delete from todo
    where id='$1'
eof
echo "Todo removed!"
}
dellall() {
    psql -d todosh <<eof
    delete from todo
    where done=true
eof
echo "Done todos removed!"
}

main() {
if [ -z $2 ]
then
    hiba=0
else
    vane=$(
    psql -d todosh -v ON_ERROR_STOP=1 -t <<EOF
    select task from todo
    where id=$2
EOF
)
fi

if [[ "$1" == "delete-todo" && -z $vane ]]
then
    echo "No such todo to remove!"
elif [[ "$1" == "delete-todo" && -n $vane ]]
then
    deltod "$2"
elif [[ "$1" == "delete-done" && $hiba==0 ]]
then
    dellall
fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    main "$@"
fi
