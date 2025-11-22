import os

def calculate_coverage(lcov_path):
    total_lines = 0
    covered_lines = 0
    file_stats = {}
    current_file = ""
    
    try:
        with open(lcov_path, 'r', encoding='utf-8') as f:
            for line in f:
                if line.startswith('SF:'):
                    current_file = line.strip()[3:]
                    file_stats[current_file] = {'total': 0, 'covered': 0}
                elif line.startswith('DA:'):
                    parts = line.strip().split(',')
                    if len(parts) >= 2:
                        count = int(parts[1])
                        total_lines += 1
                        file_stats[current_file]['total'] += 1
                        if count > 0:
                            covered_lines += 1
                            file_stats[current_file]['covered'] += 1
                            
        if total_lines == 0:
            return 0.0
            
        print("Coverage per file:")
        for file, stats in file_stats.items():
            if stats['total'] > 0:
                file_cov = (stats['covered'] / stats['total']) * 100
                print(f"{file}: {file_cov:.2f}% ({stats['covered']}/{stats['total']})")
        
        return (covered_lines / total_lines) * 100
    except FileNotFoundError:
        print(f"File not found: {lcov_path}")
        return 0.0

coverage = calculate_coverage('coverage/lcov.info')
print(f"\nTotal Coverage: {coverage:.2f}%")
