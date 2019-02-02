#!/usr/bin/env bash


#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-f = lncRNA fasta sequence"
        echo "-p = Processor numbers"
        echo "-e = E-Value threshold"
        echo "-t = protein protein sequences"
        echo "-o = Output directory"
        exit 2
fi
while getopts t:e:p:o: option
  do
    case "${option}"
      in
      p) THREADS=${OPTARG};;
      e) EVALUE=${OPTARG};;
      t) PROTEIN=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR
fi

if [ ! -f $OUTDIR/Pfam-A.hmm ]; then
wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz \
-P $OUTDIR
gunzip $OUTDIR/Pfam-A.hmm.gz
fi

hmmpress $OUTDIR/Pfam-A.hmm
hmmscan \
--cpu $THREADS \
-E $EVALUE \
--domtblout $OUTDIR/pfam.domtblout \
$OUTDIR/Pfam-A.hmm \
$PROTEINS

# make a list of ids for filtering from PFAM table
awk '{print $4}' $OUTDIR/pfam.domtblout | \
grep -E 'ENS|MSTRG' | uniq | sed 's/.p.*//g' > $OUTDIR/pfam_domain_transcripts
