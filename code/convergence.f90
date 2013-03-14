	program main	
	implicit none

	integer TOT, i

	real*8 v1, v2, v3, t1, t2, t3, uL, uM, uH, diffLM, diffMH

	print*, 'enter tot'
	read*, tot

        ! for the rho----------------------------------------
	 
        open (30, file = 'rho-max_L.dat', status = 'old')
        open (31, file = 'rho-max_M.dat', status = 'old')
        open (32, file = 'rho-max_H.dat', status = 'old')
        open (33, file = 'Qfactor-rho.dat')

	do i = 1, TOT
  	  read(30,*) t1,uL
          read(31,*) t2,uM
          read(32,*) t3,uH

          diffLM = dabs(uL - uM)
          diffMH = dabs(uM - uH)

 	  if(diffMH.gt.0.and.abs(t1-t2).lt.0.01) then
  	    write(33,*) t1,log(diffLM/diffMH)/log(2.)
	    print*, log(diffLM/diffMH)/log(2.)
	  else 
	    print*, "problems with time", t1, t2  
	  end if
	end do

	end program



	
