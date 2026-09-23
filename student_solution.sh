#!/bin/bash

# SELinux Access Denial Practical
# Student Name: 
# Register Number: 

echo "===== SELinux Status ====="
getenforce
sestatus

echo "===== Creating Web Directory ====="
sudo mkdir -p /var/www/html/testlab

echo "===== Creating HTML File ====="
echo "<h1>SELinux Test Page</h1>" | sudo tee /var/www/html/testlab/index.html > /dev/null

echo "===== Setting Linux Permissions ====="
sudo chmod -R 755 /var/www/html/testlab
sudo chown -R apache:apache /var/www/html/testlab

echo "===== Checking Initial Context ====="
ls -Z /var/www/html/testlab/index.html

echo "===== Assigning Wrong SELinux Context ====="
# Assigning user_home_t (or samba_share_t) causes httpd_t to be denied access
sudo chcon -t user_home_t /var/www/html/testlab/index.html

echo "===== Checking Wrong Context ====="
ls -Z /var/www/html/testlab/index.html

echo "===== Checking AVC Denials ====="
# Attempt to read/access or simulate access, then query audit log
curl -s http://localhost/testlab/index.html || true
sudo ausearch -m avc -ts recent | tail -n 15 || sudo grep "denied" /var/log/audit/audit.log | tail -n 10

echo "===== Correcting SELinux Context ====="
# Method 1: Using chcon to explicitly set httpd_sys_content_t
# sudo chcon -t httpd_sys_content_t /var/www/html/testlab/index.html

# Method 2: Resetting context based on default SELinux policy rules (Recommended)
sudo restorecon -vR /var/www/html/testlab

echo "===== Checking Correct Context ====="
ls -Z /var/www/html/testlab/index.html

echo "===== Practical Completed ====="
