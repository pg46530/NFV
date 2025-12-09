from scapy.all import sniff, sendp, IP, UDP, TCP

def classify(pkt):
    if IP in pkt:
        ip = pkt[IP]

        # VoIP (UDP 5060) - DSCP 46
        if UDP in pkt and pkt[UDP].dport == 5060:
            ip.tos = 46 << 2
            print(f"[VoIP] Pacote classificado: DSCP=46, src={ip.src}, dst={ip.dst}")

        # Vídeo (UDP 5004) - DSCP 34
        elif UDP in pkt and pkt[UDP].dport == 5004:
            ip.tos = 34 << 2
            print(f"[Vídeo] Pacote classificado: DSCP=34, src={ip.src}, dst={ip.dst}")

        # Bulk (TCP 5001) - DSCP 10 
        elif TCP in pkt and pkt[TCP].dport == 5001:
            ip.tos = 10 << 2
            print(f"[Bulk] Pacote classificado: DSCP=10, src={ip.src}, dst={ip.dst}")

        else:
            # Best Effort - resend without flag change
            print(f"[Best Effort] Pacote reenviado sem alteração: src={ip.src}, dst={ip.dst}")
    sendp(pkt, iface="dscp_vnf-eth1", verbose=False)

print(">>> VNF classifier started")
sniff(iface="dscp_vnf-eth0", prn=classify, store=False)
