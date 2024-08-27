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
N = 40

# Command to execute
command = ["vercors-1", "--silicon"]

# List of files to test and their corresponding names
files_to_test = [
    ("robot/robot.pvl", "Robot"),
    ("robot/robot_assert.pvl", "Robot Assert"),
    ("half_adder/half_adder.pvl", "Half Adder"),
    ("half_adder/half_adder_assert.pvl", "Half Adder Assert"),
    ("full_adder/full_adder.pvl", "Full Adder"),
    ("full_adder/full_adder_assert.pvl", "Full Adder Assert"),
    ("bit2_adder/bit2_adder.pvl", "Bit 2 Adder"),
    ("bit2_adder/bit2_adder_assert.pvl", "Bit 2 Adder Assert"),
    ("bit4_adder/bit4_adder.pvl", "Bit 4 Adder"),
    ("bit4_adder/bit4_adder_assert.pvl", "Bit 4 Adder Assert"),
    #("bit8_adder/bit8_adder.pvl", "Bit 8 Adder"),
    #("bit8_adder/bit8_adder_aasert.pvl", "Bit 8 Adder Assert"),
    ("alu/alu.pvl", "ALU"),
    ("alu/alu_assert.pvl", "ALU Assert")
]

output_file = "results.txt"
statistics_file = "statistics.txt"
tmp_folder = "tmp"
plot_title = "Performance Metrics"
output_image = "performance_metrics.png"
add_trendline = False  # Set to True to add a trendline

# Function to write results to the output file
def write_results(file, file_path, elapsed_times, verdicts):
    file.write(f"Testing {file_path}:\n")
    file.flush() 

    all_pass = True 

    for i, elapsed_time in enumerate(elapsed_times):
        verdict_marker = "*" if verdicts[i] != "Pass" else ""
        if verdict_marker: 
            all_pass = False
        file.write(f"{verdict_marker}{elapsed_time:.3f}\n")
        file.flush()

    min_time = min(elapsed_times)
    max_time = max(elapsed_times)
    avg_time = statistics.mean(elapsed_times)
    std_dev_time = statistics.stdev(elapsed_times)

    file.write(f"\nMin: {min_time:.3f}\n")
    file.write(f"Max: {max_time:.3f}\n")
    file.write(f"Average: {avg_time:.3f}\n")
    file.write(f"Standard Deviation: {std_dev_time:.3f}\n\n")
    file.flush() 
    
    return min_time, max_time, avg_time, std_dev_time, all_pass

# Open the results file and statistics file in append mode
with open(output_file, 'a') as results_file, open(statistics_file, 'a') as stats_file:
    if os.stat(statistics_file).st_size == 0:
        stats_file.write(f"{'Test Case':<20} {'Min':<10} {'Max':<10} {'Average':<15} {'Standard Deviation':<20}\n")

    statistics_data = []

    for file_path, test_name in files_to_test:
        if not os.path.isfile(file_path):
            print(f"File not found: {file_path}")
            continue

        elapsed_times = []
        verdicts = []
        for i in range(N):
            start_time = time.time() 
            result = subprocess.run(command + [file_path], capture_output=True, text=True)
            end_time = time.time() 

            elapsed_time = end_time - start_time
            elapsed_times.append(elapsed_time)
            
            final_verdict = "No verdict found"
            for line in result.stdout.splitlines():
                if "The final verdict is" in line:
                    final_verdict = line.split("The final verdict is")[-1].strip()
                    break

            verdicts.append(final_verdict)
            
            print(f"Run {i+1} for {file_path}: {final_verdict}")

        min_time, max_time, avg_time, std_dev_time, all_pass = write_results(results_file, file_path, elapsed_times, verdicts)

        if not all_pass:
            test_name += "*"
        
        stats_file.write(f"{test_name:<20} {min_time:<10.3f} {max_time:<10.3f} {avg_time:<15.3f} {std_dev_time:<20.3f}\n")
        stats_file.flush() 

        statistics_data.append((test_name, min_time, max_time, avg_time))

# Delete the tmp folder and its contents
if os.path.exists(tmp_folder):
    shutil.rmtree(tmp_folder)
    print(f"Deleted the {tmp_folder} folder and its contents.")

# Create the stock chart
test_names, min_times, max_times, avg_times = zip(*statistics_data)
x = np.arange(len(test_names)) 

fig, ax = plt.subplots(figsize=(10, 5))

bar_width = 0.35
bars_avg = ax.bar(x, avg_times, bar_width, label='Average', color='lightgrey')

if add_trendline:
    z = np.polyfit(x, avg_times, 1)
    p = np.poly1d(z)
    plt.plot(x, p(x), "--", color='black', label='Trendline (Average)')

ax.set_xlabel('Test Case')
ax.set_ylabel('Time (s)')
ax.set_title(plot_title)
ax.set_xticks(x)
ax.set_xticklabels(test_names)
ax.legend()

for i in range(len(x)):
    ax.vlines(x[i], min_times[i], max_times[i], color='black', linestyle='dashed')

fig.tight_layout()
plt.grid(True)
plt.savefig(output_image)
plt.close()
print(f"Chart saved as {output_image}")

# Inform the user that the results have been written to the files
print(f"Results have been written to {output_file}")
print(f"Statistics have been written to {statistics_file}")
