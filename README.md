
Bash Constants and 'set' options management
===========================================

There are no 'constants' in Bash, but there are read only variables.

The `constant.sh` script contains functions that can be used to create 'constant' values via readonly variables.

In addition, this script has functions for maintaining the state of 'set' values within the script.

## Constants

This works for Bash that is new enough that `declare -n varname` will work.

This works in my testing with Bash 4.3.

I do not recall which version started supporting `declare -n`.

Usage:

```bash

constant myvarname myvalue

```

Demo:

```text
>  ./constant.sh
set B: 1
set C: 0
set E: 0
set H: 0
set P: 0
set T: 0
set a: 0
set b: 0
set e: 0
set f: 0
set h: 1
set k: 0
set m: 0
set n: 0
set p: 0
set t: 0
set u: 1
set v: 0
set x: 0

  create a constant with the name 'myvar' and a value of 'myval'

  constant myvar myval

  This will be a readonly variable

myvar: myval

  The next command is 'myvar=changed'

  This will fail, as myvar has been set to read only

./constant.sh: line 127: myvar: readonly variable

myvar: myval
```

For older Bash, you can use the constantOldBash function.

This works via `printf -v`

## set values

Three functions are used to collect, set and reset `set` options

### collectSetDef()

This function populates an associative array with 0 or 1, dependent on the current settings found in set variable `$-`.

Note: search for 'set \[' in `man bash`

### showSet()

This function displays current 'set' options

### resetSet()

Reset the set option back to the original value

ie: `resetSet u`









