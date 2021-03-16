FROM almalinux/almalinux:8

RUN dnf install -y https://mirror.23media.com/remi/enterprise/remi-release-8.rpm && \
    dnf update -y && \
    dnf install -y pigz createrepo rpmdevtools rpm-sign rpmlint which redhat-lsb-core yum-utils && \
    dnf groupinstall -y 'Development Tools' && \
    dnf clean all

WORKDIR /package

RUN echo keepcache=1 >> /etc/dnf/dnf.conf && \
    mkdir -p /rpmbuild /target /package && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    cp -a /root/.cargo/env /etc/profile.d/cargo.sh

COPY yum.repos.d/ /etc/yum.repos.d/
COPY rpmmacros /root/.rpmmacros
COPY makerpm /usr/local/bin/makerpm
COPY coprmake /usr/local/bin/coprmake
COPY rpmbuild /usr/local/bin/rpmbuild

LABEL RUN="podman run -it --rm --net=host -v pkg:/package/:Z -v dist:/target/ -v cache:/var/cache/dnf IMAGE"
ENTRYPOINT ["/usr/local/bin/makerpm"]
