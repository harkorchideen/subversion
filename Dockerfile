FROM ubuntu:latest

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 apache2-utils php libapache2-mod-php php-ldap
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install vim tree subversion libsvn-dev libapache2-mod-svn subversion-tools

# svnadmin installieren und konfigurieren
#RUN cd /var/www/html && git clone https://github.com/mfreiholz/iF.SVNAdmin && mv iF.SVNAdmin svnadmin
COPY svnadmin /var/www/html/svnadmin
RUN chmod 777 /var/www/html/svnadmin/data

# apache einrichten
COPY files/svn.conf /etc/apache2/sites-available/svn.conf
#RUN htpasswd -cmb /etc/apache2/dav_svn.passwd admin admin
RUN a2ensite svn
RUN a2enmod dav dav_svn ldap authnz_ldap
RUN rm /etc/apache2/mods-enabled/dav_svn.conf
#RUN cp /etc/apache2/mods-available/dav_svn.conf /etc/apache2/mods-enabled/dav_svn.conf
#RUN chmod a+rw /etc/apache2/mods-enabled/dav_svn.conf
CMD apache2ctl -D FOREGROUND

EXPOSE 80
