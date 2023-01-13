#!/usr/bin/env bash

set -u

declare optsList='a b e f h k m n p t u v x B C E H P T'
#
# 0 == off
# 1 == on

declare -A setopts

# collect the starting values for 'set'
# search for 'set \[' in 'man bash'
collectSetDef() {

	#initialize to off

	for opt in $optsList
	do
		#echo "opt: $opt"
		setopts[$opt]=0
	done
	
	local i=0
	local currOpts=$-

	while :
	do
		local opt=${currOpts:(( i++ )):1}
		[[ -z $opt ]] && { break; }
		setopts[$opt]=1
	done

}

# This just displays the saved settings
showSet() {

	# bash 4.3.48 - seems to be sorting the keys
	for setOpt in ${!setopts[@]}	
	do
		echo "set $setOpt: ${setopts[$setOpt]}"	
	done

}

# display current settings
showCurrent() {
	local currOpts=$-
	for opt in $optsList
	do
		echo -n "opt: $opt "
		if [[ $opt =~ [$currOpts] ]]; then
			echo "1"
		else
			echo "0"
		fi
	done
}

# reset a setting to the original value
resetSet() {
	local setOpt=$1

	[[ -z $setOpt ]] && {
		echo
		echo "Invalid call witih empty parameter to resetSet()"
		echo 
		exit 1
	}

	# we need to make sure 'set -u' is not set here
	set +u

	local cmd='set -'
	if [[ ${setopts[$setOpt]} -eq 0 ]]; then
		# I do not recall why eval was used here
		# perhaps just a mistake
		#eval "set +$setOpt"
		set +${setOpt}
	else
		#eval "set -$setOpt"
		set -${setOpt}
	fi

	# set the +-u back to original
	if [[ ${setopts[u]} -eq 0 ]]; then
		#eval "set +u"
		set +u
	else
		#eval "set -u"
		set -u
	fi

}

constant () {
	set +u

	declare -n var2set=$1

	declare val2set="$2"
	var2set="$val2set"
	readonly var2set

	# set +-u back to original
	resetSet u
}

# may also work with ksh93+
constantOldBash () {
	set +u

	# use printf -v if the bash is too old
	declare var2set=$1
	declare val2set="$2"
	printf -v "$var2set" '%s' "$val2set"
	readonly $var2set

	# set +-u back to original
	resetSet u
}

collectSetDef
showSet

cat <<-EOF

  create a constant with the name 'myvar' and a value of 'myval'

    constant myvar myval

  This will be a readonly variable

EOF

constant myvar  myval
#constantOldBash myvar  myval

echo "myvar: $myvar"

cat <<-EOF

 The next command is 'myvar=changed'

 This will fail, as myvar has been set to read only

EOF

myvar='changed'

echo "myvar: $myvar"

echo
echo validate showCurrent
set +u
showCurrent
echo $-


