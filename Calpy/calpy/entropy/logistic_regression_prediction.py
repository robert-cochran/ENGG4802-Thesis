import pandas
import sklearn
from astropy.table import Table,Column,MaskedColumn
from astropy.io import ascii

def create_dataset(x,y,fileout):
    """

    :param x: the entropy values
    :param y: Typical or Atypical
    :param fileout: has to be in a format of 'filename.csv', only csv file is readable by pandas package
    :return: create a csv file containing the training data
    """
    data = Table([x, y], names=['Entropy', 'T_or_A'])
    ascii.write(data, fileout)

def logistic_regression_prediction(trainset,entropy):
