% CalcEntropyFn(M)
%
% Rank-Based Entropy Computed by Coincidence Detection for
% Natural Language
%
% Andrew Back
% (c) 2018
%
% Computes entropy based on Zipf-Mandelbrot-Li model
%
%-----------------------------------------------------------------


function [He, pc] = CalcEntropyFn(M)
    
    %----------------------------------------------------------------------
    % Compute set of ranked probabilities according to Zipf-Mandelbrot-Li model 
    % for this M value 
    %
    M1 = M + 1; 

    a = log2(M1)/log2(M);
    beta = M/(M1);
    gamma = M^(a-1)/(M-1)^a;

    p = zeros(1,M);
    psum = 0;
        for r = 1:M,        
            Pr = gamma/(r + beta)^a;
            p(r) = Pr;
            psum = psum + Pr;
            if (r <= 5)
             %fprintf('Pr(%d) = %4.3f \n',r, Pr); 
            end; 
        end;
    knorm = psum;
      
    % Normalize the ranked probabilities
    %fprintf('Normalize p(r)\n');  
    psum = 0;
        for r = 1:M,        
            Pr = p(r)/knorm;
            p(r) = Pr;
            psum = psum + Pr;
            if (r <= 5)
             %fprintf('Normalized Pr(%d) = %4.3f\n',r, Pr); 
            end; 
        end;
        
    pc = cumsum(p);
      
    % Calculate ZML ranked probability model entropy 
    
    Ha = 0;
    for r = 1:M,       
      Ha = Ha + p(r) * log2( p(r) );       
    end;
    He = -Ha;
