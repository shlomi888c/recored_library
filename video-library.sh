#! /bin/bash -x 

find_record () {
find_record="$(grep $record records.txt | cut -d: -f1)"
}

find_line_record () { 

  find_line_record="$(grep -w -n  $record_select records.txt | cut -d: -f1)"
}
find_record_number () {

find_record_number="$(grep -w $record_select records.txt | cut -d: -f2)"
}


my_records_first="$(cat records.txt|cut -d ":" -f1|tr '\n' ',')"



IFS=','
PS3="Please select action "
select record_select in  'add record' 'del record' 'update amount' 'change record' 'search record'
do
if [[ $record_select == 'add record' ]]
then
	echo please  write new record:
read record
if  grep -q $record <<< $my_records_first
then
  IFS=',' 
  my_records="$(cat records.txt|cut -d ":" -f1 | grep $record|tr '\n' ',')"
  echo $my_records
  number_of_record="$(grep -c $record records.txt)"
  if  [[ $number_of_record -gt 1 ]]
  then
    quit='new record'
    myrecords_new_record=$my_records$quit
    PS3="Please select a record "
    select record_select in ${myrecords_new_record[@]}
    do
    if [[ $record_select == $quit ]]
    then
        find_record_true="$(grep -w $record records.txt | cut -d: -f1)"
        if [[ $find_record_true == $record ]]
          then
          echo record is found
        else
          echo $record:1 >> records.txt
          echo new recored add
          sleep 5
          break
        fi
    else
        echo please put amount:   
	read amount
        find_line_record
        find_record_number
        let find_record_number_new=$find_record_number+$amount
        sed -i  "${find_line_record}s/$find_record_number/$find_record_number_new/g" records.txt
        break
    fi
    done
  else
        find_record
        if [[ $record == $find_record ]]
        then
                echo please put amount: 
                read amount
                find_line_record
                echo $find_line_record
                find_record_numbe
                let find_record_number_new=$find_record_number+$amount
                sed -i  "${find_line_record}s/$find_record_number/$find_record_number_new/g" records.txt
        else
                echo $record:1 >> records.txt   
        fi

  fi 
else
     echo $record:1 >> records.txt
fi


elif	[[ $record_select == 'del record' ]]
then
  echo "shlomi"
  echo please  write a record to delete:
  read record
  if  grep -q $record <<< $my_records_first
  then
    IFS=','
    number_of_record="$(grep -c $record records.txt)" 
    if  [[ $number_of_record == 1 ]]
     then 
        find_record_exact="$(grep -w $record records.txt | cut -d: -f1)"
        echo please put amount: 
        read amount
        find_line_record="$(grep -w -n  $record records.txt | cut -d: -f1)"
        echo $find_line_record
        find_record_number="$(grep -w $record records.txt | cut -d: -f2)"
        if [[ $find_record_number -lt $amount ]]
        then
           echo    amount too big
        else
           let find_record_number_new=$find_record_number-$amount
           sed -i  "${find_line_record}s/$find_record_number/$find_record_number_new/g" records.txt
           if [[ $find_record_number_new == 0 ]]
            then
               sed -i "/$record/d" records.txt
           fi   
        fi
    else  
        myrecords="$(cat records.txt|cut -d ":" -f1 | grep $record|tr '\n' ',')"
        PS3="Please select a record "
        select record_select in ${myrecords[@]}
        do
        echo please put amount: 
        read amount
        find_line_record="$(grep -w -n  $record_select records.txt | cut -d: -f1)"
        find_record_number="$(grep -w $record_select records.txt | cut -d: -f2)"
        if [[ $find_record_number -lt $amount ]]
         then
           echo    amount too big
         else
          let find_record_number_new=$find_record_number-$amount
          sed -i  "${find_line_record}s/$find_record_number/$find_record_number_new/g" records.txt
          if [[ $find_record_number_new == 0 ]]
          then
             sed -i "/$record_select/d" records.txt
          fi    
        fi        
        done
    fi

  else
     echo record not find
  fi
elif    [[ $record_select == 'update amount' ]] 
then
    echo please  write  record to update:
    read record
    if  grep -q $record <<< $my_records_first
    then
   	IFS=','
   	number_of_record="$(grep -c $record records.txt)" 
 	if  [[ $number_of_record == 1 ]]
  	then 
        	find_record_exact="$(grep -w $record records.txt | cut -d: -f1)"
        	echo please put amount:
                read amount
		find_line_record="$(grep -w -n  $record records.txt | cut -d: -f1)"
        	find_record_number="$(grep -w $record records.txt | cut -d: -f2)"
                let find_record_number_new=$find_record_number+$amount
                sed -i  "${find_line_record}s/$find_record_number/$find_record_number_new/g" records.txt
        else  
               myrecords="$(cat records.txt|cut -d ":" -f1 | grep $record|tr '\n' ',')"
               PS3="Please select a record "
               select record_select in ${myrecords[@]}
       	       do
       	       echo please put amount: 
               read amount
               find_line_record="$(grep -w -n  $record_select records.txt | cut -d: -f1)"
               find_record_number="$(grep -w $record_select records.txt | cut -d: -f2)"
               let find_record_number_new=$find_record_number+$amount
               sed -i  "${find_line_record}s/$find_record_number/$find_record_number_new/g" records.txt
               done
        fi 
    else
     echo record not find
    fi

elif    [[ $record_select == 'change record' ]] 
then
	echo please  write  record to change:
	read record
	echo please write new record
	read new_record
	if  grep -q $record <<< $my_records_first
 	then
 	  IFS=','
 	  number_of_record="$(grep -c $record records.txt)" 
	  echo $number_of_record 
          if  [[ $number_of_record == 1 ]]
	  then
   	        find_line_record="$(grep -n $record records.txt | cut -d: -f1)"
                find_record="$(grep $record records.txt | cut -d: -f1)"
                if  grep -w -q "$new_record" records.txt
                then
              	   echo record is found
                else    
                   sed -i  "${find_line_record}s/$find_record/$new_record/g" records.txt
                fi
          else  
                myrecords="$(grep $record records.txt | cut -d"," -f1|tr '\n' ',')"
                PS3="Please select a record "
                select record_select in ${myrecords[@]}
                do
                find_line_record="$(grep -w -n  $record_select records.txt | cut -d: -f1)"
                find_record_number="$(grep -w $record_select records.txt | cut -d: -f1)"
                if  grep -w -q "$new_record" records.txt
                then
                    echo record is found
                else    
                    sed -i  "${find_line_record}s/$find_record_number/$new_record/g" records.txt
                fi

                done
          fi

        else
            echo record not find
        fi

elif    [[ $record_select == 'search record' ]] 
then
	echo please  write new record:
	read record
	find_record="$(grep $record records.txt | cut -d: -f1)"
        if  grep -q "$record" records.txt
        then
		my_records="$(cat records.txt | grep $record | sort)"  
		echo $my_records
	else
	echo record not found
	fi

fi


done



