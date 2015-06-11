FROM tricahyana/httpd
MAINTAINER Kasyfil Aziz <kasyfil.aziz@wgs.co.id>

RUN apt-get update && apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev apache2-threaded-dev libapr1-dev libaprutil1-dev

# install jruby and passengger
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm install jruby
RUN bash -l -c "rvm use jruby --default"
RUN bash -l -c "gem install passenger"
RUN bash -l -c "gem install bundler"

# configure passanger and apache2
RUN printf \\n\\n\\n\\n | bash -l -c "passenger-install-apache2-module"
ADD apache2.conf /
RUN cat /apache2.conf >> /etc/apache2/apache2.conf

EXPOSE 22 80
RUN echo "export PATH=$PATH:/usr/local/rvm/bin" >> ~/.profile

# start apache2
CMD bash -c "source /etc/apache2/envvars ; \ 
	service apache2 restart ; \
	/usr/sbin/sshd -D"
