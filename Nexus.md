Install Java On Ubuntu
```sudo apt install openjdk-8-jdk
 ```java -version
 sudo useradd -d /opt/nexus -s /bin/bash nexus
 sudo passwd nexus 
ulimit -n 65536
 sudo nano /etc/security/limits.d/nexus.conf 
nexus - nofile 65536 
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -xvf nexus.tar.gz
mv nexus-3.70.1-02 /opt/nexus
 mv sonatype-work /opt/ 
chown -R nexus:nexus /opt/nexus /opt/sonatype-work 
sudo nano /opt/nexus/bin/nexus.rc 
run_as_user="nexus"
 sudo nano /opt/nexus/bin/nexus.vmoptions
 -Xms1024m
 -Xmx1024m 
-XX:MaxDirectMemorySize=1024m
 sudo nano /etc/systemd/system/nexus.service
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
sudo systemctl daemon-reload
 sudo systemctl start nexus.service
 sudo systemctl enable nexus.service 
sudo systemctl status nexus.service
