MODULE M_BOUNDARY
	use m_pars
	
	implicit none
	
	contains
	
	
	subroutine boundary(u,du,uboun,dx)
	real*8, dimension(:,:), intent(in) :: u, du
	real*8, dimension(:,:), intent(inout) :: uboun
	real*8 dx, gs, factor, psi, ipsi, pi, ipi, Lplus, iLplus, Lminus, iLminus
	
        !Olsson
	if(bc.eq.0) then
!	uboun(1,nx) = 0./(1.+rout) 
  	uboun(2,nx) = 0/(1.+rout)**2
  	uboun(3,nx) = 0./(1.+rout)**2

       !psi4 + fluid
	else if(bc.eq.1) then
	  !no boundary for R, standing mode
	  uboun(1,nx) = uboun(1,nx)
	  uboun(2,nx) = uboun(2,nx)
	  
	  !olsson for psi,pi
	  psi = uboun(3,nx)
	  ipsi = uboun(4,nx)
	  pi  = uboun(5,nx)
	  ipi  = uboun(6,nx)

    Lplus  = psi + pi
	  Lminus = psi - pi
    Lplus = 0.0d0
	  psi = 0.5d0*(Lplus + Lminus)
	  pi  = 0.5d0*(Lplus - Lminus) 
	  uboun(3,nx) = psi
	  uboun(5,nx) = pi
    
    iLplus  = ipsi + ipi
	  iLminus = ipsi - ipi
    iLplus = 0.0d0
	  ipsi = 0.5d0*(iLplus + iLminus)
	  ipi  = 0.5d0*(iLplus - iLminus) 
	  uboun(4,nx) = ipsi
	  uboun(6,nx) = ipi

        !copy boundary		
	else if(bc.eq.-1) then
    uboun(:,nx) = uboun(:,nx-1)
!	  uboun(:,1) = uboun(:,2) 

        !periodic
	else if(bc.eq.-2) then
	  uboun(:,nx) = uboun(:,2)
	  uboun(:,1) = uboun(:,nx-1)

        !Sommerfeld
	else if(bc.eq.-3) then
	  uboun(1,nx) = uboun(1,nx)
    uboun(2,nx) = uboun(2,nx)
 	  uboun(3,nx) = -u(3,nx)/rout-du(3,nx)
	end if
	
	end subroutine boundary
end module M_BOUNDARY
