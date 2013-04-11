from scipy import *
from pylab import *

data = genfromtxt('max.dat')

mu = 0.2
q = data[:,0]
Q = data[:,1]
Imw = data[:,2]
rm = data[:,3]
Rew = data[:,4]
wc = [i*j/(1+sqrt(1-j**2)) for i,j in zip(q,Q)]


print 'q      Q    Im(w)    r_m   Re(w)   w_c   Veff_hor'
for i,j,k,l,m,n in zip(q,Q,Imw,rm,Rew,wc):
  print i,'%5.4f'%j, '%4.3e'%k,'%4.1f'%l,'%5.4f'%m, '%5.4f'%n
  if i<1.5:
    x = linspace(0,1,1000)
    y = lambda x: 2*mu*i*x/(1+sqrt(1-x**2)) - i**2*x**2/(1-x**2)
    ylim(-0.5*max(y(x)),1.1*max(y(x)))
    plot(x,y(x),label='q='+str(i))

legend()
# plot(q,Q)
show()
