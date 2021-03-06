    ARG BASE_IMAGE="fhem/fhem"
    ARG BASE_IMAGE_TAG="latest"
    FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}

    ARG L_SIGNAL_CLI="0.6.2"

    # Install base environment
    RUN DEBIAN_FRONTEND=noninteractive apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
            cpanminus \
            build-essential \
            wget \
            shared-mime-info \
	    dbus \
          default-jre-headless \
         libunixsocket-java \
            net-tools \
            hping3 \
            wakeonlan \
	    python-mysqldb \
            \
	 && cpanm \
           Net::DBus \
           Lirc::Client \
           Crypt::Cipher::AES \
	   Image::Grab \
        && rm -rf /root/.cpanm \
        && sed -i s,/dev/lircd,/var/run/lirc/lircd,g /usr/local/share/perl/5.28.1/Lirc/Client.pm \
        && wget https://github.com/AsamK/signal-cli/releases/download/v${L_SIGNAL_CLI}/signal-cli-${L_SIGNAL_CLI}.tar.gz \
        && tar xf signal-cli-${L_SIGNAL_CLI}.tar.gz -C /opt \
        && ln -sf /opt/signal-cli-${L_SIGNAL_CLI}/bin/signal-cli /usr/local/bin/ \
        && apt-get purge -qqy \
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
