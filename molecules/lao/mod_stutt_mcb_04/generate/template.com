***,Calculation for all-electron SrO molecule, SCF and CCSD(T)
memory,1,g
gthresh,twoint=1.0E-12

basis={
ECP, la, 46, 3
4
1, 15.00000,    11.00000
3, 15.00000,   165.0
2, 15.00000,  -105.88000
2, 4.028600, -36.010016
3
2, 3.309900, 91.932177
2, 1.655000, -3.788764
2, 4.028600, 36.010016
3
2, 2.836800, 63.759486
2, 1.418400, -0.647958
2, 4.028600, 36.010016
3
2, 2.021300, 36.116173
2, 1.010700, 0.219114
2, 4.028600, 36.010016

include,../generate/cc-pwCVTZ-DK3.basis
}

geometry={
    1
    La atom
    La 0.0 0.0 0.0
}
{rhf;
 start,atden
 print,orbitals=2
 wf,11,1,1
 occ,3,1,1,0,1,0,0,0
 closed,2,1,1,0,1,0,0,0
 sym,1,1,1,2
 orbital,4202.2
}
La_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
La_ccsd=energy

basis={
ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406

include,../generate/O-aug-cc-pCVXZ.basis
}

geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,6,7,2;
 occ,1,1,1,0,1,0,0,0;
 open,1.3,1.5;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy

basis={
ECP, la, 46, 3
4
1 15.00000    11.00000
3 15.00000   165.0
2 15.00000  -105.88000
2 4.028600 -36.010016
3
2 3.309900 91.932177
2 1.655000 -3.788764
2 4.028600 36.010016
3
2 2.836800 63.759486
2 1.418400 -0.647958
2 4.028600 36.010016
3
2 2.021300 36.116173
2 1.010700 0.219114
2 4.028600 36.010016

include,../generate/cc-pwCVTZ-DK3.basis

ecp,O,2,1,0
3;
1,  12.30997,  6.000000
3,  14.76962,  73.85984
2,  13.71419, -47.87600
1;
2,  13.65512,  85.86406

include,../generate/O-aug-cc-pCVXZ.basis
}

!These are the wf cards parameters
ne = 17
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
    O 0.0 0.0 length
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


table,length,scf,ccsd,bind
save
type,csv

