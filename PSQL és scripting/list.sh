#!/bin/bash
#
# list.sh list-users
# list.sh list-todos
# list.sh list-user-todos
#
# Usage:
#    list.sh list-users
#    list.sh list-todos Paul
#    list.sh list-user-todos John
#    list.sh list-user-todos "John Doe"
#

list_users() {
    psql -t todosh<<EOF
SELECT name FROM "user"
EOF
}

list_todos() {
    psql -t todosh<<EOF
SELECT task FROM todo
EOF
}

list_user_todos() {
    echo "User: $1"
    psql todosh -t <<EOF
SELECT * FROM "todo" 
INNER JOIN "user" on "user".id="todo".user_id
WHERE "user".name='$1'
EOF
}

main() {
    vane=$(psql -d todosh -v ON_ERROR_STOP=1 -t <<EOF
select todo.task, "user".name
from todo
inner join "user" on "user".id=todo."user_id"
where "user".name='$2'
EOF
)
    if [[ "$1" == "list-users" ]]
    then
        list_users
    elif [[ "$1" == "list-todos" ]]
    then
        list_todos
    elif [[ "$1" == "list-user-todos" && -z $vane ]]
    then
        echo "No such user!"
    else
        list_user_todos "$2"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    main "$@"
fi
