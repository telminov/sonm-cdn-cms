FROM python:3.6

RUN mkdir /opt/app
ADD . /opt/app
WORKDIR /opt/app
RUN pip install -r requirements.txt

RUN cp project/local_settings.sample.py project/local_settings.py

COPY supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisor/prod.conf /etc/supervisor/conf.d/cms.conf

WORKDIR /opt/app

EXPOSE 80
VOLUME /data/
VOLUME /conf/
VOLUME /static/
VOLUME /media/

CMD test "$(ls /conf/local_settings.py)" || cp project/local_settings.sample.py /conf/local_settings.py; \
    rm project/local_settings.py;  ln -s /conf/local_settings.py project/local_settings.py; \
    rm -rf static; ln -s /static static; \
    rm -rf media; ln -s /media media; \
    python3 ./manage.py migrate; \
    python3 ./manage.py collectstatic --noinput; \
#    npm install; rm -rf static/node_modules; mv node_modules static/; \
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon
