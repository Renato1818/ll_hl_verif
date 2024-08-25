import os
import statistics
import math

# Configuration
results_file = "verif_vercors/results.txt"  # Input result file
output_statistics_file = "verif_vercors/output_statistics.txt"  # Output statistics file

def read_results(file_path):
    """Reads and parses results from a results.txt file."""
    statistics_data = {}
    current_test = None

    with open(file_path, 'r') as file:
        lines = file.readlines()
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            if line.startswith("Testing"):
                current_test = line.split()[1].replace(":", "")
                statistics_data[current_test] = {
                    'times': []
                }
            elif line and line[0].isdigit():
                statistics_data[current_test]['times'].append(float(line))
            elif line.startswith("Min"):
                statistics_data[current_test]['min'] = float(line.split(":")[1].strip())
            elif line.startswith("Max"):
                statistics_data[current_test]['max'] = float(line.split(":")[1].strip())
            elif line.startswith("Average"):
                statistics_data[current_test]['avg'] = float(line.split(":")[1].strip())
            elif line.startswith("Standard Deviation"):
                statistics_data[current_test]['std_dev'] = float(line.split(":")[1].strip())
            i += 1

    return statistics_data

def calculate_difference(simple, with_assertions):
    """Calculates the difference between simple and with assertions test times."""
    avg_diff = abs(simple['avg'] - with_assertions['avg'])
    std_dev_combined = math.sqrt(simple['std_dev']**2 + with_assertions['std_dev']**2)
    return avg_diff, std_dev_combined

def generate_statistics(results_file, output_statistics_file):
    """Generates statistics with differences between simple and with assertions tests and saves to a file."""
    results = read_results(results_file)
    test_cases = {}

    for test_name, stats in results.items():
        base_name = test_name.split('/')[0]
        if base_name not in test_cases:
            test_cases[base_name] = {}

        if "assert" in test_name:
            test_cases[base_name]['with_assertions'] = stats
        else:
            test_cases[base_name]['simple'] = stats

    all_statistics = []

    for base_name, tests in test_cases.items():
        if 'simple' in tests and 'with_assertions' in tests:
            simple_results = tests['simple']
            with_assertions_results = tests['with_assertions']

            avg_diff, std_dev_combined = calculate_difference(simple_results, with_assertions_results)

            all_statistics.append([
                base_name,
                simple_results['avg'],
                simple_results['std_dev'],
                with_assertions_results['avg'],
                with_assertions_results['std_dev'],
                avg_diff,
                std_dev_combined
            ])

    # Save statistics to a file with formatted output
    with open(output_statistics_file, 'w') as output_file:
        output_file.write(f"{'Test Case':<20} {'Simple Avg':<15} {'Simple Std Dev':<20} {'With Assertions Avg':<20} {'With Assertions Std Dev':<25} {'Difference Avg':<20} {'Combined Std Dev':<20}\n")
        #output_file.write("="*130 + "\n")
        for stat in all_statistics:
            output_file.write(f"{stat[0]:<20} {stat[1]:<15.3f} {stat[2]:<20.3f} {stat[3]:<20.3f} {stat[4]:<25.3f} {stat[5]:<20.3f} {stat[6]:<20.3f}\n")

    print(f"Statistics saved to {output_statistics_file}")

# Generate the statistics and save them to the output file
generate_statistics(results_file, output_statistics_file)