FROM ubuntu:openjdk

RUN useradd --create-home --shell /bin/bash dmadmin && \
    echo "dmadmin:D0cum3ntum01" | chpasswd && \
    mkdir /opt/documentum && \
	chown dmadmin:dmadmin /opt/documentum

ARG INSTALL_PACKAGE=content_server_20.2_linux64_postgres.tar

COPY ${INSTALL_PACKAGE} /tmp

RUN mkdir /tmp/dctm && \
    cd /tmp/dctm && \
    tar xvf ../${INSTALL_PACKAGE} && \
    chmod 750 serverSetup.bin && \
    chown -R dmadmin:dmadmin /tmp/dctm && \
    rm -f ../${INSTALL_PACKAGE}

USER dmadmin

COPY contentserver.properties /tmp/dctm

ENV DOCUMENTUM /opt/documentum

RUN cd /tmp/dctm && \
    ./serverSetup.bin -f contentserver.properties -i silent && \
    sed -i -e "s/dfc.docbroker.host\[0\]=.*/dfc.docbroker.host[0]=dctm/" $DOCUMENTUM/config/dfc.properties && \
    sed -i -e "s/dfc.docbroker.port\[0\]=.*/dfc.docbroker.port[0]=1489/" $DOCUMENTUM/config/dfc.properties && \
    sed -i 's,^JAVA_OPTS="[^"]*,& -Djava.net.preferIPv4Stack=true,' $DOCUMENTUM/wildfly17.0.1/server/startMethodServer.sh

USER root

RUN apt-get update && \
    apt-get install -y unixodbc odbc-postgresql postgresql-client && \
    rm -rf /var/lib/apt/lists/*

COPY odbc.ini /etc/

COPY odbcinst.ini /etc/

COPY docbroker.properties /tmp/dctm

USER dmadmin

RUN export POSTGRESQL_HOME=/usr && \
    /opt/documentum/product/20.2/install/dm_launch_server_config_program.sh -f /tmp/dctm/docbroker.properties && \
    sed -i "s/host=.*/host=dctm/" /opt/documentum/dba/dm_launch_Docbroker && \
    sed -i "s/docbroker -B -T.* -P -N1489/docbroker -B -Tdctm -P -N1489/" /opt/documentum/dba/dm_stop_Docbroker &&  \
	echo "export POSTGRESQL_HOME=/usr" >> /home/dmadmin/.bashrc && \
	echo "source /opt/documentum/product/20.2/bin/dm_set_server_env.sh" >> /home/dmadmin/.bashrc

USER root

COPY repository.properties /home/dmadmin

RUN apt-get update && \
    apt-get install -y libcurl4 && \
    apt-get install -y gosu && \
	rm -rf /var/lib/apt/lists/* && \
    echo "dm_dctm 50000/tcp" >> /etc/services && \
	echo "dm_dctm_s 50001/tcp" >> /etc/services && \
    chown dmadmin:dmadmin /home/dmadmin/repository.properties

COPY docker-entrypoint.sh /usr/local/bin/

USER dmadmin

ENTRYPOINT ["docker-entrypoint.sh"]
