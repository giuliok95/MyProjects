#!/bin/bash
#
# mark.sh mark-todo <todo-id>
# mark.sh unmark-todo <todo-id>
#
# Usage:
#    mark.sh mark-todo 32
#    mark.sh unmark-todo 32
#

todom() {
    psql -d todosh <<eof
    update todo
    set done = 'true'
    where id='$1'
eof
echo "Marked as done!"
}
todon() {
    psql -d todosh <<eof
    update todo
    set done = 'false'
    where id='$1'
eof
echo "Marked as undone!"
}

main() {
    vane=$(
    psql -d todosh -v ON_ERROR_STOP=1 -t <<EOF
    select task from todo
    where id='$2'
EOF
)
    if [[ "$1" == "mark-todo" && -z $vane ]]
then
    echo "No such id!"
    elif [[ "$1" == "mark-todo" && -n $vane ]]
then
    todom "$2"
    elif [[ "$1" == "mark-todo" && -z $vane ]]
then
    echo "No such id!"
else
    todon "$2"
fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    main "$@"
fi
