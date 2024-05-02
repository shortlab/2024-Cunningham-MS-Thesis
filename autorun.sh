#!/bin/bash
#PBS -N UN_all_power
#PBS -l select=1:ncpus=48:mpiprocs=48
#PBS -l walltime=5:00:00
#PBS -P moose


cd $PBS_O_WORKDIR
source /etc/profile.d/modules.sh
module load use.moose moose-dev


for f in vitanza_UN_p_*.i; do 
    
    base_name=${f%.i}
    id=${base_name#*_}
    mpirun ~/projects/bison/bison-opt -i "$f"

done
