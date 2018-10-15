% comprankdistance.m
% Andrew Back (c) 2018
%
% Computes the ranked distance between specific symbol occurrences.
% Required for Fast Entropy based on Fast Entropy Algorithm by Back et. al., 2018
%
% Inputs:
%
% Ablock = array of symbols (chars)
% Naw = size of Ablock
% CSymbol = Measure distance between this symbol
%
% Da = Array of all distances between specified symbol occurrences
%


function [Da] = comprankdistance(Ablock, Naw, CSymbol)            
% Now compute rank r distances between Csymbols
% - assume first and last chars are spaces
%
ALines = zeros(1,Naw);  % store all the distances in this array            
%
lastj = 0;
ccount = 1;
sum = 0;
    for j = 1:Naw,        
        if (Ablock(j) == CSymbol)    % eg CSymbol = 'C' , W = end of sentence, char(32)32 = space, 42 = *, 46 = full stop
           %fprintf('Coincidence detected at %d\n',i);
           dist = j - lastj + 1;
           sum = sum + dist;
           lastj = j;               
           ALines(ccount) = dist;
           fprintf('******************** %d - ccount %d    sum - %d \n',dist, ccount, sum);
           ccount = ccount + 1;
        end; 
        fprintf('j - %d     symb - %s \n', j, Ablock(j))
    end;
%
sum = cumsum(ALines);
fprintf('******************** %d - %d - ccount %d\n',dist, sum(ccount),ccount);
Da = ALines(1:ccount-1); 