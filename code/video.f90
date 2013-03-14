subroutine video(l,t,n_frame,muold,mx,nx)

   use m_pars, only : M, phi0, xx0, sr0, idsignum,E, idtype, tot_mas, sep


   implicit none

     integer k,j,l,nx
     real*8 t, smallpi
     integer i

     character*15 file1
     character*6 c_cycle
     integer n_frame
     real*8 muold(nx),mx(nx)
    
   smallpi=acos(-1.0)

     file1(1:5) = 'q_2d.'

   
     write (c_cycle,'(i6)') 100000 + l

   
     file1(6:11) = c_cycle
     file1(12:15) = '.jpg'
 


   file1(6:11) = c_cycle
   file1(12:15) = '.jpg'

     open(50,file=file1(1:11) ,status='unknown')

         do k=0,80
           do j=1,nx, 20
             write(50,*) mx(j)*cos(smallpi*dble(k)/40.0),mx(j)*sin(smallpi*dble(k)/40.0), &
                           muold(j)

              
           end do
           write(50,*)
 	  end do
       
	
      write (64,764) file1,file1(1:11),t,file1(1:11),n_frame
 764  format('set output "',a,'"'/ &
'set multiplot'/ &
'set origin 0.58,0.58'/ &
'set size 0.5,0.5'/ &
'set view 0.0,0.0'/ &
'set pm3d map'/ &
'unset xtics'/ &
'unset ztics'/ &
'unset ytics'/ &
'unset ylabel'/ &
'unset title'/ &
'unset cbtics'/ &
'splot  "',a,'"'/ &
'set ztics'/ &
'set xtics'/ &
'set ytics'/ &
'set cbtics'/ &
'set origin 0.0,0.0'/ &
'set pm3d map'/ &
'set size 1.0,1.0'/ &
'set view 30,30'/ &
'set xrange[-810:810]'/ &
'set yrange[-810:810]'/ &
!'set xrange[-155:155]'/ &
!'set yrange[-155:155]'/ &

'set title "t = ',f10.2,'"','-15.0,-8.0'/ &
'splot  "',a,'"'/ &
'unset multiplot'/ &
'unset size'/ &
'clear'/ &
'pause pause_val  "Frame = ',i4,' "')





      call flush(64)
 
      call flush(50)
! convert -delay 20 -loop 0 -verbose q_2d.1*.jpg animacion.gif
! convert  test.png  -negate  test_negate.png
end subroutine
