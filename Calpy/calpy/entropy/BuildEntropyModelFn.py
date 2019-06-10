"""
This file is mainly translated from the the BuildEntropyModelFn.m Matlab script.
"""
import numpy as np
def CalcEntropyFn(M):
    M1=M+1
    a=np.log2(M1)/np.log2(M)
    beta=M/M1
    gamma=(M**(a-1))/(M-1)**a
    p=np.zeros((1,M))
    psum=0
    for i in range(1,M+1):
        Pr=gamma/((i+beta)**a)
        p[0][i-1]=Pr
        psum=psum+Pr
        if i<=5:
            pass
    knorm=psum
    psum=0
    for i in range(1,M+1):
        Pr=p[0][i-1]/knorm
        p[0][i-1]=Pr
        psum=psum+Pr
        if i<=5:
            pass
    pc=np.cumsum(p)
    Ha=0
    for i in range(1,M+1):
        Ha=Ha+p[0][i-1]*np.log2(p[0][i-1])
    He=-Ha
    output=[He,pc]
    return output

#output=CalcEntropyFn(8)
#print(output)
#[Ha,pc]=CalcEntropyFn(8)
#print(str(pc[3]))

def BuildEntropyModelFn(Nq,Nw,Ns,Kstart,Kstep,Kend,Rmax,Mmain,Rmodel,DoPlot,DoFileSave,Doverbose):
    if Doverbose==1:
        print('Build Rank-Based Entropy Model (Biased Distribution)')
    fKrange=(Kend-Kstart)/Kstep+1  # Krange : 46
    Krange = int(fKrange)
    dmeanmat = np.zeros((Krange,Krange+1))

    Mrange=[]
    x=range(Kstart,Kend+1,Kstep)
    for i in x:
        Mrange.append(i)
    '''
    ---------------------------------
    Do Forward Model
    ---------------------------------
    '''
    NMrange = len(Mrange)
    #print('>>NMrange =' + str(NMrange))
    ix = 0
    KnCount = 1

    #  Note, we are building a model for a range of alphabet sizes, ie M = Kn.

    for Kn in range(Kstart, Kend, Kstep):
        if Doverbose==1:
            print(str(ix)+') K='+str(Kn))
        ix=ix+1
        #Mrange[ix] = Kn
    '''
    ---------------------------------
    Allocate vectors
    ---------------------------------
    '''
    d2 = np.zeros((Kn,1))
    d_all = np.zeros((1,Kn))
    dsum_all = np.zeros((1,Kn))

    '''
    ---------------------------------
    compute set of ranked probabilities according to Zipf-Mandelbrot-Li model
    for this K value
    M=Kn
    ---------------------------------
    '''
    [Ha,pc] = CalcEntropyFn(Kn)
    #Now, pc contains the vector of probabilities which are computed according to the ZML model using alphabet size M=Kn
    for h in range(1,Ns+1):
        x = np.random.rand(1,Nq)
        dist = 0                          # d value which is the distance between coincidences.
        distv = np.ones((1,Kn))           # initialize absolute distance counter for all symbols
        lastdistv = np.ones((1,Kn))       # initialize last absolute distance counter for all symbols
        reldistv = np.zeros((1,Kn))       # initialize relative distance counter for all symbols
        distm = np.zeros((Nw,Kn))         # initialize distance counter for all symbols not Nw.. but some number...
        symbolcount = np.zeros((1,Kn))    # count the number of each symbol detected
        firstsymbolflag = np.ones((1,Kn)) # need to have a flag to indicate this is the first symbol (for counting)

        # Nw = window length to obtain entropy
        for i in range(1,Nw+1):
            dist = dist + 1  # get the distance between coincidences = increment due to i, ie number of symbols passed
            j = 1

            if x[0][i-1] <= pc[j-1]:   # <== THIS IS THE LINE TO DETECT EACH SYMBOL (in this case based on numerical prob)

                # Note: This is a simple method of creating random
                # data and obtaining the occurrence of the symbolic
                # event according to the specified probability.
                #
                # eg. if pc(some_rank_r) = 1.0, then x(i) e [0,1]
                # will always fire. But on the other hand,
                #     if pc(some_rank_r) = 0.1, then x(i) e [0,1]
                # and this will fire infrequently.

                # increment the distance counter for this
                # symbol by recording the current distance
                d2[j-1][0] = d2[j-1][0] + 1
                if firstsymbolflag[0][j-1]==1:  #  is this the first time symbol is detected?
                    firstsymbolflag[0][j-1]=0   #  if so, then reset flag
                    distv[0][j-1] = dist
                    lastdistv[0][j-1] = dist
                else:
                    lastdistv[0][j-1] = distv[0][j-1]
                    distv[0][j-1] = dist
                    reldistv[0][j-1] = distv[0][j-1] - lastdistv[0][j-1] + 1

            for j in range(2,Kn+1):
                if x[0][i-1] > pc[j-2] and x[0][i-1] <= pc[j-1]:
                    d2[j-1] = d2[j-1] + 1   # record the number of coincidences of symbols

                    # increment the distance counter for this
                    # symbol by recording the current distance
                    #
                    if firstsymbolflag[0][j-1]==1:    #  is this the first time symbol is detected?
                        firstsymbolflag[0][j-1] = 0   #  if so, then reset flag
                        distv[0][j-1] = dist
                        lastdistv[0][j-1] = dist
                    else:
                        lastdistv[0][j-1] =  distv[0][j-1]
                        distv[0][j-1] = dist
                        #print ('j = ' +str(j))
                        dv1 = distv[0][j - 1]
                        dv2 = lastdistv[0][j - 1]
                        reldistv[0][j - 1] = dv1 - dv2 + 1
                        #reldistv[0][j-1]=distv[j-1]-lastdistv[0][j-1]+1
                    break

               # Now test to see if there is a coincidence yet
               # take columnwise sum value as taken from above
               # if sum is > 1, then it is a coincidence
               # when coincidence, record the Dh value and start over.
               # Dh = the number of symbols between coincidences
               # eg [a b c d a...] => Dh = 4
               #

               #-----------------------------------------------------------
               # === TEST FOR SPECIFIC RANK COINCIDENCE ===

            for j in range(1,Kn+1):
                if d2[j-1][0] > 1:  # as soon as we get 2 or more, then this indicates a coincidence of symbols
                    symbolcount[0][j-1] = symbolcount[0][j-1] + 1  # increment the symbol count for this symbol
                    smc = symbolcount[0][j-1]
                    distm[int(smc)][j-1] = reldistv[0][j-1]  # record the distance between consecutive same symbols

                    # Dhcount = Dhcount + 1;  % increment counter of the number of coincidences detected
                    # Dh(Dhcount) = dist;     % this is the latest Dh value

                    d2[j-1][0] = d2[j-1][0] - 1  #  clear this symbol count - clear the d2 vector and restart looking for coincidences

        # Get Mean D for all symbols
        #
        SumDM = np.sum(distm,axis=0)

        # d_all = SumDM ./ symbolcount;    % watch out for Nan
        #
        for jj in range(1,Kn+1):
            if symbolcount[0][jj-1] != 0:
                    d_all[0][jj-1] = SumDM[jj-1] / symbolcount[0][jj-1]
            else:
                    d_all[0][jj-1] = 0

            dsum_all = dsum_all + d_all

        dmean_all = dsum_all / Ns

        #for j in range(1,Kn+1):
        #    pass

        for j in range(1,Kn+1):
            dmean_all[0][j-1]
            dmeanmat[KnCount-1][j-1] = dmean_all[0][j-1]
        KnCount = KnCount + 1

    if Doverbose == 1:
        print('Curve fitting to create forward model (***)...\n')


# To Do: Fix the above, add curve fit section, verify against Matlab code.
