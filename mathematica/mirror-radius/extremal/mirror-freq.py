from scipy import *
from pylab import *
import sys

part = sys.argv[1]

mus = raw_input('mus: ').split()
qs = raw_input('qs: ').split()

if mus == []:
  mus = ['0.1','0.2','0.3']
  mus_text = 'all'
else:
  mus_text = '-'.join(mus)
if qs == []:
  qs = ['0.13','0.15','0.2','0.3','0.5','0.6','0.8','0.9']
  # qs = ['0.5','0.6','0.8','0.9']
  qs_text = 'all'
else:
  qs_text = '-'.join(qs)
colors = {'0.5':'black','0.6':'green', '0.8':'red', '0.9':'blue'}
linestyles = {'0.5':':','0.6':'-.', '0.8':'-', '0.9':'--'}

f = figure()
ax = f.add_subplot(111)

maxy = 0
for mu in mus:
  for q in qs:
    folder = 'mu'+mu+'/q='+q+'/'
    data = genfromtxt(folder+part+'.dat')
    ind = lexsort((data[:,1],data[:,0]))
    data = data[ind]
    mirror = data[:,0]
    freq = data[:,1]
    if q in linestyles and q in colors:
      plot(mirror, freq, label='$q='+q+'$', linestyle=linestyles[q], color=colors[q], linewidth=2)
    else:
      plot(mirror, freq, label='$q='+q+'$', linewidth=2)
    if max(freq) > maxy:
      maxy = max(freq)

rcParams.update({'font.size': 20})
xlabel(r'$r_m$', fontsize=26)
gcf().subplots_adjust(bottom=0.15,left=0.15)
if sys.argv[1] == 'I':
  # xscale('log')
  yscale('log')
  ylabel(r'$Im(\omega)$')
  # xlim(4,30)
  # ylim(1e-5,1.1e-3)
  # yticks([5e-8,1e-7,1e-6,1e-5],['$5\cdot10^{-8}$','$10^{-7}$','$10^{-6}$','$10^{-5}$'])
  # yticks(concatenate((arange(1,11)*1e-8, arange(1,11)*1e-7, arange(1,11)*1e-6),axis=0))
  # yticks(concatenate((arange(1,11)*1e-7, arange(1,11)*1e-6),axis=0))
else:
  # ylabel(r'$Re(\omega)$')
  # xlim(2,30)
  ylim(0.2,0.6)
  yticks(arange(4,13)/20.0,[str(i) for i in arange(4,13)/20.0])
# if mus[0] == '0.1':
#   text(0.9, 0.95,r'$q='+qs[0]+'$',
#       horizontalalignment='center',
#       verticalalignment='center',
#       transform = ax.transAxes,
#       fontsize=22)
# elif mus[0] == '0.3':
#   if qs[0] == '0.6':
#     legend(loc=1, fontsize=14)
# legend(loc=1,fontsize=10)
# xticks(arange(5,35,5),[str(i) for i in arange(5,35,5)])
savefig(part+'-mu-'+mus_text+'-q-'+qs_text+'.png')
# savefig(part+'-mu-'+mus_text+'-Q-'+Qs_text+'-q-'+qs_text+'.eps')
