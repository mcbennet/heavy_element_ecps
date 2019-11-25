***,Calculation for Ag atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
La
La  0.0 0.0 0.0
}

basis={
ECP, la, 46, 3
4
   1  14  11
   3  14  132
   2  14  -90.59999999999999
   2  4.0286  -36.010016
3
   2  3.3099  91.932177
   2  1.655  -3.788764
   2  4.0286  36.010016
3
   2  2.8368  63.759486
   2  1.4184  -0.647958
   2  4.0286  36.010016
3
   2  2.0213  36.116173
   2  1.0107  0.219114
   2  4.0286  36.010016

include,cc-pwCVTZ-DK3.basis
}

include,states.proc

do i=1,4
    if (i.eq.1) then
        I6s25d
    else if (i.eq.2) then
        I6s15d
    else if (i.eq.3) then
        I5d
    else if (i.eq.4) then
        I5p6
    else if (i.eq.5) then
        II4d
    else if (i.eq.6) then
        III4p6
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=200;
    thresh,coeff=1d-3,energy=1d-5;
    core}
    ccsd(i)=energy
enddo

table,scf,ccsd
type,csv
save
