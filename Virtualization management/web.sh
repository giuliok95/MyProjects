#!/bin/bash
# Create your provisioning script here
echo "Running web.sh provisioner"

cd /tmp
sudo apt-get update
sudo apt-get install -y openjdk-11-jre-headless
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
curl -O https://downloads.apache.org/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-*tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
sudo  chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo  chown -R tomcat webapps/ work/ temp/ logs/
sudo touch /etc/systemd/system/tomcat.service 
cat >> /etc/systemd/system/tomcat.service << EOL
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
# cat >> /opt/tomcat/bin/setenv.sh << EOL
# export SPRING_DATASOURCE_url=jdbc:postgresql://DOMAIN_NAME_OF_DB:5432/chinook
# export SPRING_DATASOURCE_USERNAME=WEB_NODE_DB_USERNAME
# export SPRING_DATASOURCE_PASSWORD=WEB_NODE_DB_PASSWORD
# EOL
cp /vagrant/web.war /opt/tomcat/webapps/
cd /opt/tomcat/webapps/
#sudo rm -rf /opt/tomcat/webapps/ROOT
cp /opt/tomcat/webapps/web.war /opt/tomcat/webapps/ROOT.war
sudo unzip ROOT.war

