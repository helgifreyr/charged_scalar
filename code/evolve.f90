module M_EVOLVE
  implicit none
contains
  subroutine evolve(unew,uold,dx,dt, eb,x)
    use m_derivs
    use m_boundary
    use m_rhs
    use m_pars, only : disip, dim
    implicit none
    
    integer eb, method
    real*8, dimension(:,:), intent(inout):: unew
    real*8, dimension(:,:), intent(in):: uold
    real*8, dimension(:) :: x
    real*8 dx, dt, sigma, Fren3, Fren4, delta
    real*8 onethird,twothird,onesixth,onefourth
    
    !keep in some variables the rhs
    real*8, dimension(:,:),allocatable :: rk1,rk2,rk3
    real*8, dimension(:,:),allocatable :: du,ddu,diss,u1,u2,u3
    real*8, dimension(:,:),allocatable :: w,dw
    integer i,j

    pos = 1 
    onethird = 1.0d0/3.0d0
    twothird = 2.0d0/3.0d0
    onesixth = 1.0d0/6.0d0
    onefourth = 1.0d0/4.0d0
    sigma = -disip

    !allocate memmory
    allocate(du(dim,Nx),ddu(dim,Nx),rk1(dim,Nx),rk2(dim,Nx),rk3(dim,Nx),&
      &        diss(dim,Nx))
    allocate(u1(dim,Nx),u2(dim,Nx),u3(dim,Nx))
    allocate(w(1,Nx),dw(1,Nx))

!  remember u(1)=V and u(2)=W

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!          THE IMEX RK-SSP2(3,3,2) stiffly accurate
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! FIRST STEP-----------------------------	
!-----------------------------------------

!	call flux(uold,w,dx,Nx,x)
!        call derivs(w(1,:),dw(1,:),dx,Nx,eb)
	
    ! compute the rhs and R------
    do i = 1, dim
      call derivs(uold(i,:),du(i,:),dx,Nx,eb)
      call dissip(uold(i,:),diss(i,:),dx,Nx,eb)
    end do
	
	  call rhs(uold,du,w,dw,rk1,dx,Nx,eb,x)
	  rk1 = rk1 + sigma*diss

    call boundary(u1,du,rk1,dx)
    u1 = uold + dt * rk1

! SECOND STEP-----------------------------
!-----------------------------------------

!	call flux(u1,w,dx,Nx,x)
!        call derivs(w(1,:),dw(1,:),dx,Nx,eb)

    ! compute the rhs and R------
    do i = 1, dim
      call derivs(u1(i,:),du(i,:),dx,Nx,eb)
      call dissip(u1(i,:),diss(i,:),dx,Nx,eb)
    end do
	
	  call rhs(u1,du,w,dw,rk2,dx,Nx,eb,x)
	  rk2 = rk2 + sigma*diss

    call boundary(u2,du,rk2,dx)

    u2 = 0.75d0 * uold + 0.25d0 * u1 + 0.25d0 * dt * rk2

! THIRD STEP-----------------------------
! ---------------------------------------

!	call flux(u2,w,dx,Nx,x)
!        call derivs(w(1,:),dw(1,:),dx,Nx,eb)

    ! compute the rhs and R------
  	do i = 1, dim
	    call derivs(u2(i,:),du(i,:),dx,Nx,eb)
      call dissip(u2(i,:),diss(i,:),dx,Nx,eb)
	  end do

	  call rhs(u2,du,w,dw,rk3,dx,Nx,eb,x)
	  rk3 = rk3 + sigma*diss

    call boundary(unew,du,rk3,dx)

    unew = ( uold + 2.0d0 * u2 + 2.0d0 * dt * rk3 ) / 3.0d0

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    !deallocate memmory

	  deallocate(du,rk1,rk2,rk3,diss)
  	deallocate(u1,u2,u3)
	  deallocate(w,dw)

	end subroutine evolve
end module M_EVOLVE
