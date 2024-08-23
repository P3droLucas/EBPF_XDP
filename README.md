# EBPF_XDP
 Projeto de Contagem de Pacotes
É necessário um passo a passo para a instalação dos repositorios antes de efetuar a execução. 
1. **Preparação do Ambiente:**
    - Necessário um computador com Linux.
    - Instalar algumas ferramentas necessárias: **`clang`**, **`llvm`**, **`iproute2`**, e **`libbpf`**. Pode-se fazer isso com o comando:
        
        `sudo apt-get install clang llvm iproute2 libbpf-dev`
    - Criar um diretorio para a criação dos arquivos posteriores. 
2. **Escrever o Programa XDP:**
    - Crie um arquivo chamado **`xdp_count.c`**. Este arquivo conterá o código que será executado para contar os pacotes.
    - Adicione o seguinte código ao arquivo: 
      ~~~C  
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


3. **Definindo o Mapa BPF:**
    - Criar um arquivo chamado **`xdp_count.h`** para definir o mapa BPF, que é será feito o  armazenamento da contagem de pacotes.
    - Adicionar o seguinte código ao arquivo:
      ~~~C
        struct {
            __uint(type, BPF_MAP_TYPE_ARRAY);
            __uint(max_entries, 1);
            __type(key, __u32);
            __type(value, __u32);
        } pkt_count_map SEC(".maps");

4. **Verificar a Contagem de Pacotes:**
    - Criar um arquivo chamado **`xdp_loader.c`** e adicionar o seguinte codigo:
      ~~~C
  
       #include <stdio.h>
       #include <stdlib.h>
       #include <unistd.h>
       #include <string.h>
       #include <errno.h>
       #include <bpf/bpf.h>
       #include <bpf/libbpf.h>
       #include <net/if.h>
       #include <linux/if_link.h>
       
       #define MAP_NAME "packet_count"
       
       int main(int argc, char **argv) {
           if (argc != 3) {
               fprintf(stderr, "Usage: %s <ifname> <xdp_obj_file>\n", argv[0]);
               return 1;
           }
       
           char *ifname = argv[1];
           char *filename = argv[2];
       
           struct bpf_object *obj;
           int prog_fd, map_fd;
       
           // Load and verify BPF application
           obj = bpf_object__open_file(filename, NULL);
           if (libbpf_get_error(obj)) {
               fprintf(stderr, "Error opening BPF object file\n");
               return 1;
           }
       
           // Load BPF program
           if (bpf_object__load(obj)) {
               fprintf(stderr, "Error loading BPF object file\n");
               bpf_object__close(obj);
               return 1;
           }
       
           // Get file descriptor of BPF program
           struct bpf_program *prog = bpf_object__find_program_by_name(obj, "xdp_packet_counter");
           if (!prog) {
               fprintf(stderr, "Error finding XDP program in object file\n");
               bpf_object__close(obj);
               return 1;
           }
           prog_fd = bpf_program__fd(prog);
       
           map_fd = bpf_object__find_map_fd_by_name(obj, MAP_NAME);
           if (map_fd < 0) {
               fprintf(stderr, "Error finding map\n");
               bpf_object__close(obj);
               return 1;
           }
       
           int ifindex = if_nametoindex(ifname);
           if (ifindex == 0) {
               fprintf(stderr, "Error getting interface index: %s\n", strerror(errno));
               bpf_object__close(obj);
               return 1;
           }
           struct bpf_xdp_attach_opts opts = {
       	.sz = sizeof(struct bpf_xdp_attach_opts),
           };
           if (bpf_xdp_attach(ifindex, prog_fd, 0, &opts) < 0) {
       	perror("bpf_xdp_attach");
               return 1;
           }
       
           printf("XDP program attached to interface %s\n", ifname);
       
           while (1) {
               __u32 key, next_key;
               __u64 value;
       
               key = 0;
               while (bpf_map_get_next_key(map_fd, &key, &next_key) == 0) {
                   if (bpf_map_lookup_elem(map_fd, &next_key, &value) == 0) {
                       printf("Protocol %u: %llu packets\n", next_key, value);
                   }
                   key = next_key;
               }
       
               printf("\n");
               sleep(1);
           }
       
           return 0;
       }




5. **Criar um arquivo Makefile:**
    - Criar um arquivo chamado **`Makefile`** para posteriormente compilar os arquivos.
    - Adicionar o seguinte código ao arquivo:
      ~~~C
      
               LLC ?= llc
               CLANG ?= clang
               CC ?= gcc
               
               KERN_SOURCES := xdp_counter.c
               KERN_OBJECTS := ${KERN_SOURCES:.c=.o}
               
               CFLAGS := -g -O2 -Wall
               LDFLAGS := -lbpf -lelf
               
               all: xdp_counter.o xdp_loader
               
               %.o: %.c
               	$(CLANG) -S \
               	    -target bpf \
               	    -D __BPF_TRACING__ \
               	    $(CFLAGS) \
               	    -Wall \
               	    -Wno-unused-value \
               	    -Wno-pointer-sign \
               	    -Wno-compare-distinct-pointer-types \
               	    -Werror \
               	    -O2 -emit-llvm -c -g -o ${@:.o=.ll} $<
               	$(LLC) -march=bpf -filetype=obj -o $@ ${@:.o=.ll}
               
               xdp_loader: xdp_loader.c
               	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
               
               clean:
               	rm -f *.o *.ll xdp_loader


6. **Compilar o Programa:**      
    - Compilar o programa usando o **'Makefile'** para gerar um arquivo de objeto (**`.o`**).
    - Basta utilizar o comando `make` dentro do mesmo diretorio que o arquivo `Makefile`.
      
7. **Carregar o Programa na Interface de Rede:**
    - Use o comando **'ip'** para carregar o programa XDP na interface de rede desejada (substitua **'<interface>'** pelo nome da sua interface de rede, como **'eth0, enp0s3...'**):
        `ip link set dev <interface> xdp obj xdp_count.o sec xdp`
8. **Rodar o programa de contagem de pacotes:**
    - Basta utilizar o seguinte comando no bash: `sudo ./xdp_loader enp0s3 xdp_counter.o`. 

 
