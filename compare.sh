#!/bin/bash
#
# Usage: compare.sh {ordSrcDir} {newSrcDir} {destDir}
#
oldSrcDir=$1
newSrcDir=$2
destDir=$3

for image in $(ls $oldSrcDir); do
	echo "$image will be compared.";
	composite -compose difference $oldSrcDir/$image $newSrcDir/$image $destDir/$image
	existsDiff=$(identify -format "%[mean]" $destDir/$image)
	echo "diff exists?: $existsDiff"
	if [ $existsDiff = "0" ]; then
	    echo "diff not exists."
		rm $destDir/$image
	else
	    echo "diff exists."
		compare -fuzz 2% -metric AE $oldSrcDir/$image $newSrcDir/$image $destDir/$image
		convert +append $oldSrcDir/$image $newSrcDir/$image $destDir/$image $destDir/$image
	fi	
done




