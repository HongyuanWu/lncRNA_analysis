genome_dir="reference_genome"

STAR --runThreadN 16\
     --runMode genomeGenerate \
     --sjdbOverhang 124\
     --genomeChrBinNbits 16 \
     --genomeDir $genome_dir/star_index \
     --genomeFastaFiles $genome_dir/ensembl_chok1_genome.fa \
     --sjdbGTFfile $genome_dir/ensembl_chok1_genome.gtf