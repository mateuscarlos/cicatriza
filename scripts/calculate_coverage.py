#!/usr/bin/env python3
"""
Script para calcular cobertura de código a partir de arquivo LCOV
Compatível com pipelines CI/CD e uso local
"""

import sys
import argparse
from pathlib import Path

def calculate_coverage(lcov_path, show_details=False, min_coverage=0.0):
    """
    Calcula cobertura de código a partir de arquivo LCOV
    
    Args:
        lcov_path: Caminho para o arquivo lcov.info
        show_details: Mostrar detalhes por arquivo
        min_coverage: Cobertura mínima exigida
    
    Returns:
        float: Percentual de cobertura
    """
    total_lines = 0
    covered_lines = 0
    file_stats = {}
    current_file = ""
    
    try:
        with open(lcov_path, 'r', encoding='utf-8') as f:
            for line in f:
                if line.startswith('SF:'):
                    current_file = line.strip()[3:]
                    # Usar caminho relativo para melhor legibilidade
                    if 'lib/' in current_file:
                        current_file = current_file[current_file.find('lib/'):]
                    file_stats[current_file] = {'total': 0, 'covered': 0}
                elif line.startswith('DA:'):
                    parts = line.strip().split(',')
                    if len(parts) >= 2:
                        try:
                            count = int(parts[1])
                            total_lines += 1
                            if current_file in file_stats:
                                file_stats[current_file]['total'] += 1
                                if count > 0:
                                    covered_lines += 1
                                    file_stats[current_file]['covered'] += 1
                        except ValueError:
                            continue
                            
        if total_lines == 0:
            print("⚠️ Nenhuma linha de código encontrada para análise")
            return 0.0
        
        # Calcular cobertura total
        total_coverage = (covered_lines / total_lines) * 100
        
        # Mostrar detalhes se solicitado
        if show_details:
            print("📊 Cobertura por arquivo:")
            print("-" * 60)
            
            # Ordenar arquivos por cobertura (menor primeiro)
            sorted_files = sorted(
                file_stats.items(), 
                key=lambda x: x[1]['covered'] / max(x[1]['total'], 1)
            )
            
            for file, stats in sorted_files:
                if stats['total'] > 0:
                    file_cov = (stats['covered'] / stats['total']) * 100
                    status = "✅" if file_cov >= min_coverage else "❌"
                    print(f"{status} {file}: {file_cov:.1f}% ({stats['covered']}/{stats['total']})")
            
            print("-" * 60)
        
        # Status da cobertura
        status = "✅" if total_coverage >= min_coverage else "❌"
        print(f"{status} Cobertura Total: {total_coverage:.2f}% ({covered_lines}/{total_lines})")
        
        if min_coverage > 0:
            if total_coverage >= min_coverage:
                print(f"✅ Cobertura atende ao mínimo exigido: {min_coverage:.1f}%")
            else:
                print(f"❌ Cobertura abaixo do mínimo exigido: {min_coverage:.1f}%")
                print(f"   Necessário: +{min_coverage - total_coverage:.2f}%")
        
        return total_coverage
        
    except FileNotFoundError:
        print(f"❌ Arquivo não encontrado: {lcov_path}")
        return 0.0
    except (IOError, ValueError, UnicodeDecodeError) as e:
        print(f"❌ Erro ao processar arquivo LCOV: {e}")
        return 0.0

def main():
    parser = argparse.ArgumentParser(
        description="Calcula cobertura de código a partir de arquivo LCOV"
    )
    parser.add_argument(
        "lcov_file", 
        nargs='?', 
        default="coverage/lcov.info",
        help="Caminho para o arquivo lcov.info (padrão: coverage/lcov.info)"
    )
    parser.add_argument(
        "--details", "-d",
        action="store_true",
        help="Mostrar cobertura detalhada por arquivo"
    )
    parser.add_argument(
        "--min-coverage", "-m",
        type=float,
        default=0.0,
        help="Cobertura mínima exigida (padrão: 0.0)"
    )
    parser.add_argument(
        "--fail-under",
        type=float,
        help="Falhar se cobertura estiver abaixo do valor especificado"
    )
    parser.add_argument(
        "--output-format",
        choices=["text", "json", "csv"],
        default="text",
        help="Formato de saída (padrão: text)"
    )
    
    args = parser.parse_args()
    
    # Verificar se arquivo existe
    if not Path(args.lcov_file).exists():
        print(f"❌ Arquivo LCOV não encontrado: {args.lcov_file}")
        sys.exit(1)
    
    # Calcular cobertura
    coverage = calculate_coverage(
        args.lcov_file, 
        show_details=args.details,
        min_coverage=args.min_coverage
    )
    
    # Saída em diferentes formatos
    if args.output_format == "json":
        import json
        result = {
            "coverage": round(coverage, 2),
            "file": args.lcov_file
        }
        print(json.dumps(result))
    elif args.output_format == "csv":
        print("file,coverage")
        print(f"{args.lcov_file},{coverage:.2f}")
    
    # Falhar se cobertura estiver abaixo do threshold
    if args.fail_under is not None:
        if coverage < args.fail_under:
            print(f"\n❌ Cobertura {coverage:.2f}% está abaixo do limite {args.fail_under:.2f}%")
            sys.exit(1)
        else:
            print(f"\n✅ Cobertura {coverage:.2f}% atende ao limite {args.fail_under:.2f}%")
    
    # Para uso em CI: imprimir apenas o valor numérico se não houver flags
    if len(sys.argv) == 2 and not args.details:
        print(f"{coverage:.1f}")

if __name__ == "__main__":
    main()
