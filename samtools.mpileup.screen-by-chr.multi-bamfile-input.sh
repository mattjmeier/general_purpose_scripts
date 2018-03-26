#!bin/sh
# This script will loop through all the sequences from a BAM header from an input file, and run a separate thread for each sequence.  This is useful for running samtools in a somewhat multithreaded manner.

echo "What directory would you like to run samtools mpileup on?"
read -e rootdir

bamFiles=$(find $rootdir -name "*.bam")

echo "The BAM files to be processed are:"
echo $bamFiles

for i in $bamFiles
do
bamArray+=($i)
done

# Store header from BAM file
# NOTE they must be aligned to the same reference sequence, because we are only taking the header from ONE
echo "Grabbing header from ${bamArray[0]}"
bamHeader=$(samtools view -H ${bamArray[0]})

# Obtain a list of all the sequences from the BAM headers
# Grab lines starting with @SQ, then take the second column and used sed to remove the SN: part
myList=$(echo "$bamHeader" | awk -F" " '$1 == "@SQ"{print $2}' | sed 's/SN\://g')

echo "The IDs are:"
for id in $myList
do
echo $id
done

read -r -p "Please ensure the above is correct before you continue!!! [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 

        echo "Going ahead with analysis..."
	# You have 1 second to kill it
	sleep 1

###########################################################
###########################################################
###  START COMMANDS #######################################
###########################################################
###########################################################

# Loop through each sequence ID
for id in $myList
do
echo "Starting samtools mpileup for $id..."
echo $id
echo $bamFiles
echo $mm10min
# Do a pileup on each chromosome for all the BAM files
# screen -d -m -S "$id".samtools bash -c "samtools mpileup -gDf $mm10min $bamFiles -r $id > $id.output.bcf"
# screen -d -m -S "$id".samtools bash -c 'samtools mpileup -gDf $0 $1 -r $2 > $2.output.bcf' $mm10min $bamFiles $id
nohup samtools mpileup -gDf $mm10min $bamFiles -r $id > $id.output.bcf 2>&1 | tee $id.log &


done

###########################################################
###########################################################
###  END COMMANDS #########################################
###########################################################
###########################################################

        ;;
    *)
        echo "Quitting now"
        ;;
esac

