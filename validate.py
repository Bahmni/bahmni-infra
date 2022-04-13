def high_vuln_counter(filename):
    file = open(filename, "rb")
    high_vuln_count = int(file.readlines()[-3].decode()[-2])
    return high_vuln_count

if high_vuln_counter("scan_results.txt") == 0:
    pass
else:
    raise ValueError("High level vulnerabilities found")