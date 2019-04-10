Step 1: Setup CentOS v6.9
For Bahmni, CentOS 6.x 64 bit is the recommended & tested platform
Step 2: Download and setup the bahmni installer
# yum upgrade python-setuptools #optional
# yum install https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.90-308.noarch.rpm
# bahmni –help #check if bahmni installed correctly
Step 3: Copy app config and base database dump
•	Copy mysql dump to /etc/bahmni-installer/deployment-artifacts. The dump file should be named 'mysql_dump.sql'. (From 0.82 release onwards the file name will be openmrs_backup.sql).
•	Copy postgres dump to /etc/bahmni-installer/deployment-artifacts. The dump file should be name openelis_backup.sql and openerp_backup.sql
•	Copy app config folder to /etc/bahmni-installer/deployment-artifacts. The folder name should match <implementation_name>_config
•	implementation_name is 'trishuli', so the app config will be picked up from the /etc/bahmni-installer/deployment-artifacts/trishuli_config folder

OR, follow the steps after the installation
Restore the openmrs database
mysql -uroot openmrs < openmrs_sql_dump_file]

restore the clinlims database
psql -Uclinlims < clinlims_sql_dump_file

restore the openerp database
psql -Uopenerp < openerp_sql_dump_file

restore any other databases if required

replace the content of /opt/bahmni-web/etc/bahmni_config/ with the contents of trishuli_config

Step 4: Setup Installation variables
•	Get the sample setup.yml file
curl -L https://goo.gl/R8ekg5 >> /etc/bahmni-installer/setup.yml
Sample content of the setup.yml
timezone: Asia/Kolkata
implementation_name: default
selinux_state: disabled
postgres_repo_rpm_name: pgdg-centos92-9.2-7.noarch.rpm

Update the content of the file if required. For example timezone.

Step 5: Setup deployment Configuration
•	Update the inventory file at /etc/bahmni-installer/local
Sample inventory file can be found here
https://github.com/Bahmni/bahmni-playbooks/blob/master/local

This file contains the components to be installed including the servers to be used for primary and secondary servers. The modification of this file is optional.

•	Trigger the installation command
bahmni -i local install

Step 7: Verify Installation
Access the emr app at  https://<ip_address>/home
Access the OpenMRS app at  https://<ip_address>/openmrs
Access Bahmni Lab (openelis) app at https://<ip_address>/openelis
Access Odoo/OpenERP app at https://<ip_address>:8069

