MODULE M_RHS
	implicit none
	
	contains
	
	subroutine rhs(u,du,w,dw,rk,dx,Nx, eb,x)
	use m_pars, only : cfl, M, Q, l, rhstype, E, scalar_mass, scalar_charge
	
	implicit none
	real*8, dimension(:,:), intent(in) :: u, du, w, dw
	real*8, dimension(:,:), intent(inout) :: rk
	real*8, dimension(:) :: x
	real*8 :: R, iR, psi, ipsi, pi, ipi, dx_R, dx_iR, dx_psi, dx_ipsi, dx_pi, dx_ipi, rk_R, rk_iR, rk_psi, rk_ipsi, rk_pi, rk_ipi
	real*8 :: D, u0, u1, dx_rho, rk_rho
	real*8 :: dx, xx, bb, Delta1, factorl, factoru
  real*8 :: cpi, rho, vr
	integer :: i, Nx, eb
	
	rk = 0.0
  cpi = acos(-1.0)
!        print*, "cpi=",cpi
!        stop

        ! u(1,i) = R    ,   u(2, i) = psi,   u(3, i) = pi
        ! u(4,i) = D    

	do i=1, Nx
	  xx = x(i)
    Delta1 = (xx*xx + 2.0d0*M*xx-Q**2)

	  R    = u(1,i)
	  iR    = u(2,i)
	  psi  = u(3,i)
	  ipsi  = u(4,i)
	  pi   = u(5,i)
	  ipi   = u(6,i)

	  dx_R   = du(1,i)
	  dx_iR   = du(2,i)
	  dx_psi = du(3,i)
	  dx_ipsi = du(4,i)
	  dx_pi  = du(5,i)
	  dx_ipi  = du(6,i)

          ! the evolution of the fluid
	  u1   = - dsqrt( E*E - 1.0 + 2.0*M/xx )
    u0   = (E*xx + 2.0*M*u1)/(xx - 2.0*M)
	  vr   = u1/u0
	  factoru = (E*E-1.0d0+3.0d0*M/(2.0*xx))/(xx*(E*E-1.0d0+2.0d0*M/xx))
	  factorl = sqrt((l-1.0)*l*(l+1.0)*(l+2.0))

    rk_rho  = - vr*dx_rho - 2.0d0*factoru*vr*rho


	  ! the r*psi4 equation in Kerr-Schild coordinates	   
    if (rhstype .EQ. 1) then
      rk_R    = (1.0d0/Delta1) * (xx*xx*pi + (2.0d0*M*xx - Q*Q)*psi)
      rk_iR   = (1.0d0/Delta1) * (xx*xx*ipi + (2.0d0*M*xx - Q*Q)*ipsi)

      rk_psi  = (1.0d0/Delta1) * (xx*xx*dx_pi + (2.0d0*M*xx - Q*Q)*dx_psi) &
              + 2.0d0*xx*(M*xx - Q*Q)/Delta1**2 * (pi - psi)
      rk_ipsi = (1.0d0/Delta1) * (xx*xx*dx_ipi + (2.0d0*M*xx - Q*Q)*dx_ipsi) &
              + 2.0d0*xx*(M*xx - Q*Q)/Delta1**2 * (ipi - ipsi)
      
      rk_pi   = (1.0d0/Delta1) * ( (2.0d0*M*xx - Q*Q)*dx_pi + xx*xx*dx_psi ) &
              + (2.0d0/Delta1**2) * ((M*xx**3 + 4.0d0*M*M*xx*xx - 4.0d0*M*Q*Q*xx + Q**4)*pi/xx + xx*(xx*xx+3.0d0*M*xx - 2.0d0*Q*Q)*psi) &
              + 2.0d0*scalar_charge*Q*ipi/xx + (scalar_charge**2*Q*Q*(xx*xx+2.0d0*M*xx-Q*Q)/xx**4 - l*(l+1.0d0)/xx**2 - scalar_mass**2)*R
      rk_ipi  = (1.0d0/Delta1) * ( (2.0d0*M*xx - Q*Q)*dx_ipi + xx*xx*dx_ipsi ) &
              + (2.0d0/Delta1**2) * ((M*xx**3 + 4.0d0*M*M*xx*xx - 4.0d0*M*Q*Q*xx + Q**4)*ipi/xx + xx*(xx*xx+3.0d0*M*xx - 2.0d0*Q*Q)*ipsi) &
              - 2.0d0*scalar_charge*Q*pi/xx + (scalar_charge**2*Q*Q*(xx*xx + 2.0d0*M*xx - Q*Q)/xx**4 - l*(l + 1.0d0)/xx**2 - scalar_mass**2)*iR
	  else
	    print*, "this rhstype does not exist", rhstype
	    stop
	  end if

	  rk(1,i) = rk_R
	  rk(2,i) = rk_iR
	  rk(3,i) = rk_psi
	  rk(4,i) = rk_ipsi
	  rk(5,i) = rk_pi
	  rk(6,i) = rk_ipi

	end do


	end subroutine rhs

!-----------------------------------------------------------------
!-----------------------------------------------------------------
!-----------------------------------------------------------------
!-----------------------------------------------------------------
!-----------------------------------------------------------------

	subroutine flux(u,w,dx,Nx,x)
	use m_pars, only : cfl, M, l, rhstype, E
	
	implicit none
	real*8, dimension(:,:), intent(in)    :: u
	real*8, dimension(:,:), intent(inout) :: w
	real*8, dimension(:) :: x
	real*8 :: D, u1, u0, raiz
	real*8 :: dx, xx
	integer :: i, Nx
	
        ! u(1,i) = R    ,   u(2, i) = psi,   u(3, i) = pi
        ! u(4,i) = D   

	do i=1, Nx
	  xx = x(i)

	  D    = u(4,i)
	  u1   = - dsqrt( E*E - 1.0 + 2.0*M/xx )
          u0   = (E*xx + 2.0*M*u1)/(xx - 2.0*M)

          w(1,i) = xx*xx*D*u1/u0
	end do


	end subroutine flux


	end module M_RHS
