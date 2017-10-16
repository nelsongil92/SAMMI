#!/bin/sh

# DEFINE INPUT AND OUTPUT FILES
aln_file=$1
seq_identifier=$2
PATH_ALN=/usr/local/bin

if [ $# -ne 2 ]; then
    echo Usage: $0 [aln_file] [seq_identifier] 
    exit
fi

seqsonly_file=$aln_file.onlyseqs.tmp
seqsonly_file_colshuffle=$aln_file.onlyseqs.colshuffle.tmp

mi_outfile=$aln_file.mi.out
mi_outfile_colshuffle=$aln_file.mi.colshuffle.out

midiff_outfile=$aln_file.midiff.out

# RETRIEVE SEQUENCES, SEQUENCE COUNT, AND ALIGNMENT LENGTH FROM FASTA FILES
perl aln_fasta_seqs_only_no_gaps_query.pl $aln_file $seq_identifier > $seqsonly_file

# to shuffle columns
perl aln_fasta_seqs_only_no_gaps_query_colshuffle_v2.pl $aln_file $seq_identifier > $seqsonly_file_colshuffle

seqcount=`cat $aln_file | grep -c \>`
seqlength=`perl aln_fasta_return_length.pl $aln_file $seq_identifier`


$PATH_ALN/aln_mi_calc_exe $seqsonly_file $seqcount $seqlength > $mi_outfile
$PATH_ALN/aln_mi_calc_exe $seqsonly_file_colshuffle $seqcount $seqlength > $mi_outfile_colshuffle


rm -f $seqsonly_file
rm -f $seqsonly_file_colshuffle

# CALCULATE MI-SCORE (MEAN OF TOP 5% OF MI-DIFF VALUES)
perl aln_mi_colpair_diff.pl $mi_outfile $mi_outfile_colshuffle > $midiff_outfile # calculates MI-Diff values

ndata=`cat $midiff_outfile | wc -l`
ntop5pct=`echo $ndata | awk '{printf "%d", $1*0.05}'`
avg_top5pct=`cat $midiff_outfile | awk '{print $5}' | sort -g | tail -$ntop5pct | awk '{sum+=$1}END{print sum/NR}'`
echo "MI-Score for $aln_file is $avg_top5pct"
