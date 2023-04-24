import struct
import sys
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider

# Thanks @ ChatGPT for this script!

if len(sys.argv) < 2:
    print("\n\033[1;35m\tpython visualize_keys.py <filename>\033[0m")
    print("Prints the distribution of keys stored in the \033[3mfilename\033[0m file.\n")
    sys.exit()

# Define the file path
file_path = sys.argv[1]

# Read the first 8 bytes (64 bits) of the file to get the number of keys
with open(file_path, "rb") as f:
    num_keys = struct.unpack("q", f.read(8))[0]

# Calculate the number of bytes to read
num_bytes = num_keys * 4  # 4 bytes per key

# Read the rest of the file
with open(file_path, "rb") as f:
    f.seek(8)  # Skip the first 8 bytes
    data = np.fromfile(f, dtype=np.uint32, count=num_keys)

# Set up the plot
fig, ax = plt.subplots()
plt.subplots_adjust(bottom=0.25)
plt.title("Key Distribution")
plt.xlabel("Key")
plt.ylabel("Frequency")

# Plot the initial histogram with 50 bins
n_bins = 50
hist, bins, _ = plt.hist(data, bins=n_bins)

# Add a slider to adjust the number of bins
axcolor = 'lightgoldenrodyellow'
ax_slider = plt.axes([0.15, 0.1, 0.7, 0.03], facecolor=axcolor)
slider = Slider(ax_slider, 'Number of Bins', valmin=1, valmax=1000, valinit=n_bins, valstep=1)

# Function to update the histogram when the slider is changed
def update(val):
    global n_bins
    n_bins = int(slider.val)
    hist, bins = np.histogram(data, bins=n_bins)
    for i, rectangle in enumerate(ax.patches):
        rectangle.set_height(hist[i])
    fig.canvas.draw_idle()

slider.on_changed(update)

plt.show()