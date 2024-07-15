#####Installation on Amazon linux
##Install Java first

```sh
sudo yum install java-11-amazon-corretto-devel -y
```
```sh
java -version
```
```sh
sudo yum update –y
```
```sh
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
```
```sh
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```
```sh
sudo yum upgrade
```
```sh
sudo yum install jenkins -y
```
```sh
sudo systemctl enable jenkins
```
```sh
sudo systemctl start jenkins
```
```sh
sudo systemctl status jenkins
```
