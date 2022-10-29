#!/bin/bash

# This script takes the CONTCAR of an optimized surface and insert the molecule on top of one of the surface atom of the crystalline facet

# Remember that to run the script you need to execute the command:
# ./addmolt.sh N (N = label of the active sites where you want to adsorb the molecule)
# on the terminal
# Besides, if the command does not work, you must enable its permission to execute
# chmod +x ordtor.sh
#

# INPUT
# S1

# Structure of the files

# You need to derive from the two CONTCAR how many elements and atoms you have in the systems.

# Later you will have to adjust the line of elements and number of atoms, so that you are properly accounting for the insterted molecules
# e.g. In Pd -> In Pd C O
# e.g. 12 36 -> 12 36 1 1 

# To adjust those lines, remember the awk -v i="$pos" 'NR==n{$i=b1}1' n=1 b1=${var1[$i]} utility
# b1 is the number of atom of species which you want to add
# n=1 means that you are modifying the first line

# Finally, you need to use the following command to extract the x,y,z of each of the atom of the molecules
# sed -n "$pos_ads p" $2 | awk '{print $1}' | awk '{s+=$0}END{printf("%.10f\n", s)}'
# where $pos_ads stands for each line of coordinates.
# and use the bc utility to sum these three coordinates with the ones of the active sites (ax_x, as_y, as_z), which you can calculated from

# ((line_as = 9 + $3))

# as_x=$(sed -n "$line_as p" $1 | awk '{print $1}' | awk '{s+=$0}END{printf("%.2f\n", s)}')
# as_y=$(sed -n "$line_as p" $1 | awk '{print $2}' | awk '{s+=$0}END{printf("%.2f\n", s)}')
# as_z=$(sed -n "$line_as p" $1 | awk '{print $3}' | awk '{s+=$0}END{printf("%.2f\n", s)}')
