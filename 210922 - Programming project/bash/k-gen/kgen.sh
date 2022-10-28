#!/bin/bash

# This script takes as input the POSCAR of a surface and generated the k-points mesh according to the Monkhorst-Pack.
# Use it by writing in the terminal kgen.sh
# If it does not work, there may be a permission problems, so grant the script execution permission
# Type on the terminal 
# chmod +x kgen.sg

# DEFINITION OF ROUND FUNCTION (USED TO PROPERLY ROUND THE NUMBER OF KPOINTS, SEE LAST SECTION

round()
{
echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
};

# GET THE COORDINATES VECTORS

ax=$(head -n 3 POSCAR_input | tail -n 1 | awk '{print $1}') # Get ax
ay=$(head -n 3 POSCAR_input | tail -n 1 | awk '{print $2}') # Get ay
az=$(head -n 3 POSCAR_input | tail -n 1 | awk '{print $3}') # Get az

# Now extend the previous lines to the b and c lattive vectors

echo "The lattice vectors are:"

printf "%-4s %-10s %-10s %-10s\n" "a" "$ax" "$ay" "$az"
# printf "%-4s %-10s %-10s %-10s\n" "b" "$bx" "$by" "$bz" # Remove the # symbol when you have properly defined bx, by, bz
# printf "%-4s %-10s %-10s %-10s\n" "c" "$cx" "$cy" "$cz" # Remove the # symbol when you have properly defined cx, cy, cz

# SECTION TO BE DEFINED

# Understand why the following section is needed and then uncomment it (remove the #)

# ax=${ax#+} ; ax=${ax#-}
# ay=${ay#+} ; ay=${ay#-}
# az=${az#+} ; az=${az#-}

# bx=${bx#+} ; bx=${bx#-}
# by=${by#+} ; by=${by#-}
# bz=${bz#+} ; bz=${bz#-}

# cx=${cx#+} ; cx=${cx#-}
# cy=${cy#+} ; cy=${cy#-}
# cz=${cz#+} ; cz=${cz#-}

# Get the intensity of the three lattice vectors

a2=$(echo "scale=10; $ax * $ax + $ay * $ay + $az * $az" | bc)
# Add equivalent lines for b2 and c2

a=$(echo "scale=6; sqrt($a2)" | bc)
# Add equivalent lines for b and c

# Apply the rules of thumb:  

kx=$(echo $(round 30/$ax 0))
# ky=$(echo "scale=1; 30/$by " | bc) Uncomment when you have properly defined the by variable
kz=1 # For a surface, the number of k-points along the z-direction must always be one

echo "The lattice vector magnitude is (a,b,c):
$a " # Add $b and $c as well when you have properly defined them

echo " "

echo "The k-points sampling for a metal (k*a = 30) are (kx, ky, kz):
$kx To be defined $kz" # Add $ky when you have properly defined it

# PRINT THE KPOINTS FILE WITH kx, ky, AND kz, AS CALCULATED BEFORE

cat >KPOINTS<<!
K-Points
 0
Monkhorst-Pack
 $kx To be defined $kz
 0  0  0
!
