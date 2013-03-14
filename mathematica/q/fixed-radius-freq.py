from scipy import *
from pylab import *
import sys

part = sys.argv[1]

mus = raw_input('mus: ').split()
Qs = raw_input('Qs: ').split()
Rs = raw_input('Rs: ').split()

if mus == []:
  mus = ['0.1','0.2','0.3']
  mus_text = 'all'
else:
  mus_text = '-'.join(mus)
if Qs == []:
  Qs = ['0.800', '0.900','0.950','0.990','0.999']
  Qs_text = 'all'
else:
  Qs_text = '-'.join(Qs)
if Rs == []:
  Rs = ['20','30', '40']
  Rs_text = 'all'
else:
  Rs_text = '-'.join(Rs)

maxy = 0
for mu in mus:
  for Q in Qs:
    for R in Rs:
      folder = 'mu'+mu+'/r='+R+'/Q='+Q+'/'
      data = genfromtxt(folder+part+'.dat')
      ind = lexsort((data[:,1],data[:,0]))  
      data = data[ind]
      mirror = data[:,0]
      freq = data[:,1]
      plot(mirror, freq, label='Q='+Q+', r='+R+r', $\mu$='+mu)
      if max(freq) > maxy:
        maxy = max(freq)

# legend(loc=2)
# yscale('log')
# xscale('log')
xlim(0,5)
if sys.argv[1] == 'I':
  ylim(1e-10,1e-4)
  ylabel(r'$Im(\omega)$')
else:
  ylabel(r'$Re(\omega)$')
xlabel(r'$\frac{q}{\mu}$')
savefig(part+'-mu-'+mus_text+'-R-'+Rs_text+'-Q-'+Qs_text+'.png')
