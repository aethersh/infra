setup commands

```
systemctl stop dhcpcd resolvconf
ip address add 23.150.41.166/27 broadcast 23.150.41.191 dev ens18
ip route add default via 23.150.41.161 dev ens18 proto static metric 1000
echo -e "nameserver 1.1.1.1" >> /etc/resolv.conf
mkdir -p ~/.ssh
curl https://henrikvt.com/id_ed25519.pub >> ~/.ssh/authorized_keys
```

**setup/install notes**
only worked when i did mbr?
