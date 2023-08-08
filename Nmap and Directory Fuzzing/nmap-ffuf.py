import subprocess

def run_nmap_scan(target):
    nmap_args = ["nmap", "-p", "80,443", "-sV", "-Pn", target]
    nmap_output = subprocess.check_output(nmap_args, universal_newlines=True)
    return nmap_output

def fuzz_directories(url):
    ffuf_args = [
        "ffuf", "-w", "/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt", "-u", f"{url}/FUZZ", "-c", "-o", "ffuf_report.txt"
    ]
    subprocess.call(ffuf_args)

def main():
    target = input("Enter the target IP address or domain: ")

    nmap_output = run_nmap_scan(target)
    print(nmap_output)

    if "80/tcp" in nmap_output:
        url = f"http://{target}:80"
        print("Starting directory fuzzing on port 80...")
        fuzz_directories(url)
    else:
        print("Port 80 is not open. No directory fuzzing needed.")

if __name__ == "__main__":
    main()

