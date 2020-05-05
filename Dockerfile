FROM centos:7

MAINTAINER Marcos Amorim <mamorim@redhat.com>

RUN yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-queens/rdo-release-queens-1.noarch.rpm

RUN yum update -y && yum install -y python-pip wget git which gcc make autoconf liberasurecode \
     liberasurecode-devel libtool python-devel libxslt-devel libxml2-devel zlib-devel libffi-devel && yum clean all

COPY requirements.txt /

RUN pip install --upgrade pip && pip install PyECLib --user

RUN \
    cd /tmp && git clone https://github.com/openstack/liberasurecode && \
    cd liberasurecode && ./autogen.sh && ./configure && make && make test && make install && \
    cd / && rm -rf /tmp/liberasurecode && \
    pip install -r requirements.txt

COPY prometheus-openstack-exporter /
COPY prometheus-openstack-exporter.sample.yaml /openstack-exporter.sample.yaml
COPY wrapper.sh /

ENV OS_CLOUD_FILE=/etc/openstack-exporter/clouds.yaml
RUN ln -s /etc/openstack-exporter/clouds.yaml /clouds.yaml

EXPOSE 9183
ENTRYPOINT ["/bin/sh", "/wrapper.sh"]
