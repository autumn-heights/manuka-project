#!/bin/bash -l
#SBATCH --job-name=GE-conda
#SBATCH --partition=week
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --gres=gpu:1
#SBATCH --export=ALL

start_time=$( date )

echo "Running generate_crops.slurm at $start_time"

# To configure GNU Environment for Mothur
module load Anaconda3/2020.11
# module load data_loader.py

# activate the Python environment for the unit CITS5508
conda activate bee-detection

# list the environment loaded by the modules.
# Can remove the two lines below if you want.
# module list
# conda list

# Note: SLURM_JOBID is a unique number for every job.
# These are generic variables.

# Below is the Python file that would be run
SCRIPT=code/cropFramesAndLabels.py

SCRATCH=$MYSCRATCH/run_conda/$SLURM_JOBID

###############################################
# Creates a unique directory in the SCRATCH directory for this job to run in,
# And subdirs for this specific job.
if [ ! -d $SCRATCH ]; then 
    mkdir -p $SCRATCH 
fi 
echo Working SCRATCH directory is $SCRATCH


MYINDEX="4"

cat generate_crops_${MYINDEX}.slurm | echo

#############################################
# now run our Python script file

mkdir -p ${SCRATCH}/frames/
mkdir -p ${SCRATCH}/edited_frames/
mkdir -p  ${MYGROUP}/videos_done/

cd ${MYGROUP}/videos_${MYINDEX}/ 

for MYRECORDING in *;
do

    cd ${MYGROUP}/videos_${MYINDEX}/${MYRECORDING}


    for MYFILE in *;
    do

#        rm -r -f ${MYGROUP}/crops/${MYFILE%%.*}
        mkdir -p ${MYGROUP}/crops_${MYINDEX}/${MYRECORDING}/${MYFILE%%.*}
        mkdir -p ${MYGROUP}/crop_lists/${MYRECORDING}/

        echo ${MYFILE%%.*}
        python3 ~/code/cropVideo.py ${MYFILE} ${MYGROUP}/crops_${MYINDEX}/${MYRECORDING}/${MYFILE%%.*}  ${MYGROUP}/crop_lists/${MYRECORDING}/${MYFILE%%.*}_crops.txt

    done

    cd ${MYGROUP}/videos_${MYINDEX}/ 

#    mv ${MYRECORDING} ${MYGROUP}/videos_done/

done

#############################################
# Now move the output produced by our Python script from
# the /scratch... directory to my home directory.
#cd $HOME
#mv ${SCRATCH} ${RESULTS}

#echo "mv ${SCRATCH} ${RESULTS}"
#echo "Please see the ${RESULTS} directory for any output"

echo
echo "Job started  at $start_time"
echo "Job finished at `date`"


