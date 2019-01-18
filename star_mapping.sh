SAMPLEID=$1
DATADIR=$2

genome_dir="reference_genome"

mkdir -p mapping

outdir="mapping"
$star_directory/STAR \
       --runThreadN 32 \
       --readFilesIn $DATADIR/"$SAMPLEID"_1_sequence.txt.gz $preprocessed_data_directory/"$SAMPLEID"_2_sequence.txt.gz \
       --genomeDir $genome_dir/star_index \
       --readFilesCommand gunzip -c \
       --outFileNamePrefix $outdir/"$SAMPLEID" \
       --outSAMtype BAM SortedByCoordinate \
       --twopassMode Basic 

# create a BAM index
samtools index $outdir/"SAMPLEID"Aligned.sortedByCoord.out.bam

