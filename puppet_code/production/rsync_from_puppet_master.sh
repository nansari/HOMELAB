cd /home/nasim/git/HOMELAB/puppet_code/production
rsync -rv -e 'ssh -l root' 192.168.10.60:/etc/puppetlabs/code/environments/production/ .
