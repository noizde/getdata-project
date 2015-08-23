This script first reads the _test and _train files inside their respective directories.

After doing so, `rbind` is called to concatenate each subject_, x_, and y_ file with its equivalent from the other case; `cbind` is then used to combine all the variables, by column, into a single data frame.

Column names are determined by reading from the features.txt file and replacing the columns (aside from the ones representing subject and activity id) with the contents of the features table.

A function named `grepNames` is defined, which extracts from a data frame only the columns with a given name. This is used to extract a data frame containing only subject, activity, mean, and standard deviations; "mean" and "Mean" are both used, and so are both included in the character vector.

Activity labels are applied by first reading from activity_labels.txt, and then `merge`ing them according to the activity IDs in the base data set.

The data set is then split, first by subject, then by activity, lapply functions being called on each level to go through each combination of subject and activity, to generate column means. These column means are unlisted in order to flatten them as much as possible, with the end result being a list of character vectors, each variable as described in the CodeBook.

This script outputs the tidy dataset to a file called "tidySet.txt".

To read the output produced by this script, run: `read.table("tidySet.txt", header = TRUE)`.