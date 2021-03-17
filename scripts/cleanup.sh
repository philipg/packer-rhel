
set -x
rm -f /etc/ssh/ssh_host_*
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -f /var/lib/dhclient/dhclient-eth0.leases

/bin/rm -rf /etc/*- /etc/*.bak /root/* /tmp/* /var/tmp/*
/bin/rm -rf /var/cache/yum/* /var/lib/yum/repos/* /var/lib/yum/yumdb/*
/bin/rm -rf /var/log/*debug /var/log/anaconda /var/lib/rhsm

# finalise
truncate -s 0 /etc/resolv.conf
rm -f /var/lib/systemd/random-seed
restorecon -R /etc > /dev/null 2>&1 || :

#yum -y clean all
