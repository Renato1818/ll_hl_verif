import os
import statistics
import math
import matplotlib.pyplot as plt
import numpy as np

# How to execute the script on terminal:
# python3 plot_results.py

# Configuration

# Number of times runned on the result files
num_samples = 40  

# List of result files
results_files = [
    "verif_vercors/res_all.txt",
    "verif_sby/res_all.txt"
]  
# Output statistics files
output_statistics_files = [
    "verif_vercors/output_stat_all.txt", 
    "verif_sby/output_stat_all.txt" 
] 

# Legend label for the two dataset
file_labels = [
    "HL Verif",  
    "LL Verif"  
]

# Plot configuration
plot_title = "Experimental Results Comparison"  
output_image = "plot_comp_all.png" 
add_trendline = False  

# Reads and parses results
def read_results(file_path):
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

# Calculates the difference between without and with assertions test times
def calculate_difference(simple, with_assertions):
    avg_diff = abs(simple['avg'] - with_assertions['avg'])
    std_dev_combined = math.sqrt(simple['std_dev']**2 + with_assertions['std_dev']**2)
    return avg_diff, std_dev_combined

# Generates statistics for multiple result files and saves to corresponding output files
def generate_statistics(results_files, output_statistics_files):
    for results_file, output_statistics_file in zip(results_files, output_statistics_files):
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

        with open(output_statistics_file, 'w') as output_file:
            output_file.write(f"{'Test Case':<20} {'Simple Avg':<15} {'Simple Std Dev':<20} {'Assertions Avg':<20} {'Assertions Std Dev':<25} {'Difference Avg':<20} {'Combined Std Dev':<20}\n")
            for stat in all_statistics:
                output_file.write(f"{stat[0]:<20} {stat[1]:<15.3f} {stat[2]:<20.3f} {stat[3]:<20.3f} {stat[4]:<25.3f} {stat[5]:<20.3f} {stat[6]:<20.3f}\n")

        print(f"Statistics saved to {output_statistics_file}")

# Function to read the statistics data from the file
def read_statistics(file_path):
    test_names = []
    avg_times = []
    sems = []  # Will store standard error of the mean (SEM) instead of std dev
    with open(file_path, 'r') as file:
        lines = file.readlines()
        for line in lines[1:]:  # Skip the header
            if line.strip():  # Skip empty lines
                parts = line.split()
                test_name = parts[0]
                avg_time = abs(float(parts[5]))  # 'Difference Avg'
                std_dev = float(parts[6])        # 'Combined Std Dev'
                sem = std_dev / math.sqrt(num_samples)  # Calculate the SEM
                
                test_names.append(test_name)
                avg_times.append(avg_time)
                sems.append(sem)
    return test_names, avg_times, sems

# Function to plot the results
def plot_results(statistics_data, file_labels, plot_title, output_image, add_trendline):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6)) 

    bar_width = 0.35 

    # Plot the first dataset
    test_names1, avg_times1, sems1 = statistics_data[0]
    x1 = np.arange(len(test_names1)) 

    bars_avg1 = ax1.bar(x1, avg_times1, bar_width, label=file_labels[0], color='gray')
    ax1.errorbar(x1, avg_times1, yerr=sems1, fmt='o', color='black', capsize=5, label='SEM')

    if add_trendline:
        z1 = np.polyfit(x1, avg_times1, 1)
        p1 = np.poly1d(z1)
        ax1.plot(x1, p1(x1), "--", color='black', label=f'Trendline - {file_labels[0]}')

    ax1.set_xlabel('Verif Case')
    ax1.set_ylabel('Time (s)')
    ax1.set_title(f'{file_labels[0]}')
    
    ax1.set_yscale('log')

    # Plot the second dataset
    test_names2, avg_times2, sems2 = statistics_data[1]
    x2 = np.arange(len(test_names2))

    bars_avg2 = ax2.bar(x2, avg_times2, bar_width, label=file_labels[1], color='silver')
    ax2.errorbar(x2, avg_times2, yerr=sems2, fmt='o', color='black', capsize=5, label='SEM')

    if add_trendline:
        z2 = np.polyfit(x2, avg_times2, 1)
        p2 = np.poly1d(z2)
        ax2.plot(x2, p2(x2), "--", color='black', label=f'Trendline - {file_labels[1]}')

    ax2.set_xlabel('Verif Case')
    ax2.set_ylabel('Time (s)')
    ax2.set_title(f'{file_labels[1]}')
    
    ax2.set_yscale('log')    
    #If not log scale
    #ax2.set_ylim(bottom=0)


    ax1.set_xticks(x1)
    ax1.set_xticklabels(test_names1, rotation=45, ha='right')

    ax2.set_xticks(x2)
    ax2.set_xticklabels(test_names2, rotation=45, ha='right')

    ax1.grid(linestyle='dashed', color='gainsboro')
    ax2.grid(linestyle='dashed', color='gainsboro')

    # Add a legend explaining the error bars
    ax1.legend(loc='upper left')
    ax2.legend(loc='upper left')

    fig.tight_layout()
    plt.grid(True)
    plt.savefig(output_image)
    plt.close()
    print(f"Chart saved as {output_image}")

# Generate statistics for all input-output pairs
generate_statistics(results_files, output_statistics_files)

# Read the statistics data from each file
statistics_data = [read_statistics(file) for file in output_statistics_files]

# Plot the results
plot_results(statistics_data, file_labels, plot_title, output_image, add_trendline)