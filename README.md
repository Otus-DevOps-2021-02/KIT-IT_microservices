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

-----------------------
HW docker-3
-----------------------
Учимся описывать и собирать докер образы для приложения
Учимся оптимизации
Запускаем и работаем с докер образами при помощи docker run

Разбиваем наше приложение на несколько компонентов
Запускаем наше микросервисное приложение

Скачали образ hadolint и попробовали его использовать на докерфайле от предыдущего задания
https://github.com/hadolint/hadolint

sudo docker pull hadolint/hadolint
sudo docker run --rm -i hadolint/hadolint < Dockerfile
-:3 DL3009 info: Delete the apt-get lists after installing something
-:4 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.
-:4 DL3015 info: Avoid additional packages by specifying `--no-install-recommends`
-:4 DL3008 warning: Pin versions in apt get install. Instead of `apt-get install <package>` use `apt-get install <package>=<version>`
-:5 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.
-:5 DL3028 warning: Pin versions in gem install. Instead of `gem install <gem>` use `gem install <gem>:<version>`
-:6 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.
-:12 DL3003 warning: Use WORKDIR to switch to a directory
-:13 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.

Погнали делать домашку.....
Подключаемся к докер машине
eval $(docker-machine env docker-host)
Качаем архив https://github.com/express42/reddit/archive/microservices.zip
Распаковали и переименовали в src
Добавили в каталог докерфайл touch ./post-py/Dockerfile

FROM python:3.6.0-alpine

WORKDIR /app
ADD . /app

RUN apk --no-cache --update add build-base && \
    pip install -r /app/requirements.txt && \
    apk del build-base

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]

touch ./comment/Dockerfile

FROM ruby:2.2
RUN apt-get update -qq && apt-get install -y build-essential

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]

touch ./ui/Dockerfile

Скачаем последний образ MongoDB:
docker pull mongo:latest

Соберем образы с нашими сервисами:
sudo docker build -t kitit/post:1.0 ./post-py
Collecting MarkupSafe>=2.0 (from Jinja2>=2.4->flask==0.12.3->-r /app/requirements.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz
  Requested MarkupSafe>=2.0 from https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz#sha256=594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a (from Jinja2>=2.4->flask==0.12.3->-r /app/requirements.txt (line 2)), but installing version None
You are using pip version 9.0.1, however version 21.1.2 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
Successfully built b29a03fb300d
Successfully tagged kitit/post:1.0

sudo docker build -t kitit/comment:1.0 ./comment
debconf: delaying package configuration, since apt-utils is not installed
Successfully built f27165795a59
Successfully tagged kitit/comment:1.0

sudo docker build -t kitit/ui:1.0 ./ui
Warning: the running version of Bundler (1.16.1) is older than the version that created the lockfile (1.17.2). We suggest you upgrade to the latest version of Bundler by running `gem install bundler`.
Successfully built 6c936fa32672
Successfully tagged kitit/ui:1.0

Создадим специальную сеть для приложения:
sudo docker network create reddit
187f0e99e678e16467a5b954730cbab063c26091268e316aeead8063d8d9b4e4

Запустим наши контейнеры
sudo docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
82cd08aa0a2acfe0b10382651af9eef2caecda39071a69d6021c9d07d5a8cadb
sudo docker run -d --network=reddit --network-alias=post kitit/post:1.0
5500427e333334ade4aecd97fe9c5064d042321ea196ed94a5fbe7dac5da0c63
sudo docker run -d --network=reddit --network-alias=comment kitit/comment:1.0
51c13a0c1444e01fad5937848e4e738aa0a2d8165d4686eb5ec4718fab791dcc
sudo docker run -d --network=reddit -p 9292:9292 kitit/ui:1.0
f2887fba12d776b16532b4e477414c04802952d0b3a7f6c2bbf39eca8c962e4b

Что мы сделали?
Создали bridge-сеть для контейнеров, так как сетевые алиасы не работают в сети по умолчанию (о сетях в Docker мы поговорим на следующем занятии)
Запустили наши контейнеры в этой сети
Добавили сетевые алиасы контейнерам
Сетевые алиасы могут быть использованы для сетевых соединений, как доменные имена

sudo docker container ls -a                                                  ✔  
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS                      PORTS                                       NAMES
f2887fba12d7   kitit/ui:1.0        "puma"                   34 minutes ago   Up 34 minutes               0.0.0.0:9292->9292/tcp, :::9292->9292/tcp   pensive_austin
51c13a0c1444   kitit/comment:1.0   "puma"                   34 minutes ago   Up 34 minutes                                                           epic_dewdney
5500427e3333   kitit/post:1.0      "python3 post_app.py"    34 minutes ago   Exited (1) 34 minutes ago                                               quirky_tereshkova
82cd08aa0a2a   mongo:latest        "docker-entrypoint.s…"   35 minutes ago   Up 35 minutes               27017/tcp                                  charming_

kitit/post:1.0 не взлетел, ошибка ниже, задал вопрос в слаке. Иду дальше, так как еще много домашек...
Traceback (most recent call last):
  File "post_app.py", line 7, in <module>
    from flask import Flask, request, Response, abort, logging
  File "/usr/local/lib/python3.6/site-packages/flask/__init__.py", line 19, in <module>
    from jinja2 import Markup, escape
  File "/usr/local/lib/python3.6/site-packages/jinja2/__init__.py", line 8, in <module>
    from .environment import Environment as Environment
  File "/usr/local/lib/python3.6/site-packages/jinja2/environment.py", line 15, in <module>
    from markupsafe import Markup
ImportError: cannot import name 'Markup'

sudo docker images                                                           ✔  
REPOSITORY          TAG            IMAGE ID       CREATED             SIZE
kitit/ui            1.0            6c936fa32672   39 minutes ago      771MB
kitit/comment       1.0            f27165795a59   42 minutes ago      769MB
kitit/post          1.0            b29a03fb300d   About an hour ago   111MB
kitit/otus-reddit   1.0            4137b4a9da2f   34 hours ago        645MB
reddit              latest         4137b4a9da2f   34 hours ago        645MB
mongo               latest         0e120e3fce9a   35 hours ago        449MB
ubuntu              18.04          7d0d8fa37224   7 days ago          63.1MB
hadolint/hadolint   latest         221d8ef6077a   12 days ago         4.17MB
ruby                2.2            6c8e6f9667b2   3 years ago         715MB
tehbilly/htop       latest         4acd2b4de755   3 years ago         6.91MB
python              3.6.0-alpine   cb178ebbf0f2   4 years ago         88.6MB

Сервис ui - улучшаем образ
FROM ubuntu:16.04
RUN apt-get update \
    && apt-get install -y ruby-full ruby-dev build-essential \
    && gem install bundler --no-ri --no-rdoc

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]

sudo docker build -t kitit/ui:2.0 ./ui
debconf: delaying package configuration, since apt-utils is not installed
Don't run Bundler as root. Bundler can ask for sudo if it is needed, and
installing your bundle as root will break this application for all non-root
users on this machine.
Warning: the lockfile is being updated to Bundler 2, after which you will be unable to return to Bundler 1.
Successfully built c756fe6b58c6
Successfully tagged kitit/ui:2.0

Выполнили задание с зведочкой пересобрали образы. Дополнил Докерфайл.2.

sudo docker kill $(sudo docker ps -q)                                      INT ✘  
f2887fba12d7
51c13a0c1444
82cd08aa0a2a

sudo docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
65362f86f89be6005d8e439d5aaf34d6745fe223252be172c11fc5ee58dc432b
sudo docker run -d --network=reddit --network-alias=post kitit/post:1.0
34791b39b2cdb34e28acc5600b088a00883b65038ad6651ec133e73f2b796a45
sudo docker run -d --network=reddit --network-alias=comment kitit/comment:1.0
e5b4d1d39430ce08ac6151d629517a2127c30d733bce4494419db6b88b7998fa
sudo docker run -d --network=reddit -p 9292:9292 kitit/ui:2.0

Ну как бы дичь осталась таже, не запускается сук пост. Я не питонист, так что не буду тратить время. Лучше жену трахну лишний раз, пока дочь мультики смотрит (sudo docker run -d --network=bathroom --network-alias=dickvsvirgin kitit/dojki.com).
sudo docker container ls -a
CONTAINER ID   IMAGE               COMMAND                  CREATED              STATUS                          PORTS                                       NAMES
b1e9f458c4ce   kitit/ui:2.0        "puma"                   15 seconds ago       Up 14 seconds                   0.0.0.0:9292->9292/tcp, :::9292->9292/tcp   wizardly_brahmagupta
e5b4d1d39430   kitit/comment:1.0   "puma"                   45 seconds ago       Up 44 seconds                                                               strange_meninsky
34791b39b2cd   kitit/post:1.0      "python3 post_app.py"    About a minute ago   Exited (1) About a minute ago                                               loving_sutherland
65362f86f89b   mongo:latest        "docker-entrypoint.s…"   2 minutes ago        Up 2 minutes                    27017/tcp

sudo docker volume create reddit_db                                          ✔  
reddit_db


sudo docker kill $(sudo docker ps -q)                                        ✔  
b1e9f458c4ce
e5b4d1d39430
65362f86f89b
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post <your-dockerhub-login>/post:1.0
docker run -d --network=reddit --network-alias=comment <your-dockerhub-login>/comment:1.0
docker run -d --network=reddit -p 9292:9292 <your-dockerhub-login>/ui:2.0

That's ALL, my guy!
-----------------------
HW docker-4
-----------------------
Работа с сетями в Docker
Использование docker-compose

Подключаемся к ранее созданному docker host’у
docker-machine ls                                                                               ✔
NAME          ACTIVE   DRIVER    STATE     URL                          SWARM   DOCKER     ERRORS
docker-host   -        generic   Running   tcp://178.154.229.240:2376           v20.10.7

eval $(docker-machine env docker-host)

Разобраться с работой сети в Docker
• none
• host
• bridge

Запустим контейнер с использованием none-драйвера.
В качестве образа используем joffotron/docker-net-tools
Делаем это для экономии сил и времени, т.к. в его состав уже
входят необходимые утилиты для работы с сетью: пакеты bind-
tools, net-tools и curl.
Контейнер запустится, выполнить команду `ifconfig` и будет
удален (флаг --rm)

docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
Unable to find image 'joffotron/docker-net-tools:latest' locally
latest: Pulling from joffotron/docker-net-tools
3690ec4760f9: Pull complete
0905b79e95dc: Pull complete
Digest: sha256:5752abdc4351a75e9daec681c1a6babfec03b317b273fc56f953592e6218d5b5
Status: Downloaded newer image for joffotron/docker-net-tools:latest
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

В результате, видим:
• что внутри контейнера из сетевых интерфейсов
существует только loopback.
• сетевой стек самого контейнера работает (ping localhost),
но без возможности контактировать с внешним миром.
• Значит, можно даже запускать сетевые сервисы внутри
такого контейнера, но лишь для локальных
экспериментов (тестирование, контейнеры для
выполнения разовых задач и т.д.)

Запустим контейнер в сетевом пространстве docker-хоста
docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig

docker0   Link encap:Ethernet  HWaddr 02:42:7A:E6:DF:54
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

eth0      Link encap:Ethernet  HWaddr D0:0D:10:67:3E:DD
          inet addr:10.128.0.21  Bcast:10.128.0.255  Mask:255.255.255.0
          inet6 addr: fe80::d20d:10ff:fe67:3edd%32541/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:395204 errors:0 dropped:0 overruns:0 frame:0
          TX packets:316302 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:156901038 (149.6 MiB)  TX bytes:32173742 (30.6 MiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1%32541/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:318 errors:0 dropped:0 overruns:0 frame:0
          TX packets:318 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:29618 (28.9 KiB)  TX bytes:29618 (28.9 KiB)

docker-machine ssh docker-host ifconfig
bash: ifconfig: command not found
exit status 127

docker-machine ssh docker-host sudo apt install -y net-tools

docker-machine ssh docker-host ifconfig

docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:7a:e6:df:54  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.128.0.21  netmask 255.255.255.0  broadcast 10.128.0.255
        inet6 fe80::d20d:10ff:fe67:3edd  prefixlen 64  scopeid 0x20<link>
        ether d0:0d:10:67:3e:dd  txqueuelen 1000  (Ethernet)
        RX packets 395629  bytes 157165813 (157.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 316724  bytes 32237810 (32.2 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 328  bytes 30568 (30.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 328  bytes 30568 (30.5 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

docker run --network host -d nginx                                                           ✔
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
b4d181a07f80: Pull complete
edb81c9bc1f5: Pull complete
b21fed559b9f: Pull complete
03e6a2452751: Pull complete
b82f7f888feb: Pull complete
5430e98eba64: Pull complete
Digest: sha256:47ae43cdfc7064d28800bc42e79a429540c7c80168e8c8952778c0d5af1c09db
Status: Downloaded newer image for nginx:latest
1f27f322bc018c5262453d5aeb6afef17c78f2fe79d2fcf94cd68e0679922b0f

docker ps                                                                              ✔  11s
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
1f27f322bc01   nginx     "/docker-entrypoint.…"   6 seconds ago   Up 3 seconds             keen_chebyshev

docker run --network host -d nginx                                                           ✔
f0b5e08ddd3d00ef2895e4ed1b4281eecef723208f8e04574dfd7c7403de75ae

docker run --network host -d nginx                                                           ✔
c0baf347875d3e6934445dd50b1099f65a1d7fa675213cd1b1dc64d9e6ce2939

docker ps                                                                                    ✔
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
1f27f322bc01   nginx     "/docker-entrypoint.…"   21 seconds ago   Up 18 seconds             keen_chebyshev

docker kill $(docker ps -q)                                                                  ✔
1f27f322bc01

ssh yc-user@178.154.229.240
yc-user@docker-host:~$

sudo ln -s /var/run/docker/netns /var/run/netns
sudo ip netns
default

docker run --network none -d nginx                                                 ✔
f46594cfd027d72617ac67ad03ba923471aaa276acc41b5de1fb19113de7d71a

docker run --network none -d nginx                                        125 ✘  4s
4f53cc9eb42bb2c856f10aa4e1f2fb0ec1e5cfb2e8be45084166013067466ad5

ssh yc-user@178.154.229.240

yc-user@docker-host:~$ sudo ip netns
618e6fc7fb0e
default

yc-user@docker-host:~$ sudo ip netns exec 618e6fc7fb0e ifconfig
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Создадим bridge-сеть в docker (флаг --driver указывать не
обязательно, т.к. по-умолчанию используется bridg

docker network create reddit --driver bridge                                       ✔
7c12398ee3064e28e07452afd2aea2640479bdde20cd0133fc06327021769229

docker  network ls                                                                  ✔
NETWORK ID     NAME      DRIVER    SCOPE
b60efe00f607   bridge    bridge    local
5e9a2608ed23   host      host      local
87834e203c28   none      null      local
7c12398ee306   reddit    bridge    local

Запустим наш проект reddit с использованием bridge-сети
docker run -d --network=reddit mongo:latest
docker run -d --network=reddit kitit/post:1.0
docker run -d --network=reddit kitit/comment:1.0
docker run -d --network=reddit -p 9292:9292 kitit/ui:1.0

Все конейнеры поднялись. Can't show blog posts, some problems with the post service. Refresh?
На самом деле, наши сервисы ссылаются друг на друга по dns-
именам, прописанным в ENV-переменных (см Dockerfile). В текущей
инсталляции встроенный DNS docker не знает ничего об этих
именах.
Решением проблемы будет присвоение контейнерам имен или
сетевых алиасов при старте:
--name <name> (можно задать только 1 имя)
--network-alias <alias-name> (можно задать множество алиасов)

docker kill $(docker ps -q)
b2208736b217
b31b68348f47
18f207b38a50
0b2ae089919c

docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post kitit/post:1.0
docker run -d --network=reddit --network-alias=comment  kitit/comment:1.0
docker run -d --network=reddit -p 9292:9292 kitit/ui:1.0

Все конейнеры поднялись. Приложение заработало корректно.

Bridge network driver
Давайте запустим наш проект в 2-х bridge сетях. Так , чтобы сервис ui
не имел
доступа к базе данных в соответствии со схемой ниже.

docker kill $(docker ps -q)
08b2560e48d1
4dcb7a5b4b7d
ed2c7008e5d7
22bbb8300b08

docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24
NETWORK ID     NAME        DRIVER    SCOPE
18f4fb83959e   back_net    bridge    local
b60efe00f607   bridge      bridge    local
2bda1ec86967   front_net   bridge    local
5e9a2608ed23   host        host      local
87834e203c28   none        null      local
7c12398ee306   reddit      bridge    local

docker run -d --network=front_net -p 9292:9292 --name ui  kitit/ui:1.0
docker run -d --network=back_net --name comment  kitit/comment:1.0
docker run -d --network=back_net --name post  kitit/post:1.0
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest

Что пошло не так?
Docker при инициализации контейнера может подключить к нему только 1
сеть.
При этом контейнеры из соседних сетей не будут доступны как в DNS, так
и для взаимодействия по сети.
Поэтому нужно поместить контейнеры post и comment в обе сети.
Дополнительные сети подключаются командой:
> docker network connect <network> <container>

Подключим контейнеры ко второй сети
docker network connect front_net post
docker network connect front_net comment
Приложение заработало корректно. Теперь понятно.

Давайте посмотрим как выглядит сетевой стек Linux в
текущий момент, опираясь на схему из предыдущего
слайда:
1) Зайдите по ssh на docker-host и установите пакет bridge-utils
> docker-machine ssh docker-host
> sudo apt-get update && sudo apt-get install bridge-utils
2) Выполните:
> docker network ls
3) Найдите ID сетей, созданных в рамках проекта.
4) Выполните :
> ifconfig | grep br
br-18f4fb83959e: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.1  netmask 255.255.255.0  broadcast 10.0.2.255
br-2bda1ec86967: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.1.1  netmask 255.255.255.0  broadcast 10.0.1.255
br-7c12398ee306: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.18.0.1  netmask 255.255.0.0  broadcast 172.18.255.255
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet 10.128.0.21  netmask 255.255.255.0  broadcast 10.128.0.255
5) Найдите bridge-интерфейсы для каждой из сетей. Просмотрите
информацию о каждом.
6) Выберите любой из bridge-интерфейсов и выполните команду. Ниже
пример вывода:
yc-user@docker-host:~$ brctl show br-18f4fb83959e
bridge name     bridge id               STP enabled     interfaces
br-18f4fb83959e         8000.0242cb13b558       no              veth77e2c39
                                                        vethb40b885
                                                        vethb5a2540
Отображаемые veth-интерфейсы - это те части виртуальных пар
интерфейсов (2 на схеме), которые лежат в сетевом пространстве хоста и
также отображаются в ifconfig. Вторые их части лежат внутри контейнеров
7) Давайте посмотрим как выглядит iptables. Выполним:
> sudo iptables -nL -t nat (флаг -v даст чуть больше инфы)
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  10.0.1.0/24          0.0.0.0/0
MASQUERADE  all  --  10.0.2.0/24          0.0.0.0/0
MASQUERADE  all  --  172.18.0.0/16        0.0.0.0/0
MASQUERADE  all  --  172.17.0.0/16        0.0.0.0/0
MASQUERADE  tcp  --  10.0.1.2             10.0.1.2             tcp dpt:9292

Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:9292 to:10.0.1.2:9292
Обратите внимание на цепочку POSTROUTING. В ней вы увидите нечто
подобное
Chain POSTROUTING (policy ACCEPT)
target
prot opt source
!MASQUERADE all -- 10.0.2.0/24
!MASQUERADE all -- 172.18.0.0/16
!MASQUERADE all -- 172.17.0.0/16
!MASQUERADE tcp -- 172.18.0.2
destination
0.0.0.0/0
0.0.0.0/0
0.0.0.0/0
172.18.0.2
tcp dpt:9292
8) В ходе работы у нас была необходимость публикации порта контейнера
UI (9292) для доступа к нему снаружи.
Давайте посмотрим, что Docker при этом сделал. Снова взгляните в iptables
на таблицу nat.
Обратите внимание на цепочку DOCKER и правила DNAT в ней.
DNAT
tcp
--
0.0.0.0/0
0.0.0.0/0
tcp dpt:9292 to:172.18.0.2:9292
Они отвечают за перенаправление трафика на адреса уже конкретных
контейнеров.
9) Также выполните:
> ps ax | grep docker-proxy
Вы должны увидеть хотя бы 1 запущенный процесс docker-proxy.
Этот процесс в данный момент слушает сетевой tcp-порт 9292.
 9437 pts/0    S+     0:00 grep --color=auto docker-proxy
31693 ?        Sl     0:00 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 9292 -container-ip 10.0.1.2 -container-port 9292
31700 ?        Sl     0:00 /usr/bin/docker-proxy -proto tcp -host-ip :: -host-port 9292 -container-ip 10.0.1.2 -container-port 9292

Docker-compose
Проблемы
• Одно приложение состоит из множества контейнеров/
сервисов
• Один контейнер зависит от другого
• Порядок запуска имеет значение
• docker build/run/create ... (долго и много)
• Отдельная утилита
• Декларативное описание docker-инфраструктуры в YAML-
формате
• Управление многоконтейнерными приложениями
• Установить docker-compose на локальную
машину
• Собрать образы приложения reddit с помощью
docker-compose
• Запустить приложение reddit с помощью docker-
compose

Установка docker-
compose
• MacOS - идет в docker-бандле
(https://docs.docker.com/docker-for-mac/install/)
• Windows - идет в docker-бандле
(https://docs.docker.com/docker-for-windows/install/)
• Linux - (https://docs.docker.com/compose/install/#install-
compose)
либо
> pip install docker-compose

/usr/bin/python3.8 -m pip install --upgrade pip

В директории с проектом reddit-microservices, папка
src, из предыдущего домашнего задания создайте
файл docker-compose.yml
Содержимое по ссылке скопируйте в docker-
compose.yml, ознакомьтесь с описанием нашего
проекта при помощи compose

touch docker-compose.yml

Переменные окружения в docker-compose
Отметим, что docker-compose поддерживает интерполяцию
(подстановку) переменных окружения.
В данном случае это переменная USERNAME.
Поэтому перед запуском необходимо экспортировать
значения данных переменных окружения.
Остановим контейнеры, запущенные на предыдущих шагах
> docker kill $(docker ps -q)
f98bf1988f6a
762261dc0d39
48e7c49f18cf
c90315c30900
Выполните:
> export USERNAME=kitit
> docker-compose up -d
Creating src_post_db_1 ... done
Creating src_post_1    ... done
Creating src_comment_1 ... done
Creating src_ui_1      ... done
> docker-compose ps
    Name                  Command             State                    Ports
----------------------------------------------------------------------------------------------
src_comment_1   puma                          Up
src_post_1      python3 post_app.py           Up
src_post_db_1   docker-entrypoint.sh mongod   Up      27017/tcp
src_ui_1        puma                          Up      0.0.0.0:9292->9292/tcp,:::9292->9292/tcp

Apllication is working!

Для задания имя проекта воспользовался ссылкой на stackoverflow.
https://stackoverflow.com/questions/44924082/set-project-name-in-docker-compose-file
-----------------------
HW gitlab-ci-1
-----------------------
Устройство Gitlab CI. Построение процесса непрерывной поставки
1. Создание новой ветки
Создайте новую ветку в вашем репозитории для выполнения данного ДЗ
и назовите ветку gitlab-ci-1
Проверка этого ДЗ производится через подтверждение пулл-реквеста
одним из преподавателей. После аппрува ветку можно будет смержить

Цель задания
Подготовить инсталляцию Gitlab CI
Подготовить репозиторий с кодом приложения
Описать для приложения этапы пайплайна
Определить окружения

Инсталляция Gitlab CI
Для выполнения этого ДЗ нам потребуется развернуть свой Gitlab CI с
помощью Docker.
CI-сервис является одним из ключевых инфраструктурных сервисов в
процессе выпуска ПО, и к его доступности, бесперебойной работе и
безопасности должны предъявляться повышенные требования.
Мы же в лабораторных целях упростим процедуру установки и
настройки.

Новая ВМ помощнее
Gitlab CI состоит из множества компонентов и выполняет
ресурсозатратную работу, например, компиляцию приложений.
Нам потребуется создать в Yandex.Cloud новую виртуальную машину со
следующими параметрами:
1 CPU
4 GB RAM
50 GB HDD
Ubuntu 18.04
В официальной документации https://docs.gitlab.com/ce/install/requirements.html описаны рекомендуемые характеристики сервера.

Для создания сервера вы можете использовать любой из удобных вам способов:
Веб-консоль Yandex.Cloud
Terraform
Yandex.Cloud CLI
Docker-machine

yc compute instance list

yc compute instance create \
  --name docker-host2 \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50 \
  --memory 4 \
  --ssh-key ~/.ssh/id_rsa.pub

- index: "0"
  mac_address: d0:0d:46:35:12:cb
  subnet_id: e9b4uf3p0hsf3ck1glap
  primary_v4_address:
    address: 10.128.0.19
    one_to_one_nat:
      address: 178.154.241.231
      ip_version: IPV4

docker-machine create \
  --driver generic \
  --generic-ip-address=178.154.241.231\
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/id_rsa \
  docker-host2

eval $(docker-machine env docker-host2)

Omnibus
Для запуска Gitlab CI мы будем использовать omnibus-установку. У этого
подхода есть как свои плюсы, так и минусы.
Основной плюс для нас в том, что мы можем быстро запустить сервис и
сконцентрироваться на процессе непрерывной поставки.
Минусом такого типа установки является то, что такую инсталяцию
тяжелее эксплуатировать и дорабатывать, но долговременная эксплуатация
этого сервиса не входит в наши цели.
Более подробно об этом в https://docs.gitlab.com/ce/install/requirements.html

2.2. Установка Docker
На нашем новом сервере для Gitlab CI должен каким-то образом
появиться Docker.
Вы уже знаете, как установить Docker на сервер:
Вручную
С помощью docker-machine
С помощью Ansible (плейбук или готовая роль)
Если остановились на ручной установке, то инструкции для Ubuntu
можно найти здесь https://docs.docker.com/engine/install/ubuntu/

Помимо всего прочего, нам нужно на новом сервере создать
необходимые директории и подготовить docker-compose.yml .
mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs
cd /srv/gitlab
touch docker-compose.yml

sudo mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs

sudo nano docker-compose.yml
web:
  image: 'gitlab/gitlab-ce:latest'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'http://<YOUR-VM-IP>'
  ports:
    - '80:80'
    - '443:443'
    - '2222:22'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'

2.5. Запуск контейнера
Запустите контейнер и подождите, пока скачаются образы и Gitlab CI
запустится и произведет первичную настройку (около 3-5 минут):
# В той же директории, где docker-compose.yml ( /srv/gitlab )
docker-compose up -d

Пока GitLab стартует, можно почитать, откуда мы взяли содержимое
файла docker-compose.yml :
https://docs.gitlab.com/omnibus/docker/README.html#install-gitlab-
using-docker-compose

2.6. Проверка успешности
Если все прошло успешно, то вы сможете в браузере перейти на
http://your-vm-ip и увидеть там:

Ни в какую не отдает первоначальную страницу для ввода пароля.
Пришлось зайти в конейтенер и поменять вручную.
sudo docker exec -it 564d4905585f bash
root@gitlab:/# gitlab-rake "gitlab:password:reset"
Enter username: root
Enter password:
Confirm password:
Password successfully updated for user with username root.

Через
Settings -> General -> Sign-up restrictions
отключите возможность
регистрации, она нам не нужна. Не забудьте сохранять изменения в настройках:
Отключили.

Вспомните:
Каждый проект в Gitlab CI принадлежит к группе проектов
В проекте может быть определен CI/CD-пайплайн
Задачи ( jobs) в пайплайне должны исполняться на так называемых
раннерах

Перейдите в соответствующую панель и создайте группу:
Name - homework
Description - Projects for my homework
Visibility - private
Создали

Создайте проект с именем example :
Создали

Чтобы использовать репозиторий проекта GitLab, вы должны добавить
ещё один remote к своему локальному infra-репозиторию:
git checkout -b gitlab-ci-1
git remote add gitlab http://178.154.241.231/homework/example.git
git push gitlab gitlab-ci-1

Добавили .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

build_job:
  stage: build
  script:
    - echo 'Building'

test_unit_job:
  stage: test
  script:
    - echo 'Testing 1'

test_integration_job:
  stage: test
  script:
    - echo 'Testing 2'

deploy_job:
  stage: deploy
  script:
    - echo 'Deploy'


Запушьте изменения:
git add .gitlab-ci.yml
git commit -m 'add pipeline definition'
git push gitlab gitlab-ci-1

Агга, добавлял один файл, запушил весь проект целиков с предыдушими домашками, ну ладн.

Теперь, если перейти в раздел
CI/CD -> Pipelines , вы увидите, что пайплайн
попытался запуститься, но находится в статусе pending или stuck , так как у нас пока нет
раннеров.
Нужно создать и зарегистрировать раннер.
Для регистрации нужен токен. Увидеть его можно в настройках проекта:
Settings -> CI/CD -> Pipelines ->
Runners и посмотреть на секцию Set up a specific Runner manually :


Set up a specific runner manually
    Install GitLab Runner and ensure it's running.
    Register the runner with this URL:
    http://178.154.241.231/
And this registration token:
LyptE-L2ZXMuznNBv7_7

На сервере, где работает Gitlab CI, выполните команду:
docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest

После запуска раннер нужно зарегистрировать. На сервере, где
работает Gitlab CI, выполните команду, подставив свои IP и токен:
docker exec -it gitlab-runner gitlab-runner register \
--url http://178.154.241.231/ \
--non-interactive \
--locked=false \
--name DockerRunner \
--executor docker \
--docker-image alpine:latest \
--registration-token LyptE-L2ZXMuznNBv7_7 \
--tag-list "linux,xenial,ubuntu,docker" \
--run-untagged
Registering runner... succeeded                     runner=LyptE-L2
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!

Опции и их значения можно подсмотреть так:
docker exec -it gitlab-runner gitlab-runner register --help

Если все получилось, то в настройках вы увидите новый раннер:
#1 (PU5g7P9L)
DockerRunner

После добавления раннера пайплайн должен был запуститься:
Да, в статусе Passed.

Добавьте исходный код reddit в репозиторий:
git clone https://github.com/express42/reddit.git && rm -rf ./reddit/.git
git add reddit/
git commit -m "Add reddit app"
git push gitlab gitlab-ci-1

Измените описание пайплайна в .gitlab-ci.yml :

image: ruby:2.4.2
stages:
...
variables:
DATABASE_URL: 'mongodb://mongo/user_posts'
before_script:
- cd reddit
- bundle install
...
test_unit_job:
stage: test
services:
- mongo:latest
script:
- ruby simpletest.rb

В описании pipeline вы добавили вызов теста в файле simpletest.rb .
Нужно создать его в папке reddit
require_relative './app'
require 'test/unit'
require 'rack/test'

set :environment, :test

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_get_request
    get '/'
    assert last_response.ok?
  end
end

Последним шагом вам нужно добавить библиотеку
rack-test для
тестирования в файл reddit/Gemfile :
gem 'rack-test'

Запушьте код в GitLab. Убедитесь, что теперь test_unit_job гоняет
тесты:
Гоняет успешно, но были ошибки при билде boundle not found Убрал команду boundle install.

В пайплайне мы создали задачу ( job) с названием deploy_job , но не
определили, что и куда будет задеплоено.
Изменим пайплайн таким образом, чтобы  deploy_job стал
определением окружения dev, на которое условно будет выкатываться
каждое изменение в коде проекта.
После изменения файла .gitlab-ci.yml не забывайте зафиксировать изменение в git и
отправить изменения на сервер (git commit
и git push gitlab gitlab-ci-1).
