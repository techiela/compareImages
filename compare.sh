#!/bin/bash
# Usage: compare.sh {ordSrcDir} {newSrcDir} {destDir}
#
usage='Usage: compare.sh {ordSrcDir} {newSrcDir} {destDir}'
if [ $# != 3 ]; then
	echo $usage
	exit
fi

# assign paths from args
oldSrcDir=$1
newSrcDir=$2
destDir=$3

for image in $(ls $oldSrcDir); do
	echo "$image will be compared.";
	# create a image for detecting whether it has some difference or not
	composite -compose difference $oldSrcDir/$image $newSrcDir/$image $destDir/$image
	existsDiff=$(identify -format "%[mean]" $destDir/$image)
	if [ $existsDiff = "0" ]; then
	    echo "diff not exists."
		rm $destDir/$image
	else
	    echo "diff exists."
		# create a image which has visualized difference map
		compare -fuzz 2% -metric AE $oldSrcDir/$image $newSrcDir/$image $destDir/$image > /dev/null 2>&1
		# concat old, new, and destinated images horizontally.
		convert +append $oldSrcDir/$image $newSrcDir/$image $destDir/$image $destDir/$image
	fi	
done




