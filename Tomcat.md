###Install java First
```sh
sudo yum install java-11-amazon-corretto-devel -y
```
```sh
java --version 
```
```sh
yum update
```
##To install tomcat
  ```sh
  cd /opt/
```
```sh
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.90/bin/apache-tomcat-9.0.90.tar.gz
```
```sh
tar -zvxf apache-tomcat-9.0.90.tar.gz
```
```sh
cd apache-tomcat-9.0.90
```
```sh
cd bin/
```
```sh
chmod +x startup.sh
```
```sh
chmod +x shutdown.sh
```
#To start Tomcat
```sh
./startup.sh
```

After
```sh
cd /path/to/tomcat/webapps/manager/META-INF/context.html
```
value tag un comment
( <!--
--> )


```sh
cd conf
```
```sh
vi tomcat-users.xml
```
#Add below lines between <tomcat-users> tag
```sh

<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>   
<user username="admin" password="admin" roles="manager-gui,manager-script,manager-jmx,manager-status"/>
<user username="deployer" password="deployer" roles="manager-script"/>
<user username="tomcat" password="s3cret" roles="manager-gui"/>
```
http://server_ip:8080/
In case Change tomcat port number
```sh
cd conf/
```
```sh
vi server.xml
```
>>>>>change port Number accordingly and restart again
