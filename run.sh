#!/bin/bash
# =======================================================
# Greener Pastures: Running Script
# =======================================================

# convert addresses to lat/long
chmod +x convert_to_geo.py
python convert_to_geo.py

# run set-up file first 
chmod +x set-up.sh
./set-up.sh

# run the Python fie
python vroom.py

# clean-up
chmod +x clean-up.sh
./clean-up.sh

# convert lat/long back to addreses
chmod +x convert_to_add.py
python convert_to_add.py