## Installation steps
Detail instructions for bahmni installation can be found [here](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/35291242/Install+Bahmni+on+CentOS+Advanced+Installation+Options).

### Step 1: Setup CentOS v6.9
For Bahmni, CentOS 6.x 64 bit is the recommended & tested platform

### Step 2: Download and setup the bahmni installer
<pre>
# yum upgrade python-setuptools #optional
# yum install https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.90-308.noarch.rpm
# bahmni –help #check if bahmni installed correctly
</pre>

### Step 3: Copy app config and base database dump
* Copy mysql dump to <b>/etc/bahmni-installer/deployment-artifacts</b>. The dump file should be named 'mysql_dump.sql'. (From 0.82 release onwards the file name will be openmrs_backup.sql).

* Copy postgres dump to <b>/etc/bahmni-installer/deployment-artifacts</b>. The dump file should be name openelis_backup.sql and openerp_backup.sql

* Copy app config folder to <b>/etc/bahmni-installer/deployment-artifacts</b>. The folder name should match [implementation_name]_config

* implementation_name is 'trishuli', so the app config will be picked up from the /etc/bahmni-installer/deployment-artifacts/trishuli_config folder
<p>
<b>OR, follow the steps after the installation</b>

Restore the openmrs database
<pre>
mysql -uroot openmrs &lt; openmrs_sql_dump_file]
</pre>
Restore the clinlims database
<pre>
psql -Uclinlims %lt; clinlims_sql_dump_file
</pre>
Restore the openerp database
<pre>
psql -Uopenerp &lt; openerp_sql_dump_file
</pre>
Restore any other databases if required
    
Replace the content of /opt/bahmni-web/etc/bahmni_config/ with the contents of trishuli_config (or any previous config directory)

### Step 4: Setup Installation variables
* Get the sample setup.yml file
<pre>
curl -L https://goo.gl/R8ekg5 >> /etc/bahmni-installer/setup.yml
</pre>
Sample content of the setup.yml
<pre>
timezone: Asia/Kolkata
implementation_name: default
selinux_state: disabled
postgres_repo_rpm_name: pgdg-centos92-9.2-7.noarch.rpm
</pre>

Update the content of the file if required. For example timezone.

### Step 5: Setup deployment Configuration
* Update the inventory file at /etc/bahmni-installer/local

	Sample inventory file can be found here
	https://github.com/Bahmni/bahmni-playbooks/blob/master/local

	This file contains the components to be installed including the servers to be used for primary and secondary 	servers. The modification of this file is optional.

### Step 6: Trigger the installation command
<pre>
# bahmni -i local install # local is the inventory file name, replace if different inventory file
</pre>

### Step 7: Verify Installation
Access the emr app at  https://<ip_address>/home

Access the OpenMRS app at  https://<ip_address>/openmrs

Access Bahmni Lab (openelis) app at https://<ip_address>/openelis

Access Odoo/OpenERP app at https://<ip_address>:8069
