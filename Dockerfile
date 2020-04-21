# Dockerfile for sonarqube server
# (A)
FROM            docker.io/centos:latest
# (B)
MAINTAINER      debugroom

# (C)
RUN yum install -y java-1.8.0-openjdk zip unzip wget

# (D)
ENV SONAR_VERSION=7.7 \
    SONARQUBE_HOME=/usr/local/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=jdbc:postgresql://mynavi-sample-sonarqube-db.xxxxxxxx.ap-northeast-1.rds.amazonaws.com/sonar

# (E)
EXPOSE 9000

# (F)
RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube

# (G)
RUN set -x \
 && (gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
         || gpg --batch --keyserver ipv4.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE) \
 && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
 && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
 && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
 && unzip sonarqube.zip \
 && mv sonarqube-$SONAR_VERSION $SONARQUBE_HOME \
 && rm sonarqube.zip* \
 && rm -rf $SONARQUBE_HOME/bin/*

# (H)
WORKDIR $SONARQUBE_HOME
# (I)
COPY run.sh $SONARQUBE_HOME/bin/
# (J)
RUN chmod 744 $SONARQUBE_HOME/bin/run.sh
# (K)
RUN chown -R sonarqube:sonarqube $SONARQUBE_HOME
# (L)
USER sonarqube
# (M)
CMD ["./bin/run.sh"]

|br|