FROM ubuntu:18.04
WORKDIR /app
ADD . /app
RUN apt update -y \
 && apt install -y python3-pip
RUN pip3 install -r requirements.txt
ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts
ENTRYPOINT ["python3", "post_app.py"]
