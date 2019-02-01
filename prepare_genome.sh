#!/usr/bin/env bash
while getopts v:o: option
  do
    case "${option}"
      in
      v) ENSEMBLV=${OPTARG};;
      o) GENOMEDIR=${OPTARG};;
    esac
done

mkdir -p $GENOMEDIR

# get the ENSEMBL CHOK1 reference genome and GTF file
wget ftp://ftp.ensembl.org/pub/release-$ENSEMBLV/fasta/cricetulus_griseus_crigri/dna/Cricetulus_griseus_crigri.CriGri_1.0.dna.toplevel.fa.gz \
-P $GENOMEDIR
wget ftp://ftp.ensembl.org/pub/release-$ENSEMBLV/gtf/cricetulus_griseus_crigri/Cricetulus_griseus_crigri.CriGri_1.0.94.gtf.gz \
-P $GENOMEDIR

gunzip $GENOMEDIR/*.gz

# retain only scaffold ID in the fasta header
raw_reference="Cricetulus_griseus_crigri.CriGri_1.0.dna.toplevel.fa"
name="ensembl_chok1_genome"
sed '/^>/ s/ .*//' $GENOMEDIR/$raw_reference > $GENOMEDIR/$name.fa
mv $GENOMEDIR/Cricetulus_griseus_crigri.CriGri_1.0.94.gtf $GENOMEDIR/$name.gtf
rm $GENOMEDIR/$raw_reference

# get NCBI CHOK1 Entrez annotations
wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz \
-P $GENOMEDIR

gunzip $GENOMEDIR/*.gz
grep '^\<10029\>' $GENOMEDIR/gene_info > $GENOMEDIR/chok1_ncbi_ids.txt
rm $GENOMEDIR/gene_info
