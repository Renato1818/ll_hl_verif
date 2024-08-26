import matplotlib.pyplot as plt
import numpy as np

# Configuration
statistics_files = [
    "verif_vercors/output_statistics.txt",  # First input statistics file
    "verif_sby/output_statistics.txt"       # Second input statistics file
]
file_labels = [
    "HL Verif",  # Legend label for the first dataset
    "LL Verif"   # Legend label for the second dataset
]
plot_title = "Experimental Results Comparison"  # Title of the plot
output_image = "performance_metrics_comparison.png"  # Output image file name
add_trendline = False  # Set to True to add a trendline

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

# Read the statistics data from each file
statistics_data = [read_statistics(file) for file in statistics_files]

# Plot the results
plot_results(statistics_data, file_labels, plot_title, output_image, add_trendline)
