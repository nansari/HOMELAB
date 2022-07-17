# PUPPET MASTER
Build puppet master host VM by clonning template created by Hashicorp packer + kickstart

## puppetserver
some commands
```
puppetserver ca list --all
facter networking.ip
puppet lookup <KEY> --node <NAME> --environment <ENV> --explain
puppet lookup common::resolv::nameservers --node dns.family.net --environment production --explain
puppet lookup common::resolv::nameservers  --environment production --explain
```

## puppet agent
some commands
```
puppet agen -tv --debug 2>&1 | tee /tmp/puppet-agent-debug.out

```

## validation
some commands
```
puppet-lint some-file.pp
puppet-lint --fix some-file.pp
puppet parser validate some-filke.pp
```

