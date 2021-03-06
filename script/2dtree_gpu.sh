#!/bin/bash
#PBS -l walltime=02:00:00
#PBS -q dssc_gpu
#PBS -l nodes=2:ppn=48

cd $PBS_O_WORKDIR
if [ $1 == "--clean" ]; then
  cd ../output
  rm output*
else
  module load openmpi-4.1.1+gnu-9.3.0
  make

  export OMP_PLACES=sockets
  export OMP_PROC_BIND=true

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' 'MPI,' 'OMP,' 'Send MSG,' 'OMP time,' 'Array,' 'Recv msg,' 'total time'  > ../output/time_gpu2.csv

  for i in  {1..16}
  do
    for j in {1..30}
    do
      export OMP_NUM_THREADS=${j}
      mpirun -np ${i} --map-by socket --mca btl ^openib kdtree.x 10000000 
      cat time >> ../output/time_gpu2.csv
    done
  done
fi
 
rm time
exit
