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

Тут понятно. Все увидели.

Staging и Production
Если на dev мы можем выкатывать последнюю версию кода, то к
окружению production это может быть неприменимо, если, конечно, вы не
стремитесь к continiuos deployment.
Давайте определим два новых этапа: stage и production. Первый будет
содержать задачу, имитирующую выкатку на окружение staging, второй - на
production.
Определим эти задачи таким образом, чтобы они запускались вручную,
с помощью аргумента when: manual

Условия и ограничения
Обычно на production выводится приложение с явно зафиксированной
версией (например, 2.4.10).
Добавим в описание пайплайна директиву, которая не позволит нам
выкатить на staging и production код, не помеченный с помощью тэга в git.

Изменения без указания тэга запустят пайплайн без задач staging и
production.
Изменение, помеченное тэгом в git, запустит полный пайплайн.
git commit -am '#4 add logout button to profile page'
git tag 2.4.10
git push gitlab gitlab-ci-1 --tags

Gitlab CI позволяет определить динамические окружения. Эта мощная
функциональность позволяет вам иметь выделенный стенд для, например,
каждой feature-ветки в git.
Определяются динамические окружения с помощь переменных, доступных в .gitlab-ci.yml .

Создал пару веток. Все получилось. Очень понравился гитлаб. Делал с удовольствием. Спасибо.
-----------------------
HW monitoring-1
-----------------------
git checkout -b monitoring-1

План
Prometheus: запуск, конфигурация, знакомство с Web UI
Мониторинг состояния микросервисов
Сбор метрик хоста с использованием экспортера
Задания со *

Создадим Docker хост в Yandex Cloud и настроим локальное окружение
на работу с ним

yc compute instance create \
  --name docker-host \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
  --ssh-key ~/.ssh/id_rsa.pub

- index: "0"
  mac_address: d0:0d:1a:30:50:cc
  subnet_id: e9b4uf3p0hsf3ck1glap
  primary_v4_address:
    address: 10.128.0.7
    one_to_one_nat:
      address: 130.193.51.194
      ip_version: IPV4

docker-machine create \
  --driver generic \
  --generic-ip-address=130.193.51.194 \
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/id_rsa \
  docker-host

Docker is up and running!

eval $(docker-machine env docker-host)

Систему мониторинга Prometheus будем запускать внутри Docker
контейнера. Для начального знакомства воспользуемся готовым образом с
DockerHub.

docker run --rm -p 9090:9090 -d --name prometheus prom/prometheus

docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                                       NAMES
eaa6d86ce456   prom/prometheus   "/bin/prometheus --c…"   6 seconds ago   Up 4 seconds   0.0.0.0:9090->9090/tcp, :::9090->9090/tcp   prometheus

docker-machine ip docker-host
130.193.51.194

Вкладка Console, которая сейчас активирована, выводит численное
значение выражений. Вкладка Graph, левее от нее, строит график
изменений значений метрик со временем

Если кликнем по "insert metric at cursor", то увидим, что Prometheus уже
собирает какие-то метрики. По умолчанию он собирает статистику о своей
работе. Выберем, например, метрику prometheus_build_info и нажмем
Execute, чтобы посмотреть информацию о версии.
prometheus_build_info{branch="HEAD", goversion="go1.16.5", instance="localhost:9090", job="prometheus", revision="b0944590a1c9a6b35dc5a696869f75f422b107a1", version="2.28.1"}

prometheus_build_info - название метрики. Идентификатор собранной
информации.
branch, goversion, instance, job, revision, version - лейблы. Добавляют
метаданные метрике, уточняя её. Использование лейблов дает нам
возможность не ограничиваться лишь одним названием метрик для
идентификации получаемой информации. Лейблы содержатся в {} скобках и
представлены наборами "ключ=значение".
1 - значение метрики. Численное значение метрики, либо NaN, если
значение недоступно.

targets (цели) - представляют собой системы или процессы, за которыми
следит Prometheus. Помним, что Prometheus является pull системой, поэтому
он постоянно делает HTTP запросы на имеющиеся у него адреса
(endpoints). Посмотрим текущий список целей

В Targest сейчас мы видимо только сам Prometheus. У каждой цели есть
свой список адресов (endpoints), по которым следует обращаться для
получения информации.
В веб интерфейсе мы можем видеть состояние каждого endpoint-a (up);
лейбл (instance="someURL"), который Prometheus автоматически добавляет к
каждой метрике, прошедшее с момента последней операции сбора
информации с endpoint-a.
Также здесь отображаются ошибки при  их наличии и можно отфильтровать только неживые таргеты.

Обратите внимание на endpoint, который мы с вами видели на
предыдущем слайде.
Мы можем открыть страницу в веб браузере по данному HTTP пути
(host:port/metrics), чтобы посмотреть, как выглядит та информация, которую
собирает Prometheus.

http://130.193.51.194:9090/metrics

Для перехода к следующему шагу приведем структуру каталогов в
более четкий/удобный вид:
. Создадим директорию docker в корне репозитория и перенесем в
нее директорию docker-monolith и файлы docker-compose.* и все .env
(.env должен быть в .gitignore), в репозиторий закоммичен
.env.example, из которого создается .env
. Создадим в корне репозитория директорию monitoring. В ней будет
хранится все, что относится к мониторингу.
. Не забываем про .gitignore и актуализируем записи при
необходимости
С этого момента сборка сервисов отделена от docker-compose, поэтому инструкции build
можно удалить из docker-compose.yml

Познакомившись с веб интерфейсом Prometheus и его стандартной
конфигурацией, соберем на основе готового образа с DockerHub свой
Docker образ с конфигурацией для мониторинга наших микросервисов.
Создайте директорию monitoring/prometheus. Затем в этой директории
создайте простой Dockerfile, который будет копировать файл конфигурации
с нашей машины внутрь контейнера:
monitoring/prometheus/Dockerfile
FROM prom/prometheus:v2.1.0
ADD prometheus.yml /etc/prometheus/

Конфигурация
Вся конфигурация Prometheus, в отличие от многих других систем
мониторинга, происходит через файлы конфигурации и опции командной
строки.
Мы определим простой конфигурационный файл для собра метрик с
наших микросервисов. В директории monitoring/prometheus создайте
файл prometheus.yml со следующим содержимым (см. след. слайд)

---
global:
  scrape_interval: '5s'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets:
        - 'localhost:9090'

  - job_name: 'ui'
    static_configs:
      - targets:
        - 'ui:9292'

  - job_name: 'comment'
    static_configs:
      - targets:
        - 'comment:9292'

В директории prometheus собираем Docker образ:
$ export USER_NAME=kitit
$ docker build -t $USER_NAME/prometheus .
Successfully built 85db2dd66952
Successfully tagged kitit/prometheus:latest

Образы микросервисов
В коде микросервисов есть healthcheck-и для проверки работоспособности приложения.
Сборку образом теперь необходимо производить при помощи скриптов
docker_build.sh , которые есть в директории каждого сервиса. С его
помощью мы добавим информацию из Git в наш healthcheck.

Соберем images
Выполните сборку образов при помощи скриптов docker_build.sh в
директории каждого сервиса
/src/ui
$ bash docker_build.sh
/src/post-py $ bash docker_build.sh
/src/comment $ bash docker_build.sh
Или сразу все из корня репозитория:
for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done

Образы собраны

docker-compose.yml
Будем поднимать наш Prometheus совместно с микросервисами. Определите в
вашем docker/docker-compose.yml файле новый сервис.
services:
...
  prometheus:
    image: kirillkotovsky/prometheus
    ports:
      - '9090:9090'
    volumes:
      - prometheus_data:/prometheus
    command: # Передаем доп параметры в командной строке
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention=1d' # Задаем время хранения метрик в 1

  volumes:
    prometheus_data:
Отметим, что сборка Docker образов с данного момента производится через
скрипт docker_build.sh


docker-compose up -d
CONTAINER ID   IMAGE               COMMAND                  CREATED              STATUS          PORTS                                       NAMES
7411e1d96183   kitit/prometheus    "/bin/prometheus --c…"   About a minute ago   Up 56 seconds   0.0.0.0:9090->9090/tcp, :::9090->9090/tcp   reddit_prometheus_1
ea78c3dd784b   mongo:3.2           "docker-entrypoint.s…"   About a minute ago   Up 58 seconds   27017/tcp                                   reddit_post_db_1
392cd00bdd5d   kitit/comment:1.0   "puma"                   About a minute ago   Up 57 seconds                                               reddit_comment_1
845ccf3d2fa1   kitit/post:2.0      "python3 post_app.py"    About a minute ago   Up 59 seconds                                               reddit_post_1
63ac11183375   kitit/ui:1.0        "puma"                   About a minute ago   Up 59 seconds   0.0.0.0:9292->9292/tcp, :::9292->9292/tcp   reddit_ui_1

Посмотрим список enpoint-ов, с которых собирает информацию
Prometheus. Помните, что помимо самого Prometheus, мы определили в
конфигурации мониторинг ui и comment сервисов. Endpoint-ы должны быть
в состоянии UP .
Есть!

Healtcheck-и представляют собой проверки того, что наш сервис здоров
и работает в ожидаемом режиме. В нашем случае healtcheck выполняется
внутри кода микросервиса и выполняет проверку того, что все сервисы, от
которых зависит его работа, ему доступны.
Если требуемые для его работы сервисы здоровы, то healthcheck
проверка возвращает status=1 , что соответствует тому, что сам сервис
здоров.
Если один из нужных ему сервисов нездоров или недоступен, то
проверка вернет status=0

В веб интерфейсе Prometheus выполните поиск по названию метрики
ui_health
ui_health{branch="monitoring-1",commit_hash="83edb86",instance="ui:9292",job="ui",version="0.0.1"}

Состояние сервиса UI
Построим график того, как менялось значение метрики ui_health со
временем

Обратим внимание, что, помимо имени метрики и ее значения, мы также
видим информацию в лейблах о версии приложения, комите и ветке кода в
Git-е.

Видим, что статус UI сервиса был стабильно 1, что означает, что сервис
работал. Данный график оставьте открытым.
Если у вас статус не равен 1, проверьте какой сервис недоступен
(слайд 32), и что у вас заданы все aliases для DB.
У меня все ровно!

Остановим post сервис
Мы говорили, что условились считать сервис здоровым, если все
сервисы, от которых он зависит также являются здоровыми.
Попробуем остановить сервис post на некоторое время и проверим, как
изменится статус ui сервиса, который зависим от post.
$ docker-compose stop post
Stopping docker_post_1 ... done

Метрика изменилас свое значение на 0, что означает, что UI сервис стал
нездоров

Поиск проблемы
Помимо статуса сервиса, мы также собираем статусы сервисов, от
которых он зависит. Названия метрик, значения которых соответствует
данным статусам, имеет формат ui_health_<service-name>.
Посмотрим не случилось ли чего плохого с сервисами, от которых
зависит UI сервис.
Наберем в строке выражений ui_health_ и Prometheus нам предложит
дополнить названия метрик.

Видим, что сервис свой статус не менял в данный промежуток времени

ui_health_post_availability - видим падение

Сбор метрик хоста
Exporters
Экспортер похож на вспомогательного агента для сбора метрик.
В ситуациях, когда мы не можем реализовать отдачу метрик Prometheus
в коде приложения, мы можем использовать экспортер, который будет
транслировать метрики приложения или системы в формате доступном для
чтения Prometheus.

Exporters
Программа, которая делает метрики доступными для сбора Prometheus
Дает возможность конвертировать метрики в нужный для Prometheus
формат
Используется когда нельзя поменять код приложения
Примеры: PostgreSQL, RabbitMQ, Nginx, Node exporter, cAdvisor

Воспользуемся Node экспортер https://github.com/prometheus/node_exporter для сбора информации о работе Docker
хоста (виртуалки, где у нас запущены контейнеры) и представлению этой
информации в Prometheus.

Node экспортер будем запускать также в контейнере. Определим ещё
один сервиc в docker/docker-compose.yml файле
Не забудьте также добавить определение сетей для сервиса node-
exporter, чтобы обеспечить доступ Prometheus к экспортеру.

  node-exporter:
    image: prom/node-exporter:v0.15.2
    user: root
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc)($$|/)"'

prometheus.yml
Чтобы сказать Prometheus следить за еще одним сервисом, нам нужно
добавить информацию о нем в конфиг
Добавим еще один job:
  - job_name: 'node'
    static_configs:
      - targets:
        - 'node-exporter:9100'

monitoring/prometheus $ docker build -t kitit/prometheus .

Пересоздадим наши сервисы
$ docker-compose down
$ docker-compose up -d

Готово. Появилась Node

Проверим мониторинг
Зайдем на хост: docker-machine ssh docker-host
Добавим нагрузки: yes > /dev/null

Графики поползли вверх, здорово!

Запушьте собранные вами образы на DockerHub:
Готово!

Добавьте ссылку на докер хаб с вашими образами в README.md и
описание PR

https://hub.docker.com/repository/docker/kitit/ui
https://hub.docker.com/repository/docker/kitit/post
https://hub.docker.com/repository/docker/kitit/comment
https://hub.docker.com/repository/docker/kitit/prometheus

Задание со *
Добавьте в Prometheus мониторинг MongoDB с использованием
необходимого экспортера.
Версию образа экспортера нужно фиксировать на последнюю стабильную
Если будете добавлять для него Dockerfile, он должен быть в директории
monitoring, а не в корне репозитория
Проект dcu/mongodb_exporter не самый лучший вариант, т. к. у него
есть проблемы с поддержкой (не обновляется)

https://github.com/percona/mongodb_exporter

Dockerfile https://github.com/percona/mongodb_exporter/blob/release-0.1x/Dockerfile

docker build -t kitit/prometheus .
  - job_name: 'mongodb'
    static_configs:
      - targets:
        - 'mongodb_exporter:9216'

docker build -t kitit/mongodb_exporter .


docker-compose down
docker-compose up -d

Creating network "reddit_back-network" with driver "bridge"
Creating network "reddit_front-network" with driver "bridge"
Creating reddit_post_db_1       ... done
Creating reddit_post_1          ... done
Creating reddit_node-exporter_1 ... done
Creating reddit_ui_1            ... done
Creating reddit_comment_1       ... done
Creating reddit_prometheus_1    ... done

Воткнул, но ошибка в таргете  	context deadline exceeded. mongodb (0/1 up). Не пойму в чем проблема.

Задание со *
Добавьте в Prometheus мониторинг сервисов comment, post, ui с
помощью blackbox экспортера
Blackbox exporter позволяет реализовать для Prometheus мониторинг по
принципу черного ящика. Т. е. например мы можем проверить отвечает ли
сервис по http, или принимает ли соединения порт.
Версию образа экспортера нужно фиксировать на последнюю
стабильную
Если будете добавлять для него Dockerfile, он должен быть в директории
monitoring, а не в корне репозитория
Вместо
blackbox_exporter
можете
попробовать
использовать
Cloudprober от Google.

Не особо по теме, но интересную статью нашел. https://habr.com/ru/company/otus/blog/500448/

https://github.com/prometheus/blackbox_exporter

  blackbox-exporter:
    image: prom/blackbox-exporter
    networks:
      - front-network

и

  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Look for a HTTP 200 response
    static_configs:
      - targets:
        - http://comment:9292/healthcheck  # Target to probe
        - http://post:5000/healthcheck  # Target to probe
        - http://ui:9292/healthcheck  # Target to probe
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115  # The blackbox exporter's real hostname:port.

Не взлетел он у меня. Пойду к следующей домашке, мало времени до 20го осталось.
-----------------------
HW monitoring-1
-----------------------
Мониторинг приложения и инфраструктуры
Проект microservices и проверка ДЗ
Создайте новую ветку в вашем
microservices -репозитории для
выполнения данного ДЗ. Это второе задание про мониторинг, ветку
назовите monitoring-2.
Проверка данного ДЗ будет производиться через Pull Request ветки с
ДЗ.
После того, как один из преподавателей сделает approve пул реквеста,
ветку с ДЗ можно смерджить и закрыть Pull Request.

git checkout -b monitoring-2

План
Мониторинг Docker контейнеров
Визуализация метрик
Сбор метрик работы приложения и бизнес метрик
Настройка и проверка алертинга
Много заданий со ⭐ (необязательных)

Подготовка окружения
. Открывать порты в файрволле для новых сервисов нужно
самостоятельно по мере их добавления.
. Создадим Docker хост в Yandex Cloud и настроим локальное окружение
на работу с ним. Не забудьте поменять generic-ip-address на IP адрес
созданного инстанса ( ссылка на gist ):

yc compute instance create \
  --name docker-host \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
  --ssh-key ~/.ssh/id_rsa.pub

- index: "0"
  mac_address: d0:0d:19:1b:5f:33
  subnet_id: e9b4uf3p0hsf3ck1glap
  primary_v4_address:
    address: 10.128.0.5
    one_to_one_nat:
      address: 130.193.50.148
      ip_version: IPV4

docker-machine create \
  --driver generic \
  --generic-ip-address=130.193.50.148 \
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/id_rsa \
  docker-host

eval $(docker-machine env docker-host)

Разделим файлы Docker Compose:
В данный момент и мониторинг и приложения у нас описаны в одном
большом docker-compose.yml . С одной стороны это просто, а с другой -
мы смешиваем различные сущности, и сам файл быстро растет.
Оставим описание приложений в docker-compose.yml , а мониторинг
выделим в отдельный файл docker-compose-monitoring.yml .
Для запуска приложений будем как и ранее использовать docker-
compose up -d , а для мониторинга -
docker-compose -f docker-
compose-monitoring.yml up -d

cAdvisor
Мы будем использовать cAdvisor для наблюдения за
состоянием наших Docker контейнеров.
cAdvisor
собирает информацию о ресурсах потребляемых контейнерами и характеристиках их работы.
Примерами метрик являются:
процент использования контейнером CPU и памяти, выделенные для его
запуска, объем сетевого трафика и др.

Файл docker-compose-monitoring.yml
cAdvisor также будем запускать в контейнере. Для этого добавим новый
сервис в наш компоуз файл мониторинга
docker-compose-monitoring.yml ( ссылка на Gist ).
Поместите данный сервис в одну сеть с Prometheus, чтобы тот мог
собирать с него метрики.

cadvisor:
    image: google/cadvisor:v0.29.0
    volumes:
      - '/:/rootfs:ro'
      - '/var/run:/var/run:rw'
      - '/sys:/sys:ro'
      - '/var/lib/docker/:/var/lib/docker:ro'
    ports:
      - '8080:8080'

Добавим информацию о новом сервисе в конфигурацию Prometheus,
чтобы он начал собирать метрики:
scrape_configs:
...
- job_name: 'cadvisor'
  static_configs:
    - targets:
      - 'cadvisor:8080'
Пересоберем образ Prometheus с обновленной конфигурацией:
$ export COMPOSE_PROJECT_NAME=kitit # где username - ваш логин на Docker Hub
$ docker build -t $COMPOSE_PROJECT_NAME/prometheus .
Successfully built ef07850ed1db
Successfully tagged kitit/prometheus:latest

cAdvisor UI
Запустим сервисы:
$ docker-compose up -d
Creating kitit_prometheus_1       ... done
Creating kitit_post_db_1    ... done
Creating kitit_post_1             ... done
Creating kitit_node-exporter_1    ... done
Creating kitit_mongodb_exporter_1 ... done
Creating kitit_comment_1          ... done
Creating kitit_ui_1               ... done

$ docker-compose -f docker-compose-monitoring.yml up -d
WARNING: Found orphan containers (kitit_post_1, kitit_ui_1, kitit_mongodb_exporter_1, kitit_prometheus_1, kitit_comment_1, kitit_post_db_1, kitit_node-exporter_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
Pulling cadvisor (google/cadvisor:v0.29.0)...
v0.29.0: Pulling from google/cadvisor
81033e7c1d6a: Pull complete
2b6f4f5e677d: Pull complete
7b17d4f3f2e8: Pull complete
Digest: sha256:fce642268068eba88c27c666e92ed4144be6188447a23825015884741cf0e352
Status: Downloaded newer image for google/cadvisor:v0.29.0
Creating kitit_cadvisor_1 ... done

cAdvisor имеет UI, в котором отображается собираемая о контейнерах
информация.
Откроем страницу Web UI по адресу http://130.193.50.148:8080

Нажмите ссылку Docker Containers (внизу слева) для просмотра
информации по контейнерам

Subcontainers
kitit_ui_1 (/docker/8a721c4ec4ec161e54b5051cb3f38d801c96eb8bee18ac19806e6a2dc4d0b44f)
kitit_cadvisor_1 (/docker/ea64926833e41c4f9c7351c082ff3c700b05a011eb76ffd2357afb9fcc2701e6)
kitit_comment_1 (/docker/dcf4e5660438e033ce23c1e80463e67bf025718e7dd84369ee4ed6d9e7dc2752)
kitit_node-exporter_1 (/docker/9da8f267e76d47e564303400b00d08bdfaf71f51ac8332374250e22044fc014c)
kitit_post_1 (/docker/2b0fa644f3058ae4dd82c153579526d26c1404474477adb26b5a6a901ff08720)
kitit_prometheus_1 (/docker/5474f22aa6a03bd8703c273269a248c22bd2091137d2f82a6048a84090c5c01b)
kitit_mongodb_exporter_1 (/docker/23fdf27e4706ada04cf4c19e99429d5440511c2316f3b238554635b01010c9db)
kitit_post_db_1 (/docker/364c8cbd188e781a9ce6b764dd5c9662f4475206f42f3a84f59d492d40790e4b)

В UI мы можем увидеть:
список контейнеров, запущенных на
хосте
информацию о хосте (секция Driver
Status)
информацию об образах контейнеров
(секция Images)

cAdvisor UI
Нажмем на название одного из контейнеров, чтобы посмотреть
информацию о его работе:

По пути /metrics все собираемые метрики публикуются для сбора
Prometheus:

Проверим, что метрики контейнеров собираются Prometheus. Введем,
слово container и посмотрим, что он предложит дополнить:

Используем инструмент Grafana для визуализации данных  из Prometheus.
Добавим новый сервис в docker-compose-monitoring.yml ,
используя пример со следующего слайда или этот gist
i Не забудьте добавить сервис grafana в одну сеть с Prometheus:

services:

  grafana:
    image: grafana/grafana:5.0.0
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=secret
    depends_on:
      - prometheus
    ports:
      - 3000:3000

volumes:
  grafana_data:

Creating kitit_grafana_1 ... done

Запустим новый сервис:
$ docker-compose -f docker-compose-monitoring.yml up -d grafana
Откроем страницу Web UI Grafana по адресу http://<docker-machine-
host-ip>:3000 и используем для входа логин и пароль администратора,
которые мы передали через переменные окружения:

Нажмем Add data source (Добавить источник данных):

Grafana: Добавление источника данных
Зададим нужный тип и параметры подключения:
Name: Prometheus Server
Type: Prometheus
URL: http://prometheus:9090
Access: Proxy
И затем нажмем Save & Test

Перейдем на сайт Grafana https://grafana.com/grafana/dashboards, где можно найти и скачать большое
количество уже созданных официальных и комьюнити дашбордов для
визуализации различного типа метрик для разных систем мониторинга и
баз данных

Выберем в качестве источника данных нашу систему мониторинга
(Prometheus) и выполним поиск по категории Docker. Затем выберем
популярный дашборд:

Нажмем Download JSON.
В директории monitoring создайте директории grafana/dashboards , куда поместите скачанный дашборд.
Поменяйте название файла дашборда на DockerMonitoring.json .

Загрузите скачанный дашборд. При загрузке укажите источник данных
для визуализации (Prometheus Server):

Должен появиться набор графиков с информацией о состоянии
хостовой системы и работе контейнеров:

качестве примера метрик приложения в сервис UI мы добавили :
счетчик ui_request_count , который считает каждый приходящий HTTP-
запрос (добавляя через лейблы такую информацию как HTTP метод, путь,
код возврата, мы уточняем данную метрику)
гистограмму ui_request_response_time , которая позволяет
отслеживать информацию о времени обработки каждого запроса

https://github.com/express42/reddit/commit/d8a0316c36723abcfde367527bad182a8e5d9cf2

Зачем?
Созданные метрики придадут видимости работы нашего приложения и
понимания, в каком состоянии оно сейчас находится.
Например, время обработки HTTP запроса не должно быть большим,
поскольку это означает, что пользователю приходится долго ждать между
запросами, и это ухудшает его общее впечатление от работы с
приложением. Поэтому большое время обработки запроса будет для нас
сигналом проблемы.
Отслеживая приходящие HTTP-запросы, мы можем, например,
посмотреть, какое количество ответов возвращается с кодом ошибки.
Большое количество таких ответов также будет служить для нас сигналом
проблемы в работе приложения.

prometheus.yml
Добавим информацию о post-сервисе в конфигурацию Prometheus,
чтобы он начал собирать метрики и с него:
scrape_configs:
...
- job_name: 'post'
static_configs:
- targets:
- 'post:5000'
Пересоберем образ Prometheus с обновленной конфигурацией:
$ export USER_NAME=username # где, usename - ваш логин от DockerHub
$ docker build -t kitit/prometheus .
Successfully built b07d83531a4c
Successfully tagged kitit/prometheus:latest

prometheus.yml
Пересоздадим нашу Docker инфраструктуру мониторинга:
$ docker-compose -f docker-compose-monitoring.yml down
$ docker-compose -f docker-compose-monitoring.yml up -d
Creating kitit_cadvisor_1      ... done
Creating kitit_prometheus_1    ... done
Creating kitit_node-exporter_1 ... done
Creating kitit_grafana_1       ... done

И добавим несколько постов в приложении и несколько комментов,
чтобы собрать значения метрик приложения:

Создание дашборда в Grafana
Построим графики собираемых метрик приложения. Выберем создать
новый дашборд:
Снова откроем веб-интерфейс
Grafana и выберем создание шаблона (Dashboard)

Создание дашборда в Grafana
. Выбираем "Построить график" (New Panel ➡ Graph)
. Жмем один раз на имя графика (Panel Title), затем выбираем Edit:

Создание дашборда в Grafana
Построим для начала простой график изменения счетчика HTTP-
запросов по времени. Выберем источник данных и в поле запроса введем
название метрики:

Построим для начала простой график изменения счетчика HTTP-
запросов по времени. Выберем источник данных и в поле запроса введем
название метрики:
Далее достаточно нажать мышкой на любое место UI, чтобы убрать
курсор из поля запроса, и Grafana выполнит запрос и построит график

В правом верхнем углу мы можем уменьшить временной интервал, на
котором строим график, и настроить автообновление данных:

Сейчас мы с вами получили график различных HTTP запросов,
поступающих UI сервису:
Изменим заголовок графика и описание:

Построим график запросов, которые возвращают код ошибки на этом
же дашборде. Добавим еще один график на наш дашборд:

В поле запросов запишем выражение для поиска всех http запросов, у
которых код возврата начинается либо с 4 либо с 5 (используем
регулярное выражения для поиска по лейблу). Будем использовать
функцию rate(), чтобы посмотреть не просто значение счетчика за весь
период наблюдения, но и скорость увеличения данной величины за
промежуток времени (возьмем, к примеру 1-минутный интервал, чтобы
график был хорошо видим)

rate(ui_request_count{http_status=~"[45].*"}[1m])

График ничего не покажет, если не было запросов с ошибочным кодом
возврата. Для проверки правильности нашего запроса обратимся по
несуществующему HTTP пути, например, http://:9292/nonexistent, чтобы
получить код ошибки 404 в ответ на наш запрос.

Как вы можете заметить, первый график, который мы сделали просто по
ui_request_count не отображает никакой полезной информации, т.к. тип
метрики count, и она просто растет. Задание: Используйте для первого
графика (UI http requests) функцию rate аналогично второму графику (Rate of
UI HTTP Requests with Error)
rate(ui_request_count[1m])

Гистограмма
Гистограмма представляет собой графический способ представления
распределения вероятностей некоторой случайной величины на заданном
промежутке значений. Для построения гистограммы берется интервал
значений, который может принимать измеряемая величина и разбивается
на промежутки (обычно одинаковой величины), данные промежутки
помечаются на горизонтальной оси X. Затем над каждым интервалом
рисуется прямоугольник, высота которого соответствует числу измерений
величины, попадающих в данный интервал.

Простым примером гистограммы может быть распределение оценок за
контрольную в классе, где учится 21 ученик. Берем промежуток возможных
значений (от 1 до 5) и разбиваем на равные интервалы. Затем на каждом
интервале рисуем столбец, высота которого соответсвует частоте появлению данной оценки.

Histogram метрика
В Prometheus есть тип метрик histogram. Данный тип метрик в качестве
своего значение отдает ряд распределения измеряемой величины в
заданном интервале значений. Мы используем данный тип метрики для
измерения времени обработки HTTP запроса нашим приложением.

Рассмотрим пример гистограммы в Prometheus. Посмотрим информацию
по времени обработки запроса приходящих на главную страницу приложения.

ui_request_response_time_bucket{path="/"}

Эти значения означают, что запросов с временем обработки <= 0.025s
было 3 штуки, а запросов 0.01 <= 0.01s было 7 штук (в этот столбец входят 3
запроса из предыдущего столбца и 4 запроса из промежутка [0.025s; 0.01s],
такую гистограмму еще называют кумулятивной). Запросов, которые бы
заняли > 0.01s на обработку не было, поэтому величина всех последующих
столбцов равна 7.

Процентиль
Числовое значение в наборе значений
Все числа в наборе меньше процентиля, попадают в границы
заданного процента значений от всего числа значений в наборе

Пример процентиля
В классе 20 учеников. Ваня занимает 4-е место по росту в классе. Тогда
рост Вани (180 см) является 80-м процентилем. Это означает, что 80 %
учеников имеют рост менее 180 см.

95-й процентиль
Часто для анализа данных мониторинга применяются значения 90, 95
или 99-й процентиля.
Мы вычислим 95-й процентиль для выборки времени обработки
запросов, чтобы посмотреть какое значение является максимальной
границей для большинства (95%) запросов. Для этого воспользуемся
встроенной функцией histogram_quantile():

Добавьте третий по счету график на ваш дашборд. В поле запроса
введите следующее выражение для вычисления 95 процентиля времени
ответа на запрос (gist):

histogram_quantile(0.95, sum(rate(ui_request_response_time_bucket[5m])) by (le))

Сохраним изменения дашборда и эспортируем его в JSON файл,
который загрузим на нашу локальную машину
Положите загруженный файл в созданную ранее директорию
monitoring/grafana/dashboards под названием UI_Service_Monitoring.json
OK

Сбор метрик бизнес-логики
Мониторинг бизнес-логики
В качестве примера метрик бизнес логики мы в наше приложение мы
добавили счетчики количества постов и комментариев
post_count
comment_count
Мы построим график скорости роста значения счетчика за последний
час, используя функцию rate(). Это позволит нам получать информацию об
активности пользователей приложени

Создайте новый дашборд, назовите его Business_Logic_Monitoring и
постройте график функции rate(post_count[1h])
. Постройте еще один график для счетчика comment, экспортируйте
дашборд и сохраните в директории monitoring/grafana/dashboards под
названием Business_Logic_Monitoring.json.
OK

Алертинг
Правила алертинга
Мы определим несколько правил, в которых зададим условия состояний
наблюдаемых систем, при которых мы должны получать оповещения, т.к.
заданные условия могут привести к недоступности или неправильной
работе нашего приложения.
P.S. Стоит заметить, что в самой Grafana тоже есть alerting. Но по
функционалу он уступает Alertmanager в Prometheus.

Alertmanager
Alertmanager - дополнительный компонент для системы мониторинга
Prometheus, который отвечает за первичную обработку алертов и
дальнейшую отправку оповещений по заданному назначению.
Создайте новую директорию monitoring/alertmanager. В этой директории
создайте Dockerfile со следующим содержимым:
FROM prom/alertmanager:v0.14.0
ADD config.yml /etc/alertmanager/

Alertmanager
Настройки Alertmanager-а как и Prometheus задаются через YAML файл
или опции командой строки. В директории monitoring/alertmanager создайте
файл config.yml, в котором определите отправку нотификаций в ВАШ
тестовый слак канал. Для отправки нотификаций в слак канал потребуется
создать СВОЙ Incoming Webhook monitoring/alertmanager/config.yml cсылка
на gist
global:
  slack_api_url: 'https://hooks.slack.com/services/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'

route:
  receiver: 'slack-notifications'

receivers:
- name: 'slack-notifications'
  slack_configs:
  - channel: '#stanislav_sedunov'

Соберем образ alertmanager:
monitoring/alertmanager $ docker build -t kitit/alertmanager .
Successfully tagged kitit/alertmanager:latest

. Добавим новый сервис в компоуз файл мониторинга. Не забудьте
добавить его в одну сеть с сервисом Prometheus:
services:
...
alertmanager:
image: ${USER_NAME}/alertmanager
command:
- '--config.file=/etc/alertmanager/config.yml'
ports:
- 9093:9093

Alert rules
Создадим файл alerts.yml в директории prometheus, в котором
определим условия при которых должен срабатывать алерт и посылаться
Alertmanager-у. Мы создадим простой алерт, который будет срабатывать в
ситуации, когда одна из наблюдаемых систем (endpoint) недоступна для
сбора метрик (в этом случае метрика up с лейблом instance равным имени
данного эндпоинта будет равна нулю). Выполните запрос по имени метрики
up в веб интерфейсе Prometheus, чтобы убедиться, что сейчас все
эндпоинты доступны для сбора метрик:

alerts.yml
groups:
  - name: alert.rules
    rules:
    - alert: InstanceDown
      expr: up == 0
      for: 1m
      labels:
        severity: page
      annotations:
        description: '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minute'
        summary: 'Instance {{ $labels.instance }} down'

Alert rules
Добавим операцию копирования данного файла в Dockerfile: monitoring/prometheus/Dockerfile
FROM prom/prometheus:v2.1.0
ADD prometheus.yml /etc/prometheus/
ADD alerts.yml /etc/prometheus/

prometheus.yml
Добавим информацию о правилах, в конфиг Prometheus cсылка на gist
global:
scrape_interval: '5s'
...
rule_files:
- "alerts.yml"
alerting:
alertmanagers:
- scheme: http
static_configs:
- targets:
- "alertmanager:9093"
Пересоберем образ Prometheus:
$ docker build -t kitit/prometheus .

Пересоздадим нашу Docker инфраструктуру мониторинга:
$ docker-compose -f docker-compose-monitoring.yml down
$ docker-compose -f docker-compose-monitoring.yml up -d
reating kitit_prometheus_1    ... done
Creating kitit_node-exporter_1 ... done
Creating kitit_alertmanager_1  ... done
Creating kitit_grafana_1       ... done

Алерты можно посмотреть в веб интерфейсе Prometheus:
-----------------------
HW logging-1
-----------------------
1. Создание новой ветки
Создайте новую ветку в вашем репозитории для выполнения данного ДЗ
и назовите ветку logging-1
Проверка этого ДЗ производится через подтверждение пулл-реквеста
одним из преподавателей. После аппрува ветку можно будет смержить

План
Подготовка окружения
Логирование Docker-контейнеров
Сбор неструктурированных логов
Визуализация логов
Сбор структурированных логов
Распределенный трейсинг

2.1. Подготовка окружения - скачивание
новой ветки reddit
Код
микросервисов
обновился
для
добавления
функционала
логирования. Новая версия кода доступа по ссылке .
https://github.com/express42/reddit.git
Обновите код в директории /src вашего репозитория кодом по ссылке
выше
Если вы используете python-alpine в образах, добавьте в /src/post-
py/Dockerfile установку пакетов gcc и musl-dev

2.2. Подготовка окружения - сборка образов
с новыми тэгами
Выполните сборку образов при помощи скриптов docker_build.sh в
директории каждого сервиса и отправьте их в репозиторий:
$
$
$
$
export USER_NAME='kitit'
cd ./src/ui && bash docker_build.sh && docker push $USER_NAME/ui:logging
cd ../post-py && bash docker_build.sh && docker push $USER_NAME/post:logging
cd ../comment && bash docker_build.sh && docker push $USER_NAME/comment:logging
Обратите внимание (см. docker_build.sh), что в этом ДЗ мы
используем отдельные теги для контейнеров приложений: :logging

2.3. Подготовка окружения - создание
docker-machine
Создайте Docker-хост с именем logging в Yandex.Cloud и настройте
локальное окружение на работу с ним.
Вы можете использовать способ создания docker-machine из
предыдущих ДЗ (через драйвер generic) и пропустить шаги ниже. В
этом случае добавьте ключ --memory 4 при создании инстанса.
Ниже инструкция по созданию docker-machine через драйвер yandex-
cloud (работает только для Ubuntu):
Установите golang:
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go

2.3. Подготовка окружения - создание docker-machine (продолжение)
Установите драйвер для Yandex.Cloud:
go get -u github.com/yandex-cloud/docker-machine-driver-yandex
Драйвер установится в $HOME/go/bin . Сделайте любым способом так,
чтобы драйвер был доступен через PATH .
Он установился в $HOME/go/bin . Сделайте бинарник доступным через
$PATH .
export PATH='/home/user/yandex-cloud/bin:/home/user/yandex-cloud/bin:/home/user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/user/go/bin:'
Задайте ID вашего каталога в Yandex.Cloud через переменную:
yc config list
$ export FOLDER_ID='b1gm5hh9fnrpfqagf33g'

2.3. Подготовка окружения - создание docker-machine (продолжение)
Создайте docker-machine:
$ docker-machine create \
--driver yandex \
--yandex-image-family "ubuntu-1804-lts" \
--yandex-platform-id "standard-v1" \
--yandex-folder-id $FOLDER_ID \
--yandex-sa-key-file ~/.ssh/id_rsa \
--yandex-memory "4" \
logging
Переключитесь на Docker Engine docker-машины. Затем получите IP-адрес
машины:
$ eval $(docker-machine env logging)
$ docker-machine ip logging

-------
yc compute instance list

yc compute instance create \
  --name logging \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50 \
  --memory 4 \
  --ssh-key ~/.ssh/id_rsa.pub

- index: "0"
  mac_address: d0:0d:c2:f6:13:5c
  subnet_id: e9b4uf3p0hsf3ck1glap
  primary_v4_address:
    address: 10.128.0.5
    one_to_one_nat:
      address: 178.154.240.85
      ip_version: IPV4

docker-machine create \
  --driver generic \
  --generic-ip-address=178.154.240.85\
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/id_rsa \
  logging

eval $(docker-machine env logging)
------

docker-machine ip logging                                                   ✔
178.154.240.85

Логирование Docker-
контейнеров

Elastic Stack
Как упоминалось на лекции, хранить все логи стоит централизованно: на
одном (нескольких) серверах. В этом ДЗ мы рассмотрим пример системы
централизованного
логирования
на
примере
Elastic-стека
(ранее
известного как ELK), который включает в себя 3 основных компонента:
ElasticSearch (TSDB и поисковый движок для хранения данных)
Logstash (для аггрегации и трансформации данных)
Kibana (для визуализации)
Однако для аггрегации логов вместо Logstash мы будем использовать
Fluentd, таким образом, получая еще одно популярное сочетание этих
инструментов, получившее название EFK.

3.1. Создание compose-файла для системы
логирования
Создайте отдельный compose-файл для нашей системы логирования
docker/docker-compose-logging.yml ( gist ):

version: '3'
services:
  fluentd:
    image: ${USERNAME}/fluentd
    ports:
      - "24224:24224"
      - "24224:24224/udp"

  elasticsearch:
    image: elasticsearch:7.4.0
    environment:
      - ELASTIC_CLUSTER=false
      - CLUSTER_NODE_MASTER=true
      - CLUSTER_MASTER_NODE_NAME=es01
      - discovery.type=single-node
    expose:
      - 9200
    ports:
      - "9200:9200"

  kibana:
    image: kibana:7.4.0
    ports:
      - "5601:5601"

3.2. Создание Dockerfile для Fluentd
Fluentd - инструмент, который может использоваться для отправки,
аггрегации и преобразования лог-сообщений. Мы будем использовать
Fluentd для аггрегации (сбора в одном месте) и парсинга логов сервисов
нашего приложения.
Создадим образ Fluentd с нужной нам конфигурацией.
Создайте в вашем проекте microservices директорию logging/fluentd. В
созданной директории создайте простой Dockerfile со следущим содержимым:
FROM fluent/fluentd:v0.12
RUN gem install fluent-plugin-elasticsearch --no-rdoc --no-ri --version 1.9.5
RUN gem install fluent-plugin-grok-parser --no-rdoc --no-ri --version 1.0.0
ADD fluent.conf /fluentd/etc

3.3. Создание конфигурации Fluentd
В
директории
logging/fluentd
создайте
файл
конфигурации
logging/fluentd/fluent.conf ( gist )

<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<match *.**>
  @type copy
  <store>
    @type elasticsearch
    host elasticsearch
    port 9200
    logstash_format true
    logstash_prefix fluentd
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    tag_key @log_name
    flush_interval 1s
  </store>
  <store>
    @type stdout
  </store>
</match>

3.4. Сборка образа Fluentd
Соберите docker image для fluentd:
cd logging/fluentd
docker build -t $USER_NAME/fluentd .

Cбор
структурированных
логов
Структурированные логи
Логи
должны
иметь
заданную
(единую)
структуру
и
содержать
необходимую для нормальной эксплуатации данного сервиса информацию
о его работе.
Лог-сообщения также должны иметь понятный для выбранной системы
логирования формат, чтобы избежать ненужной траты ресурсов на
преобразование данных в нужный вид. Структурированные логи мы
рассмотрим на примере сервиса post.

4.1. Запуск контейнеров из logging-enabled
образов
Сделайте так, чтобы с помощью файла docker-compose.yml
брались образы с тэгом logging.
Запустите сервисы приложения и Выполните команду для просмотра
логов post сервиса:
cd docker && docker-compose up -d
docker-compose logs -f post
⚠
Внимание!
Среди
логов
можно
наблюдать
проблемы
с
доступностью Zipkin, у нас он пока что и правда не установлен.
Ошибки можно игнорировать. ( Github issue )

Просмотр логов контейнеров
Откройте приложение в браузере и создайте несколько постов,
пронаблюдайте, как пишутся логи post серсиса в терминале
docker/ $ docker-compose logs -f post
Attaching to reddit_post_1
post_1
| {"event": "find_all_posts", "level": "info", "message": "Successfully retrieved all posts from the database", "params": {},
"request_id": "17501ae3-3d4f-4fe6-ac99-ca7cb58492a9", "service": "post", "timestamp": "2017-12-10 23:36:59"}
post_1
| {"addr": "172.21.0.7", "event": "request", "level": "info", "method": "GET", "path": "/posts?", "request_id": "17501ae3-3d4f-4fe6-
ac99-ca7cb58492a9", "response_status": 200, "service": "post", "timestamp": "2017-12-10 23:36:59"}
post_1
| {"event": "post_create", "level": "info", "message": "Successfully created a new post", "params": {"link":
"https://github.com/hynek/structlog", "title": "Structlog is awesome! "}, "request_id": "2aaf1ad3-42cf-4105-b585-d990eb22d85b", "service": "post",
"timestamp": "2017-12-10 23:37:18"}
Каждое событие, связанное с работой нашего приложения логируется в
JSON-формате и имеет нужную нам структуру: тип события (event),
сообщение (message), переданные функции параметры (params), имя
сервиса (service) и др.
Избавляем бизнес от ИТ-зависимости

4.3. Настройка отправки логов во Fluentd
для сервиса post
Как
отмечалось
на
лекции,
по
умолчанию
Docker-контейнерами
используется json-file драйвер для логирования информации, которая
пишется сервисом внутри контейнера в stdout (и stderr). Для отправки логов
во Fluentd используем docker-драйвер fluentd .
Определите драйвер для логирования для сервиса post внутри файла
docker/docker-compose.yml ( ссылка на gist ):

version: '3'
services:
  post:
    image: ${USER_NAME}/post
    environment:
      - POST_DATABASE_HOST=post_db
      - POST_DATABASE=posts
    depends_on:
      - post_db
    ports:
      - "5000:5000"
    logging:
      driver: "fluentd"
      options:
        fluentd-address: localhost:24224
        tag: service.post

4.4. Запуск системы логирования
Поднимите инфраструктуру централизованной системы логирования и
перезапустим сервисы приложения:
$ docker-compose -f docker-compose-logging.yml up -d
Creating kitit_kibana_1        ... done
Creating kitit_fluentd_1       ... done
Creating kitit_elasticsearch_1 ... done
$ docker-compose down
$ docker-compose up -d
Создадим несколько постов в приложении:
OK

Визуализация
5.1. Создание индекса в Kibana
Kibana - инструмент для визуализации и анализа логов от компании
Elastic. Откройте Web-интерфейс Kibana для просмотра собранных в
ElasticSearch логов Post-сервиса (Kibana слушает на порту 5601).
Некоторое время браузер может показывать уведомление "Kibana is not
ready yet" - это нормально.
Разнообразные Getting Started, меняющиеся от версии к версии, можно
скипнуть.
Интерфейс Kibana может значительно поменяться с новой версией.

Найдите элемент панели Discover и нажмите на него:
При первом запуске интерфейс обычно сам предложит настроить
индекс. Если этого не произошло, выберите Index Pattern -> Create Index
Pattern. В поле Index Pattern введите fluentd-* .
OK

Далее укажите поле для Time filter:
OK

Вернитесь на вкладку Discovery и посмотрите на получившийся график.
Он показывает, сколько лог-сообщений было получено в момент времени.
Теперь логи контейнера post хранятся централизованно:

5.3. Поиск по полям в Kibana
Обратите внимание на поля. Их можно использовать для поиска
сообщений по определённому критерию.

Язык запросов Kibana называется KQL .
Сконструируем
простой
запрос
по
части
имени
контейнера:
container_name : *post*

Фильтры
Заметим, что поле log содержит в себе JSON-объект, который содержит
много интересной нам информации.
Нам хотелось бы выделить эту информацию в поля, чтобы иметь
возможность производить по ним поиск. Например, для того чтобы найти
все сообщения, связанные с определенным событием (event) или
конкретным сервисом (service).
Мы можем достичь этого за счет использования фильтров для
выделения нужной информации.

6.1. Добавление фильтра во Fluentd для
сервиса post
Добавьте фильтр для парсинга json-логов, приходящих от сервиса post, в
logging/fluentd/fluent.conf:
<filter service.post>
  @type parser
  format json
  key_name log
</filter>

6.2. Перезапуск Fluentd
Пересоберите образ и перезапустите сервис Fluentd:
logging/fluentd $ docker build -t kitit/fluentd .
docker $ docker-compose -f docker-compose-logging.yml up -d fluentd
Создадим пару новых постов, чтобы проверить парсинг логов:

6.3. Просмотр структурированных логов (продолжение)
Раскройте одно из сообщений и убедитесь, что вместо одного поля log
появилось множество новых полей, которые раньше были в JSON в поле
log.

6.4. Поиск по структурированным логам
Выполните, для примера, поиск по событию создания нового поста. KQL-
запрос: event: post_create :
event:
    post_create
level:
    info
message:
    Successfully created a new post
params.link:
    http://178.154.240.85:9292/new
params.title:
    sdgdsgdsgdsg
request_id:
    6e8fdbfb-ea54-482d-9d70-b1d390d7481f
service:
    post
timestamp:
    2021-07-18 11:19:37
@timestamp:
    Jul 18, 2021 @ 14:19:37.000
@log_name:
    service.post
_id:
    s9tXuXoBUV0jVdg80lKX
_type:
    access_log
_index:
    fluentd-20210718
_score:
    -

Сбор
неструктурированных
логов

Неструктурированные логи
Неструктурированные логи отличаются отсутствием четкой структуры
данных. Также часто бывает, что формат лог-сообщений не подстроен под
систему централизованного логирования, что существенно увеличивает
затраты вычислительных и временных ресурсов на обработку данных и
выделение нужной информации.
На примере сервиса ui мы рассмотрим пример логов с неудобным
форматом сообщений.

7.1. Настройка отправки логов во Fluentd для
сервиса ui
По аналогии с сервисом post, определим для сервиса ui драйвер для
логирования fluentd в docker/docker-compose.yml:
ui:
...
logging:
driver: "fluentd"
options:
fluentd-address: localhost:24224
tag: service.ui
...

7.2. Перезапуск сервиса ui
Перезапустите ui:
docker $ docker-compose stop ui
docker $ docker-compose rm ui
docker $ docker-compose up -d
Произведите какие-нибудь действия на странице приложения reddit, а
затем вернитесь в Kibana и поменяйте запрос на
container_name :
*ui* . Видно, что общая структура у поля log в сообщениях от этого
сервиса отсутствует.

Когда приложение или сервис не пишет структурированные логи,
приходится использовать старые добрые регулярные выражения для их
парсинга в /docker/fluentd/fluent.conf.
Следующее регулярное выражение нужно, чтобы успешно выделить
интересующую нас информацию из лога сервиса ui в поля ( gist ):

source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<filter service.post>
  @type parser
  format json
  key_name log
</filter>

<filter service.ui>
  @type parser
  format /\[(?<time>[^\]]*)\]  (?<level>\S+) (?<user>\S+)[\W]*service=(?<service>\S+)[\W]*event=(?<event>\S+)[\W]*(?:path=(?<path>\S+)[\W]*)?request_id=(?<request_id>\S+)[\W]*(?:remote_addr=(?<remote_addr>\S+)[\W]*)?(?:method= (?<method>\S+)[\W]*)?(?:response_status=(?<response_status>\S+)[\W]*)?(?:message='(?<message>[^\']*)[\W]*)?/
  key_name log
</filter>


<match *.**>
  @type copy
  <store>
    @type elasticsearch
    host elasticsearch
    port 9200
    logstash_format true
    logstash_prefix fluentd
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    tag_key @log_name
    flush_interval 1s
  </store>
  <store>
    @type stdout
  </store>
</match>

7.4. Перезапуск Fluentd
Пересоберите образ и перезапустите сервис Fluentd:
logging/fluentd $ docker build -t $USER_NAME/fluentd .
docker $ docker-compose -f docker-compose-logging.yml up -d fluentd
Recreating kitit_fluentd_1 ... done
Снова сымитируйте какую-нибудь активность на странице нашего
приложения.

В Kibana, сделайте поиск по: @log_name: service.ui
Теперь наши логи как следует распарсены:

8.1. Grok-шаблоны
Созданные регулярки могут иметь ошибки, их сложно менять и ещё сложнее - читать без
применения инструментов навроде этого https://regex101.com/.
Для облегчения задачи парсинга вместо
стандартных регулярок можно использовать grok-шаблоны. По-сути grok'и - это именованные
шаблоны регулярных выражений (очень похоже на функции). Можно использовать готовый
regexp, просто сославшись на него как на функцию.
Добавьте следующий шаблон в конфигурацию Fluentd, убрав шаблон с регулярками.
Ребилдните новый образ Fluentd и перезапустите через docker-compose:
...
<filter service.ui>
  @type parser
  format grok
  grok_pattern %{RUBY_LOGGER}
  key_name log
</filter>
...

8.1. Grok-шаблоны
Созданные регулярки могут иметь ошибки, их сложно менять и ещё сложнее - читать без
применения инструментов навроде этого . Для облегчения задачи парсинга вместо
стандартных регулярок можно использовать grok-шаблоны. По-сути grok'и - это именованные
шаблоны регулярных выражений (очень похоже на функции). Можно использовать готовый
regexp, просто сославшись на него как на функцию.
Добавьте следующий шаблон в конфигурацию Fluentd, убрав шаблон с регулярками.
Ребилдните новый образ Fluentd и перезапустите через docker-compose:
%{RUBY_LOGGER} [(?<timestamp>(?>\d\d){1,2}-(?:0?[1-9]|1[0-2])-(?:(?:0[1-9])|(?:[12][0-9])|(?:3[01])|[1-9])[T ]
(?:2[0123]|[01]?[0-9]):?(?:[0-5][0-9])(?::?(?:(?:[0-5]?[0-9]|60)(?:[:.,][0-9]+)?))?(?:Z|[+-](?:2[0123]|[01]?[0-9])
(?::?(?:[0-5][0-9])))?) #(?<pid>\b(?:[1-9][0-9]*)\b)\] *(?<loglevel>(?:DEBUG|FATAL|ERROR|WARN|INFO)) -- +(?
<progname>.*?): (?<message>.*)

8.3.* Разбор ещё одного формата логов (по
желанию)
Ещё один формат лога остался неразобранным:
Составьте конфигурацию Fluentd так, чтобы разбирались оба формата
логов UI-сервиса (тот, что сделали до этого, и текущий) одновременно.

<filter service.ui>
  @type parser
  format grok
  <grok>
    pattern service=%{WORD:service} \| event=%{WORD:event} \| request_id=%{GREEDYDATA:request_id} \| message='%{GREEDYDATA:message}'
  </grok>
  <grok>
    pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{URIPATH:path} \| request_id=%{GREEDYDATA:request_id} \| remote_addr=%{IP:remote_addr} \| method= %{WORD:message} \| response_status=%{INT:response_status}
  </grok>
  key_name message
  reserve_data true
</filter>

Распределенный
трейсинг
9.1. Добавление Zipkin в систему
логирования
Добавьте
в
compose-файл
для
сервисов
логирования
сервис
распределенного трейсинга Zipkin ( gist ):
  zipkin:
    image: openzipkin/zipkin:2.21.0
    ports:
      - "9411:9411"
...

9.2. Включение Zipkin
Добавьте для каждого сервиса в нашем приложении reddit параметр
ZIPKIN_ENABLED (docker-compose.yml):
environment:
- ZIPKIN_ENABLED=${ZIPKIN_ENABLED}
В .env-файле укажите:
ZIPKIN_ENABLED=true
docker-compose up -d
Избавляем бизнес от ИТ-зависимости
53 / 619.3. Подключение Zipkin к кастомным сетям
Zipkin должен быть в одной сети с приложениями, поэтому, если вы
выполняли задание на создание сетей для backend и frontend, вам нужно
объявить эти сети в docker-compose-logging.yml и добавить в них Zipkin
похожим образом. Пример:
services:
zipkin:
image: openzipkin/zipkin
ports:
- "9411:9411"
networks:
- front_net
- back_net
...
networks:
back_net:
front_net:
Избавляем бизнес от ИТ-зависимости
54 / 619.4. Переподнятие инфраструктуры
логирования
С
помощью
docker-compose
поднимите
изменённую
систему
логирования:
$ docker-compose -f docker-compose-logging.yml -f docker-compose.yml down
$ docker-compose -f docker-compose-logging.yml -f docker-compose.yml up -d
Creating kitit_fluentd_1       ... done
Creating kitit_kibana_1        ... done
Creating kitit_elasticsearch_1 ... done
Creating kitit_post_db_1       ... done
Creating kitit_zipkin_1        ... done
Creating kitit_comment_1       ... done
Creating kitit_post_1          ... done
Creating kitit_ui_1            ... done

9.5. Просмотр трейсов в Zipkin
Откройте web-интерфейс Zipkin на порту 9411. Пока вы не найдёте
никаких трейсов, т.к. никаких запросов нашему приложению еще не
поступало.

Нажмите на один из трейсов, чтобы посмотреть, как запрос шел через
нашу систему микросервисов и каково общее время обработки запроса у
нашего приложения при запросе главной страницы:

Видно, что первым делом наш запрос попал к сервису ui, который смог
обработать наш запрос за суммарное время, равное 73.475 ms.
Из этих 73.475 ms ушло 20.051 ms на то, чтобы ui мог направить запрос
сервису post по пути /posts и получить от него ответ в виде списка постов.
Синие полоски со временем называются span и представляют собой
одну операцию, которая произошла при обработке запроса. Набор span'ов
- это и есть трейс. Суммарное время обработки нашего запроса равно
верхнему
span'у,
который
включает
в
себя
время
всех
span'ов,
расположенных под ним.

С нашим приложением происходит что-то странное. Пользователи
жалуются, что при нажатии на пост они вынуждены долго ждать, пока у них
загрузится страница с постом. Жалоб на загрузку других страниц не
поступало. Нужно выяснить, в чем проблема, используя Zipkin.
Код приложения с багом отличается от используемого ранее в этом ДЗ и
доступен в репозитории со сломанным кодом приложения. Т.е. необходимо
сбилдить багнутую версию приложения и запустить Zipkin для неё.
Описание проблемы нужно добавить в PR.

Отправка ДЗ на проверку
Результаты
вашей
работы
находятся
в
ветке
logging-1
вашего
инфраструктурного репозитория.
В README внесите описание того, что сделано
Создайте Pull Request к ветке master (описание PR нужно заполнять,
включая инструкции по запуску сделанного)
В ревьюверы можно никого не добавлять
Добавьте метку (label) logging-1 к вашему Pull Request
После того, как один из преподавателей сделает approve пулл-реквеста,
ветку с ДЗ можно смерджить и закрыть PR.

docker push kitit/ui:logging
docker push kitit/comment:logging
docker push kitit/post:logging
-----------------------
HW kubernetes-1
-----------------------
Введение в kubernetes. Фух, финишная прямая по домашкам.

-------
yc compute instance list

yc compute instance create \
  --name kubernode1 \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50 \
  --memory 4 \
  --ssh-key ~/.ssh/id_rsa.pub

- index: "0"
  mac_address: d0:0d:2c:4e:8e:75
  subnet_id: e9b4uf3p0hsf3ck1glap
  primary_v4_address:
    address: 10.128.0.5
    one_to_one_nat:
      address: 178.154.241.60
      ip_version: IPV4



------
Install k8s

    Update the apt package index and install packages needed to use the Kubernetes apt repository:

    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl

    Download the Google Cloud public signing key:

    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

    Add the Kubernetes apt repository:

    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:

    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

The kubelet is now restarting every few seconds, as it waits in a crashloop for kubeadm to tell it what to do

sudo kubeadm init --apiserver-cert-extra-sans=178.154.241.60 --apiserver-advertise-address=0.0.0.0 --control-plane-endpoint=178.154.241.60 --pod-network-cidr=10.244.0.0/16

docker-machine create \
  --driver generic \
  --generic-ip-address=178.154.241.60\
  --generic-ssh-user yc-user \
  --generic-ssh-key ~/.ssh/id_rsa \
  kubernode1

eval $(docker-machine env logging)

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join 178.154.241.60:6443 --token y3ihro.e76jxcmidu2zx7u7 \
        --discovery-token-ca-cert-hash sha256:07034c4add9bf1be8ed23a538c5b02da6e7225267a07e86ea5964d7a5d2683de \
        --control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 178.154.241.60:6443 --token y3ihro.e76jxcmidu2zx7u7 \
        --discovery-token-ca-cert-hash sha256:07034c4add9bf1be8ed23a538c5b02da6e7225267a07e86ea5964d7a5d2683de1

NAME         STATUS   ROLES                  AGE   VERSION
kubernode1   Ready    control-plane,master   17m   v1.21.3
