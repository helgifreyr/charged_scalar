import numpy as np

a=np.array([10.3,2,0.9,4,5,6,7,34,2,5,25,3,-26,-20,-29],dtype=np.float)

gradients=np.diff(a)
print gradients

maxima_num=0
minima_num=0
max_locations=[]
min_locations=[]
count=0 
for i in gradients[:-1]:
  count+=1

if ((cmp(i,0)>0) & (cmp(gradients[count],0)<=0) & (i != gradients[count])):
  maxima_num+=1
  max_locations.append(count)

if ((cmp(i,0)<0) & (cmp(gradients[count],0)>=0) & (i != gradients[count])):
  minima_num+=1
  min_locations.append(count)

turning_points = {'maxima_number':maxima_num,'minima_number':minima_num,'maxima_locations':max_locations,'minima_locations':min_locations}

print turning_points

