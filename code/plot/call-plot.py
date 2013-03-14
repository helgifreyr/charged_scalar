from pylab import *
from scipy import *
from time_plot import *
import time, sys, os

Nx = int(sys.argv[1])

xs = []
datas = []
files = []
for file in sys.argv[2:]:
  points, x, new_data = get_data(file,Nx)
  folder = 'figs-'+file[:-4]+'/'
  plot_time_data(x,new_data,points,folder)
  clf()
  datas.append(new_data)
  xs.append(x)
  files.append(file)

os.system('rm -r figs-multiple')
os.system('mkdir figs-multiple')

for i in arange(points-1):
  for j in arange(len(sys.argv[2:])):
    plot(xs[j],datas[j][i])
    yscale('log')
    # ylim(miny,maxy)
    ylim(1e-25,1e-10)
  legend(files)
  savefig('figs-multiple/' + '%03d' % i + '.png')
  clf()

