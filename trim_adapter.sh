SAMPLEID=$1
INDIR=$2
OUTDIR=$3
 
# trim adapter using cutadapt
cutadapt  -A AGATCGGAAGAGC  -a AGATCGGAAGAGC \
          -o $OUTDIR/"$SAMPLEID"_R1.fastq.gz -p $OUTDIR/"$SAMPLEID"_R2.fastq.gz \
          $INDIR/"$SAMPLEID"_R1.fastq.gz $INDIR/"$SAMPLEID"_R2.fastq.gz 

# END