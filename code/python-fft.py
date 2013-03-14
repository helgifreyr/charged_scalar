# import things we need
from scipy import genfromtxt
from scipy.fftpack import fft, fftfreq
from pylab import *                       # plot stuff

# get the data from the text file
data = genfromtxt('obsR1.dat')

# organize the data in arrays
t = data[:,0]
R = data[:,1]

# call the function fft() to calculate the fast fourier transform
fR = fft(R)
freq = fftfreq(t.shape[-1])

# plot the real, imaginary and absolute parts of the fourier transform, you can skip or comment out those you do not want to plot
plot(freq,fR.real)
plot(freq,fR.imag)
plot(freq,abs(fR))

# set the range of the x-axis
xlim(0,0.01)

# show the plot
show()
# uncomment the next line to save it as a png file
#savefig('obsR1-fourier.png')
