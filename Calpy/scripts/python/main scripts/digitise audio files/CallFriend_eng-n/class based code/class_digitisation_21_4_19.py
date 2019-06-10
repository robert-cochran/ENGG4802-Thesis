
import sys
import numpy
#import calpy
import calpy.dsp.audio_features as ca
import calpy.utilities as cu
import calpy.pause.pause_wrapper as pw
import calpy.entropy as ce
import calpy.plots as plots
import os
from pydub import AudioSegment
    #required a brew install ffmpeg

def digitize(file_path, file_name):

    #----------Start-----------
    print("starting")

    #----------Settings----------
    numpy.set_printoptions(threshold=sys.maxsize)


    #----------PARAMETERS----------

    #-----FILES-----
    #---Quick Simple Test---
    #file_name = '/OSR_us_000_0030_8k'
    #file_path = '/monologue/OSR/Male' + file_name
    #---Long Thorough Test---
    #file_name = '/6750_16000'
    #file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-s/0wav/6750' + file_name
    #---Files List---
    #----------Files to be processed----------
    #files.append('./data' + file_path + file_name + '.wav')
    #files.append('data/pause_dist/dialogue/conversations/talkbank/eng-s/6269_44100.wav')

    #-----PAUSE-----
    min_silence = 0.001 #milli is .001

    #-----SYMBOLS-----
    symbol_bins = [20,40,60,80,100,200,400,800]
    symbols_suffix = "/symbol_list"

    #-----ENTROPY-----
    M = 27
    ap = 0.0073
    bp = 4.2432
    cp = 4.2013
    window_size = 100
    '''Why 100?'''
    window_overlap = 40 #10 previously
    '''Why 5?'''
    selected_symbol = 'A' 
    '''why A, why not C or B or D?'''

    #-----PLOTS-----
    show_plots = False
    #---single pause--- i.e. [0,1,0,0,1,0]
    single_pause_title = "Single Pause Distribution"
    pause_bins = 2
    pause_bin_range = (0,1)
    #---pause lengths--- i.e. [123,4,23,23,24,1,90]
    pause_length_title = "Pause Lengths Distribution"
    freq_bins = 20
    freq_bin_range = (0,100)
    #---entropy---
    entropy_title = "Anomaly"

    #-----Finished-----
    print("finished")


'''#--Parameters Objects--'''
min_silence = 0.001
compute = False
printing = False #Recommended to leave true when computing since it takes so long
M = 27
ap = 0.0073
bp = 4.2432
cp = 4.2013
window_size = 100 #why 100??? Need to justify!
window_overlap = 5 #10 previously, why 5??? Need to justify!
selected_symbol = 'A'  #'''why A, why not C or B or D?''' Need to Justify!
window_size = 100
window_overlap = 5
symbol_model = [20,40,60,80,100,200,400,800]
selected_symbol = 'B'
bins = 20
bin_range = (0,100)

'''Test Objects'''

# folder_dir = '/monologue/OSR/Male/'
# file_number = 'OSR_us_000_0030'
# file_frequency = '8000'
# af_0030 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_0030.pauses(compute)
# af_0030.symbolize(symbol_model)
# af_0030.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_0030.plots(bins, bin_range)

# folder_dir = '/monologue/OSR/Male/'
# file_number = 'OSR_us_000_0061'
# file_frequency = '8000'
# af_0030 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_0030.pauses(compute)
# af_0030.symbolize(symbol_model)
# af_0030.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_0030.plots(bins, bin_range)

# folder_dir = '/monologue/OSR/Female/'
# file_number = 'OSR_us_000_0010'
# file_frequency = '8000'
# af_0030 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_0030.pauses(compute)
# af_0030.symbolize(symbol_model)
# af_0030.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_0030.plots(bins, bin_range)

# folder_dir = '/monologue/OSR/Female/'
# file_number = 'OSR_us_000_0011'
# file_frequency = '8000'
# af_0030 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_0030.pauses(compute)
# af_0030.symbolize(symbol_model)
# af_0030.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_0030.plots(bins, bin_range)

'''Actual Objects'''

folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
file_number = '4175'
file_frequency = '16000'
print(file_number)
af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
af_4175.pauses(compute)
af_4175.symbolize(symbol_model)
af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '4504'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '4708'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '4745'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '4823'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '4874'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '4889'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '4984'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

'''Checkpoint'''

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '5000'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '5051'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '5220'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '5635'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '5926'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6015'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6062'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6065'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6093'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6126'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6157'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6193'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6239'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6255'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6278'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6372'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6379'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6476'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6862'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6869'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6899'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6938'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)

# folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
# file_number = '6952'
# file_frequency = '16000'
# print(file_number)
# af_4175 = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
# af_4175.pauses(compute)
# af_4175.symbolize(symbol_model)
# af_4175.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
# af_4175.plots(bins, bin_range)



'''NOTES'''
        #Next want to plot the ranked probability of one over another and see how they differ given the same symbol set!

    #inject fake pauses in the audio but i could also do that with the symbol file with adding in symbols
        #if i do the ranked prob on the data before the inject, then see how the ranked prob changes 

    #add in all the understanding into my thesis (what i spent time learning)
        #so really go over what the algorithm is doing, how you break down an audio file into symbols, waht the symbols are doing
        #what Symbol file looks like
        #what it looks liek to get that file (show zoomed in audio file and how you are detecting pauses and assigning pauses)
        #
        
    #every experiment
        #every file should have the plot the ranked histogram and reg histo as probabilistic structure
            #compare the ranked prob of one convo and vs anorther
            #ex 50 yr old, 70 yr old, convo from JJJ and see how they change 

        #every file should have an anomoly plot

    #potential exp
        #inject the middle of a conversation into the middle of another to see the change

    #ask about recommendation
        #connection between NN (conditional prob estimator) and entropy (prob estimator)
        #theiss is inherently same mathematical approach
        #a lot of stats and data analysis

'''Improvements:

    - If folder dir and binary_pause.txt doesnt exist for writing out, then have 'computing' = True, otherwise assume
        it has a valid binary_pause.txt to read from
'''


