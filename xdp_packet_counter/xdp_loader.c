	// Inclusão de cabeçalhos necessários. 
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <net/if.h>
#include <linux/if_link.h>

	// Definição do nome do mapa BPF
#define MAP_NAME "packet_count"

int main(int argc, char **argv) {
	// Verifica se o número correto de argumentos foi fornecido. 
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <ifname> <xdp_obj_file>\n", argv[0]);
        return 1;
    }
	
	// Extrai o nome da interface e o nome do arquivo do objeto BPF dos argumentos. 
    char *ifname = argv[1];
    char *filename = argv[2];

    struct bpf_object *obj;
    int prog_fd, map_fd;

    // Abre o arquivo do objeto BPF
    obj = bpf_object__open_file(filename, NULL);
    if (libbpf_get_error(obj)) {
        fprintf(stderr, "Error opening BPF object file\n");
        return 1;
    }

    // Carega o programa.
    if (bpf_object__load(obj)) {
        fprintf(stderr, "Error loading BPF object file\n");
        bpf_object__close(obj);
        return 1;
    }

    // Encontra o programa XDP no objeto BPF.
    struct bpf_program *prog = bpf_object__find_program_by_name(obj, "xdp_packet_counter");
    if (!prog) {
        fprintf(stderr, "Error finding XDP program in object file\n");
        bpf_object__close(obj);
        return 1;
    }
	
	// Obtém o descritor de arquivo do programa BPF. 
    prog_fd = bpf_program__fd(prog);
	
	// Encontra o descritor de arquivo do mapa BPF.
    map_fd = bpf_object__find_map_fd_by_name(obj, MAP_NAME);
    if (map_fd < 0) {
        fprintf(stderr, "Error finding map\n");
        bpf_object__close(obj);
        return 1;
    }
	
	// Obtém o indice da interface de rede. 
    int ifindex = if_nametoindex(ifname);
    if (ifindex == 0) {
        fprintf(stderr, "Error getting interface index: %s\n", strerror(errno));
        bpf_object__close(obj);
        return 1;
    }
	
	// Prepara as opções para anexar o programa XDP. 
    struct bpf_xdp_attach_opts opts = {
	.sz = sizeof(struct bpf_xdp_attach_opts),
    };
	
	// Anexa o programa XDP a interface de rede. 
    if (bpf_xdp_attach(ifindex, prog_fd, 0, &opts) < 0) {
	perror("bpf_xdp_attach");
        return 1;
    }

    printf("XDP anexado ao programa a interface de rede %s\n", ifname);

	// Loop infinito para exibir as contagens de pacotes. 
	while (1) {
	    __u32 key, next_key;
	    __u64 value;

	    key = 0;
	    while (bpf_map_get_next_key(map_fd, &key, &next_key) == 0) {
	        if (bpf_map_lookup_elem(map_fd, &next_key, &value) == 0) {
	            const char *protocol_name;
	            switch (next_key) {
	                case 6:
	                    protocol_name = "TCP";
	                    break;
	                case 17:
	                    protocol_name = "UDP";
	                    break;
	                case 1:
	                    protocol_name = "ICMP";
	                    break;
	                default:
	                    protocol_name = "%s";
	                    break;
	            }
	            printf("Protocolo %u (%s) identificado: %llu Pacotes recebidos\n", next_key, protocol_name, value);
	        }
	        key = next_key;
	    }

	    printf("\n");
	    sleep(1);
	}

    return 0;
}
