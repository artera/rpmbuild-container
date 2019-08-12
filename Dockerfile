FROM registry.centos.org/centos/centos:6

RUN yum update -y && \
    yum install -y pigz createrepo rpmdevtools deltarpm rpm-sign rpmlint which && \
    yum groupinstall -y 'Development Tools' && \
    yum clean all

WORKDIR /package

RUN sed -i s/keepcache=0/keepcache=1/ /etc/yum.conf && \
    sed -i s/enabled=1/enabled=0/ /etc/yum/pluginconf.d/fastestmirror.conf && \
    mkdir -p /rpmbuild /target /package && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    cp -a /root/.cargo/env /etc/profile.d/cargo.sh

COPY yum.repos.d/ /etc/yum.repos.d/
COPY rpmmacros /root/.rpmmacros
COPY makerpm /usr/local/bin/makerpm

LABEL RUN="podman run -it --rm --net=host -v pkg:/package/:Z -v dist:/target/ -v cache:/var/cache/yum IMAGE"
ENTRYPOINT ["/usr/local/bin/makerpm"]
