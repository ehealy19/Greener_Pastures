import json
import pandas as pd

# Load original addresses for ID → address mapping
addys = pd.read_excel("../data/input/only_addresses_final.xlsx")

# Load VROOM input (contains correct lat/long)
with open("../data/input/vroom_input1.json") as f:
    vin = json.load(f)

# Build lookup table (id → info)
lookup = {}
for job in vin["jobs"]:
    job_id = job["id"]
    lon, lat = job["location"]
    
    row = addys.iloc[job_id - 1]  # same ordering
    
    lookup[job_id] = {
        "address": row["Address"],
        "city": row["City"],
        "lat": lat,
        "lon": lon
    }

# Load VROOM output
with open("../data/output/vroom_output1.json") as f:
    vout = json.load(f)

rows = []

# Convert each route into flat row structure
for r in vout["routes"]:
    vehicle = r["vehicle"]
    step_num = 0
    
    for step in r["steps"]:
        if step["type"] == "job":
            job_id = step["id"]
            info = lookup[job_id]
            step_num += 1
            
            rows.append({
                "vehicle": vehicle,
                "stop_number": step_num,
                "job_id": job_id,
                "address": info["address"],
                "city": info["city"],
                "lat": info["lat"],
                "lon": info["lon"]
            })

# Make DataFrame
df = pd.DataFrame(rows)

# Sort by vehicle + stop number just to be safe
df = df.sort_values(["vehicle", "stop_number"])

# Save as CSV for easy viewing
df.to_csv("../data/output/routes_table1.csv", index=False)

print(df)