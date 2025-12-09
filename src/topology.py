from mininet.net import Containernet
from mininet.node import Controller, Docker
from mininet.link import TCLink
from mininet.cli import CLI
from mininet.log import setLogLevel, info

setLogLevel('info')

net = Containernet(controller=Controller)
info('*** Adding controller\n')
net.addController('c0')

info('*** Adding VNFs\n')
# VNF DSCP
dscp_vnf = net.addDocker(
    'dscp_vnf', 
    ip='10.0.0.10', 
    dimage='dscp_vnf', 
    ports=[],
    dprivileged=True,
    dcmd="python /classifier.py"
)

h1 = net.addHost('h1', ip='10.0.0.1')
h2 = net.addHost('h2', ip='10.0.0.2')

info('*** Creating links\n')

net.addLink(h1, dscp_vnf)
net.addLink(dscp_vnf, h2)

info('*** Starting network\n')
net.start()

net.pingAll()

info('*** Running CLI\n')
CLI(net)

info('*** Stopping network\n')
net.stop()
