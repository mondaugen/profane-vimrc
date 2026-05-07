# create a completion menu from items read in from file that is first program
# argument
pyprog='
import sys

letters="abcdefghijklmnoprstuvwxyzABCDEFGHIJKLMNOPRSTUVWXYZ0123456789"

if int(sys.argv[1])>0:
    print("read -sn1 aaa")
    print("case \"$aaa\" in")

for line,letter in zip(sys.stdin.readlines(),letters):
    if int(sys.argv[1])>0:
        # print for switch
        print("\t%s)" % (letter,), "echo \"%s\" ;;" % (line.strip(),))
    else:
        # print for display
        print("%s)" % (letter,), line.strip())
    
if int(sys.argv[1])>0:
    print("esac")
'
# read the options in here
options=$(cat $1)
# add some "random" garbage to avoid collisions, we don't care about secrecy
OUTFILE=/tmp/walk-on-by-HeTjJaBdsP

reset
echo "Choose file from list by typing character in first column"
echo "$options" | python3 -c "$pyprog" 0

#echo "$options" | python3 -c "$pyprog" 1
rm -f "$OUTFILE"
eval "$(echo "$options" | python3 -c "$pyprog" 1)" > "$OUTFILE"
