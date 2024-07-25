import matplotlib.pyplot as plt
import numpy as np
import statistics

# Configuration
results_files = [
    "verif_vercors/results.txt",
    "verif_sby/results.txt"
]  # List of result files
plot_title = "Performance Metrics Comparison"  # Title of the plot
output_image = "performance_metrics_comparison.png"  # Output image file name
add_trendline = False  # Set to True to add a trendline

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
def plot_results(results_data, plot_title, output_image, add_trendline):
    fig, ax1 = plt.subplots(figsize=(12, 6))

    # Plot the first dataset on the primary Y-axis
    test_names, min_times, max_times, avg_times, _ = zip(*results_data[0])
    x = np.arange(len(test_names))  # the label locations for the first dataset

    # Plot the average bars for the first dataset
    bar_width = 0.35
    bars_avg1 = ax1.bar(x - bar_width / 2, avg_times, bar_width, label='Average - Dataset 1', color='gray')

    # Add the variation between min and max
    for i in range(len(x)):
        ax1.vlines(x[i] - bar_width / 2, min_times[i], max_times[i], color='black', linestyle='dashed')

    # Optional trendline for the first dataset
    if add_trendline:
        z = np.polyfit(x, avg_times, 1)
        p = np.poly1d(z)
        ax1.plot(x, p(x), "--", color='black', label='Trendline - Dataset 1')

    # Create a secondary Y-axis
    ax2 = ax1.twinx()

    # Plot the second dataset on the secondary Y-axis
    test_names2, min_times2, max_times2, avg_times2, _ = zip(*results_data[1])
    x2 = np.arange(len(test_names2))  # the label locations for the second dataset

    # Plot the average bars for the second dataset
    bars_avg2 = ax2.bar(x2 + bar_width / 2, avg_times2, bar_width, label='Average - Dataset 2', color='lightgray')

    # Add the variation between min and max for the second dataset
    for i in range(len(x2)):
        ax2.vlines(x2[i] + bar_width / 2, min_times2[i], max_times2[i], color='black', linestyle='dashed')

    # Optional trendline for the second dataset
    if add_trendline:
        z = np.polyfit(x2, avg_times2, 1)
        p = np.poly1d(z)
        ax2.plot(x2, p(x2), "--", color='black', label='Trendline - Dataset 2')

    # Add labels, title, and custom x-axis tick labels
    ax1.set_xlabel('Test Case')
    ax1.set_ylabel('Time (s) - Dataset 1')
    ax2.set_ylabel('Time (s) - Dataset 2')
    ax1.set_title(plot_title)

    # Adjust x-ticks to fit both datasets
    combined_x = np.concatenate([x - bar_width / 2, x2 + bar_width / 2])
    combined_labels = list(test_names) + list(test_names2)
    ax1.set_xticks(combined_x)
    ax1.set_xticklabels(combined_labels, rotation=45, ha='right')

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
plot_results(results_data, plot_title, output_image, add_trendline)
