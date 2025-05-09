wget https://repo.mysql.com/yum/mysql-8.0-community/el/9/x86_64/mysql-com                                                                             munity-icu-data-files-8.0.40-1.el9.x86_64.rpm
   39  sudo dnf install ./*.rpm --nogpgcheck -y
   40  sudo systemctl enable mysqld
   41  sudo systemctl start mysqld
   42  sudo systemctl status mysqld
   43  sudo grep 'ADJLmu-KHvZ9Y' /var/log/mysqld.log
   44  mysql -u root -p
   45  cat /var/log/mysqld.log
   46  sudo cat /var/log/mysqld.log
   47  mysql -u root -p
   48  sudo systemctl stop mysqld
   49  sudo mysqld_safe --skip-grant-tables --skip-networking &
   50  mysql -u root -p
   51  sudo systemctl status mysqld
   52  sudo systemctl start mysqld
   53  sudo systemctl status mysqld
   54  mysql -u root -p
   55  sudo systemctl start mysqld
   56  sudo systemctl status mysqld
   57  show databases;
   58  SHOW DATABASES;
   59  history
   60   mysql -u root -p
