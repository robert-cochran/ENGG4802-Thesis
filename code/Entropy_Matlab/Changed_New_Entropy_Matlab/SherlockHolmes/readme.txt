
This demo reads in two different texts, Sherlock Holmes and Dr. Seuss. The symbolization is performed
using the RunSymbFileFn and reads in the files, and creates a symbolized output. It is of interest to
view these output files to gain an understanding of what the Computer is seeing.

Once these symbolic files are read in, then the Fast Entropy algorithm is applied to the combined file
where the graphical output shows how the entropy drops when it reaches the Dr Seuss text. 

RunSymbFileFn.m = Symbolize the text 
Analyze8.m      = Run Fast Entropy across the symbolic input.

Note that the Fast Entropy model is not built here but read in from a previously created model.
The model can be recreated using the BuildModel folder, or it can be read in using the saved Matlab workspace
or it can be simply read in using the model parameters (a,b,c).
