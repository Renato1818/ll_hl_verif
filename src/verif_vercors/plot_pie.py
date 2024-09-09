import re
import matplotlib.pyplot as plt

# File paths and plot name 
file1 = "robot/robot_progress.txt"
file2 = "bit4_adder/bit4_adder_progress.txt"
plot_name = "pie_plot.png"


#Parse the file and extract the task times
def parse_file(file_path):
    task_times = {}
    total_time = 0

    pattern_with_percentage = re.compile(r'\[progress\] \[\d+%\] (.+) took (\d+) ms')
    pattern_without_percentage = re.compile(r'\[progress\] (.+) took (\d+) ms')

    with open(file_path, 'r') as file:
        for line in file:
            # Skip the last line
            if "entire run took" in line:
                continue

            match = pattern_with_percentage.search(line) or pattern_without_percentage.search(line)
            if match:
                task_name = match.group(1).strip()
                time_taken = int(match.group(2))
                task_times[task_name] = time_taken
                total_time += time_taken

    return task_times, total_time

# Join tasks that take less than 2% of total time into 'others'
def process_task_times(task_times, total_time):
    threshold = 0.02 * total_time 
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

# Assign grayscale colors to tasks, same for both charts
def get_color_mapping(task_names):
    unique_tasks = sorted(set(task_names))
    grayscale_colors = [f"#{hex(int(255 * (1 - (i / len(unique_tasks)))))[2:].zfill(2)}{hex(int(255 * (1 - (i / len(unique_tasks)))))[2:].zfill(2)}{hex(int(255 * (1 - (i / len(unique_tasks)))))[2:].zfill(2)}"
                        for i in range(len(unique_tasks))]
    
    color_mapping = {task: color for task, color in zip(unique_tasks, grayscale_colors)}
    
    return color_mapping

# Create a plot with two pie charts
def create_double_pie_chart(task_times1, task_times2, plot_name):
    labels1 = list(task_times1.keys())
    times1 = list(task_times1.values())
    labels2 = list(task_times2.keys())
    times2 = list(task_times2.values())

    all_tasks = labels1 + labels2
    color_mapping = get_color_mapping(all_tasks)

    colors1 = [color_mapping[label] for label in labels1]
    colors2 = [color_mapping[label] for label in labels2]

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 7))

    # First pie chart
    ax1.pie(times1, labels=labels1, colors=colors1, autopct='%1.1f%%', startangle=140)
    ax1.set_title('Robot')

    # Second pie chart
    ax2.pie(times2, labels=labels2, colors=colors2, autopct='%1.1f%%', startangle=140)
    ax2.set_title('Bit 4 Adder')

    plt.suptitle(plot_name)
    plt.savefig(plot_name)
    plt.show()

# Parse the files
task_times1, total_time1 = parse_file(file1)
processed_task_times1 = process_task_times(task_times1, total_time1)

task_times2, total_time2 = parse_file(file2)
processed_task_times2 = process_task_times(task_times2, total_time2)

create_double_pie_chart(processed_task_times1, processed_task_times2, plot_name)
