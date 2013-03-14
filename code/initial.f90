module m_initial
	implicit none
	
	contains
	
	subroutine initial(uold,x, Nx,dx,dt)
	use m_pars, only : M, l, phi0, xx0, sr0, idsignum,E, idtype, tot_mas, sep, cfl
	implicit none
	real*8, dimension(:,:) :: uold
	real*8, dimension(:) :: x
	integer :: Nx, i
	real*8  :: bb, xx, dx, dt
	
	do i=1, Nx
	  uold(:,i) = 0.0
	end do
	
        !stupid initial data take out
        ! u = {R , PSI, PI, D, u1}
        ! just a gaussian in the psi4


  if ( idtype .EQ. 0 ) then
    do i=1,NX
 	    xx = x(i)
	    uold(1,i) = phi0*dexp(-0.5*(xx - xx0)**2/sr0**2)    ! Re(R)
      uold(2,i) = 0.0d0                                   ! Im(R)
      uold(3,i) = -((xx - xx0)/sr0**2)*uold(1,i)          ! Re(psi)
      uold(4,i) = 0.0d0                                   ! Im(psi)
	    uold(5,i) = idsignum*uold(2,i)                      ! Re(pi)
      uold(6,i) = 0.0d0                                   ! Im(pi)
 	  end do


  elseif (idtype .EQ. 2 ) then

    uold(4,i) = 0.0d0
    print*, "reading parameters..."
 
    open(300,file="phi.initial.dat")

    do i=1,Nx
      read(300,*) x(i), uold(1,i), uold(2,i), uold(3,i)
    end do
    dx = x(2)- x(1)
    dt = cfl * dx
    print*, "redefining dt=", dt

    close(300)

  else 
    print*, "this ID does not exist", idtype
  end if

! compute the total mass of the shell


  do i=1,NX
    xx = x(i)              
    tot_mas = tot_mas + xx*xx*sqrt(1.0+2.0/xx)*uold(4,i)*dx
  end do

  print*, 'La masa total del pulso es:',tot_mas

end subroutine initial

        !------------------------------------------------------------
        ! compute energy --------------------------------------------
        !------------------------------------------------------------

	subroutine compute_energy(u,energy,x,Nx,dx)
	implicit none
	real*8, dimension(:,:) :: u
	real*8, dimension(:)   :: x
	integer :: Nx, i
	real*8  :: bb, xx, energy, M, R, psi_m, pi_m, dx
	
  energy = 0.0
        !stupid initial data take out
        ! u = {R , PSI, PI}
	
	do i=1,NX-1
	  xx = x(i)
    psi_m = 0.5d0*(u(2,i) + u(2,i+1))
    pi_m  = 0.5d0*(u(3,i) + u(3,i+1))
    energy = energy + dsqrt(1.0+2.0*M/xx)&
           &*(xx**2)*(psi_m**2 + pi_m**2)*dx
	end do
	
	end subroutine compute_energy
end module m_initial
