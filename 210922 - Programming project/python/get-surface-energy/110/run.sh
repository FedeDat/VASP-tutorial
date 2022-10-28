#!/bin/bash
### SGE Parameters #######################
#$ -S /bin/bash
#$ -N InPd2-110-surf
#$ -cwd
#$ -masterq c12m48ib.q
#$ -pe c12m48ib_mpi 12
#$ -m ae
#$ -M fdattila@iciq.es
#$ -o o_$JOB_NAME.$JOB_ID
#$ -e e_$JOB_NAME.$JOB_ID
### Load Environment Variables ###########
. /etc/profile.d/modules.sh
module load vasp/5.4.4
### Run Job ##############################
export OMP_NUM_THREADS=1
echo $PWD >> o_$JOB_NAME.$JOB_ID
echo $TMP >> o_$JOB_NAME.$JOB_ID
~/bin/savecalc ; mpirun -np $NSLOTS vasp_std ; rm -f CHG
