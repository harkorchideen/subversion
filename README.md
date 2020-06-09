# Subversionimage

This image contains an Installation of Ubuntu, Apache, Subversion and a tool to admin Subversion [iF.SVNAdmin](https://svnadmin.insanefactory.com/) [or on GitHub](https://github.com/mfreiholz/iF.SVNAdmin). The admin-tool will merged into the image. So check the [lizence](https://github.com/mfreiholz/iF.SVNAdmin/blob/master/license.txt) there.
The Subversion (via Apache) authenticates against LDAP (AD).

# Usage
...
sudo docker run --name svn-server  \
    -v /path/to/your/store/config.ini:/var/www/html/svnadmin/data/config.ini \
    -v /path/to/your/store/svn.conf:/etc/apache2/sites-available/svn.conf \
    -v /path/to/your/store/Repositories:/var/repositories \
    -v /path/to/your/store/userroleassignments.ini:/var/www/html/svnadmin/data/userroleassignments.ini \
    -v /path/to/your/store/dav_svn.acl:/var/www/svn_access/acl \
    -p 80:80 harkorchideen/subversion
...

The files config.ini and userroleassignments.ini stores the configuration for iF.SVNAdmin. The File dav_svn.acl contains the accessrules for your repositories and should be referenced within the svn.conf file of the apache configuration. Finally the repositories-directory will be linked to the container.

Alternativly its possible to use docker-compose with something like that:
...
version: '2'
services:
  svn-server:
    from: harkorchideen\subversion
    container_name: svn-server
    ports:
      - "80:80"
    volumes:
      - /path/to/your/store/SvnAdmin.config.ini:/var/www/html/svnadmin/data/config.ini
      - /path/to/your/store/svn.conf:/etc/apache2/sites-available/svn.conf
      - /path/to/your/store/Repositories:/var/repositories
      - /path/to/your/store/userroleassignments.ini:/var/www/html/svnadmin/data/userroleassignments.ini
      - /path/to/your/store/dav_svn.acl:/var/www/svn_access/dav_svn.acl
    restart: always
...

Here is a sample svn.conf:
...
Alias /svn /var/lib/svn
<Location /svn>
   DAV svn

   # configure the location of your Repositories
   SVNParentPath /var/repositories

   AuthType Basic
   AuthBasicProvider ldap
   AuthName "Subversion Repository"

   # you need an ldap user to read authenticationiformation from your directory
   AuthLDAPBindDN "CN=adreader,DC=your,DC=domain"

   # configure th location of your acl-file
   AuthzSVNAccessFile /var/www/svn_access/dav_svn.acl

   # This is the password for the AuthLDAPBindDN user in Active Directory
   AuthLDAPBindPassword adreaderPassword

   # This URL points to your LDAP/AD server
   AuthLDAPURL "ldap://192.168.0.1:389/DC=your,DC=domain?sAMAccountName?sub?(objectClass=*)"

   Require valid-user

</Location>
...

