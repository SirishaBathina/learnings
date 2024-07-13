###Install Java On Ubuntu ## Nexus Port :8081 open the port
```sh
apt update
```
```sh
sudo apt install openjdk-8-jdk
 ```
```sh
java -version
```
```sh
 sudo useradd -d /opt/nexus -s /bin/bash nexus
```
```sh
 sudo passwd nexus 
```
```sh
ulimit -n 65536
```
```sh
 sudo nano /etc/security/limits.d/nexus.conf 
```
```sh
nexus - nofile 65536 
```
```sh
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
```
```sh
tar -xvf nexus.tar.gz
```
```sh
mv nexus-3.70.1-02 /opt/nexus
```
```sh
 mv sonatype-work /opt/ 
```
```sh
chown -R nexus:nexus /opt/nexus /opt/sonatype-work 
```
```sh
sudo nano /opt/nexus/bin/nexus.rc 
```
```sh
run_as_user="nexus"

```sh
 sudo nano /opt/nexus/bin/nexus.vmoptions
 ```
-Xms1024m
 -Xmx1024m 
-XX:MaxDirectMemorySize=1024m
 ```sh
sudo nano /etc/systemd/system/nexus.service
```
```sh
 [Unit]
 Description=nexus Service
 After=network.target
 [Service] 
Type=forking
 LimitNOFILE=65536
 ExecStart=/opt/nexus/bin/nexus start
 ExecStop=/opt/nexus/bin/nexus stop User=nexus 
Restart=on-abort
 [Install] 
WantedBy=multi-user.target 
```
```sh
sudo systemctl daemon-reload
```
 ```sh
sudo systemctl start nexus.service
```
```sh
 sudo systemctl enable nexus.service 
```
```sh
sudo systemctl status nexus.service
```
```
In browser IP:8081 ====Nexus run on port  8081
