import subprocess

def run_nmap_scan(target):
    nmap_args = ["nmap", "-p", "1-1000", "-sV", target]
    nmap_output = subprocess.check_output(nmap_args, universal_newlines=True)
    return nmap_output

def fuzz_directories(target, port):
    if port == 443:
        url = f"https://{target}:{port}"
    else:
        url = f"http://{target}:{port}"
    
    dirsearch_args = ["dirsearch", "-u", url, "-e", "*", "--simple-report=dirsearch_report.txt"]
    subprocess.call(dirsearch_args)

def main():
    target = input("Enter the target IP address: ")

    nmap_output = run_nmap_scan(target)
    print(nmap_output)

    if "80/tcp" in nmap_output:
        print("Port 80 is open. Starting directory fuzzing...")
        fuzz_directories(target, 80)
    
    if "443/tcp" in nmap_output:
        print("Port 443 is open. Starting directory fuzzing...")
        fuzz_directories(target, 443)

if __name__ == "__main__":
    main()

