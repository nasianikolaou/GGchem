**********************************************************************
      SUBROUTINE INIT
**********************************************************************
*****                                                            *****
*****   Initialisiert Elementhaeufigkeiten                       *****
*****   - Anders + Grevesse (1989):                              *****
*****     Geochimica et Cosmochemica Acta Vol 53, pp 197--214    *****
*****     ("Photosphere")                                        *****
*****   - wie in MARCS-Code                                      *****
*****   - wie in Tsuji-Chemie                                    *****
*****                                                            *****
**********************************************************************
      use PARAMETERS,ONLY: abund_pick
      use DUST_DATA,ONLY: NELEM,eps=>eps0,mass,muH,elnam,amu
      use EXCHANGE,ONLY: H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,
     >                   Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,
     >                   As,Se,Br,Kr,Rb,Sr,Y,Zr,W
      implicit none
      integer :: i,nr
      real*8 :: m,abund(NELEM,4)
      character(len=2) :: el
      character(len=20) :: elname
      character(len=20) :: source(4)
      character(len=200) :: line

      write(*,*) 
      write(*,*) "elemental abundances and masses ..."
      write(*,*) "==================================="
      elnam(1)  = 'H '
      elnam(2)  = 'He'
      elnam(3)  = 'Li'
      elnam(4)  = 'Be'
      elnam(5)  = 'B '
      elnam(6)  = 'C '
      elnam(7)  = 'N '
      elnam(8)  = 'O '
      elnam(9)  = 'F '
      elnam(10) = 'Ne'
      elnam(11) = 'Na'
      elnam(12) = 'Mg'
      elnam(13) = 'Al'
      elnam(14) = 'Si'
      elnam(15) = 'P '
      elnam(16) = 'S '
      elnam(17) = 'Cl'
      elnam(18) = 'Ar'
      elnam(19) = 'K '
      elnam(20) = 'Ca'
      elnam(21) = 'Sc'
      elnam(22) = 'Ti'
      elnam(23) = 'V '
      elnam(24) = 'Cr'
      elnam(25) = 'Mn'
      elnam(26) = 'Fe'
      elnam(27) = 'Co'
      elnam(28) = 'Ni'
      elnam(29) = 'Cu'
      elnam(30) = 'Zn'
      elnam(31) = 'Ga'
      elnam(32) = 'Ge'
      elnam(33) = 'As'
      elnam(34) = 'Se'
      elnam(35) = 'Br'
      elnam(36) = 'Kr'
      elnam(37) = 'Rb'
      elnam(38) = 'Sr'
      elnam(39) = 'Y '
      elnam(40) = 'Zr'
      elnam(41) = 'W '

*     --------------------
*     ***  Atommassen  ***
*     --------------------
      mass(H)  = 1.008  * amu  
      mass(He) = 4.0026 * amu
      mass(Li) = 6.94   * amu  
      mass(Be) = 9.0122 * amu
      mass(B)  = 10.81  * amu  
      mass(C)  = 12.011 * amu  
      mass(N)  = 14.007 * amu  
      mass(O)  = 15.999 * amu  
      mass(F)  = 18.998 * amu
      mass(Ne) = 20.180 * amu 
      mass(Na) = 22.990 * amu
      mass(Mg) = 24.305 * amu 
      mass(Al) = 26.982 * amu
      mass(Si) = 28.085 * amu  
      mass(P)  = 30.974 * amu
      mass(S)  = 32.06  * amu  
      mass(Cl) = 35.45  * amu  
      mass(Ar) = 39.948 * amu  
      mass(K)  = 39.098 * amu 
      mass(Ca) = 40.078 * amu  
      mass(Sc) = 44.956 * amu
      mass(Ti) = 47.867 * amu  
      mass(V)  = 50.942 * amu 
      mass(Cr) = 51.996 * amu 
      mass(Mn) = 54.938 * amu
      mass(Fe) = 55.845 * amu  
      mass(Co) = 58.933 * amu
      mass(Ni) = 58.693 * amu 
      mass(Cu) = 63.546 * amu  
      mass(Zn) = 65.38  * amu  
      mass(Ga) = 69.723 * amu  
      mass(Ge) = 72.63  * amu  
      mass(As) = 74.922 * amu
      mass(Se) = 78.96  * amu  
      mass(Br) = 79.904 * amu  
      mass(Kr) = 83.798 * amu  
      mass(Rb) = 85.468 * amu 
      mass(Sr) = 87.62  * amu  
      mass(Y ) = 88.906 * amu
      mass(Zr) = 91.224 * amu  
      mass(W ) = 183.84 * amu       

*     ---------------------------------------
*     ***      element abundancies        ***
*     ---------------------------------------
*     Grevesse + Noels (1996, "photosphere"):
*     ---------------------------------------
      eps(H)  = 12.00 D0
      eps(He) = 10.99 D0
      eps(Li) =  1.16 D0
      eps(C)  =  8.55 D0
      eps(N)  =  7.97 D0
      eps(O)  =  8.87 D0
      eps(Ne) =  8.08 D0
      eps(Na) =  6.33 D0
      eps(Mg) =  7.58 D0
      eps(Al) =  6.47 D0
      eps(Si) =  7.55 D0
      eps(S)  =  7.33 D0
      eps(Cl) =  5.50 D0
      eps(K)  =  5.12 D0
      eps(Ca) =  6.36 D0
      eps(Ti) =  5.02 D0
      eps(Cr) =  5.67 D0
      eps(Mn) =  5.39 D0
      eps(Fe) =  7.50 D0
      eps(Ni) =  6.25 D0

*     ---------------------------------
*     Grevesse, Asplund, Sauval (2007):
*     ---------------------------------
      eps(H)  = 12.00 D0
      eps(He) = 10.93 D0
      eps(Li) =  1.10 D0  ! Lodders, Palme Gail 2009
      eps(C)  =  8.39 D0  
      eps(N)  =  7.78 D0  
      eps(O)  =  8.66 D0  
      eps(F)  =  4.56 D0
      eps(Ne) =  7.84 D0
      eps(Na) =  6.17 D0
      eps(Mg) =  7.53 D0
      eps(Al) =  6.37 D0
      eps(Si) =  7.51 D0
      eps(S)  =  7.14 D0
      eps(Cl) =  5.50 D0
      eps(K)  =  5.08 D0
      eps(Ca) =  6.31 D0
      eps(Ti) =  4.90 D0
      eps(Cr) =  5.64 D0
      eps(Mn) =  5.39 D0
      eps(Fe) =  7.45 D0
      eps(Ni) =  6.23 D0

*     ----------------------------------------------------
*     Asplund et al. (2009):
*     http://adsabs.harvard.edu/abs/2009ARA%26A..47..481A
*     ----------------------------------------------------
      eps(H)  = 12.00    
      eps(He) = 10.93  
      eps(Li) = 1.05     
      eps(Be) = 1.38   
      eps(B)  = 2.70     
      eps(C)  = 8.43     
      eps(N)  = 7.83     
      eps(O)  = 8.69     
      eps(F)  = 4.56  
      eps(Ne) = 7.93    
      eps(Na) = 6.24  
      eps(Mg) = 7.60    
      eps(Al) = 6.45  
      eps(Si) = 7.51     
      eps(P)  = 5.41  
      eps(S)  = 7.12     
      eps(Cl) = 5.50     
      eps(Ar) = 6.40     
      eps(K)  = 5.03    
      eps(Ca) = 6.34     
      eps(Sc) = 3.15  
      eps(Ti) = 4.95     
      eps(V)  = 3.93    
      eps(Cr) = 5.64    
      eps(Mn) = 5.43  
      eps(Fe) = 7.50     
      eps(Co) = 4.99  
      eps(Ni) = 6.22    
      eps(Cu) = 4.19     
      eps(Zn) = 4.56     
      eps(Ga) = 3.04     
      eps(Ge) = 3.65     
      eps(As) = -40.   
      eps(Se) = -40.     
      eps(Br) = -40.     
      eps(Kr) = 3.25     
      eps(Rb) = 2.52    
      eps(Sr) = 2.87     
      eps(Y ) = 2.21  
      eps(Zr) = 2.58  
      eps(W ) = 0.85  

      !eps(C)  = eps(O) + LOG10(2.Q0)     ! try C/O=2

      !eps(Fe) = eps(H)+30.0              ! pure Fe modelling ...

      !eps(Si) = eps(H)+30.0              ! pure SiO2 modelling ...
      !eps(O)  = eps(Si)+LOG10(2.Q0)      ! Si:O = 1:2

      !eps(Al) = eps(H)+30.0              ! pure Al2O3 modelling ...
      !eps(O)  = eps(Al)+LOG10(3.Q0/2.Q0) ! Al:O = 2:3

      !eps(C)  = eps(H)+30.0              ! pure CO2 modelling ...
      !eps(O)  = eps(C)+LOG10(2.0000000000001Q0)       ! C:O = 1:2

      !eps(:)  = eps(:)-30.0              ! pure NH3 modelling ...
      !eps(H)  = 12.0
      !eps(N)  = eps(H)-LOG10(3.Q0)       ! N:H = 1:3

      !eps(:) = eps(:)-30.0               ! pure H2O modelling ...
      !eps(H) = 12.0
      !eps(O) = eps(H)-LOG10(2.Q0)        ! H:O = 2:1

      do i=1,NELEM
        eps(i) = 10.Q0 ** (eps(i)-12.Q0)
      enddo
  
*     ------------------------------------
*     ***  read abundances from file?  ***      
*     ------------------------------------
      if (abund_pick.ne.3) then
        source = (/'EarthCrust','Ocean','Solar','Meteorites'/)
        write(*,*)
        write(*,*) "replacing from file Abundances.dat ("
     &             //trim(source(abund_pick))//") ..."
        open(1,file='Abundances.dat',status='old')
        do i=1,5
          read(1,'(A200)') line
        enddo  
        do i=1,NELEM
          read(1,*) nr,elname,el,m,abund(nr,1:4)
          mass(nr)  = m*amu
          elnam(nr) = el
          eps(nr) = MAX(1.e-99,abund(nr,abund_pick)/abund(1,abund_pick))
        enddo  
        close(1)
      endif  

      muH = 0.d0
      do i=1,NELEM
        write(*,'(1x,a2,1x,0pF8.3,1pE12.4,0pF8.3)') 
     &          elnam(i),12.d0+LOG10(eps(i)),eps(i),mass(i)/amu
        muH = muH + mass(i)*eps(i)
      enddo
      write(*,'("rho = n<H> *",1pE12.4," amu")') muH/amu

      RETURN
      end
