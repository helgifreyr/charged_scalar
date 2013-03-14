from scipy import *
from scipy.fftpack import fft, fftfreq
from pylab import *
import sys

field = sys.argv[1]
x1 = float(sys.argv[2])
x2 = float(sys.argv[3])

data = genfromtxt('obs'+field+'.dat')

t = data[:,0]
R = data[:,1]



fR = fft(R)
freq = fftfreq(t.shape[-1])

plot(freq, fR.real, freq, fR.imag, freq, abs(fR))
yscale('log')
#xscale('log')
xlim(x1,x2)
show()
