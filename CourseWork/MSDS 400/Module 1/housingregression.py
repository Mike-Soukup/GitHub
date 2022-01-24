# Script explaining how to perform linear regression in Python with a dataset from Kaggle in a file USA_Housing.csv

#First import modules needed for functionality
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

usahousing = pd.read_csv('USA_Housing.csv')
usahousing.head()
usahousing.info()
usahousing.describe()
usahousing.columns
# Price will be the dependent variable (Y)
sns.pairplot(usahousing)