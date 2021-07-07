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
