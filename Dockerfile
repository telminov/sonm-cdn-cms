# docker build -t gitlab.soft-way.biz:5010/sonm-cdn/cms .
# docker push gitlab.soft-way.biz:5010/sonm-cdn/cms

FROM ubuntu:16.04
MAINTAINER telminov <telminov@soft-way.biz>

RUN apt-get clean && apt-get update && \
    apt-get install -y \
                    vim curl locales tzdata \
                    supervisor python3-pip npm

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN locale-gen ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU:ru
ENV LC_ALL ru_RU.UTF-8

RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN pip3 install    django==2.0.5 \
                    django-bootstrap4==0.0.6 \
                    djangorestframework==3.8.2 \
                    ipython

COPY . /opt/cms
WORKDIR /opt/cms


RUN cp project/local_settings.sample.py project/local_settings.py

COPY supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisor/prod.conf /etc/supervisor/conf.d/mis.conf

WORKDIR /opt/cms

EXPOSE 80
VOLUME /data/
VOLUME /conf/
VOLUME /static/
VOLUME /media/

CMD test "$(ls /conf/local_settings.py)" || cp project/local_settings.sample.py /conf/local_settings.py; \
    rm project/local_settings.py;  ln -s /conf/local_settings.py project/local_settings.py; \
    rm -rf static; ln -s /static static; \
    rm -rf media; ln -s /media media; \
    ln -s /conf/pgpass ~/.pgpass; chmod 0600 ~/.pgpass; \
    python3 ./manage.py migrate; \
    python3 ./manage.py collectstatic --noinput; \
    npm install; rm -rf static/node_modules; mv node_modules static/; \
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon
