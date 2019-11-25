***,Calculation for all-electron SrO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,../generate/cc-pwCVTZ-DK3.basis
include,../generate/O-aug-cc-pCVTZ.basis
}

geometry={
    1
    La atom
    La 0.0 0.0 0.0
}
{rhf;
 start,atden
 print,orbitals=2
 wf,57,1,1
 occ,11,4,4,2,4,2,2,0
 closed,10,4,4,2,4,2,2,0
 sym,1,1,1,1,2,3,1,2,3,1,1,2
 orbital,4202.2
}
La_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
La_ccsd=energy


geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,8,7,2;
 occ,2,1,1,0,1,0,0,0;
 open,1.3,1.5;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy


!These are the wf cards parameters
ne = 65
symm = 1
ss= 1

!There are irrep cards paramters
A1=8+6
B1=3+1
B2=3+1
A2=2


geometry={
    2
    LaO molecule
    La 0.0 0.0 0.0
    O 0.0 0.0 2.1
}
{rhf,nitord=20;
 maxit,200;
 wf,ne,symm,ss
! occ,A1,B1,B2,A2
! closed,A1,B1,B2,A2
 print,orbitals=2
}
scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
ccsd=energy
bind=ccsd-Sr_ccsd-O_ccsd


table,2.1,scf,ccsd,bind
save
type,csv

