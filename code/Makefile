FLAGS = -O2  -ffree-form  -ffree-line-length-none
OBJS =  params.o  rhs.o boundary.o  derivs.o video.o evolve.o  initial.o  main.o 

# 
#ifeq ($(ARCH),Darwin)
#FF := f90
#FLAGS := -O2 -qfree -qsuffix=f=f90 -w -qsuppress=1520-022 -qmoddir=objs
#endif
#######

ab: dir link

dir :
#	@ mkdir -p exe

link : $(OBJS)
	gfortran $(FLAGS) -o wave $(OBJS)

params.o : params.f90
	gfortran $(FLAGS) -c params.f90

rhs.o : rhs.f90
	gfortran $(FLAGS) -c rhs.f90


main.o : main.f90
	gfortran $(FLAGS) -c main.f90


boundary.o : boundary.f90
	gfortran $(FLAGS) -c boundary.f90

derivs.o : derivs.f90
	gfortran $(FLAGS) -c derivs.f90


video.o : video.f90
	gfortran $(FLAGS) -c video.f90

evolve.o : evolve.f90
	gfortran $(FLAGS) -c evolve.f90



initial.o : initial.f90
	gfortran $(FLAGS) -c initial.f90



clean:
	rm -f $(PROG) $(OBJS) *.$(MOD)

