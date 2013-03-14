from scipy import *
from pylab import *
import sys

part = sys.argv[1]

Qs = raw_input('Qs: ').split()
qs = raw_input('qs: ').split()

if Qs == []:
  Qs = ['0.80','0.90','0.95','0.990','0.999']
  Qs_text = 'all'
else:
  Qs_text = '-'.join(Qs)
if qs == []:
  qs = ['0.6','0.8','0.9']
  qs_text = 'all'
else:
  qs_text = '-'.join(qs)

maxy = 0
for Q in Qs:
  for q in qs:
    folder = 'Q='+Q+'/q='+q+'/'
    data = genfromtxt(folder+part+'.dat')
    ind = lexsort((data[:,1],data[:,0]))
    data = data[ind]
    mirror = data[:,0]
    freq = data[:,1]
    plot(mirror, freq, label='Q='+Q+', q='+q)
    if max(freq) > maxy:
      maxy = max(freq)

legend()
yscale('log')
xscale('log')
xlim(4,50)
ylim(1e-8,5e-5)
xlabel(r'$r_0$')
ylabel(r'$Im(\omega)$')
savefig(part+'-Q-'+Qs_text+'-q-'+qs_text+'.png')
