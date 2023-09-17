#sintax=doker/dokerfile:1
###Grails 5.3.3 development environment in docker###
FROM ubuntu

### Default Java and Grails version ###
ENV SDK_JAVA_VERSION 11.0.20-amzn
ENV GRAILS_VERSION 5.3.3

###update ubuntu and installation of needed software###
RUN apt clean
RUN apt update
RUN apt upgrade -y
RUN apt -y autoremove
RUN apt install -y unzip curl git nano zip

###creation of developer user (not necessary)##
RUN useradd -p "" -ms /bin/bash developer

###creation of HOME env variable###
ENV HOME /home/developer

RUN mkdir $HOME/app
RUN chown developer $HOME/app
VOLUME $HOME/app

###impersonification of developer user (commented due to problems with permission on app folder - TODO)###
#USER developer

###move in HOME directory###
WORKDIR $HOME

###installation of jdk and grails 5.3.3
RUN curl -s "https://get.sdkman.io" | bash

RUN /bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh \
	&& sdk install java $SDK_JAVA_VERSION"

RUN echo $GRAILS_VARSION
RUN /bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh \
	&& sdk install grails $GRAILS_VERSION"

###move in app folder###
WORKDIR $HOME/app

###export of needed ports###
EXPOSE 8080
EXPOSE 5005

###launch of the application at runtime###
CMD /bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh \
	&& grails clean \
    && grails run-app"

