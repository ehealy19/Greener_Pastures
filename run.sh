#!/bin/bash
# =======================================================
# Greener Pastures: Running Script
# =======================================================

# run set-up file first 
chmod +x set-up.sh
./set-up.sh

# run the Python fie
python vroom.py

# clean-up
chmod +x clean-up.sh
./clean-up.sh