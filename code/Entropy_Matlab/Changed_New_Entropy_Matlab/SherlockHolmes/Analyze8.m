% 
% Analyze8.m
% based on analyzesyn7.m
% Andrew Back (c) 2018
%
% Reads in the synthetic symbolic text files from GenSyn3.m
%
%%
%load('monext18_2018-May-28-10-58');

% Note: ^^^^^ This is necessary unless we first run the BuildModel.
% Or load as below:

% <<< Load/Build Entropy Model >>>
%
% This is computed using BuildModelFn.m which does the heavy lifting in
% computing the Fast Entropy Model parameters.
% see BuildModel folder and then RunBuildFullModel.m
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

M = 27;

DoSaveFile = 1;  % Flag to indicate if results are saved

    Nbw = 0;   % 5; % window used from Bsym to be interleaved into Asym
    Naw = 0;

    % Base filename:
    %
    BaseDir = 'C:\data\corpora\';
%    BaseFile = [
    %BaseFile = 'C:\data\corpora\drseusscat';
    %BaseFile = 'C:\data\corpora\TomSawyer2short';
    %BaseFile = 'C:\data\corpora\sherlockholmes2';    

    RunNo = 6;
    
% SymbolizeFileFn (gensyn2.m) % run this twice with the different base filenames
%

% Read in each of the symbolic files
%


    %----------------------------------------------------------------------
    %
    % <<< Read in PLAIN text files and process >>>
    %
    BaseFile = 'C:\data\corpora\TomSawyer2';   
    BaseFile = 'corpora\sherlockholmes2';      
    TheFile = sprintf('%s.txt', BaseFile);  
    Asym = fileread(TheFile);      
    Na = length(Asym);  % ~ 402268
    
    
    BaseFile = 'corpora\drseusscat';
    TheFile = sprintf('%s.txt', BaseFile);  
    Bsym = fileread(TheFile);      
    Nb = length(Bsym);  % ~ 30650
    
    
    % Test:
%     Asym = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
%     Bsym = 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB';
    
   % Synthesize aggregate PLAIN TEXT file
   %
   Csym = '';
   Nbw = 4000;   % 5; % window used from Bsym to be interleaved into Asym
   Np  = 3;      % 4; % 50 x Np = 25000 < Nb
   Naw = 70000;  % 8; % 8000 x Np = 400,000 < Na
   
%    Nbw = 3000;   % 5; % window used from Bsym to be interleaved into Asym
%    Np  = 4;      % 4; % 50 x Np = 25000 < Nb
%    Naw = 50000;  % 8; % 8000 x Np = 400,000 < Na   
   
%    Nbw = 1000;   % 5; % window used from Bsym to be interleaved into Asym
%    Np  = 10;      % 4; % 50 x Np = 25000 < Nb
%    Naw = 20000;  % 8; % 8000 x Np = 400,000 < Na
%    
%     Nbw = 2000;   % 5; % window used from Bsym to be interleaved into Asym
%     Np  = 5;      % 4; % 50 x Np = 25000 < Nb
%     Naw = 40000;  % 8; % 8000 x Np = 400,000 < Na   
% 
%     Nbw = 6000;   % 5; % window used from Bsym to be interleaved into Asym
%     Np  = 2;      % 4; % 50 x Np = 25000 < Nb
%     Naw = 100000;  % 8; % 8000 x Np = 400,000 < Na  
    
   for i = 1:Np,  
       Astart = ((i-1)*Naw)+1;
       Aend   = (i*Naw);
       Bstart = ((i-1)*Nbw)+1;
       Bend   = (i*Nbw);       
       Ablock = Asym(Astart:Aend);
       Bblock = Bsym(Bstart:Bend);
       Csym = strcat(Csym,Ablock);
       Csym = strcat(Csym,Bblock);
   end
   

   % Save the combined file:

   if DoSaveFile == 1 
    BaseFile = 'C:\data\corpora\TomSeuss';    
    BaseFile = 'corpora\SherlockSeuss';   
    TheFile = sprintf('%s_%d.txt', BaseFile, RunNo);
    fprintf('\n\n Save the combined file: %s \n', TheFile);  
    fid = fopen(TheFile,'wt');    
    fprintf(fid, '%s', Csym);
    fclose(fid);       
   end
      
    %----------------------------------------------------------------------
    %
    % <<< Read in SYMBOLIC text files and process >>>
    %
    BaseFile = 'C:\data\corpora\output\TomSawyer2';    
    BaseFile = 'corpora\output\sherlockholmes2';      
    TheFile = sprintf('%s_gx%d.txt', BaseFile, RunNo);    
    Asym = fileread(TheFile);      
    Na = length(Asym);  % ~ 144714 TS,  ~ 211220 SH
    
    
    BaseFile = 'corpora\output\drseusscat';
    TheFile = sprintf('%s_gx%d.txt', BaseFile, RunNo);     
    Bsym = fileread(TheFile);      
    Nb = length(Bsym);  % ~ 12712 DS 
    
   % Synthesize aggregate SYMBOLIC file
   %
   Csym = '';
%    %Nbw = 2000;   % 5; % window used from Bsym to be interleaved into Asym
%    %Np  = 5; % 25;   % 4; % 25 x Np = 12500 < Nb
%    %Naw = floor(Na/Np);  % 8448 SH .. 2000;  % 8; % 2000 x Np = 50,000 < 125,000 < Na
%    Naw2 = floor(Naw/Nbw); % ie the multiple of Ablock cf Bblock
%    Naw = Naw2*Nbw;        % the final size of Naw so that we can have an even multiple of Nbw vs Naw
%    Ndivb = 4;         % number of segments in Nbw
%    Nsegb = Nbw/Ndivb;  % eg 1000/4 = 250 = now the size we use for all H calcs
%    %Ndiva = Naw/Nseg;  % segment size in Naw   
%    Ndiva = Ndivb*4;
%    Nsega = Naw/Ndiva;  % Hence Nsega*Ndiva*Np < Na
      
    Ndivb = 4;          % number of segments in Nbw
    Nsegb = Nbw/Ndivb;  % eg 2000/4 = 500 = now the size we use for all Heb calcs
    Ndiva = 35;         % number of segments in Nba
    Nsega = Naw/Ndiva;  % eg 40,000/20 = 2000 = now the size we use for all Hea calcs  
    
%     Ndivb = 4;          % number of segments in Nbw
%     Nsegb = Nbw/Ndivb;  % eg 2000/4 = 500 = now the size we use for all Heb calcs
%     Ndiva = 20;         % number of segments in Nba
%     Nsega = Naw/Ndiva;  % eg 40,000/20 = 2000 = now the size we use for all Hea calcs      
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Nbw = 20;           % window used from Bsym to be interleaved into Asym
%     Np  = 3;            % 4; % 50 x Np = 25000 < Nb
%     Naw = 36;           %    
%     Ndivb = 4;          % number of segments in Nbw
%     Nsegb = Nbw/Ndivb;  % eg 2000/4 = 500 = now the size we use for all Heb calcs
%     Ndiva = 4;         % number of segments in Nba
%     Nsega = Naw/Ndiva;  % eg 40,000/20 = 2000 = now the size we use for all Hea calcs  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   for i = 1:Np,  
       Astart = ((i-1)*Naw)+1;
       Aend   = (i*Naw);
       Bstart = ((i-1)*Nbw)+1;
       Bend   = (i*Nbw);       
       Ablock = Asym(Astart:Aend);
       Bblock = Bsym(Bstart:Bend);
       Csym = strcat(Csym,Ablock);
       Csym = strcat(Csym,Bblock);
   end
   

   % Save the combined file:
     if DoSaveFile == 1 
        BaseFile = 'corpora\Combined2';   
        TheFile = sprintf('%s_gx%d.txt', BaseFile, RunNo);    
        fprintf('\n\n Save the combined file: %s \n', TheFile);          
        fid = fopen(TheFile,'wt');    
        fprintf(fid, '%s', Csym);
        fclose(fid);   
     end

    %----------------------------------------------------------------------
    %
    % <<< Compute Entropy on the SYMBOLIC text >>>
    %

    
    fprintf('\n\n Compute Entropy on the SYMBOLIC text \n');  
    %fprintf('Read  from file\nHa(English) = 4.1\nHa(Tom Sawyer) = 4.4\n');    
   

        
    % 1-gram analysis where we use an intermediate step in which we
    % symbolize utterance length
    
    
    % DO A RUN OVER Nf BLOCKS OF TEXT TO DETERMINE He
    
    % Temp >>>>>>>>>>>>>>>>>>>>>>>>>
    %Csym = Asym;
    % >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    Nc = length(Csym);
    Ncw = 2000;
    Nf = floor(Nc/Ncw);
    
    MeanHea = 0;        
    MeanHeb = 0;  
    Hp = zeros(1,Nf);  
    Hp = [];
    Xp = [];
    Hpa = zeros(1,Nf);
    Hpb = zeros(1,Nf);    
    Xh = zeros(1,Nf);    
    ia = 0;  % actual i count index (note that there may be invalid blocks where no symbols are detected)
    ib = 0;
    nc = 0;
    Astart = 1;
    xcount = 2;    
    Hea = 0;
    Heb = 0;
    
    % Now compute rank r distances for specific symbol        
    CSymbol = 'C';    
    RunType = 'C';  % A, B or C (A+B)
    
    for i = 1:1, 
           
           for k=1:1
               % get multiple values of Ablock .. eg Ndiva = 84, 84*250 = 21000
               % 
               %Astart = nc + 1;
               %Aend   = nc + Nsega; 
               Aend   = Astart + Nsega - 1;  
               Ablock = Csym(1:2000);      
               fprintf('Astart %4.3f - Aend %4.3f \n',Astart, Aend);

                if (RunType == 'A') || (RunType == 'C')   % eg CSymbol = 'C' , W = end of sentence, char(32)32 = space, 42 = *, 46 = full stop
                                                                           
                   [Hea] = fastentropyblock(Ablock, Nsega, CSymbol, M, ap, bp, cp);
                   fprintf('********** Hea - %4.8f \n',Hea);
                   Hp = [Hp Hea];
                   if k <= Ndiva 
                     xcount = xcount + Nsega;
                   end               
                   Xp = [Xp xcount-2];
                   
                end

               %nc = Aend;
               Astart = Aend + 1; 
           end 
   end; % end of i Nf
  
    % Save the entropy file:
    %*****************UNCOMMENT LATER
%    if DoSaveFile == 1     
%     BaseFile = 'corpora\output\H';   
%     TheFile = sprintf('%s_gx%d%s%s.txt', BaseFile, RunNo, lower(CSymbol), lower(RunType));   
%     fprintf('\n\n Save the entropy file: %s \n', TheFile);      
%     fid = fopen(TheFile,'wt');    
%     fprintf(fid, '%5.4f\n', Hp);
%     fclose(fid);   
%    end
   
    
   MeanHe = mean(Hp);  % MeanHe/i;
   
   % Only use this from Asym:
   %
   n  = length(Hp);
   
   % We compute the bounds based on the long term entropy 
   % 
   % if (RunType == 'A')  % eg CSymbol = 'C' , W = end of sentence, char(32)32 = space, 42 = *, 46 = full stop
       Hm = mean(Hp);
       Hv = var(Hp);
       Hs = std(Hp);
   % end
   
   Hsp1 = (Hm + 1*Hs) .* ones(1,n);
   Hsm1 = (Hm - 1*Hs) .* ones(1,n);
   Hsp2 = (Hm + 2*Hs) .* ones(1,n);
   Hsm2 = (Hm - 2*Hs) .* ones(1,n);   
   
   %fprintf('Combined file (TS + DS): mean He(file)(%2.0f) = %5.4f \n',Kest, MeanHe); 
   
%    figure
%    plot(Xp,Hp);

%    hold on
%    plot(Xh,Hsp2,'Color','r','LineStyle','-.','LineWidth',2);  % plot fitted curve as red line
%    hold on
%    plot(Xh,Hsm2,'Color','r','LineStyle','-.','LineWidth',2);  % plot fitted curve as red line   

% Normalize the points on x axis
%
Xp = Xp ./ 1000;
   
%    figure
%   % plot(Hp);
%    plot(Xp, Hp,'Color','black','Marker','none','LineStyle','-','LineWidth',2);  % plot raw data as green lines
%    hold on
%    plot(Xp, Hsp2,'Color','r','LineStyle','-.','LineWidth',2);  % plot fitted curve as red line
%    hold on
%    plot(Xp, Hsm2,'Color','r','LineStyle','-.','LineWidth',2);  % plot fitted curve as red line   
%    
%    Nxp = length(Xp);
%    xlast = Xp(Nxp);
%    xlim([0 xlast]);
%    ylim([4.2 4.30]);
%    
%    set(gca,'FontSize',20);
%    xlabel('$$n(k)$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
%    ylabel('$$H(n)$$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
% 
%    set(gca,'position',[0.18 0.16 0.77 0.73]);
%    
%    titlestr = sprintf('$$H_{%s}, N_{w}=$$(%d,%d)', lower(RunType), Nsega, Nsegb);
%    title(titlestr,'Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
   
    %xlim([0 250]);
    %titlestr = sprintf('$$r=$$%d..%d', 1,Rmax);
    %title(titlestr,'Interpreter','latex','FontSize',18,'HorizontalAlignment','center');

    % leg1 = legend('log($\hat{e_{h}}$) ','log($e_{h}$) ');
    % set(leg1,'Interpreter','latex');
    % set(leg1,'FontSize',20);
    % set(leg1,'position', [0.62 0.62 0.30 0.23]);

%     set(gca,'XTick',[0 20 40 60 80 100]);
% 
%     set(gca,'linewidth',2);
% %     set(gca,'position',[0.13 0.18 0.8 0.72]);
%        
% 
%    if DoSaveFile == 1 
%     FigFileNameEPS = sprintf('output/H%s%s%d_%d.eps', lower(CSymbol), lower(RunType), Nsega, Nsegb);
%     FigFileNameJPG = sprintf('output/H%s%s%d_%d.jpg', lower(CSymbol),lower(RunType), Nsega, Nsegb);
%     fprintf('\n\n Save the image files: %s \n', FigFileNameJPG);      
%     print('-deps',FigFileNameEPS)
%     print('-djpeg',FigFileNameJPG)
%    end
   
    
   
    

   
   
   