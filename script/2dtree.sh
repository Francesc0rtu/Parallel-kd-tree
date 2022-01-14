#!/bin/bash
#PBS -l walltime=02:00:00
#PBS -q dssc
#PBS -l nodes=1:ppn=24

cd $PBS_O_WORKDIR
cd ../code
module load openmpi-4.1.1+gnu-9.3.0
make
cp kdtree.x ../output/kdtree.x
cd ../output
export    OMP_NUM_THREADS=12
export 		OMP_PLACES=cores
export 		OMP_PROC_BIND=close
export		MV2_ENABLE_AFFINITY=0

mpirun -np 2 --map-by socket kdtree.x 10000 > output

make clean
git add output time
git commit -m "new output from orfeo"
git push

exit
