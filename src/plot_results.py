import os
import statistics
import math
import matplotlib.pyplot as plt
import numpy as np

# Configuration
results_files = [
    "verif_vercors/results.txt",
    "verif_sby/results.txt"
]  # List of result files
output_statistics_files = [
    "verif_vercors/output_statistics.txt", 
    "verif_sby/output_statistics.txt" 
] # Output statistics files

file_labels = [
    "HL Verif",  # Legend label for the first dataset
    "LL Verif"   # Legend label for the second dataset
]
plot_title = "Experimental Results Comparison"  # Title of the plot
output_image = "performance_metrics_comparison.png"  # Output image file name
add_trendline = False  # Set to True to add a trendline

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

def generate_statistics(results_files, output_statistics_files):
    """Generates statistics for multiple result files and saves to corresponding output files."""
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

        # Save statistics to the corresponding output file with formatted output
        with open(output_statistics_file, 'w') as output_file:
            output_file.write(f"{'Test Case':<20} {'Simple Avg':<15} {'Simple Std Dev':<20} {'Assertions Avg':<20} {'Assertions Std Dev':<25} {'Difference Avg':<20} {'Combined Std Dev':<20}\n")
            for stat in all_statistics:
                output_file.write(f"{stat[0]:<20} {stat[1]:<15.3f} {stat[2]:<20.3f} {stat[3]:<20.3f} {stat[4]:<25.3f} {stat[5]:<20.3f} {stat[6]:<20.3f}\n")

        print(f"Statistics saved to {output_statistics_file}")

# Function to read the statistics data from the file
def read_statistics(file_path):
    """Reads the statistics from the given file and returns relevant data."""
    test_names = []
    avg_times = []
    std_devs = []
    with open(file_path, 'r') as file:
        lines = file.readlines()
        for line in lines[1:]:  # Skip the header
            if line.strip():  # Skip empty lines
                parts = line.split()
                test_name = parts[0]
                avg_time = abs(float(parts[5]))  # 'Difference Avg' (ensure positive values)
                std_dev = float(parts[6])   # 'Combined Std Dev'
                
                test_names.append(test_name)
                avg_times.append(avg_time)
                std_devs.append(std_dev)
    return test_names, avg_times, std_devs

# Function to plot the results
def plot_results(statistics_data, file_labels, plot_title, output_image, add_trendline):
    fig, ax1 = plt.subplots(figsize=(12, 6))

    bar_width = 0.35  # Width of the bars
    offset = bar_width / 2  # Offset to place bars side by side

    # Plot the first dataset on the primary Y-axis
    test_names1, avg_times1, std_devs1 = statistics_data[0]
    x1 = np.arange(len(test_names1))  # Positions for the bars

    # Plot the average bars for the first dataset
    bars_avg1 = ax1.bar(x1 - offset, avg_times1, bar_width, label=file_labels[0], color='gray')

    # Add the standard deviation as error bars
    ax1.errorbar(x1 - offset, avg_times1, yerr=std_devs1, fmt='o', color='black', capsize=5)

    # Optional trendline for the first dataset
    if add_trendline:
        z = np.polyfit(x1, avg_times1, 1)
        p = np.poly1d(z)
        ax1.plot(x1, p(x1), "--", color='black', label=f'Trendline - {file_labels[0]}')

    # Create a secondary Y-axis
    ax2 = ax1.twinx()

    # Plot the second dataset on the secondary Y-axis
    test_names2, avg_times2, std_devs2 = statistics_data[1]
    x2 = np.arange(len(test_names2))  # Positions for the bars

    # Plot the average bars for the second dataset
    bars_avg2 = ax2.bar(x2 + offset, avg_times2, bar_width, label=file_labels[1], color='silver')

    # Add the standard deviation as error bars
    ax2.errorbar(x2 + offset, avg_times2, yerr=std_devs2, fmt='o', color='black', capsize=5)

    # Optional trendline for the second dataset
    if add_trendline:
        z = np.polyfit(x2, avg_times2, 1)
        p = np.poly1d(z)
        ax2.plot(x2, p(x2), "--", color='black', label=f'Trendline - {file_labels[1]}')

    # Set labels, title, and custom x-axis tick labels
    ax1.set_xlabel('Verif Case')
    ax1.set_ylabel('Time (s) - HL Verif')
    ax2.set_ylabel('Time (s) - LL Verif')
    ax1.set_title(plot_title)

    # Set y-axis to logarithmic scale for exponential scaling
    ax1.set_yscale('log')
    ax2.set_yscale('log')

    # Set x-ticks and labels for primary and secondary axes
    ax1.set_xticks(x1)
    ax1.set_xticklabels(test_names1, rotation=45, ha='right')
    ax2.set_xticks(x2)
    ax2.set_xticklabels(test_names2, rotation=45, ha='right')

    # Combine legends from both axes
    lines, labels = ax1.get_legend_handles_labels()
    lines2, labels2 = ax2.get_legend_handles_labels()
    ax1.legend(lines + lines2, labels + labels2, loc='upper left')

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
