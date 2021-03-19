# vagrant awg

Provision the AGW VM:
```
HOST [magma]$ cd lte/gateway
HOST [magma/lte/gateway]$ vagrant up magma
```

Build AGW from Source:
```
HOST [magma/lte/gateway]$ vagrant ssh magma
MAGMA-VM [/home/vagrant]$ cd magma/lte/gateway
MAGMA-VM [/home/vagrant/magma/lte/gateway]$ make run
```

Connecting Your Local LTE Gateway to Your Local Cloud:
```
HOST [magma]$ cd lte/gateway
HOST [magma/lte/gateway]$ fab -f dev_tools.py register_vm
```

https://docs.magmacore.org/docs/next/lte/config_agw#access-gateway-configuration-1

check if magma is installed:
```bash
sudo dpkg -l | grep magma
```

### AGW Config

Need these to files to start:
```
/var/opt/magma/certs/rootCA.pem
/var/opt/magma/configs/control_proxy.yml
```

Check your magma service status:
```bash
sudo service magma@magmad status
sudo service magma@magmad start
sudo service magma@* stop
sudo service magma@magmad restart
```

https://docs.magmacore.org/docs/next/lte/config_agw

Check connection:
```bash
sudo journalctl -u magma@magmad -f
```