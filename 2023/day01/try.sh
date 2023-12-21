#!/bin/bash
rm -rf tmp.txt

#sed -E "s/one|two|three|four|five|six|seven|eight|nine/&/1" input.txt > temp.txt
sed -e 's/one/1/1' -e 's/two/2/1' -e 's/three/3/1' \
    -e 's/four/4/1'  -e 's/five/5/1' -e 's/six/6/1'\
    -e 's/seven/7/1' -e 's/eight/8/1' -e 's/nine/9/1' \
    temp.txt > temp2.txt

cat temp2.txt | rev > temp.txt

sed -E 's/(one|two|three|four|five|six|seven|eight|nine)/e\1o/1' temp.txt > temp2.txt

cat temp2.txt | rev > temp.txt

sed 's/[a-zA-Z]//g' temp.txt > temp3.txt

sum=0
for num in $(cat temp3.txt); do 
    if [[ $num -lt 99 ]]; then
        num=$(echo $num | sed 's/^\(.\).*\(.\)$/\1\2/')
        echo $num >> tmp.txt
    elif [[ $num -lt 10 ]]; then
        num=$((num*11))
        echo $num >> tmp.txt
    else
        echo $num >> tmp.txt
    fi
    sum=$((sum+num))
done

echo $sum

#rm -rf temp.txt temp2.txt
