#!/bin/bash
# =======================================================
# Greener Pastures: Running Script
# Performs the full working pipeline
# =======================================================

# convert addresses to lat/long
chmod +x ./scripts/convert_to_geo.py
python ./scripts/convert_to_geo.py

# run set-up file first 
chmod +x set-up.sh
./set-up.sh

# run the Python fie
python ../scripts/vroom.py

# clean-up
chmod +x clean-up.sh
./clean-up.sh

# convert lat/long back to addreses
chmod +x ./scripts/convert_to_add.py
python ./scripts/convert_to_add.py