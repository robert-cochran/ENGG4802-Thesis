% TestModel5a.m
% 
% Rank-Based Entropy Computed by Coincidence Detection for
% Natural Language
%
% Andrew Back
% (c) 2018
%
% Ref:
% J. Montalvao, D. G. Silva and R. Attux, "Simple entropy estimator for
% small datasets," in Electronics Letters, vol. 48, no. 17, pp. 1059-1061, August 16 2012.
%
% This runs a series of experiments on natural language text data with
% utterance and pause features as symbols. This is a precursor to n-gram experiments
% 
%-----------------------------------------------------------------

% Generate symbolic data based on texts:
fprintf('\n-----------------------------------------\nFast Entropy Experiment on Symbolic Text Data\n\n'); 

M = 3;      % alphabet size    
DoPlot = 0;
DoFileSave = 0;

Block20 = [0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0];
Block50 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0];
Block200 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0];


% Create warp functional
[x, Cwarp] = ZMLWarpFn(M, DoPlot, DoFileSave);

Nq = 200;  % No of samples Nq = 10000;
Nw = 20;   % window length to obtain entropy
Ns = 50;     % No of random trials to get statistical average
Kstart = 5;
Kend = 100;
Kstep = 1;
Rmax = 2;
R = 1;       % Estimate model parameters for rank R = 1

[ap, bp, cp] = BuildModelFn(Nq, Nw, Ns, Kstart, Kstep, Kend, Rmax, M, R, DoPlot, DoFileSave);  % Quite slow!! 
                % 
                % eg. R = 1, M = 27 => ap = 0.0073, bp = 4.2432, cp = 4.2013
                
fprintf('Fast Entropy Model (ap,bp,cp): %5.4f, %5.4f, %5.4f \n', ap, bp, cp);  

Hea = fastentropyblock(Block200, 199, 0, 2, ap, bp, cp);
 
fprintf('Estimated entropy (first %d samples) for %s: %5.4f \n', Nsega, BaseFile1, Hea);
% Should see: C:\data\corpora\sherlockholmes2.txt: 4.2724
      
%Output observed on cmd line:
%
% -----------------------------------------
% Fast Entropy Experiment on Symbolic Text Data
% 
% *Save the combined file: C:\data\corpora\CombA_gx7.txt 
% *Using C:\data\corpora\sherlockholmes2.txt, 
% *we obtain a symbol file: C:\data\corpora\CombA_gx7.txt 
% *which contains: AZDZDZBZAZDZBZCWAZCZ...  
% *Compute Entropy on the SYMBOLIC file 
% *A) For calculated Dmean=8.342, we have Kest=63.417,
% Estimated entropy (first 2000 samples) for C:\data\corpora\sherlockholmes2.txt: 4.2724 
