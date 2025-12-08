# NFV

## Purpose
This project aims to build a **Network Function Virtualization (NFV)** infrastructure using **Containernet**, an extension of Mininet that allows the integration of **Docker containers as hosts** within virtual network topologies.  

The virtual network will include different **VNFs (Virtual Network Functions)**:
- **Classification VNF**: receives the traffic sent by hosts and inspects the packets based on criteria such as source or destination IP address, transport ports, and protocols used. After validation, the packets are tagged with DSCP labels that represent different priority levels.  
- **Policing VNF**: After classification, the traffic flows to the Policing VNF, which regulates and limits the bandwidth defined for each type of traffic. This service is essential to prevent network congestion and protect resources from overload.
- **Monitoring VNF** — Finally, the traffic is directed to the Monitoring VNF, which collects QoS metrics such as bandwidth, latency, and packet loss. These data points are highly relevant for potential adjustments and optimizations of the virtual network, as well as for evaluating the impact of introducing VNFs.