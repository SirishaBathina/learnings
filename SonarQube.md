 ```sh
yum update
```
```sh
 sudo yum install java-11-amazon-corretto-devel -y
```
```sh
 java --version
```    
```sh
cd  /opt
```
```sh
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip
```
```sh
 unzip sonarqube-8.9.10.61524.zip
```
```sh
 useradd sonar
```
```sh
  vi /etc/sudoers
```
```sh
   sonar   ALL=(ALL)       ALL
```   mv sonarqube-8.9.10.61524 /opt
   ```sh
chown -R sonar:sonar /opt/sonarqube-8.9.10.61524
```
```sh
   chmod -R 775 /opt/sonarqube-8.9.10.61524
```
```sh
    su sonar -
```
    cd sonarqube-8.9.10.61524/
```sh
     ls
```
```sh
      cd bin/
```
```sh
      ls
```
```sh
      cd linux-x86-64/
```
      ls
```sh
      ./sonar.sh start
```
```sh
     ./sonar.sh status
```
Check ip:9000



