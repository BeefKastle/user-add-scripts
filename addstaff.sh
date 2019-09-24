#!/bin/bash
#set directory to get names from, set group to add names to, and specify skel dir.
input="/home/andrew/namesLevel0"
group="staff"
skel="/etc/staffskel"

#loop through file, line contents are saved to $line
while read -r line
do
  # store full name frome line.
  fullname=$line
  echo $fullname

  # set the values in line to numbered variables 1, 2, 3, etc..
  set -- $line

  #set a variable to hold first 2 characters in the line
  firstinital=${1:0:2}
  #echo $firstinital
  
  #set variable to hold the last word of the line
  lastname="${@: -1}"
  #echo $lastname
  
  #create a username from the first initals and last name, make sure that its all lowercase
  username="`echo $firstinital$lastname | awk '{print tolower($0)}'`"
  echo $username
  
  # Generate a bad password to go with the username
  password="2019x$username"
  
  # Put the username and bad password in a file together
  echo $username:$password >> usernamesandpasswords.txt
  
  #add user to group
  useradd -c "$fullname" -g $group -N -m -k $skel $username
  #set bad password for user
  echo -e $username:$password | chpasswd
  #force user to change it when they log in.
  chage -d 0 $username

  
done < "$input" # Where file is specified from input
