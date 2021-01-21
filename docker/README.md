docker run --network ntdckr --name postgres --volume c:/pgdata:/var/lib/postgresql/data -e POSTGRES_PASSWORD=postgres -e POSTGRES_HOST_AUTH_METHOD=trust postgres

docker run --network ntdckr --name dctm --hostname dctm --volume c:/dmdata:/opt/documentum/data --publish 1489:1489 dctm:20.2
