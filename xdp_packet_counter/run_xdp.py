import subprocess

def run_xdp(ifname, xdp_obj_file):
    try:
        # Comando para executar o programa XDP
        command = ['sudo', './xdp_loader', ifname, xdp_obj_file]
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        print("Saída do comando:", result.stdout)
    except subprocess.CalledProcessError as e:
        print("Erro ao executar o comando:", e.stderr)

if __name__ == "__main__":
    interface = "enp0s3"  # nome da interface de rede
    xdp_file = "xdp_counter.o"  # nome do arquivo objeto XDP
    run_xdp(interface, xdp_file)
