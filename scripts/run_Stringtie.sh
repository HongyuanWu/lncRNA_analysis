
#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-s = sample ID"
        echo "-i = input bam directory"
        echo "-p = num processors"
        echo "-g = GTF file"
        echo "-o = path for output BAMs"
        exit 2
fi
while getopts s:i:p:g:o: option
  do
    case "${option}"
      in
      s) SAMPLEID=${OPTARG};;
      i) INDIR=${OPTARG};;
      p) THREADS=${OPTARG};;
      g) GTF=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR
fi

stringtie \
-p $THREADS \
-G $GTF \
-o $OUTDIR/"$SAMPLEID".gtf \
$INDIR/"$SAMPLEID".bam
