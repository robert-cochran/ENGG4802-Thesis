
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
          
% This computes the functional used to warp the measured
% probabiltiies to obtain a more accurate entropy with the values being
% returned in the Cwarp vector. It is effectively measuring the difference
% between the theoretical Zipfian curve and the actual Zipfian curve 
% and using this as a correction functional.
%
% Derived from ZMLWarp.m
%
% Input(s):  M  - Alphabet size (number of symbols)
%
%-----------------------------------------------------------------

function [x, Cwarp] = ZMLWarpFn(M, DoPlot, DoFileSave)

% Simple entropy test Using Zipf-Mandelbrot-Li

Kn = M;  % 27;        % number of symbols
fprintf('K=%d\n',Kn);

  
    %----------------------------------------------------------------------
    % Compute probabilities according to Zipfian model ====================
    %
    M1 = M + 1; 

    a = log2(M1)/log2(M);
    beta = M/(M1);
    gamma = M^(a-1)/(M-1)^a;

    p = zeros(1,M);
    x = [(1:M)];
    psum = 0;
        for r = 1:M,        
            Pr = gamma/(r + beta)^a;
            p(r) = Pr;
            psum = psum + Pr;
            if (r <= 5)
             %fprintf('Pr(%d) = %4.3f \n',r, Pr); 
            end; 
        end;
        
    % Calculate actual entropy (unnormalized)
    
    Ha = 0;
    for r = 1:M,       
      Ha = Ha + p(r) * log2( p(r) );       
    end;
    Ha = -Ha;
    %fprintf('Entropy (unnormalized) - Ha(%d) = %4.3f \n',Kn, Ha);         
               
      %fprintf('Unnormalized psum = %4.3f\n', psum);   
      knorm = psum;
      
     % Normalize.... 
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
      %fprintf('Normalised psum = %4.3f\n', psum);   
      
    % Calculate actual entropy
    
    Ha = 0;
    for r = 1:M,       
      Ha = Ha + p(r) * log2( p(r) );       
    end;
    Ha = -Ha;
    fprintf('Entropy (normalized)- Ha(%d) = %4.3f \n',Kn, Ha);
    
    % Fit a curve to the Zipfian model data
    %
    
    % General model Power2:
    %        f(x) = a*x^b+c
    % Coefficients (with 95% confidence bounds):
    %        a =      0.2044  (0.2026, 0.2063)
    %        b =     -0.7251  (-0.743, -0.7071)
    %        c =   -0.007335  (-0.008939, -0.005731)
    % 
    % Goodness of fit:
    %   SSE: 1.771e-005
    %   R-square: 0.9995
    %   Adjusted R-square: 0.9995
    %   RMSE: 0.0008591
    
    fitopt = fitoptions('power2', 'Normalize', 'off', 'Robust', 'on', 'Algorithm', 'Trust-Region');
    [cf,gof,output] = fit(x',p','power2', fitopt);     
    
    ah = cf.a;
    bh = cf.b;
    ch = cf.c;
    
    phat = ah*x.^bh+ch;

    
%%%%%%%%%%%%%%%%% PLOT RESULTS %%%%%%%%%%%%%%%%%%%
 
% gray line test
%  k = 12;
%  grayrgb = [0 0 0]+0.05*k;
%  figure
%  t=0:0.1:10;
%  y=sin(t);
%  plot(t,y,'linewidth',8,'Color',grayrgb);
 
if DoPlot == 1    
    figure
    k = 5;
    grayrgb = [0 0 0]+0.05*k;
    plot(x,phat,'Color',grayrgb,'MarkerSize',2,'Marker','s','MarkerEdgeColor','r','MarkerFaceColor','r','LineStyle','-','LineWidth',2);  % plot raw data as green lines

    set(gca,'FontSize',20);
    xlabel('$$r$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
    ylabel('$$\hat{p}(r)$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');

    %ylim([0 120]);
    %titlestr = sprintf('$$r=$$%d..%d', 1,Rmax);
    %title(titlestr,'Interpreter','latex','FontSize',18,'HorizontalAlignment','center');

    % leg1 = legend('log($\hat{e_{h}}$) ','log($e_{h}$) ');
    % set(leg1,'Interpreter','latex');
    % set(leg1,'FontSize',20);
    % set(leg1,'position', [0.62 0.62 0.30 0.23]);

    set(gca,'linewidth',2);
    set(gca,'position',[0.18 0.16 0.75 0.72]);

    if DoFileSave == 1
        FigFileNameEPS = sprintf('zmlwarp1_r%d.eps', M);
        FigFileNameJPG = sprintf('zmlwarp1_r%d.jpg', M);
        print('-deps',FigFileNameEPS)
        print('-djpeg',FigFileNameJPG)
    end

    figure
    %plot(x,C,'Color',grayrgb,'MarkerSize',1,'Marker','s','MarkerEdgeColor','r','MarkerFaceColor','r','LineStyle','-','LineWidth',2);  % plot raw data as green lines
    plot(x,phat,'Color','b','LineStyle','-','LineWidth',2);  % plot raw data as green lines

    set(gca,'FontSize',20);
    xlabel('$$r$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
    ylabel('$$\hat{p}(r)$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');

    %ylim([0 1.75]);
    %titlestr = sprintf('$$r=$$%d..%d', 1,Rmax);
    %title(titlestr,'Interpreter','latex','FontSize',18,'HorizontalAlignment','center');

    % leg1 = legend('log($\hat{e_{h}}$) ','log($e_{h}$) ');
    % set(leg1,'Interpreter','latex');
    % set(leg1,'FontSize',20);
    % set(leg1,'position', [0.62 0.62 0.30 0.23]);

    set(gca,'linewidth',2);
    set(gca,'position',[0.18 0.16 0.75 0.72]);

    if DoFileSave == 1
        FigFileNameEPS = sprintf('warpphat%d.eps', M);
        FigFileNameJPG = sprintf('warpphat%d.jpg', M);
        fprintf('Saving file .. %s\n',FigFileNameJPG); 
        print('-deps',FigFileNameEPS)
        print('-djpeg',FigFileNameJPG)  
    end

end % DoPlot

    %%%%%%%%%%%%%%%%%
    
    Y = [
        0.0703
        0.0104
        0.0255
        0.0317
        0.1010
        0.0202
        0.0132
        0.0451
        0.0571
        0.0019
        0.0050
        0.0278
        0.0229
        0.0561
        0.0565
        0.0198
        0.001
        0.0507
        0.0540
        0.0821
        0.0241
        0.0077
        0.0165
        0.002
        0.0148
        0.0006
        0.1820]';
    X = [1:27];
    
    Ys = sort(Y,'descend');
    
    % Calculate actual entropy
    pa = Ys;
    
    Ha = 0;
    for r = 1:M,       
      Ha = Ha + pa(r) * log2( pa(r) );       
    end;
    Ha = -Ha;
    fprintf('Actual English Entropy: Ha = %5.4f bits\n', Ha);    %  
           
    
    fitopt2 = fitoptions('Gauss6', 'Normalize', 'off', 'Robust', 'off', 'Algorithm', 'Trust-Region');
    [cf,gof,output] = fit(X',Ys','Gauss6', fitopt2);     
    
    
%     General model Gauss6:
%        f(x) = 
%               a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2) + 
%               a3*exp(-((x-b3)/c3)^2) + a4*exp(-((x-b4)/c4)^2) + 
%               a5*exp(-((x-b5)/c5)^2) + a6*exp(-((x-b6)/c6)^2)
% Coefficients (with 95% confidence bounds):
%        a1 =    -0.01918  (-1.533e+004, 1.533e+004)
%        b1 =       1.173  (-1.198e+006, 1.198e+006)
%        c1 =      0.7986  (-1.565e+006, 1.565e+006)
%        a2 =     0.02534  (-3165, 3166)
%        b2 =       3.183  (-6.933e+004, 6.934e+004)
%        c2 =       1.183  (-3.331e+004, 3.331e+004)
%        a3 =       1.041  (-847.6, 849.7)
%        b3 =      -4.719  (-3228, 3218)
%        c3 =       12.33  (-504.1, 528.8)
%        a4 =    -0.07996  (-3016, 3016)
%        b4 =       5.752  (-2.172e+004, 2.173e+004)
%        c4 =       2.702  (-6498, 6503)
%        a5 =     -0.4728  (-1.676e+004, 1.676e+004)
%        b5 =       1.453  (-1.116e+005, 1.116e+005)
%        c5 =       3.427  (-8.49e+004, 8.491e+004)
%        a6 =     -0.2725  (-140.2, 139.7)
%        b6 =       5.952  (-1268, 1280)
%        c6 =       7.292  (-436.1, 450.7)
% 
% Goodness of fit:
%   SSE: 2.946e-005
%   R-square: 0.9993
%   Adjusted R-square: 0.9979
%   RMSE: 0.001809

       a1 =  cf.a1;
       b1 =  cf.b1;
       c1 =  cf.c1;
       a2 =  cf.a2;
       b2 =  cf.b2;
       c2 =  cf.c2;
       a3 =  cf.a3;
       b3 =  cf.b3;
       c3 =  cf.c3;
       a4 =  cf.a4;
       b4 =  cf.b4;
       c4 =  cf.c4;
       a5 =  cf.a5;
       b5 =  cf.b5;
       c5 =  cf.c5;
       a6 =  cf.a6;
       b6 =  cf.b6;
       c6 =  cf.c6;

       x = X;
       pa =   a1*exp(-((x-b1)/c1).^2) + a2*exp(-((x-b2)/c2).^2) + ...
              a3*exp(-((x-b3)/c3).^2) + a4*exp(-((x-b4)/c4).^2) + ...
              a5*exp(-((x-b5)/c5).^2) + a6*exp(-((x-b6)/c6).^2);
          
          % this is the model of the actual English language probabilities
          
          % Hence obtain the functional used to warp the measured
          % probabiltiies to obtain a more accurate entropy:
          

    
    Cwarp = pa ./ phat;      % Warping functional
    CWarpRun = 1;
    
  
if DoPlot == 1    
    
    figure
    %plot(x,C,'Color',grayrgb,'MarkerSize',1,'Marker','s','MarkerEdgeColor','r','MarkerFaceColor','r','LineStyle','-','LineWidth',2);  % plot raw data as green lines
    plot(x,Cwarp,'Color','b','LineStyle','-','LineWidth',2);  % plot raw data as green lines

    set(gca,'FontSize',20);
    xlabel('$$r$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
    ylabel('$$C(r;p,\hat{p})$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');

    ylim([0 1.75]);
    %titlestr = sprintf('$$r=$$%d..%d', 1,Rmax);
    %title(titlestr,'Interpreter','latex','FontSize',18,'HorizontalAlignment','center');

    % leg1 = legend('log($\hat{e_{h}}$) ','log($e_{h}$) ');
    % set(leg1,'Interpreter','latex');
    % set(leg1,'FontSize',20);
    % set(leg1,'position', [0.62 0.62 0.30 0.23]);

    set(gca,'linewidth',2);
    set(gca,'position',[0.18 0.16 0.75 0.72]);

    if DoFileSave == 1
        FigFileNameEPS = sprintf('warpC1%d.eps', M);
        FigFileNameJPG = sprintf('warpC1%d.jpg', M);
        fprintf('Saving file .. %s\n',FigFileNameJPG); 
        print('-deps',FigFileNameEPS)
        print('-djpeg',FigFileNameJPG)
    end

    figure
    %plot(x,C,'Color',grayrgb,'MarkerSize',1,'Marker','s','MarkerEdgeColor','r','MarkerFaceColor','r','LineStyle','-','LineWidth',2);  % plot raw data as green lines
    plot(x,pa,'Color','b','LineStyle','-','LineWidth',2);  % plot raw data as green lines

    set(gca,'FontSize',20);
    xlabel('$$r$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
    ylabel('$$p_{a}(r)$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');

    %ylim([0 1.75]);
    %titlestr = sprintf('$$r=$$%d..%d', 1,Rmax);
    %title(titlestr,'Interpreter','latex','FontSize',18,'HorizontalAlignment','center');

    % leg1 = legend('log($\hat{e_{h}}$) ','log($e_{h}$) ');
    % set(leg1,'Interpreter','latex');
    % set(leg1,'FontSize',20);
    % set(leg1,'position', [0.62 0.62 0.30 0.23]);

    set(gca,'linewidth',2);
    set(gca,'position',[0.18 0.16 0.75 0.72]);

    if DoFileSave == 1
        FigFileNameEPS = sprintf('warpa%d.eps', M);
        FigFileNameJPG = sprintf('warpa%d.jpg', M);
        fprintf('Saving file .. %s\n',FigFileNameJPG); 
        print('-deps',FigFileNameEPS)
        print('-djpeg',FigFileNameJPG)
    end

end % DoPlot
   