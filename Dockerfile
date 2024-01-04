FROM ubuntu:20.04

RUN apt-get update
RUN apt install -y build-essential autoconf
RUN apt install -y hfsprogs dmg2img
#RUN timedatectl set-timezone Europe/Berlin
#RUN cp /usr/share/zoneinfo/Europe/London /etc/localtime
RUN apt install -y libssl-dev git

# Installing libxml2-dev will install tzdata and interactively ask for your Timezone
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
RUN apt-get install -y tzdata

RUN apt install -y libxml2-dev zlib1g-dev
ADD install-mac-tools.sh /
RUN ./install-mac-tools.sh
RUN apt install -y p7zip-full p7zip-rar
ADD create-image.sh /