from scipy import *
from pylab import *
import sys

part = sys.argv[1]
nolog = sys.argv[2]

ratios = raw_input('ratios: ').split()
Qs = raw_input('Qs: ').split()

if Qs == []:
  Qs = ['0.800','0.900','0.950','0.990','0.997']
  Qs_text = 'all'
else:
  Qs_text = '-'.join(Qs)
if ratios == []:
  ratios = ['0.4','0.8','1.0','1.4','1.8','2.0']
  ratios_text = 'all'
else:
  ratios_text = '-'.join(ratios)
colors = {'0.800':'cyan', '0.900':'black', '0.950':'green', '0.990':'red', '0.997':'blue'}
linestyles = {'0.4':'-','0.8':'--','1.0':':','1.2':'-.','1.4':'-', '1.8':'--', '2.0':':', '9.9':':'}

maxy = 0
for Q in Qs:
  for ratio in ratios:
    folder = 'ratio'+ratio+'/Q='+Q+'/'
    data = genfromtxt(folder+part+'.dat')
    ind = lexsort((data[:,1],data[:,0]))
    data = data[ind]
    mirror = data[:,0]
    freq = data[:,1]
    if Q not in colors:
      colors[Q] = 'black'
    if nolog == '1':
      # plot(mirror, freq, ls=linestyles[ratio], label='Q='+Q+', ratio='+ratio, color=colors[Q])
      plot(mirror, freq, label='Q='+Q+', ratio='+ratio, color=colors[Q])
    else:
      if max(freq) > 0:
        # plot(mirror, freq, ls=linestyles[ratio], label='Q='+Q+', ratio='+ratio, color=colors[Q])
        plot(mirror, freq, label='Q='+Q+', ratio='+ratio, color=colors[Q])
    if max(freq) > maxy:
      maxy = max(freq)

# legend(loc=4)
if nolog == '0':
  yscale('log')
  xscale('log')
  xlim(4,50)
  # ylim(1e-9,1e-5)
  ylim(maxy/1000,10*maxy)
else:
  xlim(4,80)
  ylim(-1e-9,1.5*maxy)
xlabel(r'$r_0$')
ylabel(r'$Im(\omega)$')
if nolog == '0':
  savefig(part+'-Q-'+Qs_text+'-ratio-'+ratios_text+'-log.png')
else:
  savefig(part+'-Q-'+Qs_text+'-ratio-'+ratios_text+'.png')
