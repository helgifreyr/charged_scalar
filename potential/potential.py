from scipy import *
from pylab import *
import sys

qs = raw_input('qs: ').split()
Qs = raw_input('Qs: ').split()
mus = raw_input('mus: ').split()
ws = raw_input('ws: ').split()
l = 1.0

def Veff(q,Q,mu,w,l):
  rm = 1-sqrt(1-Q**2)
  rp = 1+sqrt(1-Q**2)
  r = linspace(rp+1e-8,100,100000)
  rstar = lambda x: x + 2/(rp-rm) * (rp * log(abs(x-rp)/2) - rm * log(abs(x-rm)/2))

  f = lambda x: 1 - 2/x + Q**2/x**2
  df = lambda x: 2/x**2 - 2*Q**2/x**3

  Veff = lambda x: q*Q/x * (2*w-q*Q/x) + f(x)*(l*(l+1)/x**2 + mu**2) + f(x)*df(x)/x
  #plot(rstar(r),Veff(r), label='$q='+str(q)+'$, $Q='+str(Q)+'$, $\mu='+str(mu)+'$, $\omega='+str(w)+'$')
  #plot(rstar(r),Veff(r), label='$\mu='+str(mu)+'$')
  #plot(rstar(r),Veff(r), label='$Q='+str(Q)+'$')
  plot(rstar(r),Veff(r), label='$q='+str(q)+'$')
  #plot(rstar(r),Veff(r), label='$\omega='+str(w)+'$')
  axhline(y=mu**2,xmin=min(rstar(r)), xmax=max(rstar(r)), linestyle='--',color='black')

for q in qs:
  q = float(q)
  for Q in Qs:
    Q = float(Q)
    for mu in mus:
      mu = float(mu)
      for w in ws:
        w = float(w)
        Veff(q,Q,mu,w,l)
text(-42,0.1,r'$\omega_c\left(2\omega-\omega_c\right)$',fontsize=18)
xlabel(r'$r^*$',fontsize=24)
ylabel(r'$V_{eff}$',fontsize=24)
xlim(-50,100)
# ylim(0,0.3)
legend()
savefig('potential.png')
savefig('potential.eps')
