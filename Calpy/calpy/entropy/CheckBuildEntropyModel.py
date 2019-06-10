
# based on CheckBuildEntropyModel.m
#
# Rank-Based Entropy Computed by Coincidence Detection for
# Natural Language
#
# Andrew Back
# (c) 2018
#
# History:
#
#  14 Dec 2018
#
# Ref:
#  1. Fast Entropy paper (Back, Angus and Wiles).
#
#  2. J. Montalvao, D. G. Silva and R. Attux, "Simple entropy estimator for
#     small datasets," in Electronics Letters, vol. 48, no. 17, pp. 1059-1061, August 16 2012.
#
# This runs a simple experiment using letters as symbols.
#
#-----------------------------------------------------------------

import BuildEntropyModelFn as build_entropy

DoPlot = 1
DoFileSave = 1
DoVerbose = 1

M = 12 # Alphabet size

Nq = 50000  # No of samples
Nw = 5000   # Window length to obtain entropy
Ns = 100    # No of random trials to get statistical average
Kstart = 5
Kend = 50
Kstep = 1
Rmax = 5

R = 1; # Estimate model parameters for rank R = 1
[ap, bp, cp] = build_entropy.BuildEntropyModelFn(Nq, Nw, Ns, Kstart, Kstep, Kend, Rmax, M, R, DoPlot, DoFileSave, DoVerbose);
# Quite slow!!

print("------------------------------- Build Entropy Model Output Test------------------------------")
print('Entropy Model (a,b,c):'+str(ap)+str(bp)+str(cp))

"""
Note:
1. Expected output is something similar to: 
Do Rank R=1 Model..
Fast Entropy Model M=12: (ap,bp,cp): 0.0108, 4.0361, 3.6858 

"""
