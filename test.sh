#!/bin/bash
item=$1
data=$2
user=$3
echo "User Name: 장영서"
echo "Student Number: 12201790"
echo "[ MENU ] 
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of 'action' genre movies from 'u.item'
3. Get the average 'rating' of the movie identified by specific 'moive id' from 'u.data'
4. Delete the 'IMDb URL' from 'u.item'
5. Get the data about movies rated by a specific 'user id' from 'u.data'
6. Modify the format of movies rated by a specific 'user id' from 'u.data'
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit"
echo "-------------------------------------------"
for((;;))
do
read -p "Enter your choice [ 1-9 ] " choice
case $choice in
	1)
		echo -e "\n"
		read -p "Please enter the 'movie id' (1~1682): " movie_id
		awk -F\| -v id=$movie_id '$1==id { print $0 }' $item
		;;
	2)
		echo -e "\n"
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n): " respond
		if [ $respond == "y" ] 
		then
			awk -F\| '$7==1 {print $1, $2}' $item | head
		fi
		;;
	3)
		echo -e "\n"
		read -p "Please enter the 'movie id' (1~1682): " movie_id
		echo "average rating of $movie_id: "
		awk -v id=$movie_id '$2==id { sum+=$3; cnt++ } END { print sum/cnt }' $data
		;;
	4)
		echo -e "\n"
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " respond
		if [ $respond == "y" ]
		then
			sed -E "s/http[^|]*\)//" $item | head 
		fi
		;;
	5)
		echo -e "\n"
		read -p "Do you want to get the data about users from 'u.user'?(y/n): " respond
		if [ $respond == "y" ]
		then
			awk -F\| '{print "user ", $1, " is ", $2, " years old " $3, $4}' $user | head
	
		fi
		;;
	6)
		echo -e "\n"
		read -p "Do you want to modify the format of 'release data' in 'u.item'?(y/n): " respond
		if [ $respond == "y" ] 
		then
			sed -E '
			s/Jan/01/g
			s/Feb/02/g
			s/Mar/03/g
			s/Apr/04/g
			s/May/05/g
			s/Jun/06/g
			s/Jul/07/g
			s/Aug/08/g
			s/Sep/09/g
			s/Oct/10/g
			s/Nov/11/g
			s/Dec/12/g
			s/-//g' $item |
			sed -E -e '
			s/([0-9]{2})([0-9]{2})([0-9]{4})/\3\2\1/g
			' | tail
		fi
		;;
	7)
		echo -e "\n"
		read -p "Please enter the 'user id' (1~943): " user_id
		awk -v id=$user_id '$1==id { print $2 }' $data | sort -n | sed -z 's/\n/|/g' | head
		echo -e "\n"
		awk -v id=$user_id '$1==id { print $2 }' $data | sort -n | head |
			while read line
			do
				awk -F\| -v id=$line '$1==id { print $1, "|", $2 }' $item
			done
		;;
	8)
		echo -e "\n"
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n): " respond
		if [ $respond == "y" ]
		then
			for var in $(seq 1 1682)
			do
			awk -F\| -v occupation="programmer" '$2 >=20 && $2 < 30 && $4==occupation { print $1 }' $user |
				while read line
				do
					awk -v user_id=$line '$1==user_id { print $0 }' $data 
				done | awk -v id=$var '$2==id { sum+=$3; cnt++ } END { print id, sum/cnt }'
			done
		fi
		;;
	9)	
		echo "Bye!"
		break
		;;
	*)
		echo "Wrong choice!"
	esac
	echo -e "\n"
done
