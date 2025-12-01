import os
import json
from codecarbon import EmissionsTracker
from subprocess import run, CalledProcessError

# begin the code carbon
tracker = EmissionsTracker(project_name="greener_pasturers")
tracker.start()

# check that the CLI toop vroom is installed
result = run(["brew", "install", "vroom"], check=False)
if result.returncode != 0:
    print("Please brew install vroom on the command line")

# read in the JSON file of addresses
input_path = "data/input/vroom_input.json"
output_path = "data/output/vroom_output.json"
try:
    with open(input_path, "r", encoding="utf-8") as f:
        data = json.load(f)
except FileNotFoundError:
    raise SystemExit("Data file not found.")
except json.JSONDecodeError as e:
    raise SystemExit("Failed to parse file.")

# run VROOM on the inputs addresses
result = run(["vroom", "-i", input_path, "-o", output_path], check=True)

# stop the code carbon tracker
emissions = tracker.stop()
print(f"Estimated O₂ emissions: {emissions:.6f} kg")

# view the output results
with open(output_path, "r", encoding="utf-8") as f:
    optimized_routes = json.load(f)
print(json.dumps(optimized_routes, indent=2))