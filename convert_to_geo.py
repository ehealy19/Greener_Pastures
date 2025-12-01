import requests
import pandas as pd
import json

# Read in the addresses file
addys = pd.read_excel('./data/input/only_addresses_final.xlsx')
addys['Long'] = None
addys['Lat'] = None

url = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"

# Converting to Lat and Long
for i, row in addys.iterrows():
    address = f"{row['Address']}, {row['City']}"

    params = {
        "address": address,
        "benchmark": "Public_AR_Census2020",
        "format": "json"
    }

    if address == "418 Ravenscliff Dr, Media":
        coords = {"y": -75.36618079301951, "x": 39.93955917939913} 
    elif address == "727 Iris Ln, Media":
        coords = {"y": -75.42235610674658, "x": 39.881741578337895} 
    elif address == "1 Rose Hill Rd, Media":
        coords = {"y": -75.39399672208904, "x": 39.9073283834072} 
    elif address == "1343 W Baltimore Pike, Media":
        coords = {"y": -75.45188742208904, "x": 39.90995123649049} 
    elif address == "1343 West Baltimore Pike, Media":
        coords = {"y": -75.45188742208904, "x": 39.90995123649049} 
    elif address == "1048 W Baltimore Pike, Media":
        coords = {"y": -75.42613635952054, "x": 39.91144070683103} 
    elif address == "18 Brookview Rd, Rose Valley":
        coords = {"y": -75.38133096441781, "x": 39.88908675461511} 
    else:
        r = requests.get(url, params=params).json()
        matches = r["result"]["addressMatches"]
        
        if len(matches) == 0:
            print(f"No match for: {address}")
            continue

        coords = matches[0]["coordinates"]
    addys.at[i, "Lat"] = coords["y"]
    addys.at[i, "Long"] = coords["x"]

    print(f"✔ {address} → {coords}")

# Writing to JSON file
DEPOT = [-75.38130569631731, 39.91697580591546]
NUM_VEHICLES = 13
vroom = {
    "vehicles": [
        {
            "id": vid,
            "start": DEPOT,
            "end": DEPOT,
            "capacity": [8]
        }
        for vid in range(1, NUM_VEHICLES + 1)
    ],
    "jobs": []
}
for idx, row in addys.iterrows():
    vroom["jobs"].append({
        "id": idx + 1,
        "location": [row["Long"], row["Lat"]],
        "service": 300,
        "delivery": [1]
    })
with open("./data/input/vroom_input1.json", "w") as f:
    json.dump(vroom, f, indent=2)