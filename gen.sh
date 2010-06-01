#!/bin/bash

for i in `seq 2`
do
	A="__db_instance = new Exploit(\"php$i\",\"testbb\",\"$i.0\",\"Sql Injection$i\",\"b99b6621743321cd339eIi740b36$i\",\"TEST!$i\");"
	echo $A > ./db/exploit/test$i.db
done
