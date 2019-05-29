#!/bin/sh
redis_7000=`docker container ls | grep "redis-7000"`
container_id=`echo $redis_7000 | awk '{print $1}'`

if [ -z $container_id ]; then
	echo "redis not start"
	exit
fi


#docker exec -it --rm $container_id redis-cli -p 7000 -a test --cluster 
#get all redis networks
server_networks=""
for port in `seq 7000 7005`; do
	server_networks="$server_networks `echo -n "$(docker inspect --format '{{ (index .NetworkSettings.Networks "redis-net").IPAddress }}' "redis-${port}")":${port} `"
done

docker exec -it $container_id redis-cli -p 7000 -a test --cluster create $server_networks
