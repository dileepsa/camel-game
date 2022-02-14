#stats[0]=miles
#stats[1]=chaser_distance
#stats[2]=thirst
#stats[3]=count

function display_statistics () {
	local stats=($@)
	echo -e "Your thirst is ${stats[2]}\n"
	echo -e "\nYou are ${stats[0]} miles away from destination"
	echo -e "your chaser is ${stats[1]} miles away from you\n"
}

function drink_some_water () {
	local stats=($@)
	stats[2]=$(( stats[2] - 1 ))
	stats[1]=$(( stats[1] - 5 ))
	echo "${stats[@]}"
}

function go_fast () {
	local stats=($@)
	stats[0]=$(( stats[0] - 10 ))
	(( stats[2]++ ))
	echo "${stats[@]}"
}

function go_slow (){
	local stats=($@)
	stats[0]=$(( stats[0] - 5 ))
	stats[1]=$(( stats[1] - 5 ))
	echo "${stats[@]}"
}

function choose_options () {

	local choice=$1
	local stats=($2)

	if [[ $choice == "Drink_some_water" ]] && [[ ${stats[2]} -gt 0 ]]
	then
		stats=(`drink_some_water $( echo ${stats[@]} )`)
		echo -e "${stats[@]}"
	
	
	elif [[ $choice = "Go_fast" ]] && [[ ${stats[0]} -ne 0 ]]
	then
		stats=(`go_fast $( echo ${stats[@]} )` )
		echo -e "${stats[@]}"
	

	elif [[ $choice = "Go_slow" ]]
	then
		stats=(`go_slow $( echo ${stats[@]} )` )
		echo -e "${stats[@]}"
	fi
}

function read_options() {
	local choice 
	PS3="choose one option : "
	local options=( Drink_some_water Go_fast Go_slow QUIT )
	select choice in ${options[@]} ; do break ;done
	echo $choice
}

function check_status () {
	local stats=($@)
	if [[ ${stats[0]} == 0 ]]
	then
		echo -e "\n\nYou have succefully Escaped from the chaser ! INTELLIGENT\n"
		exit
	fi

	if [[ ${stats[1]} == 0 ]] || [[ ${stats[2]} > 4 ]]
	then
		echo -e "\n\n\nOOHH NOOO ! You are caught by the CHASER 🤕\n"
		echo -e "Be careful when robbing ! \n"
		exit 2
	fi
	
	if [[ ${stats[2]} < 1 ]]
	then
		echo "your stomach is full of water ! Don't burst it 😂"
	fi
}	

function main(){
	local stats=($@)
	local choice

	while [[ stats[3] -ne 15 ]]
	do 
		check_status "$(echo ${stats[@]})"
		choice=`read_options `

		if [[ $choice = "QUIT" ]]
		then
			echo -e "\nYou QUIT the game !!!"
			exit 4
		fi
	
		stats=(`choose_options $choice "$(echo ${stats[@]})"`)
		clear
		display_statistics "$(echo ${stats[@]})"
		((stats[3] ++))
	done
}
bash description.sh
main 60 20 1 1
