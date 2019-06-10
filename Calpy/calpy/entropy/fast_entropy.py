import numpy

"""TO DO: 
        - Get FAST ENTROPY working
        - Restructure entropy profile to include both classic and fast modes
        - Generalize to use any M
        - Generalize to use any selected_symbol (if selected symbol doesnt occur)
            - What happens to entropy when we selected symbol occurs way outside of what we expect??
                -example, whole time?
"""

def fast_entropy_profile(symbols, selected_symbol, M, ap, bp, cp, window_size=4000, window_overlap = 0):
    """Estimate the entropy profile of a list of symbols using predefined parameters

    Args:
        symbols (numpy.array or list (int)):  A list of symbols.
        selected_symbol (int or char): A selected symbol from the symbol set.
        M (int): Number of distinct symbols in the set.
        ap (int): the a value for the model D used to estimate M.
        bp (int): the b value for the model D used to estimate M.
        cp (int): the c value for the model D used to estimate M.
        window_size (int, optional):  Number of symbols per entropy window.  Defaults to 100.
        window_overlap (int, optional):  How much the entropy windows should overlap.  Defaults to 0.

    Returns:
        numpy.array(float): The entropy profile.
    """

    entropy_profile = [] #Hp  - I changeed this to keep in style with the current formatting of variables
    windows = int(len(symbols)/window_size)
    window_start_index = 0
    for j in range(windows):
        window_end_index = window_start_index + window_size
        symbol_window_block = symbols[window_start_index:window_end_index]
        estimated_entropy = fast_entropy(symbol_window_block, selected_symbol, M, ap, bp, cp)
        entropy_profile.append(estimated_entropy)
        window_start_index = window_end_index + 1
        #print(j ,"\n")
    # MeanHe = numpy.mean(entropy_profile)
    # n = len(entropy_profile)
    # print(n)
    # print('{} \n'.format(MeanHe))
    return entropy_profile

def fast_entropy(symbols, selected_symbol, M, ap, bp, cp):
    """Calculates the entropy value of a given set of samples

    Args:
        symbols (numpy.array or list (int)):  A list of symbols.
        selected_symbol (int or char): A selected symbol from the symbol set.
        M (int): Number of distinct symbols in the set.
        ap (int): the a value for the model D used to estimate M.
        bp (int): the b value for the model D used to estimate M.
        cp (int): the c value for the model D used to estimate M.

    Results:
        float: The entropy value

    """
    """
        To Do: Rename variables to be more descriptive
    """
    mean_rank_distance = compare_rank_distance(symbols, selected_symbol)
    if mean_rank_distance == 0:
        print("Selected Symbol Not Found")
        return 0
    R = 1
    k_est = ap * (numpy.power(mean_rank_distance, bp)) + cp
    #print('*A) For calculated Dmean={}, we have Kest={},\n'.format(mean_rank_distance, k_est))
    m_est = k_est
    m1_est = k_est + 1
    a2 = numpy.log2(m1_est) / numpy.log2(m_est)
    beta2 = m_est / (m1_est)
    gamma2 = numpy.power(m_est, (a2 - 1)) / numpy.power((m_est - 1), a2)
    p = numpy.zeros(M)
    p_sum = 0
    rangeM = range(M)
    for r in range(M):
        Pr = gamma2 / numpy.power(((r+1) + beta2), a2)
        p[r] = Pr
        p_sum = p_sum + Pr
    k_norm = p_sum
    p_sum = 0
    for r in range(M):
        Pr = p[r] / k_norm
        p[r] = Pr
        p_sum = p_sum + Pr
    He = 0
    for r in range(M):
        He = He + (p[r] * numpy.log2(p[r]))
        #print('r: {}  p[r] = {}   log2(p[r]) = {}    He = {} \n'.format(r,p[r], numpy.log2(p[r]), He))
    Hea = -He
    return Hea

def compare_rank_distance(symbols, selected_symbol):
    """Compares the distances between a given symbol thor

    :param symbols:
    :param selected_symbol:
    :return:
    """
    """
        Should we use a more general term for this?
        My understanding is this is essentially our P(rank.i)
        So could there be other measures by which we find P(rank.i) other than comparing distance?
    """
    distances = []
    last_i = -1 #matlab starts on index 1, so last_i needs to be one less than i, not sure why 2 though?"
    symbol_count = 0
    """COMPARE [C,C,C,C,C,C] TO MATLAB"""
    for i in range(len(symbols)):
        if selected_symbol == symbols[i]:
            dist = i - last_i + 1
            last_i = i
            distances.append(dist)
            #print("i ", i, "  dist ", dist, " sum ", numpy.sum(distances), "symb count ", symbol_count)
            symbol_count = symbol_count + 1
        #print("i ",i, "symb - ", symbols[i])
    #print("sum - ",numpy.sum(distances))
    return numpy.mean(distances)

def symbolise_file():
   return
