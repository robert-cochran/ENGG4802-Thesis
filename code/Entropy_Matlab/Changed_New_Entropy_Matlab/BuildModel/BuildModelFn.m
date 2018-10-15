
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
% Notes: The model creates a series of curves corresponding to the ranks
% from r = 1 to Rmax. The actual model parameters are returned
% corresponding to the supplied parameter Rmodel. From these parameters the
% entropy can be estimated. However, in practice, the algorithm can be
% further extended such that the entropy can be estimated using multiple R
% values corresponding tothe distances measured across multiple symbolic
% distances instead of a single symbol. However, the accuracy for even a
% single symbol can be reasonable.
%
% ===== IMPORTANT NOTE: [PLEASE READ FOR FUTURE IMPLEMENTATION!!!] =========
% Note that this function builds ALL models to create the curves, but we
% could make it much quicker by simply doing the inverse model required for a 
% specific R value. An even quicker method is to use a look-up table, ie 
% saving the models and then reading them in instantaneously. 
% =========================================================================
%        
% Note: Due to pedagogial reasons, the variable K, viz., Kn, Kstart, Kend
%       is equivalent to the alphabet length M in the given context.
%
%-----------------------------------------------------------------

% Nq = 10000;  % No of samples Nq = 10000;
% Nw = 1000;   % window length to obtain entropy
% Ns = 50;     % No of random trials to get statistical average
% Kstart = 5;
% Kend = 100;
% Rmax = 5;
% NOT USED AT PRESENT >>>
% Mmain = alphabet size, ie number of unique symbols. For now this is not
%         used, but fixed internally in this function at Mmain = 27.
% R = 1;   % Estimate model parameters for rank R = 1

function [ap, bp, cp] = BuildModelFn(Nq, Nw, Ns, Kstart, Kstep, Kend, Rmax, Mmain, Rmodel, DoPlot, DoFileSave, DoVerbose)

% Note: the parameters returned correspond to R=r,eg r=1, but should be vectors
% for a set of R values.

if DoVerbose == 1
 fprintf('\n Build Rank-Based Entropy Model (Biased Distribution) ... \n');
end

%Make sure that ZMLWarp.m has been run before this..

% if ~exist('CWarpRun','var') == 1
%     disp('Make sure that ZMLWarp.m has been run before this..');
% end

Krange = (Kend - Kstart)/Kstep + 1;
dmeanmat = zeros(Krange,Krange+1);

Mrange = [Kstart:Kstep:Kend];   % ones(1,Krange+1);

%=========================================================
% DO FORWARD MODEL
%=========================================================

ix = 0;
KnCount = 1;

% Note, we are building a model for a range of alphabet sizes, ie M = Kn.

for Kn=Kstart:Kstep:Kend,
    if DoVerbose == 1
        fprintf('K=%d\n',Kn);
    end
    ix = ix + 1;
    Mrange(ix) = Kn;

    %----------------------------------------------------------------------
    % Allocate vectors 
    %     
    d2 = zeros(Kn,1);
    d_all = zeros(1,Kn);  
    dsum_all = zeros(1,Kn);       
        
    %----------------------------------------------------------------------
    % Compute set of ranked probabilities according to Zipf-Mandelbrot-Li model 
    % for this K value 
    %
    %M = Kn;
    [Ha, pc] = CalcEntropyFn(Kn);  % Kn = M
    
    % Now, pc contains the vector of probabilities which are computed according
    % to the ZML model using the alphabet size M = Kn
       
        for h = 1:Ns    % Do Ns runs to get stat avg

        %----------------------------------------------------------------------
        % Generate data according to probability model   
        %
        % Use continuous random variables occuring between some bounds as symbols
        %
        %rand('state',0);
        x = rand(1,Nq);  

        %----------------------------------------------------------------------
        % Capture the stream of input, then monitor coincidences
        % 
        % Note: check whether we are happy for any coincidence or whether 
        %       we are looking for a specific symbol coincidence
        %

            dist = 0;    % d value which is the distance between coincidences.
            distv = ones(1,Kn);    % initialize absolute distance counter for all symbols
            lastdistv = ones(1,Kn); % initialize last absolute distance counter for all symbols
            reldistv = zeros(1,Kn); % initialize relative distance counter for all symbols
            
            distm = zeros(Nw,Kn); % initialize distance counter for all symbols not Nw.. but some number...
            symbolcount = zeros(1,Kn); % count the number of each symbol detected
                       
            firstsymbolflag = ones(1,Kn); % need to have a flag to indicate this is the first symbol (for counting)
            
                           % Nw = window length to obtain entropy
            for i = 1:Nw   % loop over all the generated samples of symbols

                dist = dist + 1;     % get the distance between coincidences = increment due to i, ie number of symbols passed
               
                % For interest, capture this stream of symbols ------------
                %      
                  j = 1;
                  if (x(i) <= pc(j)) % <== THIS IS THE LINE TO DETECT EACH SYMBOL (in this case based on numerical prob)                    
                      
                      % Note: This is a simple method of creating random
                      % data and obtaining the occurrence of the symbolic
                      % event according to the specified probability.
                      %
                      % eg. if pc(some_rank_r) = 1.0, then x(i) e [0,1]
                      % will always fire. But on the other hand, 
                      %     if pc(some_rank_r) = 0.1, then x(i) e [0,1]
                      % and this will fire infrequently.
                      
                      d2(j) = d2(j) + 1;  % record the number of coincidences of symbols
                      
                      % increment the distance counter for this
                      % symbol by recording the current distance
                      if(firstsymbolflag(j) == 1) % is this the first time symbol is detected?
                          firstsymbolflag(j) = 0; % if so, then reset flag
                          distv(j) = dist;
                          lastdistv(j) = dist;
                      else  
                          lastdistv(j) = distv(j);
                          distv(j) = dist;
                          reldistv(j) = distv(j) - lastdistv(j) + 1;    
                      end;                         
                                             
                  end  % if (x(i) <= pc(j))                
                
                    for j = 2:Kn                                             
                          if ( (x(i) > pc(j-1)) && (x(i) <= pc(j)) )  % 

                              d2(j) = d2(j) + 1;  % record the number of coincidences of symbols

                              % increment the distance counter for this
                              % symbol by recording the current distance
                              if(firstsymbolflag(j) == 1) % is this the first time symbol is detected?
                                  firstsymbolflag(j) = 0; % if so, then reset flag
                                  distv(j) = dist;
                                  lastdistv(j) = dist;
                              else  
                                  lastdistv(j) = distv(j);
                                  distv(j) = dist;
                                  reldistv(j) = distv(j) - lastdistv(j) + 1;    
                              end;                         
 
                              break
                          end % if ( (x(i) > pc(j-1)) && (x(i) <= pc(j)) )  %                                        
                    end;    % end of for j = 1:Kn      
                    
           
               % Now test to see if there is a coincidence yet
               % take columnwise sum value as taken from above
               % if sum is > 1, then it is a coincidence
               % when coincidence, record the Dh value and start over.
               % Dh = the number of symbols between coincidences
               % eg [a b c d a...] => Dh = 4
               %

               %-----------------------------------------------------------
               % === TEST FOR SPECIFIC RANK COINCIDENCE ===
               for j = 1:Kn            
                  if (d2(j) > 1)  % as soon as we get 2 or more, then this indicates a coincidence of symbols
                      symbolcount(j) = symbolcount(j) + 1;    % increment the symbol count for this symbol
                      distm(symbolcount(j), j) = reldistv(j); % record the distance between consecutive same symbols 
                      
                      %Dhcount = Dhcount + 1;  % increment counter of the number of coincidences detected
                      %Dh(Dhcount) = dist;     % this is the latest Dh value
                      d2(j) =  d2(j) - 1;     % clear this symbol count  % = zeros(Kn,1);       % clear the d2 vector and restart looking for coincidences
                  end;                                    
               end;
               %-----------------------------------------------------------          

            end;  % for i = 1:Nw
           
           % Get Mean D for all symbols
           %
           SumDM = sum(distm);

            %d_all = SumDM ./ symbolcount;    % watch out for Nan           
            for jj = 1:Kn
                if (symbolcount(jj) ~= 0)
                  d_all(jj) = SumDM(jj) / symbolcount(jj); 
                else
                  d_all(jj) = 0; 
                end
            end;           
           
           dsum_all = dsum_all + d_all;
           
        end;  % for h = 1:Ns    
        
        dmean_all = dsum_all ./ Ns;  % Get Dmean for all symbols at the current K value
        
        
        for j = 1:Kn
           %fprintf('Dmean(r=%d,K=%d)=%4.3f\n',j,Kn,dmean_all(j)); 
        end;
               
        % Record the dmean values into matrix -> dmeanmat = zeros(Nw,Krange+1);
        for j = 1:Kn
           dmeanmat(KnCount,j) = dmean_all(j); % similar to dmeanvec(Kn) except now we have dmean for each symbol
                                          % columns = symbols
        end;
                
    KnCount = KnCount + 1;
    
end;  % end of Kn loop

% Now we have a set of data for a range of alphabet sizes giving
% Dmean for all symbols.
%
% More specifically,
% 
% dmeanmat contains the estimated distances for each ranked symbol in an alphabet.
%    where the rows correspond to a given alphabet size M and then for 
%    each column corresponds to a set of ranked symbols.
%
%    Rows = alphabet size
%    Cols = ranked symbols
%
%
% This set of distance data is now used to create a set of forward models
% for a range of M values and for each rank within that alphabet size.
%
if DoVerbose == 1
 fprintf('Curve fitting to create forward model (***)...\n'); 
end

 % Check this: This next plot part is a bit dodgy it seems.
 % Note that the model and plot immediately below corresponds to a specific
 % M value = Mmain (and = Kend if Kn is used since we sinply continue on from 
 % above loop).
 %
 % We have the D values above to do a wide range of models across a set of
 % M values, but now we revert to simply doing a specific model for the
 % given Mmain value.
 %
 % *** 5 Oct 2018 Correction Kn was used in model, but now used Mmain.

%----------------------------------------------------------------------
% Curve fit to dmeanvec ===============================================
% Using cftool
% Step over a number of R values

if DoPlot == 1  
 figure
end

for R = 1:Rmax,
    if DoVerbose == 1
      fprintf('R=%d\n',R);
    end
    dmeanvec = dmeanmat(:,R)';
   
    % Fit this model using new data 
    % fitopt = fitoptions('Poly4', 'Normalize', 'off', 'Robust', 'LAR');
    % %fitopt.StartPoint=[2.5, 0.35, 0.29 ];
    % [cf,gof,output] = fit(Mrange',dmeanvec','Poly4', fitopt); 

    fitopt = fitoptions('power2', 'Normalize', 'off', 'Robust', 'off', 'Algorithm', 'Trust-Region', 'MaxFunEvals',1000);
    [cf,gof,output] = fit(Mrange',dmeanmat(:,R),'power2', fitopt); 
    
    % ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    % Note: for a vector of D values, and a given rank R, we now create a
    % smooth invertible model which fits the given M values.
    % Hence, for a given rank R, the input is a particular M value, and
    % the output is a distance (supplied via the stochastic model results
    % in dmeanmat(:,R). Hence we fit the model curves for a range of M
    % values.
    % ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    % fitopt = fitoptions('Poly4', 'Robust', 'off');
    % [cf,gof,output] = fit(Mrange',dmeanvec','Poly4'); 

    % Hence, determine dmeanvec, from the supplied M value
    % dmeanvec(M) = = a*x^b+c

    % Forward model parameters for this particular R value.
    % >>>
    ap = cf.a;
    bp = cf.b;
    cp = cf.c;
    
% NOT USED>>>
%      % *** 5 Oct 2018 Correction Kn was used in model, but now used Mmain
%      % below: =>
%     TheD = ap*Mmain^bp+cp; % Apply model for alphabet size M = Kn.
%                         % and hence obtain the resulting estimated distance
%                         % D corresponding to the input alphabet size.
   
    % create actual curve output - Forward Model
    FitDmean = ap*Mrange.^bp+cp;
    %FitDmean = cf.p1*Mrange.^4 + cf.p2*Mrange.^3 + cf.p3*Mrange.^2 + cf.p4*Mrange + cf.p5;

    % FORWARD MODEL CURVES    
    if DoPlot == 1      
        %figure
        plot(Mrange, dmeanvec,'Color',[0.333333 0.666667 0],'Marker','none','LineStyle','-.','LineWidth',2);  % plot raw data as green lines
        hold on
        plot(Mrange,FitDmean ,'Color','r','LineStyle','-','LineWidth',3);  % plot fitted curve as red line
    end % DoPlot

end;   % for R = 1:Rmax,

if DoPlot == 1  
    
    set(gca,'FontSize',20);
    xlabel('$$M$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
    ylabel('$$D(M)$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');

    %xlim([0 250]);
    %titlestr = sprintf('$$r=$$%d..%d', 1,Rmax);
    %title(titlestr,'Interpreter','latex','FontSize',18,'HorizontalAlignment','center');

    % leg1 = legend('log($\hat{e_{h}}$) ','log($e_{h}$) ');
    % set(leg1,'Interpreter','latex');
    % set(leg1,'FontSize',20);
    % set(leg1,'position', [0.62 0.62 0.30 0.23]);

    set(gca,'XTick',[0 20 40 60 80 100]);

    set(gca,'linewidth',2);
    set(gca,'position',[0.13 0.18 0.8 0.72]);
    
    str = '$$r=1$$';
    text(80,10.5,str,'Interpreter','latex','FontSize',16);
    
    str = '$$r=2$$';
    text(80,14.5,str,'Interpreter','latex','FontSize',16);    
    
    str = '$$r=3$$';
    text(80,18.5,str,'Interpreter','latex','FontSize',16); 
    
    str = '$$r=4$$';
    text(80,22.5,str,'Interpreter','latex','FontSize',16);    
    
    str = '$$r=5$$';
    text(80,26.5,str,'Interpreter','latex','FontSize',16);       

    if DoFileSave == 1  
        % FORWARD MODEL CURVES
        FigFileNameEPS = sprintf('output/EntropyModela_R%d_M%d.eps', R, Mmain);
        FigFileNameJPG = sprintf('output/EntropyModela_R%d_M%d.jpg', R, Mmain);
        print('-deps',FigFileNameEPS)
        print('-djpeg',FigFileNameJPG)
    end

end % DoPlot


%=========================================================
% DO INVERSE MODEL
%=========================================================

 fprintf('Do inverse model..\n'); 
 
if DoPlot == 1      
    figure
end % DoPlot

    for R = 1:Rmax,
        %fprintf('R=%d\n',R);
        % M = y-axis and D = x-axis
        
        if R == 1
            xxx = 1;  % debug
        end

        % Fit this model using new data 
        fitopt = fitoptions('power2', 'Normalize', 'off', 'Robust', 'LAR', 'Algorithm', 'Levenberg-Marquardt', 'MaxFunEvals',1000);
        % options = optimset('MaxFunEvals',1000);
        %fitopt.StartPoint=[2.5, 0.35, 0.29 ];
        [cf,gof,output] = fit(dmeanmat(:,R),Mrange','power2', fitopt); 
        
        % ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        % ^^^^^^ Note that we reverse X and Y above cf forward model
        % ^^^^^^
        % In other words, we have the previous input M values and the
        % output D values, except now we simply invert and determine a
        % model which fits the M to the input D.
        % Note that this function fitting model requires some care with the
        % input data, ie you need enough data points or else it will
        % misbehave oand fail eith an error warning. If you get an error,
        % try increasing the number of statistical points used in the
        % calling function.
        % ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        
        
        % Hence, determine dmeanvec, from the supplied M value
        % dmeanvec(M) = = a*x^b+c

        % Inverse Model for this particular R value
        ap = cf.a;
        bp = cf.b;
        cp = cf.c;
        %%%TheK = ap*D^bp+cp;

        % create actual curve output - Inverse Model
        %FitK = ap*dmeanvec.^bp+cp;
        FitK = ap*dmeanmat(:,R).^bp+cp;  % ie FitK = M_hat

        % INVERSE MODEL        
        if DoPlot == 1          
            %figure
            plot(dmeanmat(:,R), Mrange,'Color',[0.333333 0.666667 0],'Marker','none','LineStyle','-.','LineWidth',2);  % plot raw data as green lines
            hold on
            plot(dmeanmat(:,R),FitK ,'Color','r','LineStyle','-','LineWidth',3);  % plot fitted curve as red line
        end % doPlot
        
    end;   % for R = 1:Rmax,
    
if DoPlot == 1   
    set(gca,'FontSize',20);
    xlabel('$$D$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
    ylabel('$$M$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');

    ylim([0 120]);
    titlestr = sprintf('$$r=$$%d..%d', 1,Rmax);
    title(titlestr,'Interpreter','latex','FontSize',18,'HorizontalAlignment','center');

    % leg1 = legend('log($\hat{e_{h}}$) ','log($e_{h}$) ');
    % set(leg1,'Interpreter','latex');
    % set(leg1,'FontSize',20);
    % set(leg1,'position', [0.62 0.62 0.30 0.23]);

    set(gca,'linewidth',2);
    set(gca,'position',[0.13 0.16 0.8 0.72]);

    if DoFileSave == 1
        % INVERSE MODEL
        FigFileNameEPS = sprintf('output/EntropyModelb_R%d_M%d.eps', R, Mmain);
        FigFileNameJPG = sprintf('output/EntropyModelb_R%d_M%d.jpg', R, Mmain);
        print('-deps',FigFileNameEPS)
        print('-djpeg',FigFileNameJPG)
    end
    
end % DoPlot

% The plots show models for each of the ranked R values. Below we select
% just one of the R values to return the parameters for, corresponding
% to the symbol of that rank.


%00000000000000000000000000000000000000000000000000000000000000000
% Select the Rank we wish to model
% 
% But note we could efficently output a set of models corresponding to
% different R values.
if DoVerbose == 1
 fprintf('Do Rank R=%d Model..\n', Rmodel); 
end 
%   R = 1;  % USED FOR TEST PHASE
% this was not inverted previously... it should be K = y-axis and D=x-axis

% Fit this model using new data 
fitopt = fitoptions('power2', 'Normalize', 'off', 'Robust', 'LAR', 'Algorithm', 'Levenberg-Marquardt', 'MaxFunEvals',1000);
[cf,gof,output] = fit(dmeanmat(:,Rmodel),Mrange','power2', fitopt); 
% Hence, determine dmeanvec, from the supplied M value
% dmeanvec(M) = = a*x^b+c

%     cf1 = cf;
%     
%     R = 2;  % USED FOR TEST PHASE
%     [cf2,gof,output] = fit(dmeanmat(:,R),Mrange','power2', fitopt); 
% 
%     R = 3;  % USED FOR TEST PHASE
%     [cf3,gof,output] = fit(dmeanmat(:,R),Mrange','power2', fitopt); 

% Final ZML Model Parameters to return
%
ap = cf.a;
bp = cf.b;
cp = cf.c;
        
% Save the current workspace
%
if DoFileSave == 1
   TheEntropyModel = sprintf('EntropyModel_R%d_M%d_', Rmodel, Mmain);
   FileName=[TheEntropyModel,datestr(now, 'yyyy-mmm-dd-HH-MM'),'.mat'];
   save(FileName);
end
    
    
