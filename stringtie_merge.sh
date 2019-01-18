export mapped_dir=mapped
export gtf_file=reference_genome/ensembl_chok1.gtf
export assembled_transcripts_dir=stringtie_output

readlink -f $assembled_transcripts_dir/*.gtf >> $assembled_transcripts_dir/mergelist.txt 

stringtie --merge $assembled_transcripts_dir/mergelist.txt -o $assembled_transcripts_dir/stringtie.gtf -f 0.1  -c 10 

gffcompare -o $assembled_transcripts_dir/gffcompare -r $gtf_file $assembled_transcripts_dir/stringtie.gtf -N -M

## prepare GTF for rmats
# append ensembl gene ids to MSTRG GTF
perl mstrg_prep.pl $assembled_transcripts_dir/stringtie_merged.gtf > $assembled_transcripts_dir/stringtie_merged.appended.gtf

# find instances where stringtie has asemebled transcripts from 2 or more overlaping loci and created a new "gene". 
# The final field of the GTF file will contain an MSTRG ID not an ENS ID 
grep 'MSTRG.*|ENSCGRG.*|ENSC.*' $assembled_transcripts_dir/stringtie_merged.appended.gtf | grep '\<transcript\>' | awk '$NF ~/MSTRG/ {print $NF}'  > $assembled_transcripts_dir/removed.overlapped.MSTRG.transcripts

# remove assembled transcripts spanning two or more sense overlapping genes transcripts
grep -v -F -f $assembled_transcripts_dir/removed.overlapped.MSTRG.transcripts $assembled_transcripts_dir/stringtie_merged.appended.gtf > $assembled_transcripts_dir/rmats_stringtie.gtf

#END