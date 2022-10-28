#!/bin/bash

# This script takes the POSCAR of a disordered surface as output and returns a POSCAR ordered according to the z-dimension, with a certain number of surface layers in the bulk fixed (e.g. with selective coordinates, free to move T T T

# Remember that to run the script you need to execute the command:
# ./ordtor.sh n_free (n_free: number of bulk layer)
# on the terminal
# Besides, if the command does not work, you must enable its permission to execute
# chmod +x ordtor.sh
#

# Below some tips on how to sctructure the script

# INPUT $1: Number of bulk layers, i.e. the number of layers whose coordinates need to be fixed (F F F)

# PRINT THE NUMBER OF ELEMENTS #

ne1=$(awk '{print NF}' POSCAR_input | head -n 6 | tail -n 1) 
# awk '{print NF}' returns the number of columns per line; head -n 6 takes just the first 6 columns ; tail prints only the last one of these six column. For instance, head -n 6 POSCAR_input would print the first 6 lines of the file POSCAR_input, while tail -n 1 POSCAR_input would print the last one. The | command concatenates a list of commands.

echo "  Number of elements found in the POSCAR: $ne1" 
# echo the section among "" on the terminal. Try it on a terminal (e.g. echo "Hello world"). Since the 6th line of a POSCAR gives the number of elements, we are now printing the number of elements.

# PRINT THE NUMBER OF ATOMS #

for ((i=1;i<=$ne1;i++)) # This is a for cycle among all the elements
	do
    		m=$(sed -n "7p" POSCAR_input | awk -v i="$i" '{print $i}') 
# On the 7th line of POSCAR we have the number of atoms per elements. So we are saving this information in the vector Natom[$i]
    		Natom[$i]="$m"
		echo "  Number of atoms of species $i: ${Natom[$i]}"
	done

# TOTAL ATOMS #

n=8 # Since the atomic coordinates start from line 8. 
for ((i=1;i<=$ne1;i++)) # Cycle amon all elements
	do
		(( n = $n + ${Natom[$i]} )) # Add to the number n the number of atoms per species
		linatom[$i]="$n"
		echo "The last line of coordinates for species $i is ${linatom[$i]}"
	
	done

# PRINT ORDERED POSCAR

head -n 7 POSCAR_input >> poscar-ordered 
# Insert in the ordered POSCAR the first 7 lines from input POSCAR (lattice vectors, elements)
echo "Selective" >> poscar-ordered # 
# Print the line which is needed for selective dynamics
head -n 8 POSCAR_input | tail -n 1 >> poscar-ordered # Insert the line with Direct

for ((i=1;i<=$ne1;i++)) # Cycle among all elements
        do
		echo "  Ordering atoms by atoms species and freeing the upper half"
                head -n ${linatom[$i]} POSCAR_input | tail -n ${Natom[$i]} | sort -k 3 >> poscar-ordered
		# the command sort -k 3 sort the atoms included in the head -n ${linatom[$i]} POSCAR | tail -n ${Natom[$i]} by their z-axis
        done

echo "  "
(( ntot = 1 + $n )) 

for ((n=10;n<=$ntot;n++)) 
# Cycle among all the atomic coordinates. Three F are addeded respectively on the 4th, 5th, and 6th (i=4,5,6) to fix all the coordinates
	do
		awk -v i=4 'NR==n{$i=b1}1' n=$n b1="F" poscar-ordered > poscar-ord && mv poscar-ord poscar-ordered
		awk -v i=5 'NR==n{$i=b1}1' n=$n b1="F" poscar-ordered > poscar-ord && mv poscar-ord poscar-ordered
		awk -v i=6 'NR==n{$i=b1}1' n=$n b1="F" poscar-ordered > poscar-ord && mv poscar-ord poscar-ordered
	done

for ((i=1;i<=$ne1;i++))
# Cycle among the atomic species. Now it free half of the cell (2 layers). Try to modify it, so that you only free (n - N) the surface layers, where n is the total number of layers, 4 in this case, and N is input 1, i.e. the number of layers you want as bulk? 
       	do
                	((nfree = ${Natom[$i]}/2))
                	((linfin = ${linatom[$i]} + 1))
			((linin = $linfin - $nfree + 1))
			sed -i "$linin,$linfin s/F/T/g" poscar-ordered
       done


mv poscar-ordered POSCAR
echo "POSCAR has been ordered successfully. Check it in the folder under the name POSCAR"

