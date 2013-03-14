from scipy import *
import time, sys, os

field = sys.argv[1]

def extract(field, dx):
  time = []
  for line in open(field+'-'+dx+'.dat'):
    if '#' in line:
      t = line.split()[3]
      time.append(t)
  data = genfromtxt(field+'-'+dx+'.dat')
  Nx = int(dx)
  points = int(len(data[:,0])/Nx)

  x = data[0:Nx-1,0]
  new_data = []
  miny = 0
  maxy = 0
  for i in range(0,points+1):
    y = data[(Nx-1)*i:(Nx-1)*(i+1),1]
    new_data.append(y)
    if min(y) < miny:
      miny = min(y)
    if max(y) > maxy:
      maxy = max(y)
  return time, x, new_data, miny, maxy

def norm1(vector1,vector2):
  sum = 0
  for i,j in zip(vector1,vector2):
    sum += abs(i-j)**2
  return sqrt(sum)

times = []
xs = []
datas = []
minys = []
maxys = []
for dx in sys.argv[2:]:
  time, x, data, miny, maxy = extract(field, dx)
  times.append(time)
  xs.append(x)
  datas.append(data)
  minys.append(miny)
  maxys.append(maxy)

norm12 = []
norm24 = []
for t in range(1,len(times[0])):
  norm12.append(norm1(datas[0][t],datas[1][t][::2]))
  norm24.append(norm1(datas[1][t][::2],datas[2][t][::4]))

output1 = open(field+'-f12.dat','w')
output2 = open(field+'-f24.dat','w')
output3 = open(field+'-f12f24.dat','w')
output1.write('#  t    |f1-f2|\n')
output2.write('#  t    |f2-f4|\n')
output3.write('#  t    |f1-f2|/|f2-f4|\n')
for t,f12,f24 in zip(times[0][1:],norm12,norm24):
  output1.write('%7.2f' % float(t) +'  '+'%12.10f' % float(f12)+'\n')
  output2.write('%7.2f' % float(t) +'  '+'%12.10f' % float(f24)+'\n')
  output3.write('%7.2f' % float(t) +'  '+'%7.5f' % float(f12/f24)+'\n')
