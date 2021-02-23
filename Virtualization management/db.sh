#!/bin/bash
# Create your provisioning script here
echo "Running db.sh provisioner"

apt-get update
apt-get install -y postgresql postgresql-contrib
sudo -u postgres psql -c "DROP ROLE IF EXISTS vagrant"
sudo -u postgres psql -c "CREATE ROLE vagrant SUPERUSER LOGIN PASSWORD 'vagrant'"

echo "host    all             all             0.0.0.0/0            md5" >> /etc/postgresql/10/main/pg_hba.conf
echo "listen_addresses = '*'" >> /etc/postgresql/10/main/postgresql.conf
sudo -u postgres dropdb chinook
sudo -u postgres createdb chinook
sudo -u postgres psql -d chinook -f /vagrant/chinook_data.sql
sudo -u postgres createuser web1
sudo -u postgres createuser web2
sudo -u postgres createuser web3
sudo -u postgres psql -c "revoke connect on database chinook from public"
sudo -u postgres psql -c "grant connect on database chinook to web1"
sudo -u postgres psql -c "grant connect on database chinook to web2"
sudo -u postgres psql -c "grant connect on database chinook to web3"
sudo -u postgres psql -c "revoke all on all tables in schema public from public"
sudo -u postgres psql -c "alter user web1 with password 'web1'"
sudo -u postgres psql -c "alter user web2 with password 'web2'"
sudo -u postgres psql -c "alter user web3 with password 'web3'"
sudo -u postgres psql -d chinook -c "grant select, update, insert, delete on all tables in schema public to web1;"
sudo -u postgres psql -d chinook -c "grant select on all tables in schema public to web2;"
sudo -u postgres psql -d chinook -c "grant select on all tables in schema public to web3;"
systemctl restart postgresql

