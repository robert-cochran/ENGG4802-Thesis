
# based on CheckFastEntropy.m
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

import fast_entropy as fast

Atest = 'AZDZDZBZAZDZBZCWAZCZDZCVBZDZBZCZBZCZCWAZ'  # <== This is the list of input symbols
symbols = list(Atest)
selected_symbol='C' # <== test using rank r = 3 symbol

# The BuildModel function needs to be called before using this function to obtain
# the parameter values ap,bp,cp

# The original values here were M=27, ap=0.0073, 4.2432, 4.2013. 
# I have changed M as andrew has said it shouldn't make that much of a difference
# and left ap, bp, cp as they were.

M = 27

ap = 0.0073
bp = 4.2432
cp = 4.2013

entropy=fast.fast_entropy(symbols,selected_symbol,M,ap,bp,cp)

print("-------------------------------1.0 Fast Entropy Output Test------------------------------")
print('Estimated entropy(40 samples):'+str(entropy))

"""
Note:
1. Expected output is: Estimated entropy(40 samples):4.266

2. Verify BuildModelFn. If the function is working properly, the output of (ap,bp,cp) values should
be approximate 0.0054, 4.3885, 4.7227.
However, the values might be slightly different due to curve fitting algorithm is different from Matlab.

"""
