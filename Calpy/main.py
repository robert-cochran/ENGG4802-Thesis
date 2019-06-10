#general
import sys
import numpy
import os

#calpy
import calpy.dsp.audio_features as ca
import calpy.utilities as cu
import calpy.pause.audio_file_ as audio_file_
import calpy.entropy as ce
import calpy.plots as plots
import calpy.students as students
from calpy.pause import parameters
from calpy.pause import dataset_functions

#uneditited data
from calpy.pause.dataset_folder import test
from calpy.pause.dataset_folder.talkbank.callHome import jpn 
from calpy.pause.dataset_folder.talkbank.callHome import eng
from calpy.pause.dataset_folder.talkbank.callFriend.n import eng_n
from calpy.pause.dataset_folder.talkbank.callFriend.n import male
from calpy.pause.dataset_folder.talkbank.callFriend.n import female
from calpy.pause.dataset_folder.talkbank.callFriend.n import mixed_sex
from calpy.pause.dataset_folder.abc.jjj import mornings
from calpy.pause.dataset_folder.abc.radio import conversations
from calpy.pause.dataset_folder import timing_test

#augmented data
from calpy.pause.dataset_folder.abc.radio import abc_augmented_audio
from calpy.pause.dataset_folder.abc.jjj import jjj_augmented_audio

import calpy.plots as plots

#importing wav
from pydub import AudioSegment #required a brew install ffmpeg

#numpy.set_printoptions(threshold=sys.maxsize)
#def digitize(file_path, file_name):


import numpy as np


#--------------------------------------#--------------------------------------#--------------------------------------#--------------------------------------

print ('starting')
#audio_files = dataset_functions.pause_process_dataset(test.directory, test.files, test.frequency)

#demo 1
jjj_audio_files = dataset_functions.pause_process_dataset(timing_test.directory, timing_test.files, timing_test.frequency)
abc_audio_files = dataset_functions.pause_process_dataset(conversations.directory, conversations.files, conversations.frequency)
jjj_audio_files = dataset_functions.pause_process_dataset(mornings.directory, mornings.files, mornings.frequency)
abc_audio_files1 = dataset_functions.pause_process_dataset(abc_augmented_audio.directory, abc_augmented_audio.files, abc_augmented_audio.jjj_insert_end)
abc_audio_files2 = dataset_functions.pause_process_dataset(abc_augmented_audio.directory, abc_augmented_audio.files, abc_augmented_audio.jjj_insert_middle)
jjj_audio_files1 = dataset_functions.pause_process_dataset(jjj_augmented_audio.directory, jjj_augmented_audio.files, jjj_augmented_audio.abc_insert_middle)
jjj_audio_files2 = dataset_functions.pause_process_dataset(jjj_augmented_audio.directory, jjj_augmented_audio.files, jjj_augmented_audio.abc_insert_end)


# print(abc_audio_files1[0].maximum_entropy)
# print(numpy.mean(abc_audio_files[0].entropy_profile))
# print(numpy.var(abc_audio_files[0].entropy_profile))

plots.profile_plot(self, self.entropy_directory, title, self.entropy_profile, figsize=(25,4), ylim = self.maximum_entropy) #needs title, finer grained x, axis labels


 # def matching_ranked_symbol(audio_file_0, audio_file_1):
def symbol_probability(audio_file):
    audio_file.letter = []
    audio_file.letter_probability = []
    audio_file.symbol_rank = []
    for i in range(len(audio_file.ranked_probability)):
        letter_probability = audio_file.ranked_probability[i][0]/audio_file.number_of_pauses
        letter = audio_file.ranked_probability[i][1]
        audio_file.letter.append(letter)
        audio_file.letter_probability.append(letter_probability)
        audio_file.symbol_rank.append(ord(letter)-65)
    # return audio_file

def matching_ranked_symbol(audio_file, audio_file_to_match):
    audio_file.letter = []
    audio_file.letter_probability = []
    for i in audio_file_to_match.symbol_rank:
        # print(i)
        letter_probability = audio_file.symbol_occurrence[i]/audio_file.number_of_pauses
        letter = audio_file.symbols_in_model[i]
        audio_file.letter.append(letter)
        audio_file.letter_probability.append(letter_probability)
    #abc.letters_ranked = np.arange(len(abc.letter_probability))
    return audio_file

def average_probability(audio_files):
    audio_files_letter_probability = []
    for symbol in audio_files[0].symbols_in_model:
        audio_files_letter_probability.append(0)
    
    for audio_file in audio_files:
        symbol_probability(audio_file)
        for i, letter_probability in enumerate(audio_file.letter_probability):
            audio_files_letter_probability[i] = audio_files_letter_probability[i]  + letter_probability
            # print(letter_probability)
        # print("-------")
    # print(audio_files_letter_probability)
    for i in range(len(audio_files[0].symbols_in_model)):
        audio_files_letter_probability[i] = audio_files_letter_probability[i] / len(audio_files)
    return audio_files_letter_probability
    # print(len(audio_files))

    # print(sum(audio_files_letter_probability))
    # print(audio_files_letter_probability)
    
# jjj_probs = average_probability(jjj_audio_files)
# abc_probs = average_probability(abc_audio_files)



# plots.dual_ranked_probability(
#                                 abc_audio_files[0].symbols_in_model,
#                                 jjj_probs,
#                                 abc_probs
#                                 )




# audio_files = dataset_functions.pause_process_dataset(jjj_augmented_audio.directory, jjj_augmented_audio.files, jjj_augmented_audio.abc_insert_middle)
# audio_files = dataset_functions.pause_process_dataset(jjj_augmented_audio.directory, jjj_augmented_audio.files, jjj_augmented_audio.abc_insert_end)
# audio_files = dataset_functions.pause_process_dataset(abc_augmented_audio.directory, abc_augmented_audio.files, abc_augmented_audio.jjj_insert_end)
# audio_files = dataset_functions.pause_process_dataset(abc_augmented_audio.directory, abc_augmented_audio.files, abc_augmented_audio.jjj_insert_middle)
# audio_files.append(dataset_functions.pause_process_dataset(augmented_audio.directory, augmented_audio.files, augmented_audio.single_pause_insert_30s)[0])
# audio_files.append(dataset_functions.pause_process_dataset(augmented_audio.directory, augmented_audio.files, augmented_audio.single_pause_insert_60s)[0])
# audio_files.append(dataset_functions.pause_process_dataset(augmented_audio.directory, augmented_audio.files, augmented_audio.multiple_pause_insert_30s)[0])
# audio_files.append(dataset_functions.pause_process_dataset(augmented_audio.directory, augmented_audio.files, augmented_audio.jjj_insert)[0])

#dataset_functions.averages(conversations.directory, audio_files)


#plots.histogram_fn(mornings.directory, mornings.files, 100, (0,100), 'japanese')
#plots.best_fit_hist()
print('finished')

#--------------------------------------#--------------------------------------#--------------------------------------#--------------------------------------
#--------------------------------------#--------------------------------------#--------------------------------------#--------------------------------------
#--------------------------------------#--------------------------------------#--------------------------------------#--------------------------------------
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
    - Change the code so that Compute = True doesn't do anything else other than computing the binary txt, then rewrite everything after that
        This way I can rerun the code with changes and not append the same thing a million times, but also write changes
        and only need the binary pause to be carried over
    - Rewrite the output folder layout so that it either does: 
        the way I currently have it (but better) which would be be to have one master output audio file that organises everything
            into different folders based on parameter settings, that way I can see where things are easily but would require
            a lot of folders being made which im not sure i have time to do (for entropy folders would be outlining the M value,
            window size, overlap, selected symbol, etc..., symbolisation would have symbol model in the folder set, )
        or have one master 'binary_pause.txt' file that saves custom binary pauses that I can just load from and then save all the other
            output into dated folders. this would be the simplest but also hardest to keep track of long term. 
    - Visualisations - https://mlwhiz.com/blog/2019/04/19/awesome_seaborn_visuals/ - Google more!
        https://d212y8ha88k086.cloudfront.net/manuscripts/16574/49f87590-f903-4ad3-8d1b-096b518b4e2c_15191_-_rogier_kievit.pdf?doi=10.12688/wellcomeopenres.15191.1&numberOfBrowsableCollections=1&numberOfBrowsableGateways=9
'''


