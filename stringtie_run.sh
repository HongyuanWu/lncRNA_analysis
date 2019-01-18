SAMPLEID=$1
mapped_dir="mapped"
gtf_file="reference_genome/ensembl_chok1.gtf"

mkdir -p stringtie_output
output_dir=stringtie_output
stringtie -p 32 -G $gtf_file -o $output_dir/"$SAMPLEID".gtf $mapped_dir/"$SAMPLEID".bam

# END