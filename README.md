# Greener Pastures: Reducing Small-Business Emissions Through Route Optimization

## Problem Definition

One of the biggest contributors to climate change is the excessive emissions caused by transportation. For this project, I aim to tackle the problem of emissions in a small real-world example. This entails making a flower shop ‘greener’ by attempting to optimize delivery routes for the local small business. The goal will be to determine if utilizing route optimization algorithms is a viable solution to unnecessary emissions from inefficient delivery routes. While this project is not computationally heavy, the importance is focusing on the real world aspect of and the scalability to other similar small and medium sized businesses, which together could make a measured difference in emissions from the delivery portion of the transportation sector. 

## Tools:
- CodeCarbon
- TheVroomProject
- MIT's CarbonCounter


## Usage
1. git clone <this-repo>

2. Download and unzip the OSRM data from Google Drive into Green_Pastures/data/osrm/
  https://drive.google.com/drive/folders/1nMnt-cxcbrkVfoQmea7lhhsgWUuwgExL?usp=drive_link

3. Add you data file to data/input in the form of .xlsx with columns Address and City (ie. Address = 370 Lancaster Ave City = Haverford)

4. Either name you data file only_addresses_final.xlsx OR
     a. Open the convert_to_geo.py file and change addys = pd.read_excel('./data/input/only_addresses_final.xlsx') to ('./data/input/**your_file_name_here**.xlsx')
     b. Open the conver_to_add.py and change addys = pd.read_excel('./data/input/only_addresses_final.xlsx') to ('./data/input/**your_file_name_here**.xlsx') 

5. chmod +x ./run.sh

6. ./run.sh
