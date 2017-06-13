FROM centos:latest
MAINTAINER Marcus Grando <marcus@sbh.eng.br>

ENV REPO none
ENV REGION none
ENV AWS_ACCESS_KEY_ID none
ENV AWS_SECRET_ACCESS_KEY none

# Add Fuse and Boto support
RUN yum -y update \
    && yum -y install fuse fuse-libs createrepo rsync epel-release \
    && yum -y install python-pip && pip install boto \
    && yum -y install automake fuse-devel gcc-c++ libcurl-devel libxml2-devel make openssl-devel \
    && curl -L https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.82.tar.gz | tar -xzf - \
    && cd s3fs-fuse-1.82 \
    && ./autogen.sh && ./configure --prefix=/usr \
    && make \
    && make install \
    && cd .. \
    && rm -rf s3fs-fuse-1.82 \
    && yum -y history undo last \
    && yum clean all

ADD ./start.sh /usr/bin/start.sh
ADD ./sqs-createrepo.py /usr/bin/sqs-createrepo.py

RUN chmod +x /usr/bin/start.sh
CMD ["/usr/bin/start.sh"]
