FROM registry.centos.org/centos/centos:7

RUN yum update -y && \
    yum install -y pigz createrepo rpmdevtools deltarpm rpm-sign rpmlint && \
    yum groupinstall -y 'Development Tools' && \
    yum clean all

COPY RPM-GPG-KEY-remi /etc/pki/mock/RPM-GPG-KEY-remi

WORKDIR /package

RUN sed -i s/keepcache=0/keepcache=1/ /etc/yum.conf && \
    sed -i s/enabled=1/enabled=0/ /etc/yum/pluginconf.d/fastestmirror.conf && \
    mkdir -p /rpmbuild /target /package

COPY rpmmacros /root/.rpmmacros
COPY makerpm /usr/local/bin/makerpm

LABEL RUN="podman run -it --rm --net=host -v pkg:/package/:Z -v dist:/target/ -v cache:/var/cache/yum IMAGE"
ENTRYPOINT ["/usr/local/bin/makerpm"]
