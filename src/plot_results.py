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

# Function to read results from the file
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

# Function to plot data from multiple files
def plot_results(results_data, plot_title, output_image):
    fig, ax = plt.subplots(figsize=(12, 6))

    colors = ['gray', 'lightgray']
    labels = []

    for index, data in enumerate(results_data):
        test_names, min_times, max_times, avg_times, _ = zip(*data)
        x = np.arange(len(test_names))  # the label locations

        # Plot the average bars
        bar_width = 0.35
        bars_avg = ax.bar(x + index * bar_width, avg_times, bar_width, label=f'Average - Dataset {index + 1}', color=colors[index])
        
        # Add the variation between min and max
        for i in range(len(x)):
            ax.vlines(x[i] + index * bar_width, min_times[i], max_times[i], color='black', linestyle='dashed')

        labels.append(f'Dataset {index + 1}')

    # Optional trendline
    add_trendline = True
    if add_trendline:
        for index, data in enumerate(results_data):
            _, _, _, avg_times, _ = zip(*data)
            x = np.arange(len(avg_times))
            z = np.polyfit(x, avg_times, 1)
            p = np.poly1d(z)
            plt.plot(x + index * bar_width, p(x), "--", color='black', label=f'Trendline - Dataset {index + 1}')

    # Add some text for labels, title and custom x-axis tick labels, etc.
    ax.set_xlabel('Test Case')
    ax.set_ylabel('Time (s)')
    ax.set_title(plot_title)
    ax.set_xticks(x + (len(results_data) - 1) * bar_width / 2)
    ax.set_xticklabels(test_names)
    ax.legend()

    fig.tight_layout()
    plt.grid(True)
    plt.savefig(output_image)
    plt.close()
    print(f"Chart saved as {output_image}")

# Read the results data from each file
results_data = [read_results(file) for file in results_files]

# Plot the results
plot_results(results_data, plot_title, output_image)
