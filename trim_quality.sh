SAMPLEID=$1
INDIR=$2
OUTDIR=$3

mkdir -p $OUTDIR
mkdir -p $OUTDIR/paired $OUTDIR/unpaired

# quality preprocessing; minimum read length = 36nt
java -jar ~/bin/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
                     -threads 32 \
                     $INDIR/"$SAMPLEID"_R1.fastq.gz $INDIR/"$SAMPLEID"_R2.fastq.gz \
                     $OUTDIR/paired/"$SAMPLEID"_R1.fastq.gz $OUTDIR/unpaired/"$SAMPLEID"_R1.fastq.gz \
                     $OUTDIR/paired/"$SAMPLEID"_R2.fastq.gz $OUTDIR/unpaired/"$SAMPLEID"_R2.fastq.gz \
                     SLIDINGWINDOW:4:20 \
                     MINLEN:36 \
                     -trimlog $OUTDIR/"$SAMPLEID".trimmomatic.log
                     
# END