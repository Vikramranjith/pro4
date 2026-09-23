#!/bin/bash

echo "========================================"
echo " SELinux Practical - Autograding"
echo "========================================"

FILE="student_solution.sh"

if [ ! -f "$FILE" ]; then
    echo "FAIL: student_solution.sh not found"
    exit 1
fi

echo "Student solution found: $FILE"
echo

MARKS=0

check_command() {
    NAME="$1"
    PATTERN="$2"

    if grep -Eq "$PATTERN" "$FILE"; then
        echo "PASS: $NAME"
        MARKS=$((MARKS + 1))
    else
        echo "FAIL: $NAME"
    fi
}

echo "Checking required SELinux commands..."
echo

check_command "getenforce" '(^|[[:space:]])getenforce([[:space:]]|$)'
check_command "sestatus" '(^|[[:space:]])sestatus([[:space:]]|$)'
check_command "Create /myweb" 'mkdir[[:space:]]+(-p[[:space:]]+)?/myweb'
check_command "Create index.html" 'index\.html'
check_command "chmod 755" 'chmod[[:space:]]+755[[:space:]]+/myweb'
check_command "chmod 644" 'chmod[[:space:]]+644[[:space:]]+/myweb/index\.html'
check_command "ls -Z" 'ls[[:space:]]+-Z[[:space:]]+/myweb/index\.html'
check_command "Wrong SELinux context" 'chcon[[:space:]]+-t[[:space:]]+default_t'
check_command "ausearch AVC" 'ausearch[[:space:]]+-m[[:space:]]+AVC'
check_command "Correct SELinux context" 'chcon[[:space:]]+-t[[:space:]]+httpd_sys_content_t'

echo
echo "========================================"
echo "Marks: $MARKS / 10"
echo "========================================"

if [ "$MARKS" -eq 10 ]; then
    echo "RESULT: PASS"
    exit 0
elif [ "$MARKS" -ge 8 ]; then
    echo "RESULT: PASS"
    exit 0
else
    echo "RESULT: FAIL"
    exit 1
fi
