#!/bin/bang

TESTS_PASSED=0
TESTS_TOTAL=7
CAT_OUT="cat.out"
DOG_OUT="dog.out"

touch $CAT_OUT
touch $DOG_OUT

FILES=('f1.txt' 'f2.txt' 'f3.txt')

for((i = 0 ; i < 3 ; i++)); do
	touch ${FILES[$i]}
	echo -e "This is file $i" >>  ${FILES[$i]} 
done

echo "Testing... when terminal prompt appears, press ctrl-D."
#---------test_1---------
# tests 3 files
cat >> $CAT_OUT ${FILES[0]} ${FILES[1]} ${FILES[2]}
./a.out >> $DOG_OUT ${FILES[2]} ${FILES[1]} ${FILES[0]}
if diff $DOG_OUT $CAT_OUT &> /dev/null ; then
    echo "Case 1 Passed."
    ((TESTS_PASSED+=1))
else
    echo "Case 1 Failed."
fi

#---------test_2---------
# tests 1 file
cat > $CAT_OUT ${FILES[0]}
./a.out > $DOG_OUT ${FILES[0]}
if diff $DOG_OUT $CAT_OUT &> /dev/null ; then
    echo "Case 2 Passed."
    ((TESTS_PASSED+=1))
else
    echo "Case 2 Failed."
fi

#---------test_3---------
# tests - without files
cat > $CAT_OUT -
echo "test input"
./a.out > $DOG_OUT -
echo "test input"
if diff $DOG_OUT $CAT_OUT &> /dev/null ; then
    echo "Case 3 Passed."
    ((TESTS_PASSED+=1))
else
    echo "Case 3 Failed."
fi




#---------test_4---------
# tests - with files 
cat > $CAT_OUT ${FILES[1]} -
echo "test input"
./a.out > $DOG_OUT - ${FILES[1]}
echo "test input"
if diff $DOG_OUT $CAT_OUT &> /dev/null ; then
    echo "Case 4 Passed."
    ((TESTS_PASSED+=1))
else
    echo "Case 4 Failed."
fi



#---------test_5---------
# tests no arg
cat > $CAT_OUT
echo "test input"
./a.out > $DOG_OUT
echo "test input"
if diff $DOG_OUT $CAT_OUT &> /dev/null ; then
    echo "Case 5 Passed."
    ((TESTS_PASSED+=1))
else
    echo "Case 5 Failed."
fi

#---------test_6---------
# tests 3 non-matching files
cat >> $CAT_OUT ${FILES[0]} ${FILES[1]} ${FILES[2]}
./a.out >> $DOG_OUT ${FILES[0]} ${FILES[1]} ${FILES[2]}
if diff $DOG_OUT $CAT_OUT &> /dev/null ; then
    echo "Case 6 Failed."
else
    echo "Case 6 Passed."
    ((TESTS_PASSED+=1))
fi

#---------test_7---------
# tests 3 files
cat >> $CAT_OUT ${FILES[0]} 
./a.out >> $DOG_OUT ${FILES[2]} ${FILES[1]}
if diff $DOG_OUT $CAT_OUT &> /dev/null ; then
    echo "Case 7 Failed."
else
    echo "Case 7 Passed."
    ((TESTS_PASSED+=1))
fi

#clean and print results
rm f1.txt f2.txt f3.txt dog.out cat.out
echo "$TESTS_PASSED out of $TESTS_TOTAL passed."
