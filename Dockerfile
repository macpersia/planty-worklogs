FROM java:openjdk-8

MAINTAINER Hadi Ahmadi macpersia@gmail.com 

# install sbt  
ENV SBT_VERSION 0.13.8 
#ENV SBT_OPTS -Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xss2M -Duser.timezone=GMT  
RUN wget https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb  
RUN dpkg -i sbt-$SBT_VERSION.deb  
RUN sbt sbt-version

# add the project directory
ADD ./ /src/planty-worklogs/

# build dependencies and the leaf project
WORKDIR /src/planty-worklogs/planty-worklogs-common
RUN sbt publishLocal

WORKDIR /src/planty-worklogs/planty-worklogs--adapter-cats
RUN sbt publishLocal

WORKDIR /src/planty-worklogs/planty-worklogs-adapter-jira
RUN sbt publishLocal

WORKDIR /src/planty-worklogs/planty-worklogs-angular
RUN sed 's/http:\/\/localhost:9000/https:\/\/diy-planty.rhcloud.com/g' src/client/app/services/worklog.service.ts
# BEGIN Installing Node.js
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done
ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 5.12.0
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt
# END   Installing Node.js
RUN npm run build.prod -- --base /ng/

WORKDIR /src/planty-worklogs/planty-worklogs-web
RUN rm -rf public/ng/
RUN cp -rf ../planty-worklogs-angular/dist/prod public/ng
RUN sbt stage

CMD ["target/universal/stage/bin/planty-worklogs-web"]
