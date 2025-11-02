import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

data=pd.read_excel('Q5.3.xlsx')
plt.scatter(data['x'],data['y'])
plt.xlabel('x')
plt.ylabel('y')
plt.title('Scatter plot')
plt.show()