import subprocess
import time
import shutil
import os
import statistics

# Number of times to run the command
N = 5

# List of files to test
files_to_test = ["robot/robot.pvl", "half_adder/Main.pvl"]
output_file = "results.txt"
statistics_file = "statistics.txt"
tmp_folder = "tmp"

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

    for file_path in files_to_test:
        # Run the command N times and measure the time
        elapsed_times = []
        for i in range(N):
            start_time = time.time()  # Start time
            result = subprocess.run(["vercors", "--silicon", "--progress", file_path], capture_output=True, text=True)
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
        test_case_name = os.path.basename(file_path).split('.')[0]
        stats_file.write(f"{test_case_name:<20} {min_time:<10.3f} {max_time:<10.3f} {avg_time:<15.3f} {std_dev_time:<20.3f}\n")

# Delete the tmp folder and its contents
if os.path.exists(tmp_folder):
    shutil.rmtree(tmp_folder)
    print(f"Deleted the {tmp_folder} folder and its contents.")

# Inform the user that the results have been written to the files
print(f"Results have been written to {output_file}")
print(f"Statistics have been written to {statistics_file}")
