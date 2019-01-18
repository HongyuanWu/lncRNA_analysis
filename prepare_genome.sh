mkdir -p reference_genome
genome_dir="reference_genome"

# get the ENSEMBL CHOK1 reference genome and GTF file
wget ftp://ftp.ensembl.org/pub/release-94/fasta/cricetulus_griseus_crigri/dna/Cricetulus_griseus_crigri.CriGri_1.0.dna.toplevel.fa.gz -P $genome_dir
wget ftp://ftp.ensembl.org/pub/release-94/gtf/cricetulus_griseus_crigri/Cricetulus_griseus_crigri.CriGri_1.0.94.gtf.gz -P $genome_dir 
gunzip $genome_dir/*.gz

# retain only scaffold ID in the fasta header
raw_reference="Cricetulus_griseus_crigri.CriGri_1.0.dna.toplevel.fa"
name="ensembl_chok1_genome"
sed '/^>/ s/ .*//' $genome_dir/$raw_reference > $genome_dir/$name.fa
mv $genome_dir/Cricetulus_griseus_crigri.CriGri_1.0.94.gtf $genome_dir/$name.gtf 
rm $genome_dir/$raw_reference

# get NCBI CHOK1 Entrez annotations
wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz -P $genome_dir
gunzip $genome_dir/*.gz
grep '^\<10029\>' $genome_dir/gene_info > $genome_dir/chok1_ncbi_ids.txt
rm $genome_dir/gene_info

# END