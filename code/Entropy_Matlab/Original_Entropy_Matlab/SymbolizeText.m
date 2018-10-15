
% SymbolizeText.m
% Andrew Back (c) 2018
%
%% This reads in a text file and then symbolicizes it and saves to a new file
%
% Inputs:
% Model = future use to select a model type for symbolization
% BaseFile = Input text filename
%
% OutputFile = Output symbolized text filename as: sprintf('%s_g%d.txt', OutputFile, RunNo);
% basefilename_gN.txt  = output symbolic file, 
%                        * = symbol, Z = pause, eg **Z********Z******Z**
% basefilename_gxN.txt = output symbolic file  
%                        actual symbols, Z = pause, eg AZDZDZBZAZDZBZCWAZC
% basefilename_gzN.txt = output symbolic file with interword pauses dropped
%                        (symbol = 'Z'), eg ADDBADBCWACDCVBDBCBCCWABCBDVB
%
% Output:
% Nx = number of samples in symbol file
%
% This is derived from gensyn.m, cd_montext21.m
%
%
% Refs: Introduction to Cryptography with Open-Source Software
%       Alasdair McAndrew
%       Usher and Guy, Information and Communicatin for Engineers
%-----------------------------------------------------------------------------------------------------

function [Nx] = SymbolizeText(Model,BaseFile, OutputFile, RunNo)

    % Read in actual text file and process
    %
    % eg filetext = fileread('C:\data\corpora\TomSawyer2short.txt');
    TheFile = sprintf('%s', BaseFile);
    filetext = fileread(TheFile);       
    astr = filetext;  %(1:5000);
    % Remove unwanted chars: (  ) \r \n ! " - , , ? ] [ * _ : /
 
    astr = strrep(astr,sprintf('^'),'');    % Remove this character    
        
    % Filter letters
    % Convert to all lower case, should now only have 27 unique characters
    % in alphabet.
    %
    astr = lower(astr);    
    
    % filter symbols
    %   
    astr(ismember(double(astr),[48:57])) = '*';  %# Convert numbers to *
    astr(ismember(double(astr),[64:90])) = '*';  %# Convert uc letters to *
    astr(ismember(double(astr),[96:122])) = '*';  %# Convert lc letters to *    
    
    %%-----------------------
   
    % Remove non ASCII chars
    astr(ismember(double(astr),[128:512])) = '';  %# Remove characters based on
                                                  %#   their integer code   
                                                 
                                                 
    % Remove extraneous characters
    %
    astr = strrep(astr,sprintf('('),'');
    astr = strrep(astr,sprintf(')'),'');
 
    astr = strrep(astr,sprintf('/'),'');
    astr = strrep(astr,sprintf('['),'');
    astr = strrep(astr,sprintf(']'),'');
    astr = strrep(astr,sprintf('^'),'');      
    
    astr = strrep(astr,char(39),'');    % apostrophe
    astr = strrep(astr,sprintf('"'),'');
    
    % === Transform pause length to symbols ===
    %    
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
         
    astr = strrep(astr,'YW','W');      
    astr = strrep(astr,'ZX','Z');  
    

    astr = strrep(astr,sprintf('!'),'');  % Blank out extraneous characters
      
    TheFile = sprintf('%s_g%d.txt', OutputFile, RunNo);
    fid = fopen(TheFile,'wt');
    fprintf(fid, '%s', astr);
    fclose(fid);
    
    % === Transform utterance length to symbols ===
    %    
    % if [s] (ie length(str)) <= n1 -> replace with U1 (eg 'A')
    % if [s] (ie length(str)) n1 > [s] <= n2 -> replace with U2 (eg 'B') 
    % etc
    % also replace subsequent pauses, ie spaces with V1, V2 etc
    %
    Nx = length(astr); 
 
%     nlastsymbol = -1;     % keep track of last symbol    
%     ncurrentsymbol = 0;   % keep track of which symbol we are at
%     symbollength = 0;
%     symbolclass = 0;
%     Aseq = [''];         % modified sequence
    
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
    
    
    % === Symbolic conversion of utterance length ===
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
    Nx = length(astr);
    
    %fid = fopen('C:\data\corpora\drseusscatg4.txt','wt');
    TheFile = sprintf('%s_gz%d.txt', OutputFile, RunNo);
    fid = fopen(TheFile,'wt');       
    fprintf(fid, '%s', astr);
    fclose(fid); 
    
 