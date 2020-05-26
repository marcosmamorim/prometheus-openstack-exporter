# Install prometheus-openstack-exporter using Ansible

The Prometheus OpenStack exporter, exports Prometheus metrics from a running OpenStack cloud
for consumption by prometheus. The cloud credentials and identity configuration
should use the [os-client-config](https://docs.openstack.org/os-client-config/latest/) format.

## Requirements

1. A CentOS server
2. Access to internet to download the prometheus-openstack-exporter docker image and packages
3. A Openstack clouds.yaml

### OpenStack configuration

The cloud credentials and identity configuration
should use the [os-client-config](https://docs.openstack.org/os-client-config/latest/) format
and must by specified with the `--os-client-config` flag.

Current list of supported options can be seen in the following example
configuration:

```yaml
clouds:
 default:
   region_name: {{ openstack_region_name }}
   identity_api_version: 3
   identity_interface: internal
   auth:
     username: {{ keystone_admin_user }}
     password: {{ keystone_admin_password }}
     project_name: {{ keystone_admin_project }}
     project_domain_name: 'Default'
     user_domain_name: 'Default'
     auth_url: {{ admin_protocol }}://{{ kolla_internal_fqdn }}:{{ keystone_admin_port }}/v3
     cacert: |
            ---- BEGIN CERTIFICATE ---
      ...
    verify: true | false  // disable || enable SSL certificate verification
```

## Create inventory file 

Copy the `inventory.sample` file to `inventory`

```bash
cp inventory.sample inventory
```

### Edit inventory

Modify the inventory file and updating the values of:

```bash
ansible_host=<<IP_ADDRESS>>
ansible_user=centos
```

Replace `<<IP_ADDRESS>>` by your openstack-exporter server
Replace `centos` by the username to be used to connect to the server

## Configure group vars

Check the file `group_vars/all.yml` and update the variables if necessary

*The most import variable will be `cloud_config_file`, this variable must be your `clouds.yaml`*

## Run playbook to install 
```bash
ansible-playbook -i inventory main.yml 
```

## Check if works

To validate if everything is works, wait 5 minutes to the collector collect all metrics

```yaml
curl --silent http://<<IP_ADDRESS>>:9183/metrics
```

