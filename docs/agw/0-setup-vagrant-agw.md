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


