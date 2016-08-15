
The R script run_analysis.R performs 5 steps as asked in the project.

This script download the files and saves it into local folders and
it is cached so that when the script is executed multiple times the
download does not occur multiple times.

All the training and test data set is read and they are merged with rbind
function to create one dataset.

The regular expressions for getting the descriptive names for the features
measurements is used and then colMeans to find the average for all the dataset.

Then the final results are written out to a file.
