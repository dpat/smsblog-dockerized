FROM ubuntu:stable
MAINTAINER "David Patawaran <david.patawaran@gmail.com>"

# install necessary packages
RUN apt-get update && \
    apt-get install -y \
    pinentry-curses xz-utils \
    python3-pip && \
    apt-get clean

RUN pip3 install virtualenv && \
    virtualenv venv && \
    source venv/bin/activate

RUN apt-get update && \
    apt-get install -y \
    apache2 libapache2-mod-wsgi-py3 \
    python3-dev && \
    apt-get clean

RUN git clone https://github.com/dpat/smsblog.git
RUN git clone https://github.com/dpat/smsface.git
RUN cd smsblog
RUN pip3 install -r requirements.txt
RUN pip3 install .
RUN smsblog init
RUN pip3 install mod_wsgi

COPY smsface_wsgi.txt ~/smsface_wsgi.txt
COPY smsblog_wsgi.txt ~/smsblog_wsgi.txt
COPY smsblog_conf.txt ~/smsblog_conf.txt

ADD init_blog.sh /init_blog.sh
ENTRYPOINT ["/init_blog.sh"]
