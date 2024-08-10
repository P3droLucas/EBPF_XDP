#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 256);
    __type(key, __u32);
    __type(value, __u64);
} packet_count SEC(".maps");

SEC("xdp")
int xdp_packet_counter(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;

    if (data + sizeof(struct ethhdr) > data_end)
        return XDP_PASS;

    if (eth->h_proto != __constant_htons(ETH_P_IP))
        return XDP_PASS;

    struct iphdr *ip = data + sizeof(struct ethhdr);
    if ((void *)ip + sizeof(struct iphdr) > data_end)
        return XDP_PASS;

	//verifica se o protocolo é TCP, UDP e ICMP
    if(ip->protocol == IPPROTO_TCP || ip->protocol == IPPROTO_UDP || ip->protocol == IPPROTO_ICMP){
    __u32 protocol = ip->protocol;
    __u64 *count = bpf_map_lookup_elem(&packet_count, &protocol);
    if (count) {
	if (protocol == IPPROTO_ICMP && *count >= 11){
		return XDP_DROP; //Dropando pacotes ICMP se a contagem for maior que  10.
	}
        __sync_fetch_and_add(count, 1);
    } else {
        __u64 initial_count = 1;
        bpf_map_update_elem(&packet_count, &protocol, &initial_count, BPF_ANY);
    }
}

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
