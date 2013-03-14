from scipy import *
from pylab import *

data = genfromtxt('max.dat')

q = data[:,0]
Q = data[:,1]
Imw = data[:,2]
rm = data[:,3]
Rew = data[:,4]
wc = [i*j/(1+sqrt(1-j**2)) for i,j in zip(q,Q)]

print 'q      Q    Im(w)    r_m   Re(w)   w_c'
for i,j,k,l,m,n in zip(q,Q,Imw,rm,Rew,wc):
  print i,'%5.4f'%j, '%4.3e'%k,'%4.1f'%l,'%5.4f'%m, '%5.4f'%n

plot(q,Q)
show()
