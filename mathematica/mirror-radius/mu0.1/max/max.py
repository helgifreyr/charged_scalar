from scipy import *
from pylab import *

data = genfromtxt('max.dat')

mu = 0.1
q = data[:,0]
Q = data[:,1]
Imw = data[:,2]
rm = data[:,3]
Rew = data[:,4]
wc = [i*j/(1+sqrt(1-j**2)) for i,j in zip(q,Q)]
Veff_hor = [i*(2*mu-i) for i,j in zip(wc,Rew)]

print 'q      Q    Im(w)    r_m   Re(w)   w_c   Veff_hor'
for i,j,k,l,m,n,p in zip(q,Q,Imw,rm,Rew,wc,Veff_hor):
  print i,'%5.4f'%j, '%4.3e'%k,'%4.1f'%l,'%5.4f'%m, '%5.4f'%n, '%6.4f'%p #, n * (2*m - n)

# plot(q,Q)
# show()
