#!/bin/bash
rm db/exploit/test*
for i in `seq $1`
do
	A="__db_instance = new Exploit(\"php\",\"testbb$i\",\"$i.0\",\"Sql Injection\",\"b99b6621743321cd339eIi740b36$i\",\"TEST!$i\");"
	echo $A > ./db/exploit/test$i.db
done
