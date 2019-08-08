FROM registry.centos.org/centos/centos:7

RUN yum update -y && \
    yum install -y pigz createrepo rpmdevtools deltarpm rpm-sign rpmlint && \
    yum groupinstall -y 'Development Tools' && \
    yum clean all

COPY RPM-GPG-KEY-remi /etc/pki/mock/RPM-GPG-KEY-remi

WORKDIR /root/rpmbuild/package

RUN sed -i s/keepcache=0/keepcache=1/ /etc/yum.conf && \
    mkdir -p /root/rpmbuild/package

COPY rpmmacros /root/.rpmmacros
COPY makerpm /usr/local/bin/makerpm

LABEL RUN="podman run -it --rm --net=host -v pkg:/root/rpmbuild/package/:Z -v dist:/root/rpmbuild/target/ -v cache:/var/cache/yum IMAGE"
ENTRYPOINT ["/usr/local/bin/makerpm"]
