
#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-f = lncRNA fasta sequence"
        echo "-o = Output directory"
        exit 2
fi
while getopts f:o: option
  do
    case "${option}"
      in
      f) LNCRNASEQ=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR
fi

#get mouse CPAT data if needed
if [ ! -f $OUTDIR/Mouse_logitModel.RData ]; then
wget https://ayera.dl.sourceforge.net/project/rna-cpat/v1.2.2/prebuilt_model/Mouse_logitModel.RData \
-P $OUTDIR
fi

if [ ! -f $OUTDIR/Mouse_Hexamer.tsv ]; then
wget https://ayera.dl.sourceforge.net/project/rna-cpat/v1.2.2/prebuilt_model/Mouse_Hexamer.tsv \
-P $OUTDIR
fi

cpat.py \
-g $LNCRNASEQ \
-o $OUTDIR/CPAT.analysis.txt \
-x $OUTDIR/Mouse_Hexamer.tsv \
-d $OUTDIR/Mouse_logitModel.RData
