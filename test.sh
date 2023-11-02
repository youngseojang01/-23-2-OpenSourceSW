#!/bin/bash
read -p "User Name: " name
read -p "Student Number: " std_num
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
echo "choice: $choice"
case $choice in
	1) 
		read -p "Please enter the 'movie id' (1~1682): " movie_id
		echo "movie_id: $movie_id"
		cat u.item | awk -F\| -v id=$movie_id '$1==id {print $0}'
		;;
	2)
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n): " respond
		if [ $respond == "y" ] 
		then
			cat u.item | awk -F\| '$7==1 {print $1, $2}' | head
		fi
		;;
	3)
		read -p "Please enter the 'movie id' (1~1682): " movie_id
		echo "average rating of $movie_id: "
		cat u.data | awk -v id=$movie_id '$2==id { sum+=$3; cnt++ } END { print sum/cnt }'
		;;
	4)
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " respond
		if [ $respond == "y" ]
		then
			sed -i '/^http://us.imdb.com/d' u.item
			sed -E "s/http[^|]*\)//" 
			cat u.item | awk -F\| '{print $0}' | head
		fi
		;;
	5)
		read -p "Do you want to get the data about users from 'u.user'?(y/n): " respond
		if [ $respond == "y" ]
		then
			cat u.user | awk -F\| '{print "user ", $1, " is ", $2, " years old " $3, $4}' | head
	
		fi
		;;
	6)
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
			s/-//g' u.item |
			sed -E -e '
			s/([0-9]{2})([0-9]{2})([0-9]{4})/\3\2\1/g
			' | tail
		fi
		;;
	7)
		read -p "Please enter the 'user id' (1~943): " user_id
		cat u.data | awk -v id=$user_id '$1==id { print $2 }' | sort -n | sed -z 's/\n/|/g'
		echo ""
		;;
	8)
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n): " respond
		if [ $respond == "y" ]
		then
			echo "a"
		fi
		;;
	9)	
		echo "Bye!"
		break
		;;
	*)
		echo "wrong choice"
	esac
done
