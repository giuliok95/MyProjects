#!/bin/bash
#
# add.sh add-user <user>
# add.sh add-todo <user> <todo>
#
# Usage:
#    add.sh add-user John
#    add.sh add-user Paul
#    add.sh add-todo John Meeting
#    add.sh add-todo Paul "Make breakfast"
#

add_user() {
psql -d todosh -qt <<EOF
INSERT INTO "user" (name) VALUES ('$1')
EOF

#    echo "User: $1"
}

add_todo() {

userId=$(
psql -d todosh -qt  <<EOF
SELECT id FROM "user" WHERE name='$1';
EOF
)

psql -d todosh -qt <<EOF
INSERT INTO todo (task,user_id) VALUES ('$2','$userId');
EOF
#echo "$userId"
#    echo "User: $1"
#    echo "Todo: $2"
}

main() {
vane=$(psql -d todosh -v ON_ERROR_STOP=1 -t <<EOF
select todo.task, "user".name
from todo
inner join "user" on "user".id=todo."user_id"
where "user".name='$2'
EOF
)
    if [[ "$1" == "add-user" ]]
    then
        add_user "$2"
    elif [[ "$1" == "add-todo" && -z $vane ]]
    then
        echo "No such user!"
    else
        add_todo "$2" "$3"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    main "$@"
fi
