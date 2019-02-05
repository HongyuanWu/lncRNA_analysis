#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-s = SWISSPROT BLAST output dir"
        echo "-r = RFAM BLAST output dir"
        echo "-m = MIRBASE BLAST output dir"
        echo "-e = E-Value threshold"
        echo "-n = FEELNc lncRNA nucleotide sequence"
        echo "-p = protein sequence"
        echo "-t = Processor numbers"
        exit 2
fi
while getopts r:s:e:p:n:s:m:t: option
  do
    case "${option}"
      in
      r) RFAMOUTPUTDIR=${OPTARG};;
      e) EVALUE=${OPTARG};;
      p) PROTEIN=${OPTARG};;
      n) NUCLEOTIDE=${OPTARG};;
      s) SWISSPROTOUTDIR=${OPTARG};;
      m) MIRBASEOUTDIR=${OPTARG};;
      t) THREADS=${OPTARG};;
    esac
done

# Swiss prot
if [ ! -d $SWISSPROTOUTDIR ]; then
mkdir -p $SWISSPROTOUTDIR
fi

if [ ! -f $SWISSPROTOUTDIR/uniprot_sprot.fasta ]; then
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz \
-P $SWISSPROTOUTDIR
gunzip $SWISSPROTOUTDIR/uniprot_sprot.fasta.gz
fi

if [ ! -f $SWISSPROTOUTDIR/uniprot_sprot.fasta.phr ]; then
makeblastdb -in $SWISSPROTOUTDIR/uniprot_sprot.fasta -dbtype prot
fi

blastp \
-query $PROTEIN \
-db $SWISSPROTOUTDIR/uniprot_sprot.fasta  \
-max_target_seqs 1 \
-outfmt 6 \
-evalue $EVALUE \
-num_threads $THREADS \
> $SWISSPROTOUTDIR/blastp.outfmt6

#miRBase
if [ ! -d $MIRBASEOUTDIR ]; then
mkdir -p $MIRBASEOUTDIR
fi

if [ ! -f $MIRBASEOUTDIR/hairpin.fa ]; then
wget ftp://mirbase.org/pub/mirbase/CURRENT/hairpin.fa.gz \
-P $MIRBASEOUTDIR
gunzip $MIRBASEOUTDIR/hairpin.fa.gz
fi

if [ ! -f $MIRBASEOUTDIR/hairpin.fa.nhr ]; then
makeblastdb -in $MIRBASEOUTDIR/hairpin.fa -dbtype nucl
fi

blastn \
-db $MIRBASEOUTDIR/hairpin.fa \
-query $NUCLEOTIDE \
-strand plus \
-evalue $EVALUE \
-num_threads $THREADS \
-outfmt 6 \
-num_alignments 1 \
> $MIRBASEOUTDIR/blastn.outfmt6

# RFAM
if [ ! -d $RFAMOUTPUTDIR ]; then
mkdir -p $RFAMOUTPUTDIR
fi

#wget -r ftp://ftp.ebi.ac.uk/pub/databases/Rfam/CURRENT/fasta_files/ -P $RFAMOUTPUTDIR


if [ ! -f $RFAMOUTPUTDIR/rfam_no_lncrna.fasta.hnr ]; then
makeblastdb -in $RFAMOUTPUTDIR/rfam_no_lncrna.fasta -dbtype nucl
fi

blastn \
-db $RFAMOUTPUTDIR/rfam_no_lncrna.fasta \
-query $NUCLEOTIDE \
-strand plus \
-evalue $EVALUE \
-num_threads $THREADS \
-outfmt 6 \
-num_alignments 1 \
> $RFAMOUTPUTDIR/blastn.outfmt6
