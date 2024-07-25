import subprocess
import time
import shutil
import os
import statistics
import matplotlib.pyplot as plt
import numpy as np

# How to execute the script on terminal:
# python3 execute.py

# Number of times to run the command
N = 3

# Command to execute
command = ["vercors-1", "--silicon"]

# List of files to test and their corresponding names
files_to_test = [
    ("robot/robot.pvl", "Robot"),
    ("half_adder/half_adder.pvl", "Half Adder"),
    ("full_adder/full_adder.pvl", "Full Adder")
]

output_file = "results.txt"
statistics_file = "statistics.txt"
tmp_folder = "tmp"
add_trendline = False  # Set to True to add a trendline

# Function to write results to the output file
def write_results(file, file_path, elapsed_times):
    file.write(f"Testing {file_path}:\n")
    for elapsed_time in elapsed_times:
        file.write(f"{elapsed_time:.3f}\n")

    # Calculate statistics
    min_time = min(elapsed_times)
    max_time = max(elapsed_times)
    avg_time = statistics.mean(elapsed_times)
    std_dev_time = statistics.stdev(elapsed_times)

    # Write the statistics to the file
    file.write(f"\nMin: {min_time:.3f}\n")
    file.write(f"Max: {max_time:.3f}\n")
    file.write(f"Average: {avg_time:.3f}\n")
    file.write(f"Standard Deviation: {std_dev_time:.3f}\n\n")
    
    return min_time, max_time, avg_time, std_dev_time

# Open the results file for writing
with open(output_file, 'w') as results_file, open(statistics_file, 'w') as stats_file:
    # Write the header for the statistics file
    stats_file.write(f"{'Test Case':<20} {'Min':<10} {'Max':<10} {'Average':<15} {'Standard Deviation':<20}\n")

    statistics_data = []

    for file_path, test_name in files_to_test:
        # Run the command N times and measure the time
        elapsed_times = []
        for i in range(N):
            start_time = time.time()  # Start time
            result = subprocess.run(command + [file_path], capture_output=True, text=True)
            end_time = time.time()    # End time

            # Calculate the elapsed time
            elapsed_time = end_time - start_time
            elapsed_times.append(elapsed_time)
            
            # Optionally print the output to the terminal
            if result.returncode == 0:
                print(f"Run {i+1} for {file_path}: Success")
            else:
                print(f"Run {i+1} for {file_path}: Error")

        # Write results to the results file
        min_time, max_time, avg_time, std_dev_time = write_results(results_file, file_path, elapsed_times)

        # Write statistics to the statistics file
        stats_file.write(f"{test_name:<20} {min_time:<10.3f} {max_time:<10.3f} {avg_time:<15.3f} {std_dev_time:<20.3f}\n")

        # Append data for chart
        statistics_data.append((test_name, min_time, max_time, avg_time))

# Delete the tmp folder and its contents
if os.path.exists(tmp_folder):
    shutil.rmtree(tmp_folder)
    print(f"Deleted the {tmp_folder} folder and its contents.")

# Create the stock chart
test_names, min_times, max_times, avg_times = zip(*statistics_data)
x = np.arange(len(test_names))  # the label locations

fig, ax = plt.subplots(figsize=(10, 5))

# Plot the average bars
bar_width = 0.35
bars_avg = ax.bar(x, avg_times, bar_width, label='Average', color='lightgrey')

# Optional trendline
if add_trendline:
    z = np.polyfit(x, avg_times, 1)
    p = np.poly1d(z)
    plt.plot(x, p(x), "--", color='black', label='Trendline (Average)')

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_xlabel('Test Case')
ax.set_ylabel('Time (s)')
ax.set_title('Performance Metrics')
ax.set_xticks(x)
ax.set_xticklabels(test_names)
ax.legend()

# Add the variation between min and max
for i in range(len(x)):
    ax.vlines(x[i], min_times[i], max_times[i], color='black', linestyle='dashed')

fig.tight_layout()
plt.grid(True)
plt.savefig('performance_metrics.png')
plt.close()
print(f"Chart saved as performance_metrics.png")

# Inform the user that the results have been written to the files
print(f"Results have been written to {output_file}")
print(f"Statistics have been written to {statistics_file}")
