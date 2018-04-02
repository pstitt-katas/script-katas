#!/usr/bin/env bash

isBalanced() {
	input=$1

	depth=0
	for (( i=0; i<${#input}; i++ )); do
		ch=${input:$i:1}
		case $ch in
			[)
			depth=$((depth + 1))
			;;

			])
			depth=$((depth - 1))
			if [ $depth -eq -1 ]
			then
				return 1
			fi
			;;

			*)
			return 255
			;;
		esac
	done

	if [ $depth -ne 0 ]
	then
		return 1
	fi

	return 0
}

runTestCase() {
	description=`echo $@ | awk '{split($0,a,","); print a[1]}'`
	input=`echo $@ | awk '{split($0,a,","); print a[2]}'`
	expected=`echo $@ | awk '{split($0,a,","); print a[3]}'`

	#echo "Is Balanced: description=$description, input='$input', expected=$expected"

	isBalanced $input
	result=$?
	case $result in
		$expected)
			echo PASS: $description
			;;
		*)
			echo "FAIL: '$result' for $description, expected $expected"
			;;
	esac
}

while read testCase
do
	runTestCase $testCase
done << EOF
	empty string,,0
	invalid char,$,255
	balanced1,[],0
	balanced2,[[[]]],0
	balanced3,[[[]]][][[][]],0
	unmatchedOpening1,[,1
	unmatchedOpening2,[[[]],1
	unmatchedOpening3,[[[,1
	unmatchedClosing1,],1
	unmatchedClosing2,][,1
EOF
