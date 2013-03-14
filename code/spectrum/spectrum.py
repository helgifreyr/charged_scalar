from pylab import *
from scipy import *
from scipy.fftpack import fft,fftfreq
import sys

data = genfromtxt('obs'+sys.argv[1]+'.dat')

t = data[:,0]
R = data[:,1]
plot(t,R)
ylim(1e-12,5e-6)
yscale('log')
xlabel(r'$t$')
ylabel(r'$R$')
savefig('obs'+sys.argv[1]+'-time.png')
clf()


ft = fft(R)
w = fftfreq(t.shape[-1])
fta = abs(ft)

localmax = (diff(sign(diff(fta))) < 0).nonzero()[0] + 1

file = open('obs'+sys.argv[1]+'-peaks','w')
file.write('# pos     time      freq       fta\n')
for i,j,k,l in zip(localmax, t[1:][localmax], w[localmax], fta[localmax]):
  if k > 0:
    file.write('%5d' % i + '%11.3f' % j + '%11.7f' % k + '%11.3e' % l+'\n')

#for i,j in zip(w[localmax],fta[localmax]):
#  text(i,j,'max')
plot(w,fta)
if len(sys.argv) > 2:
  xlim(float(sys.argv[2]),float(sys.argv[3]))
else:
  xlim(0,max(w))
xlabel(r'$\omega$')
ylabel(r'$\tilde{R}$')
savefig('obs'+sys.argv[1]+'-frequency.png')
#show()
