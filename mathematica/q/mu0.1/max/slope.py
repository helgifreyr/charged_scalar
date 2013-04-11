from scipy import *
import sys

def calculate_slope(Q,mu,R):
  Rdata = genfromtxt('R.dat')
  Rind = lexsort((Rdata[:,1],Rdata[:,0]))
  Rdata = Rdata[Rind]
  Rq = Rdata[:,0]
  Rfreq = Rdata[:,1]
  Idata = genfromtxt('I.dat')
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

  wc = [q*float(Q)/(1+sqrt(1-float(Q)**2)) for q in Y]

  slope = ((X*Y).mean() - X.mean()*Y.mean()) / ((X**2).mean() - (X.mean())**2)
  print 'For \mu='+mu+', Q='+Q+', R='+R+' the slope is ' +'%7.6f' % slope
  return Rq[-1],Rfreq[-1],slope

lastq, lastfreq, slope = calculate_slope('0.99','0.01','10')
n = int(sys.argv[1])
print 'At q='+str(lastq+n)+', the frequency is '+str(lastfreq + slope * n)
