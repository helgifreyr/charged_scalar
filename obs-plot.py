from scipy import *
from pylab import *
import sys

def obsdata(field,Rout):
  data = genfromtxt('obs'+field+'-'+Rout+'.dat')
  t = data[:,0]
  R = data[:,1]
  return t, R

for Rout in sys.argv[2:]:
  t, R = obsdata(sys.argv[1],Rout)
  plot(t[200:], R[200:], label=Rout)

xlim(200,6500)
yscale('log')
legend()
show()
