MODULE M_PARS
	implicit none

!define parameters !!!!!!!!!!!!!!!!!!!!!!!
	real*8 :: Rin, Rout, Robs1, Robs2, Robs3, Robs4, Robs5
	real*8 :: cfl, disip, M, Q, time, phi0, xx0, sr0, l, E,tot_mas,sep, scalar_mass, scalar_charge
	integer :: dim, Nx, Nt, freq, bc, pos, derorder, rhstype, idsignum, idtype


	CONTAINS


  subroutine readpars
    implicit none
    namelist /pars_input/ dim, Nx, Nt, rhstype, E, freq, cfl, disip, M, Q, scalar_mass, scalar_charge, l, idtype, phi0, xx0, sr0,&
                               sep, idsignum, Rin, Rout, Robs1, Robs2, Robs3, Robs4, Robs5, bc, derorder

    !read params !!!!!!!!!!!!!!!!!!!!!!!
    open (unit = 10, file = "pars.in", status = "old" )
    read (unit = 10, nml = pars_input)
    close(unit = 10)

  end subroutine readpars


end module M_pars
