from scipy import *

mus = raw_input('mus: ').split()
Rs = raw_input('Rs: ').split()
Qs = raw_input('Qs: ').split()

if Qs == []:
  Qs = ['0.800','0.900','0.950','0.990']
if mus == []:
  mus = ['0','0.1','0.2','0.3']
if Rs == []:
  Rs = ['20','30','40',]

def calculate_slope(Q,mu,R):
  folder = 'mu'+mu+'/r='+R+'/Q='+Q+'/'
  Rdata = genfromtxt(folder+'R.dat')
  Rind = lexsort((Rdata[:,1],Rdata[:,0]))
  Rdata = Rdata[Rind]
  Rq = Rdata[:,0]
  Rfreq = Rdata[:,1]
  Idata = genfromtxt(folder+'I.dat')
  Iind = lexsort((Idata[:,1],Idata[:,0]))
  Idata = Idata[Iind]
  Iq = Idata[:,0]
  Ifreq = Idata[:,1]

  eyes = []
  for i,j in zip(range(len(Ifreq)),Ifreq):
    if j>0:
      eyes.append(i)

  Y = Rfreq[eyes]
  X = Rq[eyes]

  wc = [q for q in Y]

  slope = ((X*Y).mean() - X.mean()*Y.mean()) / ((X**2).mean() - (X.mean())**2)
  print 'For \mu='+mu+', Q='+Q+', R='+R+' the slope is ' +'%7.6f' % slope

for mu in mus:
  for Q in Qs:
    for R in Rs:
      calculate_slope(Q,mu,R)
