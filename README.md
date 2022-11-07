# Optimal path optimisation in a given wind profile
# Alongside a battery-aware model

**Sub-system 4:** Alexandre Berkovic

The scripts in MATLAB require the OptimiZation Toolbox and Global Optimization Toolbox. 

The scripts in Python (Jupyter Notebooks) require pandas, numpy, matplotlib.pyplot and scipy

The execution time is for a 2.4 GHz Dual-Core Intel Core i5 (6267U) running MacOS 10.15.4. 

These scripts optimise the torque to weight ratio of brushless DC motor's stator based on 5 variables: number of rotor poles, number of stator teeth, number of coil windings, stator radius and stator thickness.

## Files:

### MATLAB:
- main.m: script to output the optimal path in a generated wind field for the different functions, constraints and varaibles defined
  - execution time : 3.04 seconds
- nlcon.m: script for the different linear and non-linear constraints of the optimisation model
- TimeFromPath.m: script where the main objective function is defined and which actually calculates the line integral along the path to determine the time steps between each points
  - execution time : 1.08 seconds
- WaypointToPath.m: file to interpolate the curve based on the discrete waypoints to generate a continuous path
  - execution time : 0.28 seconds
- WindField.m: helper function to generate a random wind field

### Python:
- Data analysis SOC.ipynb: script that discretises the discharge curves from the specs of the battery 
  - execution time : 0.08 seconds
- Data analysis SOC.ipynb: script to determine the weights of the polynomial for the function C(V)
- execution time : 0.12 seconds