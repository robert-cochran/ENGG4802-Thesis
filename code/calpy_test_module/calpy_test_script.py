# from calpy import dsp
# from calpy import plots
# from calpy.utilities import read_wavfile
# from calpy.entropy import symbolise_speech, entropy_profile, fast_entropy_profile
import calpy
import github_calpy
import numpy as np
import time
import logging
import fast_entropy
LOG_FILENAME = 'log.txt'
logging.basicConfig(filename=LOG_FILENAME, level=logging.DEBUG)
logging.debug('*******DEBUG********')


""" Prosody: Produces a plot of the soundwave, decibel, pitch and mfcc of the given wav file
                into a folder of the filename
    
    num_plots: number of plots the result will be split amongst
    """
def plot_prosody(file_name, features=["waveform", "mfcc", "pitch", "intensity", "dB"], num_plots=200, num_chunks=10, scaling=4, print_status=False):
    '''Plots a multirow plot of various prosody features.

        Args:
            filename (str): path to the audio file.
            features (list(string)): list of features to be plotted.  Ignores nonexistent features.  Defaults to ["waveform", "mfcc", "pitch", "intensity", "pitch_hist", "dB"]
            num_plots (int): divide the intial wavform into num_plots pieces and create one plot each.  Defaults to 200.
            num_chunks (int): number of subdivisions of one plot.  Defaults to 10.
            scaling (int): scales the size of the output plot.

        Returns:
            null:  saves plots to  a folder in current directory.
    '''
    calpy.plots.all_profile_plot(file_name=file_name, features=features, num_plots=num_plots, num_chunks=num_chunks, scaling=scaling, print_status=print_status)


''' PauseCode: Produces a plot of the pause and speaking instances for both speakers
    
    Note: For plot to function correctly, both wav files must have no background noise of the other channel, 
    otherwise the PauseCode produced becomes meaningless
    
    Example: I've taken the clean Left channels from two separate conversations, correct pausecode is produced
    but conversation is meaningless itself 
    '''
def plot_sounding_pattern(
        file_name_A,
        file_name_B,
        time_step=0.01,
        time_range=(0,-1),
        row_width=10,
        row_height=1,
        duration_per_row=60,
        xtickevery=10,
        ylabels='short',
        dpi=300,
        filename="pause_code",
        title="sounding_pattern"):
    """Plot sounding patterns like uptakes, inner pauses, over takes.
    Args:
        file_name_A (str): path to audio file of speaker A.
        file_name_B (str): path to audio file of speaker B.
        time_step (float, optional): time interval in between two elements in seconds, default to 0.01s.
        time_range ((float, float), optional): time range of the plot in seconds, default to from the entire converstaion.
        row_width (int, optional): parametre for display purpose, the width of a row, default to 10 units.
        row_height (int, optional): parametre for display purpose, the height of a row, default to 1 unit.
        duration_per_row (float, optional): parametre for display purpose, the duration of a row in seconds, default to 60 seconds.
        xtickevery (float, optional): parametre for display purpose, the duration of time in seconds in between two neighbour x ticks, default to 10 secnds.
        ylabels (string, optional): self explanatory.
        dpi (int, optional): self explanatory.
        filename (string, optional): file name of the output figure.
        title (string, optional): self explanatory.

        
    Returns:
        True, and write figure to disk.
    """
    fs_A, sound_A = calpy.utilities.read_wavfile(file_name_A)
    fs_B, sound_B = calpy.utilities.read_wavfile(file_name_B)
    pause_A = calpy.dsp.pause_profile(sound_A, fs_A)
    pause_B = calpy.dsp.pause_profile(sound_B, fs_B)
    github_calpy.plots.sounding_pattern_plot(
        A=pause_A,
        B=pause_B,  
        time_step=time_step,
        time_range=time_range,
        row_width=row_width,
        row_height=row_height,
        duration_per_row=duration_per_row,
        xtickevery=xtickevery,
        ylabels=ylabels,
        dpi=dpi,
        filename=filename,
        title=title)


''' Anomaly: Produces a line graph of the entropy profile to classic_anomaly.png

    Saves output to anomaly+file_name folder
    '''
def classic_entropy(file_name, file_output):
    #for 4390.wav
    fs, sound = calpy.utilities.read_wavfile(file_name) #2,381,072
    pause = calpy.dsp.pause_profile(sound, fs) #~29,000
    pitch = calpy.dsp.pitch_profile(sound, fs)
    prosody = np.append([pitch], [pause], axis=0)
    symbols = np.array([])
    for arr in np.array_split(prosody, pause.shape[0] // 10, axis=1):
        #WHY ONLY SYMBOLIZE SPEECH? #DIDNT HAVE TIME FOR PAUSE?
        symbols = np.append(symbols, calpy.entropy.symbolise_speech(arr[0,:], arr[1,:])) #2,976
    #PRINTS LENGTH FOR PAUSE, PITCH, PROSODY
    #print("Pitch len - {} , Pause len - {}, Prosody len {}".format(len(pitch), len(pause), len(prosody)))
    #PRINTS SYMBOLS & LENGTH
    #print("Symbols before being fed into entropy profile  - ", len(symbols), "\n", symbols)
    entropy_profile = calpy.entropy.entropy_profile(symbols, window_size=100) #28 - old data, size=200, overlap=100
    with open(file_output+'.txt',"w+") as f:
        for i in range(len(entropy_profile)):
            f.write(str(entropy_profile[i])+'\n')
    calpy.plots.profile_plot(entropy_profile, file_name=file_output+'.png' ,figsize=(10,4))
    #fast_entropy_prof = entropy.fast_entropy_prof(symbols, 'C', 27, 0.0073, 4.2432, 4.2013, window_size=100)
    #plots.profile_plot(entropy_prof, file_name="fast_anomaly.png",figsize=(10,4))

''' Fast Entropy: Runs Fast Entropy over a input file, plots entropy profile to fast_anomaly.png
        
        Note: Currently only takes in text file, as model is tailored for text files
        Once model building is done then audiofile results can be compared between classic and fast in calpy
    '''
def fast_entropy_fn(file_name, file_output, selected_symbol='C', M=27, ap=0.0073, bp=4.2432, cp=4.2013):
    
    symbol_file = open(file_name, "r")
    symbols = symbol_file.read()
    fast_profile = fast_entropy.fast_entropy_profile(symbols, selected_symbol, M, ap, bp, cp)
    with open(file_output+'.txt',"w+") as f:
        for i in range(len(fast_profile)):
            f.write(str(fast_profile[i])+'\n')
    calpy.plots.profile_plot(fast_profile, file_name=file_output+'.png', figsize=(10, 4))

''' Model Building: Produces unique ap, bp, cp values specific to M and the type of symbol being measured
    
    TBC
    '''
def model_building():
    file = open("model_building/input_model.txt","w")
    file.write("model")
    file.close()
""" Histogram: Plots histograms of various features
    
    TBC
    """
def plot_histogram():
    file = open("histogram/histogram_profile.txt","w")
    file.write("histogram data from various features")
    file.close()

def main():
    
    # #Initialization
    # np.set_printoptions(threshold=np.nan) #prints entire array instead of replacing large portion with "..."
    
    # #Prosody
    # print("-------------------------------Prosody------------------------------")
        # works
    # plot_prosody('data/4390.wav', num_plots=1)

    # #PauseCode
    # print("-------------------------------Pause Code------------------------------")
        # this doesnt work - I think because sounding_pattern_plot isn't included in the pip installer for calpy
        # this works
    plot_sounding_pattern('data/4484-L-Cut.wav', 'data/4390-L.wav', filename="pause_code/pause_code")

    # #Entropy
    # #print("-------------------------------Regular Entropy------------------------------")
        # works
    #classic_entropy(file_name='data/4390.wav', file_output="classic_entropy/classic_anomaly")

    # #Fast Entropy
    # #print("--------------------------------Fast Entropy--------------------------------")
        # works
    #fast_entropy_fn(file_name='data/holmes_seuss_symbolized.txt', file_output="fast_entropy/fast_entropy_profile")

    """Not Made"""
    # #Model Building
    # model_building()

    # #Histogram
    # ##TBC
    # print("-------------------------------Histogram------------------------------")
    # plot_histogram():

    print("dd")
    time.sleep(3)


try:
    main()
except:
    logging.exception('Got exception on main handler')
    raise

