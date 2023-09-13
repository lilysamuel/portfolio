import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

matplotlib.rcParams['figure.figsize'] = (12,8)

pd.read_csv(r'/Users/lilysamuel/Desktop/dailyActivity_merged.csv')
df = pd.read_csv(r'/Users/lilysamuel/Desktop/dailyActivity_merged.csv')

df.head()

#Display Null Values

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col,pct_missing))
    
#Data Types For Columns
    
print(df.dtypes)

#Find Total Amount of Active Minutes

df['TotalActiveMinutes'] = df['VeryActiveMinutes'] + df['FairlyActiveMinutes'] + df['LightlyActiveMinutes'] 

print(df['TotalActiveMinutes'])

#We can see from the original dataframe that there are each FitBit owner (Id column) has recorded their data over the span of multiple days. In order to track their active minutes over the course of their time recording their data, I grouped rows on the 'Id' column and got a list for the 'TotalActiveMinutes' column

df2 = df.groupby('Id')['TotalActiveMinutes'].apply(list).reset_index(name="ProgressionOfTotalActiveMinutes")
print(df2)

print(df2['ProgressionOfTotalActiveMinutes'])

#Add all the values in the list of active minutes to get total number of active minutes for each FitBit ID.

df2['TotalActiveMinsPerID'] = df2['ProgressionOfTotalActiveMinutes'].apply(sum).astype(int)
print(df2)

#Now that we have the total amount of active minutes, find out how many hours each Fitbit ID was active for.

df2['TotalActiveHours'] = df2['TotalActiveMinsPerID'].div(60)

print(df2)

#Graph this Data

import matplotlib.pyplot as plt
  

Id_list = list(df2["Id"])
print(Id_list)
  
Hour_list = list(df2["TotalActiveHours"])
print(Hour_list)

plt.plot(Id_list, Hour_list)
plt.xlim=(1503960366, 8877689391)
plt.title('Active Hours amongst Fitbit Users')
plt.xlabel('User ID')
plt.ylabel('Total Active Hours')
plt.xticks(Id_list, labels=Id_list)
plt.show()

#From what we kow from the graph and from the tables above, ID 2873212765 has the highest number of active hours (169.583333) and ID 4057192912 has the lowest number of active 7.016667 (7.016667). 

