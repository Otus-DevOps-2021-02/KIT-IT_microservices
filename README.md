# KIT-IT_microservices
KIT-IT microservices repository
HW docker-2
sudo docker run hello-world
sudo docker ps -a
sudo docker images
sudo docker run -it ubuntu:18.04 /bin/bash
sudo docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}"
docker system df - отображает сколько дискового пространства занято образами, конейнерами и voluameами
Отображает скролкьо из них н испольхзуется и возможно удалить
sudo docker rm $(sudo docker ps -a -q) 
sudo docker rmi $(sudo docker images -q) 
Установите Yandex Cloud CLI
Mac OS и Windows: идет в комплекте с docker (docker-machine -v)Linux: docker-machine - встроенный в докер инструмент для создания хостови установки на них docker engine. Имеет поддержку облаков и системвиртуализации (Virtualbox, GCP и др.)Команда создания - docker-machine create <имя>. Имен может бытьмного, переключение между ними через eval $(docker-machine env<имя>). Переключение на локальный докер - eval $(docker-machineenv --unset). Удаление - docker-machine rm <имя>.
Docker machineyc создаст инстанс из стандартного образа в image-family ubuntu-1804-ltsdocker-machine инициализирует на нём докер хост системуВсе докер команды, которые запускаются в той же консоли после eval$(docker-machine env <имя>) работают с удаленным докер демоном вYandex Cloud.

yc compute instance create \
  --name docker-host \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
  --ssh-key ~/.ssh/id_rsa.pub

- index: "0"
  mac_address: d0:0d:10:67:3e:dd
  subnet_id: e9b4uf3p0hsf3ck1glap
  primary_v4_address:
    address: 10.128.0.21
    one_to_one_nat:
      address: 178.154.229.240
      ip_version: IPV4
	
docker-machine create \
  --driver generic \
  --generic-ip-address=178.154.229.240\
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/id_rsa \
  docker-host

Checking connection to Docker...
Docker is up and running!

eval $(docker-machine env docker-host)

docker-machine ls
NAME          ACTIVE   DRIVER    STATE     URL                          SWARM   DOCKER     ERRORS
docker-host   *        generic   Running   tcp://178.154.229.240:2376           v20.10.7 


Dockerfile-текстовоеописаниенашегообраза
mongod.conf-подготовленныйконфигдляmongodbdb_config-содержит переменную окружениясоссылкойнаmongodb
start.sh-скрипт запускаприложенияВсяработапроисходитвпапке dockermonolith

sudo docker build -t reddit:latest .

sudo docker images -a

можно запустить наш контейнер командой
sudo docker run --name reddit -d --network=host reddit:latest
 ~/De/K/OTUS/KIT-IT_microservices/dockermonolith  docker-2 !1 ?1  sudo docker run --name reddit -d --network=host reddit:latest              ✔ 
30621f893d9f9e30497835cd82dab43ae202670efe93882ce9901279eca79e47

sudo docker login 
sudo docker tag reddit:latest kitit/otus-reddit:1.0
sudo docker push kitit/otus-reddit:1.0

sudo docker run --name reddit -d -p 9292:9292 kitit/otus-reddit:1.0



