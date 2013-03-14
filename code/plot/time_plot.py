from pylab import *
from scipy import *
import time, sys, os

def get_data(file,Nx):
  if Nx == 0:
    Nx = input(file+' Nx: ')
  data = genfromtxt(file)
  points = int(len(data[:,0])/Nx)

  x = data[0:Nx-1,0]
  new_data = []
  miny = 0
  maxy = 0
  for i in range(0,points):
    y = data[(Nx-1)*i:(Nx-1)*(i+1),1]
    new_data.append(y)
  return points, x, new_data

def plot_time_data(x,time_data,points,folder='figs/'):
  os.system('rm -r '+folder)
  os.system('mkdir '+folder)

  plot(x,time_data[0])
  # ylim(mean(time_data[0])/1000,mean(time_data[0])*1000)
  ylim(1e-25,1e-10)
  yscale('log')
  savefig(folder+'000.png')

  for i in arange(1,points):
    clf()
    plot(x,time_data[i])
    # ylim(mean(time_data[0])/1000,mean(time_data[0])*1000)
    ylim(1e-25,1e-10)
    yscale('log')
    savefig(folder+'%03d' % i+'.png')
