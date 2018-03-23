#/bin/bash

db_dir="/home/mmeier/local-appz/BLAST/"

echo "What is the root directory in which your FASTA files are located?"
read -e rootdir
echo "What directory to store the results?"
read -e outdir

files=$(find $rootdir -name "*.fasta" | grep -E 'T|C')
echo "Found these files:"
for i in $files; do echo $i; done

echo "What output format would you like the blast results? 0 for pairwise, 7 for tabular with commented lines, 8 for text ASN.1"
read format

echo "What blast database would you like to query? Default is 16SMicrobial; comment out line in script to change."
# read database
database=16SMicrobial

for i in $files
do

### CODE ###

# Get name
fname=${i%.fasta}
fname=${fname##*/}

echo $i
echo $rootdir/$fname
echo $format

# Run BLASTN #

nohup /utils/appz/blast/ncbi-blast-2.2.30+/bin/blastn -num_threads 3 -outfmt $format -db $db_dir/$database -query $i -out $outdir/$fname.txt -max_target_seqs 1 &
# nohup /utils/appz/blast/ncbi-blast-2.2.30+/bin/blastn -num_threads 2 -outfmt '7 qseqid qlen slen qcovhsp sseqid staxids bitscore score evalue pident qstart qend sstart send' -db $db_dir/$database -query $i -out $outdir/$fname.txt & 

### END CODE ###

# If the number of processes that are running exceeds a certain number (start with 14), sleep for 5 seconds, then check again until a process ends.
numProc=$(ps auxw|grep -i blast|grep -v grep|wc -l)
while [ $numProc -gt 35 ]
do sleep 5
numProc=$(ps auxw|grep -i blast|grep -v grep|wc -l)
done


done

