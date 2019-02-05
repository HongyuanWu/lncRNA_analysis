#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-s = sample ID"
        echo "-m = Mapping directory"
        echo "-g = Stringtie GTF"
        echo "-o = path for output BAMs"
        exit 2
fi
while getopts s:m:g:o: option
  do
    case "${option}"
      in
      s) SAMPLEID=${OPTARG};;
      g) STRGTF=${OPTARG};;
      m) MAPDIR=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

echo $OUTDIR

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR
fi

htseq-count -r pos -f bam -i gene_id -s reverse $MAPDIR/"$SAMPLEID"Aligned.sortedByCoord.out.bam $STRGTF > "$OUTDIR"/"$SAMPLEID".counts
# END
