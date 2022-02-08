    ARG BASE_IMAGE="fhem/fhem"
    ARG BASE_IMAGE_TAG="latest"
   # FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}
    FROM ghcr.io/fhem/fhem/fhem-docker:dev-bullseye
    ARG L_SIGNAL_CLI="0.10.3"

    # Install base environment
    RUN DEBIAN_FRONTEND=noninteractive apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
        cpanminus \
        build-essential \
        wget \
        shared-mime-info \
	    dbus \
      #  default-jre-headless \
        libunixsocket-java \
        net-tools \
        hping3 \
        wakeonlan \
	  #  python-mysqldb \
        ansible \
        python3-pip \
        python3-mysqldb \
        libnet-dbus-perl \  
        haveged \
      #  default-jdk \
        systemd \
        nano \
            \
	 && cpanm \
           Net::DBus \
           Lirc::Client \
           Crypt::Cipher::AES \
           Protocol::DBus \
           Data::Peek \
           Net::FTPSSL \
	       Image::Grab \
        && rm -rf /root/.cpanm \
        && sed -i s,/dev/lircd,/var/run/lirc/lircd,g /usr/local/share/perl/5.28.1/Lirc/Client.pm \
        && wget https://github.com/AsamK/signal-cli/releases/download/v${L_SIGNAL_CLI}/signal-cli-${L_SIGNAL_CLI}-Linux.tar.gz \
        && tar xf signal-cli-${L_SIGNAL_CLI}-Linux.tar.gz -C /opt \
        && ln -sf /opt/signal-cli-${L_SIGNAL_CLI}/bin/signal-cli /usr/local/bin/ 
 

    RUN  wget https://download.bell-sw.com/java/17.0.2+9/bellsoft-jdk17.0.2+9-linux-amd64.deb	\
        && apt-get install -qqy --no-install-recommends ./bellsoft-jdk17.0.2+9-linux-amd64.deb 



    RUN  apt-get purge -qqy \
            build-essential \
            cpanminus \
            subversion \
        && apt-get autoremove -qqy && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

    COPY ./src/pre-start.sh /pre-start.sh
    COPY ./src/000_fhem-nopasswd /etc/sudoers.d/
    COPY ./src/org.asamk.Signal.service /usr/share/dbus-1/system-services/
    COPY ./src/org.asamk.Signal.conf /etc/dbus-1/system.d/
    ADD https://raw.githubusercontent.com/Quantum1337/32_SiSi.pm/master/FHEM/32_SiSi.pm /fhem/FHEM/32_SiSi.pm
    RUN mkdir /run/dbus && mkdir /run/lirc
    RUN mkdir /opt/signal-cli && mkdir /opt/lirc
    RUN chmod +x /pre-start.sh
    RUN npm install -g alexa-fhem

    VOLUME [ "/opt/signal-cli" ]
    VOLUME [ "/opt/lirc" ]
