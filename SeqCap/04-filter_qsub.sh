#!/bin/bash
#set -xe
set -xeuo pipefail

usage="USAGE:
bash 04-filter_qsub.sh <sample_list.txt> <genome.fa> <CalculateHsMetrics_bait_reference.bed> <CalculateHsMetrics_specific_target_reference.bed>
for example:
bash \
/home/springer/pcrisp/gitrepos/springerlab_methylation/SeqCap/04-filter_qsub.sh \
single_sample.txt \
/home/springer/pcrisp/ws/refseqs/maize/Zea_mays.AGPv4.dna.toplevel.fa \
/home/springer/pcrisp/ws/refseqs/maize/Seqcap_ultimate_annotation_files/SeqCapEpi2_v4_capture_space_sorted.interval_list \
/home/springer/pcrisp/ws/refseqs/maize/Seqcap_ultimate_annotation_files/SeqCapEpi2_v4_specific_targets_no_NA_sorted.interval_list
"

#define stepo in the pipeline - should be the same name as the script
step=04-filter

######### Setup ################
sample_list=$1
genome_reference=$2
CalculateHsMetrics_bait_reference=$3
CalculateHsMetrics_specific_target_reference=$4

if [ "$#" -lt "4" ]
then
echo $usage
exit -1
else
echo "Submitting samples listed in '$sample_list' for trimming"
cat $sample_list
echo genome reference is $genome_reference
echo CalculateHsMetrics_reference is $CalculateHsMetrics_bait_reference $CalculateHsMetrics_specific_target_reference
fi

#number of samples
number_of_samples=`wc -l $sample_list | awk '{print $1}'`
if [[ "$number_of_samples" -eq 1 ]]
then
qsub_t=1
else
qsub_t="1-${number_of_samples}"
fi
echo "argument to be passed to qsub -t is '$qsub_t'"

#find script to run, makes it file system agnostic
if
[[ $OSTYPE == darwin* ]]
then
readlink=$(which greadlink)
scriptdir="$(dirname $($readlink -f $0))"
else
scriptdir="$(dirname $(readlink -f $0))"
fi

########## Run #################

#make log and analysis folders
#make logs folder if it doesnt exist yet
mkdir -p logs

timestamp=$(date +%Y%m%d-%H%M%S)

#make analysis dir if it doesnt exist yet
analysis_dir=analysis
mkdir -p $analysis_dir

#make trimmgalore logs folder, timestamped
log_folder=logs/${timestamp}_${step}
mkdir $log_folder

#script path and cat a record of what was run
script_to_qsub=${scriptdir}/${step}.sh
cat $script_to_qsub > ${log_folder}/script.log
cat $0 > ${log_folder}/qsub_runner.log

#submit qsub and pass args
#-o and -e pass the file locations for std out/error
#-v additional variables to pass to the qsub script including the PBS_array list and the dir structures
qsub -t $qsub_t \
-o ${log_folder}/${step}_o \
-e ${log_folder}/${step}_e \
-v LIST=${sample_list},genome_reference=$genome_reference,CalculateHsMetrics_bait_reference=$CalculateHsMetrics_bait_reference,CalculateHsMetrics_specific_target_reference=$CalculateHsMetrics_specific_target_reference \
$script_to_qsub
