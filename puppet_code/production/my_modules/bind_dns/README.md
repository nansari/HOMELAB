# installation
* install rpms
```bash
yum install bind bind-chroot bind-utils -y
```
* copy files in /etc and /var/named 
* change IP against listen-on port in /etc/named.conf
* enable and restart named
* ensure /etc/resolv.conf has `nameserver <dns-server-ip>`
* Refer [this](https://opensource.com/article/17/4/build-your-own-name-server) for installation and configuration
