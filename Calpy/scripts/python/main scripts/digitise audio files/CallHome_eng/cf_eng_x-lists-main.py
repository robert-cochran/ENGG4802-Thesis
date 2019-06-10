
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
#numpy.set_printoptions(threshold=sys.maxsize)
#def digitize(file_path, file_name):

#timer
import time

#swarmplot
# import numpy as np
# import pandas as pd
# import seaborn as sns
# import matplotlib.pyplot as plt

#raincloud plot
# import ptitprince as pt



#--------------------------------------#--------------------------------------#--------------------------------------
'''Parameters'''
#----------Settings----------

#-----DIGITISATION-----
compute = True
printing = False #Recommended to leave true when computing since it takes so long
min_silence = 0.001 #milli is .001

#-----SYMBOLISATION-----
#symbol_model = [20,40,60,80,100,200,400,800]
symbol_model = [5, 10, 20, 50, 100, 200]
symbols_suffix = "/symbol_list"

#-----ENTROPY-----
M = 27
ap = 0.0073
bp = 4.2432
cp = 4.2013
window_size = 50 #100 previously, why 100??? Need to justify!
window_overlap = 40 #10 previously, why 5??? Need to justify!
selected_symbol = 'A' #'''why A, why not C or B or D?''' Need to Justify!

#-----PLOTS-----
#---single pause--- i.e. [0,1,0,0,1,0]
pause_bins = 2
pause_bin_range = (0,1)
#---pause lengths--- i.e. [123,4,23,23,24,1,90]
bins = 20
bin_range = (0,100)
#---entropy---

#--------------------------------------#--------------------------------------#--------------------------------------
'''Functions'''
def pause_process(folder_dir, file_number, file_frequency):
    #folder_dir = folder_dir
    #file_number = file_number
    #file_frequency = frequency
    audio_file = pw.AudioFile(folder_dir, file_number, file_frequency, min_silence, compute, printing)
    audio_file.pauses(compute)
    audio_file.symbolize(symbol_model)
    audio_file.entropy(selected_symbol, M, ap, bp, cp, window_size, window_overlap)
    audio_file.plots(bins, bin_range)
    #print(audio_file.pause)
    return audio_file

def run_test():
    folder_dir = '/monologue/OSR/Male/'
    file_number = 'OSR_us_000_0030'
    file_frequency = '8000'
    test = pause_process(folder_dir, file_number, file_frequency)
    return test

def run_cf_eng_n_all():
    folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
    cf_eng_n_all = ['4175', '4504', '4708', '4745', '4823', '4874', '4889', '4984', '5000', '5051', '5220', '5635', '5926',
                    '6015', '6062', '6065', '6093', '6126', '6157', '6193', '6239', '6255', '6278', '6372', '6379', '6476',
                    '6862', '6869', '6899', '6938', '6952']
    file_frequency = '16000'
    audio_files = []
    for file_number in cf_eng_n_all:
        print(file_number)
        audio_files.append(pause_process(folder_dir, file_number, file_frequency))
    return audio_files

def run_cf_eng_n_good():
    folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallFriend/eng-n/0wav/'
    cf_eng_n_good = ['4175', '4889', '4984']
    file_frequency = '16000'
    audio_files = []
    for file_number in cf_eng_n_good:
        print(file_number)
        audio_files.append(pause_process(folder_dir, file_number, file_frequency))
    return audio_files

def run_ch_eng_all():
    folder_dir = '/dialogue/conversations/media.talkbank.org/ca/CallHome/eng/0wav/'
    #ch_eng_1 = ['0638', '4065', '4074', '4077', '4092', '4093', '4104', '4112', '4145', '4156', '4157', '4170', '4183', '4184', '4234', '4245', '4247', '4248','4289']
    #ch_eng_2 = ['4290', '4310', '4315', '4316', '4325', '4335', '4365', '4371', '4390', '4404', '4415', '4431', '4432', '4459', '4484', '4485', '4490', '4507', '4520', '4521']
    #ch_eng_3 = ['4522', '4537', '4543', '4544', '4547', '4556', '4560', '4564', '4569', '4571', '4574', '4576', '4577', '4580', '4595', '4601', '4610', '4612', '4616'] 
    #ch_eng_3_rest = ['4604'] this didnt work (no pauses produced)
    #ch_eng_4 = ['4622', '4623', '4624', '4628', '4629', '4660', '4665', '4666', '4673', '4677', '4683', '4686', '4689', '4694', '4702', '4705', '4721', '4726', '4753', '4776', '4790']
    #ch_eng_5 = ['4792', '4801', '4802', '4807', '4808', '4822', '4824', '4829', '4838', '4844', '4852', '4854', '4861', '4875', '4886', '4887', '4902', '4908', '4913']
    #ch_eng_5_rest = ['4910'] this didnt work (no pauses produced)
    ch_eng_6 = ['4926', '4927', '4938', '4941', '4966', '4967', '4968', '5011', '5017', '5020', '5023', '5046', '5166', '5208', '5242', '5254', '5273', '5278', '5352', '5373', '5388']
    #ch_eng_7 = ['5495', '5532', '5551', '5573', '5648', '5700', '5712', '5713', '5736', '5777', '5788', '5866', '5872', '5888', '5907', '5931', '6033', '6045', '6047', '6067']
    #ch_eng_8 = ['6071', '6079', '6100', '6107', '6130', '6161', '6165', '6179', '6183', '6189', '6217', '6252', '6265', '6267', '6274', '6282', '6298', '6313', '6314', '6348']
    ch_eng_9 = ['6408', '6447', '6456', '6467', '6474', '6479', '6489', '6521', '6625', '6658', '6785', '6825', '6861', '6880', '6912']
    file_frequency = '16000'
    audio_files = []
    for file_number in ch_eng_6:
        start = time.time()
        print(file_number)
        audio_files.append(pause_process(folder_dir, file_number, file_frequency))
        end = time.time()
        timer = end-start
        print("minutes: " + str(timer/60) + "   seconds: " + str(timer))
    return audio_files

def resolution_tests():
    folder_dir = '/resolution-experiments/'
    file_number = '6269'
    file_frequency_all = ['11025', '16000', '22050', '32000', '44100', '48000', '88200', '96000']
    audio_files = []
    for file_frequency in file_frequency_all:
        start = time.time()
        print(file_frequency)
        audio_files.append(pause_process(folder_dir, file_number, file_frequency))
        end = time.time()
        timer = end-start
        print("minutes: " + str(timer/60) + "   seconds: " + str(timer))
    return audio_files

def raincloud_plot():
    # all_audio_files = run_cf_eng_n_all()
    # all_pauses = []
    # for audio_file in all_audio_files:
    #     all_pauses.append(audio_file.number_of_pauses)
    # #pauses = np.array(all_pauses)
    # print(all_pauses)

    #average number of pauses all
    #pauses = np.array([27.177496038034864, 26.035087719298247, 34.31818181818182, 186.51315789473685, 143.86290322580646, 41.860240963855425, 24.72222222222222, 18.480898876404495, 1284.2857142857142, 630.64, 241.85135135135135, 27.042857142857144, 42.47560975609756, 28.40567612687813, 154.96521739130435, 344.63461538461536, 55.4765625, 91.93264248704664, 748.5416666666666, 55.411949685534594, 62.80714285714286, 175.1764705882353, 84.80327868852459, 52.58383233532934, 215.63855421686748, 54.30246913580247, 492.3636363636364, 155.3846153846154, 641.75, 86.32682926829268, 351.7647058823529])

    #number of pauses
    pauses = np.array([631, 171, 506, 76, 124, 415, 576, 890, 14, 25, 74, 630, 410, 599, 115, 52, 256, 193, 24, 318, 280, 102, 61, 334, 83, 324, 22, 39, 28, 205, 51])

    sns.set(style="whitegrid")
    #ax = sns.boxplot(x=pauses, whis=np.inf)
    #ax = sns.swarmplot(x=pauses, color='black')

    x = (3.5+2*np.random.randn(1000, 1))#); x1 = (-3.5+2*np.random.randn(1000, 2))
    #x=np.concatenate((x,x1),axis=0)
    #x_cat = np.random.randint(0,4,size=(2000, 1))
    #x=np.concatenate((x_cat,x),axis=1)
    #df_rand = pd.DataFrame(pauses, columns=['pauses','all pauses'])
    fig, ax = plt.subplots(figsize=(8,3))
    ax = pt.RainCloud(x=pauses,orient='h',bw=.1, ax=ax)
    #sns.despine()

    #sns.despine()
    #ax.figure.set_size_inches(12,8)
    plt.savefig('raincloud_pause_groups_num_all.png')
    plt.show()



#--------------------------------------#--------------------------------------#--------------------------------------

run_ch_eng_all()



#--------------------------------------#--------------------------------------#--------------------------------------
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


