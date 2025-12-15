from mininet.net import Containernet
from mininet.node import Controller, Docker
from mininet.cli import CLI
from mininet.log import setLogLevel, info

setLogLevel('info')

net = Containernet(controller=Controller)
net.addController('c0')

h1 = net.addHost('h1', ip='10.0.0.1/24')
h2 = net.addHost('h2', ip='10.0.0.2/24')

dscp_vnf = net.addDocker(
    'dscp_vnf',
    dimage='dscp_vnf',
    dprivileged=True,
    cap_add=["NET_ADMIN"],
    dcmd="/startup.sh"
)

pol_vnf = net.addDocker(
    'pol_vnf',
    dimage='pol_vnf',
    dprivileged=True,
    cap_add=["NET_ADMIN"],
    dcmd="/startup.sh"
)

mon_vnf = net.addDocker(
    'mon_vnf',
    dimage='mon_vnf',
    dprivileged=True,
    cap_add=["NET_ADMIN"],
    dcmd="/startup.sh"
)

net.addLink(h1, dscp_vnf)
net.addLink(dscp_vnf, pol_vnf)
net.addLink(pol_vnf, mon_vnf)
net.addLink(mon_vnf, h2)

net.start()
CLI(net)

net.stop()