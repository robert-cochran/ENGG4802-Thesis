% fastentropyblock.m
% Andrew Back (c) 2018
%
% Computes Fast Entropy based on Fast Entropy Algorithm by Back et. al., 2018
%
% Inputs:
%
% Ablock = array of symbols (chars)
% Naw = size of Ablock
% M =  Alphabet size
% ap, bp, cp = fast Entropy Model parameters
%
% Outputs:
% Hea - Estimated Entropy Computed using Fast Entropy Model (requires supplied Model parameters)

function [Hea] = fastentropyblock(Ablock, Naw, CSymbol, M, ap, bp, cp)
% OLD: function [Hp, Hea] = fastentropyblock(Hp, i, ia, Ablock, Naw, CSymbol, M, ap, bp, cp)
   [Da] = comprankdistance(Ablock, Naw, CSymbol);  % get the distsnces between symbol occurrences.
    sum = cumsum(Da);
    %fprintf('sum - %d \n',sum(sum.len-1));
    if isempty(Da)

         fprintf('Invalid at block %d\n', i);     

    else
        %ia = ia + 1;
        %Dhcount = length(Da);
        dmeantest = mean(Da);  %  6.0392    
        %dmeantest = 8.338235294117647;
        % Compute Dh using average of Dh values
        %
        % We are using Rank 1, so et R=1.
        % We only have one row of symbol data, we simply take the value for R =1.

        R = 1;

        %*** fprintf('Test 2 - Ds|n=%d = %4.3f \n', Dhcount, dmeantest);   
        %=============================

        % Now, based on the estimated D, calculate K and thence H:
        % Note: parametrs come from what was learned back in training stage using
        % inverse model.
        %
        % create fit data
        Kest = ap*dmeantest.^bp+cp;
        fprintf('*A) For calculated Dmean=%4.3f, we have Kest=%4.8f,\n',dmeantest, Kest);  

        Ms = Kest;  % Mest
        M1s = Kest + 1;
        % K = M, hence we can now compute alpha(r,M), beta(r,M) , gamma(r,M) and hence P(r,M)
        %
            a2 = log2(M1s)/log2(Ms);
            beta2 = Ms/(M1s);
            gamma2 = Ms^(a2-1)/(Ms-1)^a2;
            
            p = zeros(1,M);
            psum = 0;
                for r = 1:M,        
                    Pr = gamma2/((r + beta2)^a2);
                    p(r) = Pr;
                    psum = psum + Pr;
                    if (r <= 5)
                     %fprintf('Pr(%d) = %4.3f \n',r, Pr); 
                    end; 
                end;
            knorm = psum;

             % Normalize.... 
            %fprintf('Normalize p(r)\n');  
            psum = 0;
                for r = 1:M,        
                    Pr = p(r)/knorm;
                    p(r) = Pr;
                    psum = psum + Pr;
                    fprintf('r:%d ---- %4.8f ---- %4.8f ---- %4.8f \n',r,Pr,p(r),psum);

                    if (r <= 5)
                     %fprintf('Normalized Pr(%d) = %4.3f\n',r, Pr); 
                    end; 
                end;

            % Calculate actual entropy

            He = 0;
            for r = 1:M,       
              He = He + p(r) * log2( p(r) );  
              fprintf('r:%d   p(r)= %4.8f    log2(p(r))= %4.8f    He = %4.8f \n',r,p(r),log2(p(r)),He);
            end;
            Hea = -He;
            
            %OLD fprintf('A) Combined file (TS + DS): Hea(%d)(%4.2f) = %5.4f \n',i, Kest, Hea);    % 4.2523 
            % Note: this is actually a good answer, since it is showing that it is
            % very close to the original model we predicted for English in
            % Experiment 1. Put another way, if our Zipfian model was more accurate
            % to begin with, then we would expect this to flow on here also..
            %MeanHea =  MeanHea + Hea; 
            %OLD: Hp = [Hp Hea];
    end % end of if isempty(Da)


