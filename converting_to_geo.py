import requests
import pandas as pd

# Read in the addresses file
addys = pd.read_excel('./data/input/only_addresses.xlsx')
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
    r = requests.get(url, params=params).json()
    matches = r["result"]["addressMatches"]

    if len(matches) == 0:
        print(f"No match for: {address}")
        continue

    coords = matches[0]["coordinates"]
    addys.at[i, "Lat"] = coords["y"]
    addys.at[i, "Long"] = coords["x"]

    print(f"✔ {address} → {coords}")