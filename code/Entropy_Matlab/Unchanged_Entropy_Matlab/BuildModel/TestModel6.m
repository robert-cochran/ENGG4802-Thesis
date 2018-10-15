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

DoSaveFile = 1; 


%BaseFile = 'C:\data\corpora\TomSawyer2short';
BaseFile1   = 'C:\data\corpora\sherlockholmes2.txt';   
BaseFile2 = 'C:\data\corpora\drseusscat.txt';
OutputFile1 = 'C:\data\corpora\output\sherlock2';  
OutputFile2 = 'C:\data\corpora\output\drseusscat';  
CombFile = 'C:\data\corpora\Sherlock2Seuss'; 
RunNo = 8;

M = 27;
Model = 1;  % Not used 

[Nx1] = SymbolizeText(Model,BaseFile1, OutputFile1, RunNo);   % Symbolize text and save to file
[Nx2] = SymbolizeText(Model,BaseFile2, OutputFile2, RunNo);   % Symbolize text and save to file


%----------------------------------------------------------------------
%
% <<< Read in SYMBOLIC text files and process >>>
%   
TheFile = sprintf('%s_gx%d.txt', OutputFile1, RunNo);    
Asym = fileread(TheFile);      
Na = length(Asym);  % ~ 144714 TS,  ~ 211220 SH

     
%----------------------------------------------------------------------
%
% <<< Load/Build Entropy Model >>>
%
% This is computed using BuildModelFn.m which does the heavy lifting in
% computing the Fast Entropy Model parameters.
% see Run.m
% [ap, bp, cp] = BuildModelFn(Nq, Nw, Ns, Kstart, Kend, Rmax, M, R);  %Quite slow!!
% load('monext18_2018-May-28-10-58');
% This provides the ZML Model
% For M=27, we find that 
%          ap = 0.0073
%          bp = 4.2432
%          cp = 4.2013
% Bypass this step for now, and simply load in precomputed FE model parameters:
ap = 0.0073;
bp = 4.2432;
cp = 4.2013;

    
%----------------------------------------------------------------------
%
% <<< Synthesize aggregate SYMBOLIC file >>>
%
%       

% Save the symbolic file:
 if DoSaveFile == 1 
    BaseFile = 'C:\data\corpora\CombA';   
    TheFile = sprintf('%s_gx%d.txt', BaseFile, RunNo);    
    fprintf('*Save the combined file: %s \n', TheFile);          
    fid = fopen(TheFile,'wt');    
    fprintf(fid, '%s', Asym);
    fclose(fid);   
 end

 % Sanity check:
 %
 fprintf('*Using %s, \n*we obtain a symbol file: %s \n*which contains: %s...  \n', BaseFile1, TheFile, Csym(1:20));  
  
%----------------------------------------------------------------------
%
% <<< Compute Entropy on the SYMBOLIC text >>>
%
fprintf('*Compute Entropy on the SYMBOLIC file \n');    

CSymbol = 'C'; % Compute entropy based on distances for this symbol
Nsega = 2000;  % Compute entropy actually here on only the first 2000 samples

Hea = fastentropyblock(Asym(1:Nsega), Nsega, CSymbol, M, ap, bp, cp);
 
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
