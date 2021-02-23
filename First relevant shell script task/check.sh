#!/bin/bash
check() {
    command="$1"
    actual="$(eval "$command" 2> /dev/null)"
    expected="$2"
    if [[ "$actual" -eq "$expected" ]]
    then
        echo "OK $command == $expected"
    elif [[ -n "$actual" ]]
    then
        echo "NO $command, expected $expected, actual was $actual"
    else
        echo "NO $command"
    fi
}

check './alice.sh' 156
check './alice.sh january' 156
check './alice.sh february' 126
check './alice.sh march' 127
check './alice.sh april' 124
check './bob.sh' 120
check './bob.sh january' 120
check './bob.sh february' 114
check './report.sh alice' 156
check './report.sh alice january' 156
check './report.sh alice february' 126
check './report.sh alice march' 127
check './report.sh alice april' 124
check './report.sh bob' 120
check './report.sh bob january' 120
check './report.sh bob february' 114
check './report.sh ellie february' 134
check './report.sh ellie march' 115
check './report.sh ellie april' 164
