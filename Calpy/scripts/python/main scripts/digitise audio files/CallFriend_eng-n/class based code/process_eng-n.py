
import sys
import numpy
#import calpy
import calpy.dsp.audio_features as ca
import calpy.utilities as cu
import calpy.pause.pause_wrapper as pause
import calpy.entropy as ce
import calpy.plots as plots
import os
from pydub import AudioSegment
    #required a brew install ffmpeg

def pause_interface(file_path, file_name):

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
    window_size = 20
    window_overlap = 10
    selected_symbol = 'A'

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





    #----------Data Processesing-----------
    #---Pauses---
    single_pauses = pause.compute_pauses_from_audio(file_path, file_name, min_silence)
    pause.write_pauses_to_file(file_path, single_pauses, min_silence)
    pause_freqs = pause.read_pauses_from_file(file_path, min_silence)

    #---Symbols---
    symbols = pause.compute_entropy_symbols(pause_freqs, symbol_bins)
    pause.write_entropy_symbols_to_file(file_path, file_name, symbols, symbols_suffix, window_size)
    symbols_file = pause.read_entropy_symbols_from_file(file_path, symbols_suffix)

    #---Entropy---
    entropy_profile = pause.compute_entropy(symbols_file, selected_symbol, M, ap, bp, cp, window_size=20, window_overlap=10)
    pause.write_entropy_profile_to_file(file_path, entropy_profile, M, ap, bp, cp, window_size, window_overlap)

    #---Plots---
    #-Singular Pauses-
    pause.produce_pause_plot(file_path, file_name, single_pauses, single_pause_title, pause_bins, pause_bin_range, show_plots) # [0,1,1,1,0,0,0,0,1,0,0,1,1,0,0], x=sound y=count
    #-Pause Lengths-
    pause.produce_pause_plot(file_path, file_name, pause_freqs, pause_length_title, freq_bins, freq_bin_range, show_plots) # [123,2,34,24,4,1,1,90,58] x=length y=count
    #-Anomaly-
    pause.produce_entropy_plots(file_path, entropy_title, entropy_profile, M, ap, bp, cp, window_size, window_overlap) # the entropy calculations over time
    #-Ranking Symbols-
    pause.produce_ranked_probability(pause_freqs, symbol_bins) #do a ranked probability plot (plot symbol counts in order of frequency x=symbol, y=count)
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



    #----------Testing----------



    #-----Finished-----
    print("finished")



###############
## CODE ##
###############


#test file - very short digitisation time
file_name = '/OSR_us_000_0030_8k'
file_path = '/monologue/OSR/Male' + file_name
pause_interface(file_path, file_name)

#actual files - running time may take ~40 minutes for everything
file_name = '/4175_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/4175' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/4504_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/4504' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/4708_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/4708' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/4745_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/4745' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/4823_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/4823' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/4874_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/4874' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/4889_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/4889' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/4984_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/4984' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/5000_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/5000' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/5051_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/5051' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/5220_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/5220' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/5635_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/5635' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/5926_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/5926' + file_name
pause_interface(file_path, file_name)
#done
file_name = '/6015_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6015' + file_name
pause_interface(file_path, file_name)

file_name = '/6062_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6062' + file_name
digitize(file_path, file_name)
#done
file_name = '/6065_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6065' + file_name
digitize(file_path, file_name)
#done
file_name = '/6093_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6093' + file_name
digitize(file_path, file_name)
#done
file_name = '/6126_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6126' + file_name
digitize(file_path, file_name)
#done
file_name = '/6157_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6157' + file_name
digitize(file_path, file_name)
#done
file_name = '/6193_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6193' + file_name
digitize(file_path, file_name)
#done
file_name = '/6239_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6239' + file_name
digitize(file_path, file_name)
#done
file_name = '/6255_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6255' + file_name
digitize(file_path, file_name)
#done
file_name = '/6278_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6278' + file_name
digitize(file_path, file_name)
#done
file_name = '/6372_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6372' + file_name
digitize(file_path, file_name)
#done
file_name = '/6379_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6379' + file_name
digitize(file_path, file_name)
#done
file_name = '/6476_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6476' + file_name
digitize(file_path, file_name)
#done
file_name = '/6862_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6862' + file_name
digitize(file_path, file_name)
#done
file_name = '/6869_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6869' + file_name
digitize(file_path, file_name)
#done
file_name = '/6899_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6899' + file_name
digitize(file_path, file_name)
#done
file_name = '/6938_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6938' + file_name
digitize(file_path, file_name)
#done
file_name = '/6952_16000'
file_path = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/6952' + file_name
digitize(file_path, file_name)
