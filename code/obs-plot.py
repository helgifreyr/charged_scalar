from scipy import *
from pylab import *
import sys

def obsdata(field):
  data = genfromtxt('obs'+field+'.dat')
  t = data[:,0]
  R = data[:,1]
  return t, R

t, R = obsdata(sys.argv[1])
plot(t[200:], R[200:])

xlim(200,6500)
yscale('log')
show()
