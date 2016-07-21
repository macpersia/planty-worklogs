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

WORKDIR /src/planty-worklogs/planty-cats-view
RUN sbt publishLocal

WORKDIR /src/planty-worklogs/planty-jira-view
RUN sbt publishLocal

WORKDIR /src/planty-worklogs/planty-worklogs-angular
RUN npm run build.prod -- --base /ng/

WORKDIR /src/planty-worklogs/planty-worklogs-web
RUN rm -rf public/ng/
RUN cp -rf ../planty-worklogs-angular/dist/prod public/ng
RUN sbt stage

CMD ["target/universal/stage/bin/planty-worklogs-web"]
