#location of required codes
DRIVER_LOC=/PATH/TO/ELECTRIC.py
TINKER_LOC=/PATH/TO/DYNAMIC.X

#remove old files
if [ -d work ]; then
  rm -r work
fi

#create work directory
cp -r data work
cd work

#set the number of threads
export OMP_NUM_THREADS=2

#launch Tinker using EWALD
#${TINKER_LOC} 1l2y -k tinker.key 100 1.0 2 3 300.00

#launch MDI enabled Tinker
${TINKER_LOC} 1l2y -k noewald.key -mdi "-role ENGINE -name NO_EWALD -method TCP -port 8022 -hostname localhost"  10 1.0 0.001999 2 300.00 > no_ewald.log &


#launch driver
python ${DRIVER_LOC} -snap 1l2y_npt.arc -probes "78 93 94" -mdi "-role DRIVER -name driver -method TCP -port 8022" --byres 1l2y_solvated.pdb --equil 160 --stride 2 &

wait
