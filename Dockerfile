FROM registry.centos.org/centos/centos:6

RUN yum update -y && \
    yum install -y pigz createrepo rpmdevtools deltarpm rpm-sign && \
    yum groupinstall -y 'Development Tools' && \
    yum clean all

COPY RPM-GPG-KEY-remi /etc/pki/mock/RPM-GPG-KEY-remi
COPY rpmmacros /root/.rpmmacros
COPY makerpm /usr/local/bin/makerpm

RUN sed -i s/keepcache=0/keepcache=1/ /etc/yum.conf
RUN mkdir -p /root/rpmbuild/package

WORKDIR /root/rpmbuild/package

LABEL RUN="podman run -it --rm --net=host -v pkg:/root/rpmbuild/package/:Z -v cache:/var/cache/yum IMAGE"

ENTRYPOINT ["/usr/local/bin/makerpm"]
