from scipy import *
from pylab import *
import sys

part = sys.argv[1]

Qs = raw_input('Qs: ').split()
Rs = raw_input('Rs: ').split()

if Qs == []:
  Qs = ['0.800', '0.900','0.950','0.990']
  Qs_text = 'all'
else:
  Qs_text = '-'.join(Qs)
if Rs == []:
  Rs = ['20','30', '40']
  Rs_text = 'all'
else:
  Rs_text = '-'.join(Rs)

maxy = 0
for Q in Qs:
  for R in Rs:
    folder = 'r='+R+'/Q='+Q+'/'
    data = genfromtxt(folder+part+'.dat')
    ind = lexsort((data[:,1],data[:,0]))  
    data = data[ind]
    mirror = data[:,0]
    freq = data[:,1]
    plot(mirror, freq, label='Q='+Q+', r='+R)
    if max(freq) > maxy:
      maxy = max(freq)

legend(loc=2)
yscale('log')
# xscale('log')
# xlim(0,1)
ylim(1e-10,1e-4)
xlabel(r'$\frac{q}{\mu}$')
ylabel(r'$Im(\omega)$')
savefig(part+'-R-'+Rs_text+'-Q-'+Qs_text+'.png')
