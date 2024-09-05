import re
import matplotlib.pyplot as plt

# Get file paths and plot name from user
file1 = "robot/robot_progress.txt"
file2 = "bit4_adder/bit4_adder_progress.txt"
plot_name = "pie_plot.png"

def parse_file(file_path):
    """Parse the file and extract the task times."""
    task_times = {}
    total_time = 0

    # Regex to extract task names and times
    pattern = re.compile(r'\[progress\] \[\d+%\] (.+) took (\d+) ms')

    with open(file_path, 'r') as file:
        for line in file:
            match = pattern.search(line)
            if match:
                task_name = match.group(1).strip()
                time_taken = int(match.group(2))
                task_times[task_name] = time_taken
                total_time += time_taken

    return task_times, total_time

def process_task_times(task_times, total_time):
    """Group tasks that take less than 2% of total time into 'others'."""
    threshold = 0.02 * total_time  # 2% of total time
    others_time = 0
    filtered_tasks = {}

    for task, time in task_times.items():
        if time < threshold:
            others_time += time
        else:
            filtered_tasks[task] = time

    if others_time > 0:
        filtered_tasks['Others'] = others_time

    return filtered_tasks

def create_double_pie_chart(task_times1, task_times2, plot_name):
    """Create a plot with two pie charts, one for each file."""
    labels1 = task_times1.keys()
    times1 = task_times1.values()

    labels2 = task_times2.keys()
    times2 = task_times2.values()

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 7))

    # First pie chart for "robot"
    ax1.pie(times1, labels=labels1, autopct='%1.1f%%', startangle=140)
    ax1.set_title('Robot')

    # Second pie chart for "bit 4 adder"
    ax2.pie(times2, labels=labels2, autopct='%1.1f%%', startangle=140)
    ax2.set_title('Bit 4 Adder')

    plt.suptitle(plot_name)
    plt.savefig(plot_name)
    plt.show()


# Parse the first file
task_times1, total_time1 = parse_file(file1)
processed_task_times1 = process_task_times(task_times1, total_time1)

# Parse the second file
task_times2, total_time2 = parse_file(file2)
processed_task_times2 = process_task_times(task_times2, total_time2)

# Create the pie chart with two pies
create_double_pie_chart(processed_task_times1, processed_task_times2, plot_name)
