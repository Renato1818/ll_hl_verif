import matplotlib.pyplot as plt
import numpy as np
import statistics

# Configuration
results_files = [
    "verif_vercors/results.txt",
    "verif_sby/results.txt"
]  # List of result files
file_labels = [
    "Robot", 
    "Half Adder",
    "Full Adder",
    "ALU"
] 

plot_title = "Performance Metrics Comparison"  # Title of the plot
output_image = "performance_metrics_comparison.png"  # Output image file name
add_trendline = True  # Set to True to add a trendline

# Read results from the file
def read_results(file_path):
    statistics_data = []
    with open(file_path, 'r') as file:
        lines = file.readlines()
        i = 0
        while i < len(lines):
            if lines[i].startswith("Testing"):
                test_name = lines[i].split()[1].replace(":", "")
                i += 1
                elapsed_times = []
                while i < len(lines) and lines[i].strip() and not lines[i].startswith("Testing"):
                    elapsed_times.append(float(lines[i].strip()))
                    i += 1
                if elapsed_times:
                    min_time = min(elapsed_times)
                    max_time = max(elapsed_times)
                    avg_time = statistics.mean(elapsed_times)
                    std_dev_time = statistics.stdev(elapsed_times) if len(elapsed_times) > 1 else 0
                    statistics_data.append((test_name, min_time, max_time, avg_time, std_dev_time))
            else:
                i += 1
    return statistics_data

# Plot data from multiple files
def plot_results(results_data, file_labels, plot_title, output_image, add_trendline):
    fig, ax1 = plt.subplots(figsize=(12, 6))

    bar_width = 0.35  # Width of the bars
    offset = bar_width / 2  # Offset to place bars side by side

    # Plot the first dataset on the primary Y-axis
    test_names1, min_times1, max_times1, avg_times1, _ = zip(*results_data[0])
    x1 = np.arange(len(test_names1))  # Positions for the bars

    # Plot the average bars for the first dataset
    bars_avg1 = ax1.bar(x1 - offset, avg_times1, bar_width, label=f'Average - {file_labels[0]}', color='gray')

    # Add the variation between min and max for the first dataset
    for i in range(len(x1)):
        ax1.vlines(x1[i] - offset, min_times1[i], max_times1[i], color='black', linestyle='dashed')

    # Optional trendline for the first dataset
    if add_trendline:
        z = np.polyfit(x1, avg_times1, 1)
        p = np.poly1d(z)
        ax1.plot(x1, p(x1), "--", color='black', label=f'Trendline - {file_labels[0]}')

    # Create a secondary Y-axis
    ax2 = ax1.twinx()

    # Plot the second dataset on the secondary Y-axis
    test_names2, min_times2, max_times2, avg_times2, _ = zip(*results_data[1])
    x2 = np.arange(len(test_names2))  # Positions for the bars

    # Plot the average bars for the second dataset
    bars_avg2 = ax2.bar(x2 + offset, avg_times2, bar_width, label=f'Average - {file_labels[1]}', color='lightgray')

    # Add the variation between min and max for the second dataset
    for i in range(len(x2)):
        ax2.vlines(x2[i] + offset, min_times2[i], max_times2[i], color='black', linestyle='dashed')

    # Optional trendline for the second dataset
    if add_trendline:
        z = np.polyfit(x2, avg_times2, 1)
        p = np.poly1d(z)
        ax2.plot(x2, p(x2), "--", color='black', label=f'Trendline - {file_labels[1]}')

    # Add labels, title, and custom x-axis tick labels
    ax1.set_xlabel('Test Case')
    ax1.set_ylabel('Time (s) - Dataset 1')
    ax2.set_ylabel('Time (s) - Dataset 2')
    ax1.set_title(plot_title)

    # Combine x-ticks and labels for both datasets
    combined_x = np.concatenate([x1 - offset, x2 + offset])
    combined_labels = file_labels * max(len(test_names1), len(test_names2))
    
    # Set x-ticks and labels
    ax1.set_xticks(x1)  # Set ticks only where bars are placed
    ax1.set_xticklabels(test_names1, rotation=45, ha='right')

    # Add secondary x-ticks for the second dataset
    ax2.set_xticks(x2 + offset)
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

# Read the results data from each file
results_data = [read_results(file) for file in results_files]

# Plot the results
plot_results(results_data, file_labels, plot_title, output_image, add_trendline)