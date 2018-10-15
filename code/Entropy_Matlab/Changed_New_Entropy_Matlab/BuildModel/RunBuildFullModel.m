    
% RunBuildFullModel.m
% 
% Rank-Based Entropy Computed by Coincidence Detection for
% Natural Language
%
% Andrew Back
% (c) 2018
%
% Refs:
% J. Montalvao, D. G. Silva and R. Attux, "Simple entropy estimator for
% small datasets," in Electronics Letters, vol. 48, no. 17, pp. 1059-1061, August 16 2012.
%
% A.D. Back, D. Angus, J. Wiles, Fast Entropy Estimation for Natural Sequences, submitted, 2018
%
% This is the main script to build an entropy model and run a series of experiments.
%
%-----------------------------------------------------------------

fprintf('------------[ Fast Entropy Build Full Model ]------------\n'); 

DoPlot = 0;
DoFileSave = 0;
DoVerbose = 1;

% Set number of symbols
M = 7;  %27;      % alphabet size    

% Create warp functional
%%[x, Cwarp] = ZMLWarpFn(M, DoPlot, DoFileSave);

Nq = 10000;  % No of samples Nq = 10000;
Nw = 1000;   % 1000 window length to obtain entropy
Ns = 50;    % 50 No of random trials to get statistical average
Kstart = 5;
Kend = 100;  %100
Kstep = 1;
Rmax = 5;


R = 1;       % Estimate model parameters for rank R = 1
[ap, bp, cp] = BuildModelFn(Nq, Nw, Ns, Kstart, Kstep, Kend, Rmax, M, R, DoPlot, DoFileSave, DoVerbose);  % Quite slow!! 
                % 
                % eg. R = 1, M = 27 => ap = 0.0073, bp = 4.2432, cp = 4.2013
                
fprintf('Fast Entropy Model M=%d: (ap,bp,cp): %5.4f, %5.4f, %5.4f \n', M, ap, bp, cp);  

R = 2;
[ap, bp, cp] = BuildModelFn(Nq, Nw, Ns, Kstart, Kstep, Kend, Rmax, M, R, DoPlot, DoFileSave, DoVerbose);  % Quite slow!!                
fprintf('Fast Entropy Model M=%d: (ap,bp,cp): %5.4f, %5.4f, %5.4f \n', M, ap, bp, cp);  

R = 3;
[ap, bp, cp] = BuildModelFn(Nq, Nw, Ns, Kstart, Kstep, Kend, Rmax, M, R, DoPlot, DoFileSave, DoVerbose);  % Quite slow!!                
fprintf('Fast Entropy Model M=%d: (ap,bp,cp): %5.4f, %5.4f, %5.4f \n', M, ap, bp, cp);  

% Cmd Line Output using above parameters:
%
% ------------[ Fast Entropy Model Build Test ]------------
% K=27
% Entropy (normalized)- Ha(27) = 4.261 
% Actual English Entropy: Ha = 4.0960 bits
% 
%  Build Rank-Based Entropy Model (Biased Distribution) ... 
% K=20
% K=30
% K=40
% K=50
% K=60
% Fast Entropy Model (ap,bp,cp): 1.6727, 1.5085, -14.8525 