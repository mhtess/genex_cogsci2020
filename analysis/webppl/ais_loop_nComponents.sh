#!/bin/bash

modelTypes=("independent")
conditions=("pedagogical" "2pedagogical" "3pedagogical" "generic" "accidental" "2accidental" "3accidental" "4pedagogical" "4accidental" "pedageneric")
n_components=(1 2 3)
job_directory=$PWD/.job

for modelType in ${modelTypes[@]}; do
    for condition in ${conditions[@]}; do
	for n_c in ${n_components[@]}; do

	    job_file="${job_directory}/${condition}_${modelType}_${n_c}.job"

	echo "#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --time=10:00:00
#SBATCH --mem=6G
#SBATCH --cpus-per-task=1
#SBATCH -p cpl
#SBATCH -o .out/log_${condition}_${modelType}_${n_c}_%j.out # Standard output
#SBATCH -e .err/log_${condition}_${modelType}_${n_c}_%j.err # Standard error
#SBATCH --mail-user=tessler@mit.edu # -- use this to send an automated email when:
#SBATCH --mail-type=end            # -- your job completes successfully
#SBATCH --mail-type=fail           # -- or if your job fails

singularity exec -B  /om2/user/tessler/projects/genex_cogsci2020/analysis/webppl/ \
/om2/user/jennhu/singularity_images/webppl0.9.15-conda.sif \
 webppl mixture_of_betas-om.wppl --require webppl-csv ${modelType} ${condition} ${n_c} \$SLURM_ARRAY_TASK_ID" > $job_file
	
	sbatch --array=1-1:1 $job_file
	done
    done
done

