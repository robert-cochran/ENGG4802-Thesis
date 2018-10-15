
% SymbolizeFileFn 
% .. derived from gensyn2.m
% Andrew Back (c) 2018
%
% This reads in a text file and then symbolicizes it and saves to a new
% file:
% basefilename_gxN.txt = output symbolic file
% basefilename_gzN.txt = output symbolic file with interword pauses dropped (symbol = 'Z')
%
% This is derived from cd_montext21.m
%
%%
%load('monext18_2018-May-28-10-58');

function SymbolizeFileFn(RunNo, BaseFile, OutputFile)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Experiment 2(e)
    % Entropy of whole English text - Tom Sawyer
    %
    %[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
    %======================--------------------------------------------------
    
    %fprintf('\n\n=====Experiment 2(g) - Real English text - Tom Sawyer\n');  
    %fprintf('Read  from file\nHa(English) = 4.1\nHa(Tom Sawyer) = 4.4\n');  
    
    % Base filename:
    %
%       %BaseFile = 'C:\data\corpora\drseusscat';
%       %BaseFile = 'C:\data\corpora\TomSawyer2short';
%       %BaseFile = 'C:\data\corpora\TomSawyer2';    
%     BaseFile = 'C:\data\corpora\sherlockholmes2';     
%     
%       %OutputFile = 'C:\data\corpora\TomSawyer2';    
%     OutputFile = 'C:\data\corpora\output\sherlockholmes2';        
    
%    RunNo = 9;
    
    % Refs: Introduction to Cryptography with Open-Source Software
    %       Alasdair McAndrew
    %       Usher and Guy, Information and Communicatin for Engineers

    % This should be done automatically, but for this simple test, the data
    % is below, corresponding to the symbol distance between the rank r = 1
    % symbols, which are the spaces. Punctuation is removed. Beginning at
    % Ch 2: 
    
    % SATURDAY morning was come, and all the summer world was bright and
    % fresh, and brimming with life. There was a song in every heart; and if
    % the heart was young the music issued at the lips. There was cheer in
    % every face and a spring in every step. The locust-trees were in bloom    
    
%     Line1 = [10 9 5 6 5 5 5 8 7 5];
%     Line2 = [7 5 10 6 7 5 3 6 4 7 5 4];
%     Line3 = [5 7 5 7 5 7 8 4 5 6 7 5 7 4];
%     Line4 = [7 6 5 7 5 8 4 7 6 5 8 7 6 4 7];
%     D = [Line1 Line2 Line3 Line4];
%     Dhcount = length(D);
%     dmeantest = mean(D);  %  6.0392
    
    % Read in actual text file and process
    %
   % filetext = fileread('C:\data\corpora\TomSawyer2short.txt');
     TheFile = sprintf('%s.txt', BaseFile);
    %filetext = fileread('C:\data\corpora\drseusscat.txt');    
    filetext = fileread(TheFile);       
    astr = filetext;  %(1:5000);
    % Remove unwanted chars: (  ) \r \n ! " - , , ? ] [ * _ : /
 
    astr = strrep(astr,sprintf('^'),'');    % Remove this character    
    %astr = strrep(astr,sprintf('*'),'^');       
    
    % Filter letters
    % Convert to all lower case, should now only have 27 unique characters
    % in alphabet.
    %
    astr = lower(astr);    
    
    % filter symbols
    %
%     astr = strrep(astr,sprintf('a'),'*');
%     astr = strrep(astr,sprintf('b'),'*');    
%     astr = strrep(astr,sprintf('c'),'*');
%     astr = strrep(astr,sprintf('d'),'*');    
%     astr = strrep(astr,sprintf('e'),'*');
%     astr = strrep(astr,sprintf('f'),'*');        
%     astr = strrep(astr,sprintf('g'),'*');
%     astr = strrep(astr,sprintf('h'),'*');    
%     astr = strrep(astr,sprintf('i'),'*');
%     astr = strrep(astr,sprintf('j'),'*');    
%     astr = strrep(astr,sprintf('k'),'*');
%     astr = strrep(astr,sprintf('l'),'*');   
%     astr = strrep(astr,sprintf('m'),'*');
%     astr = strrep(astr,sprintf('n'),'*');    
%     astr = strrep(astr,sprintf('o'),'*');
%     astr = strrep(astr,sprintf('p'),'*');    
%     astr = strrep(astr,sprintf('q'),'*');
%     astr = strrep(astr,sprintf('r'),'*');        
%     astr = strrep(astr,sprintf('s'),'*');
%     astr = strrep(astr,sprintf('t'),'*');    
%     astr = strrep(astr,sprintf('u'),'*');
%     astr = strrep(astr,sprintf('v'),'*');    
%     astr = strrep(astr,sprintf('w'),'*');
%     astr = strrep(astr,sprintf('x'),'*');      
%     astr = strrep(astr,sprintf('y'),'*');
%     astr = strrep(astr,sprintf('z'),'*');     
    
% ZZZZZZZZZZZZZZZZZZZ
    astr(ismember(double(astr),[48:57])) = '*';  %# Convert numbers to *
    astr(ismember(double(astr),[64:90])) = '*';  %# Convert uc letters to *
    astr(ismember(double(astr),[96:122])) = '*';  %# Convert lc letters to *    
    
   %%-----------------------
   
   % Remove non ASCII chars
   astr(ismember(double(astr),[128:512])) = '';  %# Remove characters based on
                                                 %#   their integer code   
                                                 
                                                 
   % Remove extraneous characters
    
    %astr = strrep(astr,sprintf('\n'),'');
    %astr = strrep(astr,sprintf('\r'),'');

    %astr = strrep(astr,sprintf('\r\n'),' ');
    astr = strrep(astr,sprintf('('),'');
    astr = strrep(astr,sprintf(')'),'');
    %astr = strrep(astr,sprintf('--'),' ');    
    %astr = strrep(astr,sprintf('-'),'!');      
 
    astr = strrep(astr,sprintf('/'),'');
    astr = strrep(astr,sprintf('['),'');
    astr = strrep(astr,sprintf(']'),'');
    astr = strrep(astr,sprintf('^'),'');      
    
   %%% astr = strrep(astr,sprintf('.'),'!');
    astr = strrep(astr,char(39),'');    % apostrophe
    astr = strrep(astr,sprintf('"'),'');
    
    %astr = strrep(astr,sprintf('-'),' '); 
    %astr = strrep(astr,sprintf('-'),' ');  % replace hyphen with space, but be careful, it might be suitable for all situations
                                                      
                                                 
   
   % Filter out pauses
   % Note: consider the possibility that there will be one or more spaces
   % immediately after the specified symbol, eg semicolon space, full stop
   % space. etc
   
    % V5
    astr = strrep(astr,sprintf('.\r\n\r\n\r\n\r\n\r\n\r\n'),'V');    
    astr = strrep(astr,sprintf('.\r\n\r\n\r\n\r\n\r\n'),'V');        
    astr = strrep(astr,sprintf('.\r\n\r\n\r\n\r\n'),'V');        
    astr = strrep(astr,sprintf('.\r\n\r\n\r\n'),'V');        
     
    astr = strrep(astr,sprintf('\r\n\r\n\r\n\r\n'),'V');    
    astr = strrep(astr,sprintf('\r\n\r\n\r\n'),'V');  
    astr = strrep(astr,sprintf('\r\n\r\n'),'V');  
    astr = strrep(astr,sprintf('\r\n'),'V');      

    astr = strrep(astr,sprintf('.\n\n\n\n\n\n'),'V');    
    astr = strrep(astr,sprintf('.\n\n\n\n\n'),'V');         
    astr = strrep(astr,sprintf('.\n\n\n\n'),'V');      
    astr = strrep(astr,sprintf('.\n\n\n'),'V');         
    astr = strrep(astr,sprintf('.\n\n'),'V');
    astr = strrep(astr,sprintf('.\n'),'V');    
    
    astr = strrep(astr,sprintf('\n\n\n\n'),'V');      
    astr = strrep(astr,sprintf('\n\n\n'),'V');   
    astr = strrep(astr,sprintf('\n\n'),'V');       
    astr = strrep(astr,sprintf('\n'),'V');      
    
    % with spaces
    astr = strrep(astr,sprintf('...\r\n\r\n '),'V');   % 1 space     
    astr = strrep(astr,sprintf('..\r\n\r\n '),'V');    % 1 space      
    astr = strrep(astr,sprintf('.\r\n\r\n '),'V');     % 1 space    
    astr = strrep(astr,sprintf('...\r\n\r\n  '),'V');  % 2 spaces     
    astr = strrep(astr,sprintf('..\r\n\r\n  '),'V');   % 2 spaces      
    astr = strrep(astr,sprintf('.\r\n\r\n  '),'V');    % 2 spaces      
    astr = strrep(astr,sprintf('\r\n\r\n '),'V');  
    
    astr = strrep(astr,sprintf('!\r\n\r\n  '),'V');    % 2 spaces         
    astr = strrep(astr,sprintf('!\r\n\r\n '),'V');     % 1 space 
    
    astr = strrep(astr,sprintf('!\r\n\r\n'),'V');       
    astr = strrep(astr,sprintf('.\r\n\r\n'),'V');       
    astr = strrep(astr,sprintf('\r\n\r\n'),'V'); 
    
    astr = strrep(astr,sprintf(':\r\n\r\n'),'V');     
    
     
    %V4
    % with spaces
    astr = strrep(astr,sprintf('!!! '),'W');   % 1 space
    astr = strrep(astr,sprintf('!! '),'W');    % 1 space   
    astr = strrep(astr,sprintf('! '),'W');     % 1 space 
    astr = strrep(astr,sprintf('!!!  '),'W');  % 2 spaces
    astr = strrep(astr,sprintf('!!  '),'W');   % 2 spaces   
    astr = strrep(astr,sprintf('!  '),'W');    % 2 spaces     
    astr = strrep(astr,sprintf('?? '),'W');    % 1 space
    astr = strrep(astr,sprintf('? '),'W');     % 1 space  
    astr = strrep(astr,sprintf('??  '),'W');   % 2 spaces
    astr = strrep(astr,sprintf('?  '),'W');    % 2 spaces     
    astr = strrep(astr,sprintf('..  '),'W');   
    astr = strrep(astr,sprintf('.  '),'W');  
    astr = strrep(astr,sprintf('.. '),'W');   
    astr = strrep(astr,sprintf('. '),'W');      
    astr = strrep(astr,sprintf('\r\n '),'W');
    
    astr = strrep(astr,sprintf('!!!'),'W');  
    astr = strrep(astr,sprintf('!!'),'W');      
    astr = strrep(astr,sprintf('!'),'W');      
    astr = strrep(astr,sprintf('???'),'W');    
    astr = strrep(astr,sprintf('??'),'W');     
    astr = strrep(astr,sprintf('?'),'W');       
    astr = strrep(astr,sprintf('...'),'W');   
    astr = strrep(astr,sprintf('..'),'W');      
    astr = strrep(astr,sprintf('.'),'W');       
    astr = strrep(astr,sprintf('\r\n'),'W');    
    
    % V3
    % with 2 spaces
    astr = strrep(astr,sprintf(':  '),'X');
    astr = strrep(astr,sprintf(';  '),'X');     
    astr = strrep(astr,sprintf('---  '),'X');
    astr = strrep(astr,sprintf('--  '),'X');    
    astr = strrep(astr,sprintf('-  '),'X');  
    astr = strrep(astr,sprintf('__  '),'X');
    astr = strrep(astr,sprintf('_  '),'X');      
    
    % with 1 space
    astr = strrep(astr,sprintf(': '),'X');
    astr = strrep(astr,sprintf('; '),'X');     
    astr = strrep(astr,sprintf('--- '),'X');
    astr = strrep(astr,sprintf('-- '),'X');    
    astr = strrep(astr,sprintf('- '),'X');  
    astr = strrep(astr,sprintf('__ '),'X');
    astr = strrep(astr,sprintf('_ '),'X');    
    
    astr = strrep(astr,sprintf(':'),'X');
    astr = strrep(astr,sprintf(';'),'X');     
    astr = strrep(astr,sprintf('--'),'X');
    astr = strrep(astr,sprintf('-'),'X');  
    astr = strrep(astr,sprintf('__'),'X');
    astr = strrep(astr,sprintf('_'),'X');        
    
    % V2
    % with spaces
    astr = strrep(astr,sprintf(', '),'Y');     
        
    astr = strrep(astr,sprintf(','),'Y');      
    %astr = strrep(astr,char(44),'Y');    % comma
    
    % V1
    astr = strrep(astr,sprintf('   '),'Z');        
    astr = strrep(astr,sprintf('  '),'Z');   
    astr = strrep(astr,sprintf(' '),'Z');       
    
    % Remove doubles
    astr = strrep(astr,'VV','V');    
    astr = strrep(astr,'WV','V');  
    astr = strrep(astr,'XV','V');
    astr = strrep(astr,'YV','V');
    astr = strrep(astr,'ZV','V');
    
    astr = strrep(astr,'WW','W');  
    astr = strrep(astr,'XW','W');
    astr = strrep(astr,'YW','W');
    astr = strrep(astr,'ZW','W');   
    
    astr = strrep(astr,'XX','X');
    astr = strrep(astr,'YX','X');
    astr = strrep(astr,'ZX','X');  
    
    astr = strrep(astr,'YY','Y');
    astr = strrep(astr,'ZY','Y');    
    
    astr = strrep(astr,'ZZ','Z');       
    
%     astr = strrep(astr,'WX','X');     
%   
%     
%     astr = strrep(astr,'XY','Y');      
%     astr = strrep(astr,'WY','Y'); 
%     astr = strrep(astr,'VY','Y');     
%     
%     astr = strrep(astr,'YZ','Z');      
%     astr = strrep(astr,'XZ','Z'); 
%     astr = strrep(astr,'WZ','Z');        
%     astr = strrep(astr,'VZ','Z');    
    
    astr = strrep(astr,'YW','W');      
    astr = strrep(astr,'ZX','Z');  
    
    
    astr = strrep(astr,sprintf('!'),'');  % Blank out extraneous characters
      
    TheFile = sprintf('%s_g%d.txt', OutputFile, RunNo);
    fid = fopen(TheFile,'wt');
    fprintf(fid, '%s', astr);
    fclose(fid);
    
    test1 = 1;
    % transform utterance length to symbols
    %
    % if [s] (ie length(str)) <= n1 -> replace with U1 (eg 'A')
    % if [s] (ie length(str)) n1 > [s] <= n2 -> replace with U2 (eg 'B') 
    % etc
    % also replace subsequent pauses, ie spaces with V1, V2 etc
    %
    Nx = length(astr); 
 
    nlastsymbol = -1;     % keep track of last symbol    
    ncurrentsymbol = 0;   % keep track of which symbol we are at
    symbollength = 0;
    symbolclass = 0;
    Aseq = [''];         % modified sequence
    
    % Symbols
    % Utterance
    U1 = 'A';          %   Utterance symbol 1  
    U2 = 'B';          %   Utterance symbol 2  
    U3 = 'C';          %   Utterance symbol 3   
    U4 = 'D';          %   Utterance symbol 4       
    U5 = 'E';          %   Utterance symbol 5        
    currentsymbolclass = 1;
    % Lengths
    q1 = 3;
    q2 = 5;
    q3 = 8;
    
    % Pause
    V1 = 'Z';          %   Pause symbol 1  
    V2 = 'Y';          %   Pause symbol 2  
    V3 = 'X';          %   Pause symbol 3      
    V4 = 'W';          %   Pause symbol 4  
    V5 = 'V';          %   Pause symbol 5        
    currentsymbolclass = 0;
    
    
    % Symbolic conversion of utterance length
    %
    % note: this method assumes the maximum length of utterance to be known
    astr = strrep(astr,'************',U5);   % 12   
    astr = strrep(astr,'***********',U5);    % 11
    astr = strrep(astr,'**********',U5);     % 10    
    astr = strrep(astr,'*********',U5);      %  9
    
    astr = strrep(astr,'********',U4);       %  8 
    astr = strrep(astr,'*******',U4);        %  7     
    astr = strrep(astr,'******',U4);         %  6
    
    astr = strrep(astr,'*****',U3);          %  5
    astr = strrep(astr,'****',U3);           %  4  
    
    astr = strrep(astr,'***',U2);            %  3
    
    astr = strrep(astr,'**',U1);             %  2      
    astr = strrep(astr,'*',U1);              %  1   
    
    %fid = fopen('C:\data\corpora\drseusscatg4.txt','wt');
    TheFile = sprintf('%s_gx%d.txt', OutputFile, RunNo);
    fid = fopen(TheFile,'wt');    
    fprintf(fid, '%s', astr);
    fclose(fid);    
        
    
    % Save file without interword spaces .. hence ignore them
    %
    astr = strrep(astr,'Z','');              %    
    
    %fid = fopen('C:\data\corpora\drseusscatg4.txt','wt');
    TheFile = sprintf('%s_gz%d.txt', OutputFile, RunNo);
    fid = fopen(TheFile,'wt');       
    fprintf(fid, '%s', astr);
    fclose(fid); 
    
 