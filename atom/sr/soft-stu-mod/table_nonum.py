import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
import os,sys
import pandas as pd

ai = 1.0
bi = 1.0
toev = 27.211386

def scf_fit(x,*parms):
        return parms[0] + parms[1]*np.exp(-parms[2]*x)

#def corr_fit(x,*parms):
#        return parms[0]+parms[1]/(x+3./8.)**3 + parms[2]/(x+3./8.)**5
def corr_fit(x,a,b,c):
        return a+b/(x+3./8.)**3 + c/(x+3./8.)**5


df=pd.DataFrame()

for basis in ['dz','tz','qz']:
	x = pd.read_csv('./basis/'+basis+'.table1.csv',skip_blank_lines=True,skipinitialspace=True)
	df[basis+'_scf'] = x['SCF']
        df[basis+'_ccsd'] = x['CCSD']

scf = df.filter(regex='scf')
cc = df.filter(regex='ccsd')

n = [2,3,4]

scf_extrap = []
corr_extrap=[]
for i in df.index:
	y1 = scf.iloc[i, :].values
	y2 = cc.iloc[i, :].values
	ycorr = y2 - y1
	#print(ycorr)
	initial = [2*y2[2]-y2[1], ai, bi]
	limit = ([2*y2[2]-y2[0]-0.2, 0, 0], [y1[2], 100, 100])
	popt1, pcov1 = curve_fit(scf_fit, n, y1, p0=initial, bounds=limit)
	popt2, pcov2 = curve_fit(corr_fit, n, ycorr)
	scf_extrap.append(popt1[0])
	corr_extrap.append(popt2[0])

scf['extrap'] = scf_extrap
scf['extrap_gaps'] = scf['extrap'].values - scf['extrap'].values[0]
cc['extrap'] = np.array(corr_extrap)+np.array(scf_extrap)

##Extrapolation is done here. I am doing formating for the SCF Table, namely hf and Correlation Table, namely corr

hf = pd.DataFrame()

hf['D'] = scf['dz_scf']
hf['T'] = scf['tz_scf']
hf['Q'] = scf['qz_scf']
hf['Extrap.'] = scf['extrap']
hf['Extrap.Gaps'] = scf['extrap_gaps']


corr = pd.DataFrame()
corr['D'] = cc['dz_ccsd']-scf['dz_scf']
corr['T'] = cc['tz_ccsd']-scf['tz_scf']
corr['Q'] = cc['qz_ccsd']-scf['qz_scf']
corr['Extrap.'] = corr_extrap
corr['Extrap.Gaps'] = corr['Extrap.'].values - corr['Extrap.'].values[0]
print(hf.to_latex(index=False))
print(corr.to_latex(index=False))
#corr['extrap'] = corr_extrap
	
import pickle
gaps = pd.DataFrame()
gaps['extrapolated gaps'] = hf['Extrap.Gaps'] + corr['Extrap.Gaps']
gaps.drop(gaps.index[0],inplace=True)
with open('gaps.p','wb') as f:
        pickle.dump(gaps,f)




#initial=[2*y1[2]-y1[1], ai, bi]
#limit=( [2*y1[2]-y1[0], 0, 0], [y1[2], 100, 100])
#
#popt1, pcov1 = curve_fit(scffunc, x, y1, p0=initial, bounds=limit)
#popt2, pcov2 = curve_fit(ccfunc, x, y2)
