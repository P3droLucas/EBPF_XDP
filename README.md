# EBPF_XDP
 Projeto de Contagem de Pacotes
É necessário um passo a passo para a instalação dos repositorios antes de efetuar a execução. 
1. **Preparação do Ambiente:**
    - Necessário um computador com Linux.
    - Instalar algumas ferramentas necessárias: **`clang`**, **`llvm`**, **`iproute2`**, e **`libbpf`**. Pode-se fazer isso com o comando:
        
        `sudo apt-get install clang llvm iproute2 libbpf-dev`
 2. **Escrever o Programa XDP:**
    - Crie um arquivo chamado **`xdp_count.c`**. Este arquivo conterá o código que será executado para contar os pacotes.
    - Adicione o seguinte código ao arquivo:
        
        `#include <linux/bpf.h>#include <bpf/bpf_helpers.h>
        
        SEC("xdp")
        int xdp_prog(struct xdp_md *ctx) {
            __u32 *pkt_count;
            __u32 key = 0;
        
            pkt_count = bpf_map_lookup_elem(&pkt_count_map, &key);
            if (pkt_count) {
                __sync_fetch_and_add(pkt_count, 1);
            }
        
            return XDP_PASS;
        }
        
        char _license[] SEC("license") = "GPL";`
    3. **Definindo o Mapa BPF:**
    - Criar um arquivo chamado **`xdp_count.h`** para definir o mapa BPF, que é será feito o  armazenamento da contagem de pacotes.
    - Adicionar o seguinte código ao arquivo:
        
        `struct {
            __uint(type, BPF_MAP_TYPE_ARRAY);
            __uint(max_entries, 1);
            __type(key, __u32);
            __type(value, __u32);
        } pkt_count_map SEC(".maps");`
    4. **Compilar o Programa:**
    - Compilar o programa usando o **`clang`** para gerar um arquivo de objeto (**`.o`**):
        
        `clang -O2 -target bpf -c xdp_count.c -o xdp_count.o`
    5. **Carregar o Programa na Interface de Rede:**
    - Use o comando **`ip`** para carregar o programa XDP na interface de rede desejada (substitua **`<interface>`** pelo nome da sua interface de rede, como **`eth0`**):
        
        `ip link set dev <interface> xdp obj xdp_count.o sec xdp`
    6. **Verificar a Contagem de Pacotes:**
    - Criar um pequeno programa em C ou um script para ler o valor do mapa BPF e mostrar a contagem de pacotes:
        
        `#include <bpf/bpf.h>#include <stdio.h>int main() {
            int map_fd = bpf_obj_get("/sys/fs/bpf/pkt_count_map");
            __u32 key = 0, value;
        
            if (map_fd < 0) {
                perror("bpf_obj_get");
                return 1;
            }
        
            if (bpf_map_lookup_elem(map_fd, &key, &value) == 0) {
                printf("Pacotes recebidos: %u\n", value);
            } else {
                perror("bpf_map_lookup_elem");
            }
        
            return 0;
        }`
