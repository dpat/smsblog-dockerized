FROM ubuntu:xenial
MAINTAINER "David Patawaran <david.patawaran@gmail.com>"

# install necessary packages
RUN apt-get update && \
    apt-get install -y \
    pinentry-curses xz-utils \
    python3-pip git && \
    apt-get clean

RUN cd ~ \
  && pip3 install virtualenv \
  && virtualenv venv
ENV PATH="~/venv/bin/activate:${PATH}"

RUN apt-get update && \
    apt-get install -y \
    apache2 libapache2-mod-wsgi-py3 \
    python3-dev && \
    apt-get clean

RUN cd ~ \
  && git clone https://github.com/dpat/smsblog.git \
  && git clone https://github.com/dpat/smsface.git \
  && cd smsblog \
  && pip3 install -r requirements.txt \
  && pip3 install . \
  && smsblog init

COPY smsface_wsgi.txt ~/smsface_wsgi.txt
COPY smsblog_wsgi.txt ~/smsblog_wsgi.txt
COPY smsblog_conf.txt ~/smsblog_conf.txt

ADD init_blog.sh /init_blog.sh
ENTRYPOINT ["/init_blog.sh"]
