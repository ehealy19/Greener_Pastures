import json
import pandas as pd

"""
Python Script to convert the VROOM outputted 
coordinates from the JSON into a CSV (excel) 
version that is human readable.
"""

# reading in the original addresses
addys = pd.read_excel("./data/input/only_addresses_final.xlsx")

# reading in the VROOM input (lat/long)
with open("./data/input/vroom_input1.json") as f:
    vin = json.load(f)

# creating a lookup table between the addresses and coordinates
lookup = {}
for job in vin["jobs"]:
    job_id = job["id"]
    lon, lat = job["location"]
    row = addys.iloc[job_id - 1]
    lookup[job_id] = {
        "address": row["Address"],
        "city": row["City"],
        "lat": lat,
        "lon": lon
    }

# reading in the outputted coording from VROOM
with open("./data/output/vroom_output1.json") as f:
    vout = json.load(f)

# converting the coordinates back to addresses with the lookup table
rows = []
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

# making a pandas dataframe and sorting
df = pd.DataFrame(rows)
df = df.sort_values(["vehicle", "stop_number"])

# saving the final converted addresses as a CSV and printing
df.to_csv("./data/output/routes_table1.csv", index=False)
print(df)