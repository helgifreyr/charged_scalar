program main
  use m_initial
  use m_evolve
  use m_pars 
  use m_derivs
  implicit none


  !define variables, of an undetermined size yet

	real*8, dimension(:,:), allocatable :: unew, uold, du, dtu
	real*8, dimension(:), allocatable :: x, mout
	
  !variables for the rest
	real*8 :: dx, dt, Rmax, maskf, pp, energy,aux1,aux2,smallpi
  real*8 :: xx, rk_pi, R, psi, pi, ipi, dx_psi, dx_pi, Delta1
	integer :: i,j,k,gft_out_full,gft_out_brief, ret, eb, ebo
	integer :: iobs1,iobs2,iobs3,iobs4,iobs5
  integer  output2d, n_frame

  output2d = 10
	smallpi= acos(-1.0d0)
  n_frame = 0 

  !read pars
	call readpars
   	
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  !allocate memmory
	allocate(uold(dim,Nx),unew(dim,Nx),x(Nx),mout(Nx), du(dim,Nx), dtu(dim,Nx))

  !define grid
	dx = (Rout - Rin)/dble(Nx-1)
	dt = cfl * dx
	do i=1, Nx
	  x(i) = Rin + dble(i-1)*dx
	end do

  iobs1 = int(1 + (Robs1 - Rin)/dx)
  iobs2 = int(1 + (Robs2 - Rin)/dx)
  iobs3 = int(1 + (Robs3 - Rin)/dx)
  iobs4 = int(1 + (Robs4 - Rin)/dx)
  iobs5 = int(1 + (Robs5 - Rin)/dx)


	print *, "iobs1=", iobs1, "obsR1=", Rin + dble(iobs1-1)*dx
	print *, "iobs2=", iobs2, "obsR2=", Rin + dble(iobs2-1)*dx
	print *, "iobs3=", iobs3, "obsR3=", Rin + dble(iobs3-1)*dx
	print *, "iobs4=", iobs4, "obsR4=", Rin + dble(iobs4-1)*dx
	print *, "iobs5=", iobs5, "obsR5=", Rin + dble(iobs5-1)*dx

  mout = 1
  eb = 1
  energy=0.0
  aux1=0.0
  aux2=0.0
	
  !intialize
	time = 0.0
	call initial(uold,x,Nx,dx,dt)
	
	open (110, file="R.dat")
	open (111, file="psi.dat")
	open (112, file="pi.dat")
	open (132, file="dt-pi.dat")
	open (120, file="iR.dat")
	open (121, file="ipsi.dat")
	open (122, file="ipi.dat")
	open (140, file="potential.dat")
	open (150, file="operator.dat")
	open (113, file="obsR1.dat")
	open (114, file="obsR2.dat")
	open (115, file="obsR3.dat")
	open (116, file="obsR4.dat")
	open (117, file="obsR5.dat")
	open (118, file="energy.dat")
  open (300, file="R3d.dat")
  open (301, file="rho3d.dat")
  open(64,file="algo.gnu" ,status='unknown')

  write(64,764)


  764  format( "set term jpeg "/ &
               "set parametric"/ &
               "set nokey"/ &
               "pause_val = 0")





  print*, time, maxval(abs(uold(1,:))),maxval(abs(uold(2,:)))

  write(110,*) "# time = ", time
  write(111,*) "# time = ", time
  write(112,*) "# time = ", time
  write(120,*) "# time = ", time
  write(121,*) "# time = ", time
  write(122,*) "# time = ", time
  write(132,*) "# time = ", time
  write(140,*) "# time = ", time
  write(150,*) "# time = ", time

  ! get d_x psi
  call derivs12(uold(3,:),du(3,:), dx, Nx, eb)
  do j=1,nx-1
	  write(110,*) x(j), uold(1,j)*x(j)
	  write(111,*) x(j), uold(3,j)*x(j)
	  write(112,*) x(j), uold(5,j)*x(j)
	  write(120,*) x(j), uold(2,j)*x(j)
	  write(121,*) x(j), uold(4,j)*x(j)
	  write(122,*) x(j), uold(6,j)*x(j)
    R    = uold(1,j)
    psi  = uold(3,j)
    pi   = uold(5,j)
    ipi   = uold(6,j)

    dx_psi = du(3,j)
    dx_pi  = du(5,j)

    xx = x(j)
    Delta1 = (xx*xx + 2.0d0*M*xx-Q**2)
    rk_pi   = (1.0d0/Delta1) * ( (2*M*xx - Q*Q)*dx_pi + xx*xx*dx_psi ) &
          + (2.0d0/Delta1**2) * ((M*xx**3 + 4.0d0*M*M*xx*xx - 4.0d0*M*Q*Q*xx + Q**4)*pi/xx + xx*(xx*xx+3.0d0*M*xx - 2.0d0*Q*Q)*psi) &
          + 2.0d0*scalar_charge*Q*ipi/xx + (scalar_charge**2*Q*Q*(xx*xx+2.0d0*M*xx-Q*Q)/xx**4 - l*(l+1.0d0)/xx**2 - scalar_mass**2)*R
    write(140,*) x(j), rk_pi
	end do
	write(113,*) time, uold(1,iobs1)
	write(114,*) time, uold(1,iobs2)
	write(115,*) time, uold(1,iobs3)
	write(116,*) time, uold(1,iobs4)
	write(117,*) time, uold(1,iobs5)
  !	write(118,*) time, energy

  !2d


!        ret = gft_out_full('V',time, nx-1, 'x', 1, x,uold(1,1:nx-1)) 
!        ret = gft_out_full('W',time, nx-1, 'x', 1, x,uold(2,1:nx-1)) 
			
  !time loop	
	do i = 1, Nt

    call evolve(unew,uold,dx,dt,eb,x)
    call derivs12(unew(3,:),du(3,:), dx, Nx, eb)
    call derivsT(unew(5,:),uold(5,:), dtu(5,:), dt, Nx, eb)
    if (i == 1) then
      do j=1,Nx-1
   	    write(132,*) x(j), dtu(5,j)
        R    = uold(1,j)
        psi  = uold(3,j)
        pi   = uold(5,j)
        ipi   = uold(6,j)

        dx_psi = du(3,j)
        dx_pi  = du(5,j)

        xx = x(j)
        Delta1 = (xx*xx + 2.0d0*M*xx-Q**2)
        rk_pi   = (1.0d0/Delta1) * ( (2*M*xx - Q*Q)*dx_pi + xx*xx*dx_psi ) &
                + (2.0d0/Delta1**2) * ((M*xx**3 + 4.0d0*M*M*xx*xx - 4.0d0*M*Q*Q*xx + Q**4)*pi/xx + xx*(xx*xx+3.0d0*M*xx - 2.0d0*Q*Q)*psi) &
                + 2.0d0*scalar_charge*Q*ipi/xx + (scalar_charge**2*Q*Q*(xx*xx+2.0d0*M*xx-Q*Q)/xx**4 - l*(l+1.0d0)/xx**2 - scalar_mass**2)*R
        write(150,*) x(j), dtu(5,j) - rk_pi
      end do
    end if
    call derivsT(uold(5,:),unew(5,:), dtu(5,:), dt, Nx, eb)

    !update fileds and time	
	  uold = unew
	  time = time + dt

    !if(time .gt. 300.0) then
    aux1 = aux1+uold(1,iobs1)*dt
    aux2 = aux1*aux1
    !energy = energy + aux2*dt/tot_mas**2/(16.0d0*smallpi)
    energy = energy + aux2*dt/(16.0d0*smallpi) ! en vacio

    !end if
	  
!	  if(mod(i,freq/40).eq.0) then
      write(113,*) time, uold(1,iobs1)
      write(114,*) time, abs(uold(1,iobs1))
      write(115,*) time, uold(1,iobs3)
      write(116,*) time, uold(1,iobs4)
      write(117,*) time, uold(1,iobs5)
	    write(118,*) time, energy
!    end if

    !every now and then do some output
	  if(mod(i,freq).eq.0) then

	    !will call here for output
	    print*, time, maxval(abs(uold(1,:))),maxval(abs(uold(2,:)))
        write(110,*) "  "
        write(111,*) "  "
        write(112,*) "  "
        write(120,*) "  "
        write(121,*) "  "
        write(122,*) "  "
        write(132,*) "  "
        write(140,*) "  "
        write(150,*) "  "
        write(110,*) "# time = ", time
        write(111,*) "# time = ", time
        write(112,*) "# time = ", time
        write(120,*) "# time = ", time
        write(121,*) "# time = ", time
        write(122,*) "# time = ", time
        write(132,*) "# time = ", time
        write(140,*) "# time = ", time
        write(150,*) "# time = ", time

        do j=1,Nx-1
          ! multiply by x(j) so that the outgoing wave does not decay
   	      write(110,*) x(j), uold(1,j)*x(j)
   	      write(111,*) x(j), uold(3,j)*x(j)
	        write(112,*) x(j), uold(5,j)*x(j)
   	      write(120,*) x(j), uold(2,j)*x(j)
   	      write(121,*) x(j), uold(4,j)*x(j)
	        write(122,*) x(j), uold(6,j)*x(j)
   	      write(132,*) x(j), dtu(5,j)
          R    = uold(1,j)
          psi  = uold(3,j)
          pi   = uold(5,j)
          ipi   = uold(6,j)

          dx_psi = du(3,j)
          dx_pi  = du(5,j)

          xx = x(j)
          Delta1 = (xx*xx + 2.0d0*M*xx-Q**2)
          rk_pi   = (1.0d0/Delta1) * ( (2*M*xx - Q*Q)*dx_pi + xx*xx*dx_psi ) &
                  + (2.0d0/Delta1**2) * ((M*xx**3 + 4.0d0*M*M*xx*xx - 4.0d0*M*Q*Q*xx + Q**4)*pi/xx + xx*(xx*xx+3.0d0*M*xx - 2.0d0*Q*Q)*psi) &
                  + 2.0d0*scalar_charge*Q*ipi/xx + (scalar_charge**2*Q*Q*(xx*xx+2.0d0*M*xx-Q*Q)/xx**4 - l*(l+1.0d0)/xx**2 - scalar_mass**2)*R
          write(140,*) x(j), rk_pi 
          write(150,*) x(j), dtu(5,j) - rk_pi
	    end do
      !write(113,*) time, uold(1,iobs)	    	    
      !ret = gft_out_full('V',time, nx-1, 'x', 1, x,uold(1,1:nx-1))
      !ret = gft_out_full('W',time, nx-1, 'x', 1, x,uold(2,1:nx-1))

      if(output2d==20)then
        n_frame = n_frame+1
        call video(i,time,n_frame,uold(1,:),x,nx)

      end if


	  end if
	
	end do

  ! 2d data

	
	close(110)
	close(111)
	close(112)
	close(120)
	close(121)
	close(122)
	close(113)
	close(114)
	close(115)
	close(116)
	close(117)
	close(118)

  close(300)
  close(64)
  close(50)
end program
