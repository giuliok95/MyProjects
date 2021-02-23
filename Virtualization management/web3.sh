#!/bin/bash
# Create your provisioning script here
echo "Running web3.sh provisioner"

cat >> /opt/tomcat/bin/setenv.sh << EOL
export SPRING_DATASOURCE_url=jdbc:postgresql://team3db.duckdns.org:5432/chinook
export SPRING_DATASOURCE_USERNAME=web3
export SPRING_DATASOURCE_PASSWORD=web3
EOL
#ssh -R 5432:localhost:5432 vagrant@31.24.19.80