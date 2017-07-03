*********************************************************************
      SUBROUTINE SUPERSAT(T,nat,nmol,Sat)
*********************************************************************
      use CHEMISTRY,ONLY: NMOLE,cmol
      use dust_data,ONLY: NELEM,NDUST,bk,atm,rgas,bar,
     &                    dust_nam,dust_nel,dust_el,dust_nu,elnam
      use EXCHANGE,ONLY: C,Na,Fe
      implicit none
      integer,parameter  :: qp = selected_real_kind ( 33, 4931 )
      real*8,intent(in) :: T
      real(kind=qp),intent(in) :: nat(NELEM),nmol(NMOLE)
      real(kind=qp),intent(out):: Sat(NDUST)
      real(kind=qp),parameter :: cal=4.184Q+0 
      real(kind=qp),parameter :: mmHg=1.333Q+3 ! mmHg --> dyn/cm2
      real(kind=qp) :: TT,kT,dG,lbruch,lresult,pst,psat,term,ex,TC,S2
      integer :: i,j,STINDEX,el
      integer,save :: TiO2,SiO,H2O,NH3,CH4,SiO2,CaCl2,H2SO4,FeS,NaCl
      integer,save :: KCl,FeO,MgO,AlCl3,LiCl
      logical,save :: firstCall=.true.
*
      if (firstCall) then
        TiO2  = STINDEX(cmol,NMOLE,'TIO2     ')
        SiO   = STINDEX(cmol,NMOLE,'SIO      ')
        SiO2  = STINDEX(cmol,NMOLE,'SIO2     ')
        H2O   = STINDEX(cmol,NMOLE,'H2O      ')
        NH3   = STINDEX(cmol,NMOLE,'NH3      ')
        CH4   = STINDEX(cmol,NMOLE,'CH4      ')
        CaCl2 = STINDEX(cmol,NMOLE,'CACL2    ')
        H2SO4 = STINDEX(cmol,NMOLE,'H2SO4    ')
        FeS   = STINDEX(cmol,NMOLE,'FES      ')
        NaCl  = STINDEX(cmol,NMOLE,'NACL     ')
        KCl   = STINDEX(cmol,NMOLE,'KCL      ')
        FeO   = STINDEX(cmol,NMOLE,'FEO      ')
        MgO   = STINDEX(cmol,NMOLE,'MGO      ')
        AlCl3 = STINDEX(cmol,NMOLE,'ALCL3    ')
        LiCl  = STINDEX(cmol,NMOLE,'LICL     ')
        firstCall=.false.
      endif    
      TT  = MAX(T,100.Q0)
      kT  = bk*TT
      Sat = 0.Q0
      do i=1,NDUST
        if (dust_nam(i).eq.'TiO2[s]   ') then
          !------------------------------------------------
          !***  TiO2[s]: own fit to JANAF T=100-4000 K  ***
          !------------------------------------------------
          !psat = EXP(35.8027Q0 - 74734.7Q0/TT)
          psat = EXP( -7.65465Q+04/TT  
     &                +3.72148Q+01
     &                +1.76288Q-03*TT 
     &                -1.35859Q-06*TT**2  
     &                +1.66681Q-10*TT**3 )
          Sat(i) = nmol(TiO2)*kT/psat
          !pst = bar
          !dG = 2.29666E+05/TT 
     &    !    -3.20926E+00*LOG(TT) 
     &    !    -3.40061E+01  
     &    !    +2.59309E-03*TT 
     &    !    -2.28208E-08*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)           

        else if (dust_nam(i).eq.'TiO2[l]') then
          !-------------------------------------------------
          !***  TiO2[l]: George's JANAF-fit T=298-4000K  ***
          !-------------------------------------------------
          !pst = bar
          !dG = 3.31189Q+06/TT    !linear extrapolation poor
     &    !    -1.88378Q+06       !298.15K used instead
     &    !    +4.59487Q+02*TT 
     &    !    -1.56016Q-02*TT**2
     &    !    +1.17332Q-06*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP( -7.07819Q+04/TT  
     &                +3.68021Q+01 
     &                -1.29214Q-03*TT 
     &                -6.87776Q-08*TT**2  
     &                +1.89408Q-11*TT**3 )
          Sat(i) = nmol(TiO2)*kT/psat

        else if (dust_nam(i).eq.'Ti4O7[s]') then
          !----------------------------------------------
          !***  Ti4O7[s] own fit to JANAF 290-2400 K  ***
          !----------------------------------------------
          ! Sharp & Huebner 
          !pst = atm
          !dG  = 0.00000Q+0/TT 
     &    !     -1.68437Q+6 
     &    !     +3.99611Q+2*TT
     &    !     -6.01231Q-3*TT**2
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          !pst = bar
          !dG = 8.47415E+05/TT 
     &    !    -2.07198E+00*LOG(TT)  
     &    !    -1.89337E+02  
     &    !    +5.94363E-03*TT 
     &    !    -4.79693E-07*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)  
          pst = bar
          dG = 1.85821Q+06/TT    !fit_set
     &        -7.06188Q+06  
     &        +1.70429Q+03*TT 
     &        -4.67044Q-02*TT**2
     &        +4.71514Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)         

	else if (dust_nam(i).eq.'Ti4O7[l]') then
          !-----------------------------------------------------
          !***  Ti4O7[l]: George's JANAF-fit T=298.15-4000K  ***
          !-----------------------------------------------------
          pst = bar
          dG = 5.06384Q+06/TT    !fit_set
     &        -6.89199Q+06  
     &        +1.64108Q+03*TT 
     &        -5.93652Q-02*TT**2
     &        +4.64893Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'Mg2SiO4[s]') then
          !-------------------------------------------------
          !***  MgSi2O4[s] : own fit to JANAF 100-3000K  ***
          !-------------------------------------------------
          ! Sharp & Huebner 1990
          !pst = atm
          !dG  = 7.52334Q+4/TT 
     &    !     -9.38369Q+5 
     &    !     +2.47581Q+2*TT
     &    !     -3.14980Q-3*TT**2
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          dG = 1.70117Q+06/TT     !fit_set
     &        -3.93154Q+06  
     &        +1.04604Q+03*TT 
     &        -1.77300Q-02*TT**2  
     &        +7.18369Q-07*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)
 
         else if (dust_nam(i).eq.'MgO[s]') then 
          !------------------------------
          !***  Sharp & Huebner 1990  ***
          !------------------------------
          !pst = atm
          !dG  = 4.38728Q+3/TT
     &    !     -2.38741Q+5
     &    !     +6.86582Q+1*TT 
     &    !     -1.19852Q-3*TT**2
     &    !     +5.72304Q-8*TT**3
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          psat = EXP( -7.91838Q+04/TT    !fit_set
     &                +3.57312Q+01
     &                +1.45021Q-04*TT 
     &                -8.47194Q-08*TT**2  
     &                +4.49221Q-12*TT**3 )
          Sat(i) = nmol(MgO)*kT/psat

         else if (dust_nam(i).eq.'MgO[l]') then 
          !--------------------------------------------
          !***  George's Janaf fit suggested range  ***
          !--------------------------------------------
          pst = bar
          psat = EXP( -7.07437Q+04/TT    !fit_set
     &                +3.25683Q+01
     &                +6.94583Q-04*TT 
     &                -2.71415Q-07*TT**2  
     &                +2.24580Q-11*TT**3 )
          Sat(i) = nmol(MgO)*kT/psat

        else if (dust_nam(i).eq.'MgSiO3[s]') then
          !------------------------------------------------
          !***  MgSiO3[s] : own fit to JANAF 100-2500K  ***
          !------------------------------------------------
          ! Sharp & Huebner 1990
          !pst = atm
          !dG  = 8.74400Q+3/TT 
     &    !     -6.92565Q+5
     &    !     +1.77877Q+2*TT
     &    !     -1.41412Q-3*TT**2
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el    = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          dG = 1.54295Q+06/TT     !fit_set
     &        -2.90619Q+06  
     &        +7.60576Q+02*TT 
     &        -1.52087Q-02*TT**2  
     &        +1.78138Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'SiO2[s]') then
          !----------------------------------------------------
          !***  SiO2[s] own fit to JANAF (Quarz) 50-2200 K  ***
          !----------------------------------------------------
          ! Sharp & Huebner 1990 
          !pst = atm
          !dG =  -4.44364Q+5 
     &    !      +1.08531Q+2*TT
     &    !      -6.59213Q-4*TT**2
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          !dG = 2.22454E+05/TT 
     &    !    -4.49455E+00*LOG(TT) 
     &    !    -2.55904E+01  
     &    !    +3.67389E-03*TT 
     &    !    -2.68971E-07*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          !S2 = Sat(i)
          !George's poly fit 100-2000K
          psat = EXP( -7.28086Q+04/TT    !fit_set
     &                +3.65312Q+01
     &                -2.56109Q-04*TT 
     &                -5.24980Q-07*TT**2  
     &                +1.53343Q-10*TT**3 )
          Sat(i) = nmol(SiO2)*kT/psat
          !print*,"SiO2[s]:",TT,S2,Sat(i)

	else if (dust_nam(i).eq.'SiO2[l]') then
          !------------------------------------------
          !*** SiO2[l]: own JANAF-fit T=100-4500K ***
          !------------------------------------------
          pst = bar
          !dG = 2.21501E+05/TT 
     &    !    -4.23355E+00*LOG(TT) 
     &    !    -2.62826E+01  
     &    !    +3.19502E-03*TT 
     &    !    -2.32039E-07*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          !S2 = Sat(i)
          !George's poly fit 100-4500K
          psat = EXP( -7.18591Q+04/TT
     &                +3.59570Q+01
     &                -6.57765Q-04*TT 
     &                -3.78705Q-08*TT**2  
     &                +8.78339Q-12*TT**3 )
          Sat(i) = nmol(SiO2)*kT/psat
          !print*,"SiO2[l]:",TT,S2,Sat(i)

        else if (dust_nam(i).eq.'SiO[s]   ') then
          !psat = EXP(17.56Q0 - 40760.0Q0/TT) * atm   !(Nuth 200x)
          !--------------------------
          !***  Gail et al. 2013  ***
          !--------------------------
          !Tv   = 49520. ! K  +/- 1400K
          !Sv   = 32.52  !    +/- 0.97
          psat = EXP(-49520.Q0/TT + 32.52Q0)
          Sat(i) = nmol(SiO)*kT/psat

        else if (dust_nam(i).eq.'Fe[s]') then 
          !-------------------------------------------
          !***  Fe[s] own fit to JANAF 100-2200 K  ***
          !-------------------------------------------
          !pst = bar
          !dG = 7.37828Q+5/TT 
     &    !    -4.22183Q+5 
     &    !    +1.71919Q+2*TT
     &    !    -1.76037Q-2*TT**2 
     &    !    +2.31459Q-6*TT**3
          !dG = dG/(rgas*TT)
          !el = dust_el(i,1)
          !lbruch = LOG(nat(el)*kT/pst)
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          dG  = 4.97701Q+04/TT      !fit_set
     &         -1.42812Q+00*LOG(TT) 
     &         -1.03693Q+01
     &         +2.57730Q-03*TT 
     &         -2.50937Q-07*TT**2
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch+dG)
          !psat = EXP( -4.99622Q+04/TT
     &    !            +3.21370Q+01
     &    !            +6.68363Q-04*TT 
     &    !            -1.13811Q-06*TT**2  
     &    !            +2.57277Q-10*TT**3 )
          !Sat(i) = nat(Fe)*kT/psat

        else if (dust_nam(i).eq.'Al2O3[s]') then 
          !---------------------------------------------
          !***  Al2O3[s] own fit to JANAF 50-3000K  ***
          !---------------------------------------------
          ! Sharp & Huebner 1990 
          !pst = atm
          !dG  =-7.32976Q+5 
     &    !     +1.84782Q+2*TT 
     &    !     -2.57313Q-3*TT**2
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          dG  = 1.29765Q+06/TT    !fit_set
     &         -3.09312Q+06  
     &         +7.86027Q+02*TT 
     &         -1.36327Q-02*TT**2
     &         +8.59619Q-07*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)
          !S2 = Sat(i)
          !pst = bar
          !dG  = 3.69509E+05/TT 
     &    !     -3.62577E+00*LOG(TT) 
     &    !     -6.78774E+01  
     &    !     +2.43831E-03*TT  
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          !print*,'Al2O3[s]: ',real(S2),real(Sat(i))
          
	else if (dust_nam(i).eq.'Al2O3[l]') then
          !----------------------------------------
          !*** Al2O3[l]: own fit T=298.15-4000K ***
          !----------------------------------------
          !pst = bar
          !dG = 3.64249E+05/TT 
     &    !    -1.75586E+00*LOG(TT) 
     &    !    -8.06995E+01  
     &    !    +2.72010E-03*TT
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          !print*,'Al2O3[l]: ',real(Sat(i))
          pst = bar
          dG  = 9.69640Q+06/TT    !fit_set
     &         -3.07785Q+06 
     &         +8.23186Q+02*TT 
     &         -3.65211Q-02*TT**2
     &         +2.33258Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'CaTiO3[s]') then 
          !------------------------------
          !***  Sharp & Huebner 1990  ***
          !------------------------------
          pst = atm
          dG  = 1.19107Q+4/TT 
     &         -7.30327Q+5 
     &         +1.75930Q+2*TT
     &         -2.84630Q-3*TT**2 
     &         +1.10392Q-7*TT**3
          dG = dG/(rgas/cal*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'CaSiO3[s]') then 
          !------------------------------
          !***  Sharp & Huebner 1990  ***
          !------------------------------
          pst = atm
          dG  = 6.37937Q+4/TT 
     &         -7.21819Q+5 
     &         +1.77647Q+2*TT
     &         -2.59254Q-3*TT**2 
          dG = dG/(rgas/cal*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'Fe2SiO4[s]') then 
          !------------------------------
          !***  Sharp & Huebner 1990  ***
          !------------------------------
          pst = atm
          dG  = 6.84477Q+4/TT
     &         -9.02146Q+5
     &         +2.51045Q+2*TT 
     &         -4.44028Q-3*TT**2
          dG = dG/(rgas/cal*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'FeS[s]') then 
          !----------------------------------------
          !***  FeS[s] own fit JANA 100-1900 K  ***
          !----------------------------------------
          ! Sharp & Heubner
          !pst = atm
          !dG  =-6.83787Q+4/TT
     &    !     -1.8862Q+5
     &    !     +6.7059Q+1*TT 
     &    !     -2.318938Q-3*TT**2
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          !dG  = 9.53762E+04/TT 
     &    !     -1.32135E+00*LOG(TT)
     &    !     -2.80847E+01  
     &    !     +5.09885E-03*TT 
     &    !     -9.63944E-07*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          psat = EXP( -5.69922Q+04/TT   !fit_set
     &                +3.86753Q+01
     &                -4.68301Q-03*TT 
     &                +1.03559Q-06*TT**2  
     &                -8.42872Q-11*TT**3 )
          Sat(i) = nat(FeS)*kT/psat

        else if (dust_nam(i).eq.'Fe2O3[s]') then 
          !------------------------------
          !***  Sharp & Huebner 1990  ***
          !------------------------------
          pst = atm
          dG  =-9.09265Q+1/TT
     &         -5.75261Q+5
     &         +1.85908Q+2*TT 
     &         -7.14322Q-3*TT**2
     &         +8.63059Q-7*TT**3
          dG = dG/(rgas/cal*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'Na[s]') then 
          !----------------------------------------------------------
          !***  Na[s] Martinez, Ferguson, Heist, Nuth III (2005)  ***
          !***  psat in mm Hg! --- eigener fit JANAF              ***
          !----------------------------------------------------------          
          !psat = mmHg*EXP(10.86423Q0 - 5619.406Q0/TT + 3.45Q-6*TT)
          !Sat(i) = nat(Na)*kT/psat
          !print*,TT,Sat(i)
          pst = bar
          !dG = 2.93259Q+04/TT 
     &    !    -1.08994Q+05  
     &    !    +1.13076Q+02*TT 
     &    !    -1.98703Q-02*TT**2
     &    !    +4.92883Q-06*TT**3
          !dG = dG/(rgas*TT)
          !el = dust_el(i,1)
          !lbruch = LOG(nat(el)*kT/pst)
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP(-1.30424Q+04/TT     !fit_set
     &               +2.70281Q+01
     &               -1.44654Q-03*TT  
     &               -4.12467Q-07*TT**2 
     &               +3.86734Q-10*TT**3)
          Sat(i) = nat(Na)*kT/psat

        else if (dust_nam(i).eq.'S[s]') then 
          !--------------------------------------
          !***  S[s]: eigener Fit nach JANAF  ***
          !--------------------------------------
          pst = bar
          !dG = 1.50466Q+05/TT 
     &    !    -2.78602Q+05  
     &    !    +1.41214Q+02*TT 
     &    !    -5.71577Q-03*TT**2
          !dG = dG/(rgas*TT)
          !el = dust_el(i,1)
          !lbruch = LOG(nat(el)*kT/pst)
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP(-3.32020Q+04/TT     !fit_set
     &               +2.90980Q+01
     &               +3.44461Q-03*TT  
     &               -4.54179Q-06*TT**2 
     &               +1.85126Q-09*TT**3)
          Sat(i) = nat(S)*kT/psat

        else if (dust_nam(i).eq.'S[l]') then 
          !--------------------------------------
          !***  S[s]: eigener Fit nach JANAF  ***
          !--------------------------------------
          pst = bar
          psat = EXP(-3.32601Q+04/TT     !fit_set
     &               +3.07134Q+01
     &               -2.01083Q-03*TT  
     &               +4.47359Q-07*TT**2)
          Sat(i) = nat(S)*kT/psat

        else if (dust_nam(i).eq.'NaCl[s]') then
          !-----------------------------------------
          !***  NaCl[s]: eigener Fit nach JANAF  ***
          !-----------------------------------------
          pst = bar
          !dG  = 2.21897Q+05/TT 
     &    !     -6.41916Q+05  
     &    !     +2.54889Q+02*TT 
     &    !     -1.14769Q-02*TT**2
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP(-2.79146Q+04/TT     !fit_set
     &               +3.46023Q+01
     &               -3.11287Q-03*TT  
     &               +5.30965Q-07*TT**2 
     &               -2.59584Q-12*TT**3)
          Sat(i) = nmol(NaCl)*kT/psat

        else if (dust_nam(i).eq.'MgS[s]') then
          !-----------------------------------------
          !***  MgS[s]: eigener Fit nach JANAF  ***
          !-----------------------------------------
          pst = bar
          dG  = -3.08737Q+04/TT 
     &          -7.70053Q+05  
     &          +2.69294Q+02*TT 
     &          -5.60302Q-03*TT**2  
     &          +3.38303Q-07*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'CaS[s]') then
          !-----------------------------------------
          !***  CaS[s]: eigener Fit nach JANAF  ***
          !-----------------------------------------
          pst = bar
          dG  = -8.11371Q+04/TT 
     &          -9.28021Q+05  
     &          +2.69568Q+02*TT 
     &          -7.11550Q-03*TT**2  
     &          +5.21453Q-07*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'FeS2[s]') then
          !-----------------------------------------
          !***  FeS2[s]: eigener Fit nach JANAF  ***
          !-----------------------------------------
          pst = bar
          dG  = 5.30142Q+05/TT 
     &         -1.14524Q+06  
     &         +4.72929Q+02*TT 
     &         -4.33681Q-03*TT**2 
     &         -1.49521Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'KCl[s]') then
          !---------------------------------------------
          !***  KCl[s]: own fit to JANAF 100-1500 K  ***
          !---------------------------------------------
          !pst = bar
          !dG  = 1.42802Q+05/TT 
     &    !     -6.49100Q+05  
     &    !     +2.51681Q+02*TT 
     &    !     -1.24419Q-02*TT**2
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          !dG = 7.78285E+04/TT 
     &    !    -1.23531E+00*LOG(TT) 
     &    !    -2.34028E+01  
     &    !    +4.22811E-03*TT 
     &    !    -8.10849E-07*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)          
          psat = EXP(-2.69250Q+04/TT     !fit_set
     &               +3.39574Q+01
     &               -2.04903Q-03*TT  
     &               -2.83957Q-07*TT**2 
     &               +1.82974Q-10*TT**3)
          Sat(i) = nmol(KCl)*kT/psat

        else if (dust_nam(i).eq.'Na2SiO3[s]') then 
          !--------------------------------------------
          !***  Na2SiO3[s]: eigener Fit nach JANAF  ***
          !--------------------------------------------
          pst = bar
          dG  = 1.31453Q+06/TT     !fit_set
     &         -2.98538Q+06
     &         +8.76910Q+02*TT 
     &         -2.65571Q-02*TT**2
     &         +1.15443Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'MgAl2O4[s]') then      ! Spinel 
          !-----------------------------------------------
          !***  MgAl2O4[s] own fit to JANAF 50-2800K  ***
          !-----------------------------------------------
          ! Sharp & Huebner
          !pst = atm
          !dG  = 2.50397Q+5/TT
     &    !     -9.83584Q+5
     &    !     +2.54352Q+2*TT 
     &    !     -4.24568Q-3*TT**2
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          !S2 = Sat(i)
          pst = bar
          dG  = 1.85854Q+06/TT     !fit_set
     &         -4.11695Q+06  
     &         +1.06653Q+03*TT 
     &         -1.81276Q-02*TT**2  
     &         +1.26020Q-08*TT**3 
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)
          !S2 = Sat(i)
          !pst = bar
          !dG  = 4.91776E+05/TT 
     &    !     -5.07402E+00*LOG(TT)  
     &    !     -9.16247E+01  
     &    !     +3.91488E-03*TT
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          !print*,"MgAl2O4_cr",SNGL(S2),SNGL(Sat(i))

        else if (dust_nam(i).eq.'CaMgSi2O6[s]') then    ! Diopside 
          !-------------------------------------------
          !***  CaMgSi2O6[s] Sharp & Huebner 1990  ***
          !-------------------------------------------
          pst = atm
          dG  = 1.36629Q+5/TT
     &         -1.42281Q+6
     &         +3.59968Q+2*TT 
     &         -4.70714Q-3*TT**2
     &         +1.67622Q-7*TT**3
          dG = dG/(rgas/cal*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'CaAl2Si2O8[s]') then   ! Anorthite 
          !--------------------------------------------
          !***  CaAl2Si2O8[s] Sharp & Huebner 1990  ***
          !--------------------------------------------
          pst = atm
          dG  = 1.32241Q+05/TT
     &         -1.87815Q+06 
     &         +4.71591Q+02*TT 
     &         -6.08175Q-03*TT**2
     &         +1.10392Q-07*TT**3
          dG = dG/(rgas/cal*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'NaAlSi3O8[s]') then    ! Albite
          !-------------------------------------------
          !***  NaAlSi3O8[s] Sharp & Huebner 1990  ***
          !-------------------------------------------
          pst = atm
          dG  = -1.83381Q+06 
     &          +4.49940Q+02*TT
          dG = dG/(rgas/cal*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'KAlSi3O8[s]') then     ! Orthoclase 
          !-------------------------------------
          !***  KAlSi3O8[s] Sharp & Huebner  ***
          !-------------------------------------
          pst = atm
          dG  = -1.83930Q+06 
     &          +4.49643Q+02*TT
          dG = dG/(rgas/cal*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'MgTi2O5[s]') then      ! Armalcolite
          !-----------------------------------------
          !***  MgTi2O5[s] Sharp & Huebner 1990  ***
          !-----------------------------------------
          !pst = atm
          !dG  = 3.07902Q+05/TT
     &    !     -1.16223Q+06 
     &    !     +2.88995Q+02*TT 
     &    !     -4.64108Q-03*TT**2 
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          pst = bar
          dG = 2.12742Q+06/TT    !fit_set
     &        -4.86574Q+06 
     &        +1.21637Q+03*TT 
     &        -2.34246Q-02*TT**2
     &        +8.39658Q-07*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'MgTi2O5[l]') then      ! Armalcolite
          !------------------------------------------------------
          !***  MgTi2O5[s] George's Janaf fit suggested range ***
          !------------------------------------------------------
          pst = bar
          dG = 5.49485Q+06/TT    !fit_set
     &        -4.75803Q+06
     &        +1.18602Q+03*TT 
     &        -4.08290Q-02*TT**2
     &        +3.08428Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'LiCl[s]') then
          !-----------------------------------------
          !***  LiCl[s]: eigener Fit nach JANAF  ***
          !-----------------------------------------
          pst = bar
          !dG  = 9.25751Q+04/TT 
     &    !     -6.90447Q+05  
     &    !     +2.52009Q+02*TT 
     &    !    -1.07037Q-02*TT**2
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP(-2.57733Q+04/TT     !fit_set
     &               +3.36349Q+01
     &               -2.43056Q-03*TT  
     &               +2.35233Q-07*TT**2)
          Sat(i) = nmol(LiCl)*kT/psat

        else if (dust_nam(i).eq.'SiS2[s]') then
          !-----------------------------------------
          !***  SiS2[s]: eigener Fit nach JANAF  ***
          !-----------------------------------------
          pst = bar
          dG  =-3.51195Q+05/TT
     &         -1.21550Q+06
     &         +4.25005Q+02*TT
     &         -9.59678Q-03*TT**2
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'SiC[s]') then
          !----------------------------------------
          !***  SiC[s]: eigener Fit nach JANAF  ***
          !----------------------------------------
          pst = bar
          dG  = 6.73337Q+5/TT
     &         -1.24381Q+6
     &         +3.21779Q+2*TT
     &         -4.54405Q-3*TT**2
     &         +2.69711Q-7*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'TiC[s]') then
          !----------------------------------------
          !***  TiC[s]: eigener Fit nach JANAF  ***
          !----------------------------------------
          pst = bar
          dG =  +1.11878Q+5/TT
     &          -1.37612Q+6
     &          +3.20666Q+2*TT
     &          -4.63379Q-3*TT**2
     &          +1.85306Q-7*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'H2O[l]') then
          !----------------------------------------
          !***  H2O[l]: eigener Fit nach JANAF  ***
          !----------------------------------------
          !pst = bar
          !dG = 1.52414Q+05/TT
     &    !    -9.72996Q+05  
     &    !    +3.32210Q+02*TT 
     &    !    -2.60876Q-02*TT**2
     &    !    +1.32889Q-05*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          !--- Ackerman & Marley 2001 ---
          TC   = MIN(2000.0,TT)-275.15         ! T[degree Celsius]
          psat = 6112.1*exp((18.729*TC - TC**2/227.3)/(TC + 257.87))
          !--- make sure that liquid psat stays > solid psat for low T ---
          psat = psat*exp(-2.Q-6*MIN(0.Q0,TC+20.Q0)**3)  
          Sat(i) = nmol(H2O)*kT/psat
          
        else if (dust_nam(i).eq.'H2O[s]') then
          !----------------------------------------
          !***  H2O[s]: Ackerman & Marley 2001  ***
          !----------------------------------------
          TC   = MIN(2000.0,TT)-275.15         ! T[degree Celsius]
          psat = 6111.5*exp((23.036*TC - TC**2/333.7)/(TC + 279.82))
          Sat(i) = nmol(H2O)*kT/psat
 
        else if (dust_nam(i).eq.'NH3[s]') then
          !--------------------------------------------------------------------
          !***  NH3[s]: CRC Handbook of Chemistry and Physics (Weast 1971)  ***
          !--------------------------------------------------------------------
          psat = exp(10.53 - 2161.Q0/TT - 86596.Q0/TT**2)*bar
          Sat(i) = nmol(NH3)*kT/psat
 
        else if (dust_nam(i).eq.'CH4[s]') then
          !---------------------------------------------------------------------
          !***  CH4[s]: Prydz, R.; Goodwin, R.D., J. Chem. Thermodyn., 1972, 4,1
          !---------------------------------------------------------------------
          psat = 10.0**(3.9895 - 443.028/(TT-0.49))*bar
          Sat(i) = nmol(CH4)*kT/psat
 
        else if (dust_nam(i).eq.'H2SO4[l]') then
          !---------------------------------------------
          !***  H2SO4[cr/l]: eigener Fit nach JANAF  ***
          !---------------------------------------------
          pst = bar
          !dG = 9.70368Q+05/TT
     &    !    -2.53825Q+06  
     &    !    +9.35422Q+02*TT 
     &    !    -4.96224Q-02*TT**2
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          !---------------------------------------------
          !***  H2SO4[l]: C.L.Yaws T=283.15-603.15K  ***
          !---------------------------------------------
          psat = 10.0**( 2.0582Q+00 
     &                  -4.1924Q+03/TT
     &                  +3.2578Q+00*LOG10(TT)
     &                  -1.1224Q-03*TT
     &                  +5.5371Q-07*TT**2)
          Sat(i) = nmol(H2SO4)*kT/psat	

        else if (dust_nam(i).eq.'C[s]') then
          !--------------------------------------------------------------
          !*** C[s]: eigener Fit. JANAF data 100-6000K, fit 100-4000K ***
          !--------------------------------------------------------------
          ! 50-4000K:  5.65332E+05 -7.21659E+05  1.61798E+02 -1.33409E-03  5.04974E-08
          !pst = bar
          !dG = 7.78984Q+05/TT
     &    !    -7.22324Q+05  
     &    !    +1.62385Q+02*TT 
     &    !    -1.52928Q-03*TT**2
     &    !    +7.23212Q-08*TT**3 
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP( 3.27860Q+01 - 8.65139Q+04 / (TT + 4.80395Q-01) )
	  Sat(i) = nat(C)*kT/psat	

        else if (dust_nam(i).eq.'Na2S[s]') then
          !---------------------------------------
          !*** Na2S[s]: eigener Fit nach JANAF ***
          !---------------------------------------
          pst = bar
          dG = 1.99053Q+06/TT 
     &        -8.70027Q+05  
     &        +4.06721Q+02*TT 
     &        -2.78298Q-02*TT**2
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

        else if (dust_nam(i).eq.'AlCl3[s]') then
          !----------------------------------------
          !*** AlCl3[s]: eigener Fit nach JANAF ***
          !----------------------------------------
          pst = bar
          !dG = 4.17188Q+05/TT 
     &    !    -1.40425Q+06  
     &    !    +5.68472Q+02*TT 
     &    !    -1.79150Q-02*TT**2
     &    !    -4.81449Q-06*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP( -1.49010Q+04/TT    !fit_set
     &                +4.07301Q+01
     &                -3.64958Q-03*TT 
     &                -2.95869Q-08*TT**2  
     &                -7.88175Q-11*TT**3 )
          Sat(i) = nmol(AlCl3)*kT/psat

        else if (dust_nam(i).eq.'AlCl3[l]') then
          !----------------------------------------
          !*** AlCl3[s]: eigener Fit nach JANAF ***
          !----------------------------------------
          pst = bar
          psat = EXP( -1.15857Q+04/TT    !fit_set
     &                +3.65148Q+01
     &                -1.22410Q-02*TT 
     &                +5.42405Q-06*TT**2  
     &                -1.08780Q-09*TT**3 )
          Sat(i) = nmol(AlCl3)*kT/psat

	else if (dust_nam(i).eq.'Fe[l]') then
          !---------------------------------------------
          !*** Fe[l]: George's JANAF-fit T=100-4000K ***
          !---------------------------------------------
          !pst = bar
          !dG =-2.10749Q+04/TT 
     &    !    -4.04879Q+05  
     &    !    +1.55545Q+02*TT 
     &    !    -1.10965Q-02*TT**2
     &    !    +8.59559Q-07*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          !psat = EXP( -4.86102Q+04/TT
     &    !            +3.21706Q+01
     &    !            -9.92112Q-04*TT 
     &    !            -1.64248Q-08*TT**2  
     &    !            +1.38179Q-11*TT**3 )
          !Sat(i) = nat(Fe)*kT/psat
          pst = bar
          dG  = 4.83568Q+04/TT      !fit_set
     &         -1.07902Q+00*LOG(TT) 
     &         -1.15904Q+01
     &         +2.10205Q-03*TT 
     &         -1.76458Q-07*TT**2
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch+dG)

	else if (dust_nam(i).eq.'FeS[l]') then
          !-------------------------------------------------
          !*** FeS[l]: George's JANAF-fit T=298.15-3800K ***
          !-------------------------------------------------
          pst = bar
          !dG =-2.25804Q+06/TT     !linear extrapolation poor
     &    !    -7.48562Q+05  
     &    !    +2.50442Q+02*TT 
     &    !    -8.23504Q-03*TT**2
     &    !    +6.58542Q-07*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP( -5.26135Q+04/TT    !fit_set
     &                +3.46138Q+01
     &                -3.55056Q-03*TT 
     &                +7.59195Q-07*TT**2  
     &                -6.94708Q-11*TT**3 )
          Sat(i) = nmol(FeS)*kT/psat

	else if (dust_nam(i).eq.'NaCl[l]') then
          !-----------------------------------------------
          !*** NaCl[l]: George's JANAF-fit T=100-2500K ***
          !-----------------------------------------------
          pst = bar
          !dG = 2.37331Q+05/TT 
     &    !    -6.17718Q+05  
     &    !    +2.37406Q+02*TT 
     &    !    -1.85587Q-02*TT**2
     &    !    +2.09326Q-06*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP(-2.48880Q+04/TT    !fit_set
     &               +3.18494Q+01
     &               -3.08748Q-03*TT  
     &               +4.84990Q-07*TT**2 
     &               -2.60359Q-11*TT**3)
          Sat(i) = nmol(NaCl)*kT/psat

	else if (dust_nam(i).eq.'Na2SiO3[l]') then
          !----------------------------------------------------
          !*** Na2SiO3[l]: George's JANAF-fit T=298.15-2500 ***
          !----------------------------------------------------
          pst = bar
          dG = 1.72092Q+06/TT       !fit_set
     &        -2.93824Q+06  
     &        +8.49423Q+02*TT 
     &        -3.54866Q-02*TT**2
     &        +3.74762Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

	else if (dust_nam(i).eq.'MgAl2O4[l]') then
          !-----------------------------------------------
          !*** MgAl2O4[l]: own JANAF-fit T=298.15-4000 ***
          !-----------------------------------------------
          pst = bar
          dG = 4.87016Q+06/TT      !fit_set
     &        -3.93827Q+06  
     &        +1.00592Q+03*TT 
     &        -2.80659Q-02*TT**2
     &        +1.70265Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)
          !S2 = Sat(i)
          !pst = bar
          !dG  = 4.70478E+05/TT 
     &    !     -1.35143E+00*LOG(TT) 
     &    !     -1.08539E+02  
     &    !     +2.76930E-03*TT 
     &    !     -7.78980E-08*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          !print*,"MgAl2O4_l",SNGL(S2),SNGL(Sat(i))

	else if (dust_nam(i).eq.'Mg2SiO4[l]') then
          !----------------------------------------------------
          !*** Mg2SiO4[l]: George's JANAF-fit T=298.15-4000 ***
          !----------------------------------------------------
          pst = bar
          dG = 3.26302Q+06/TT    !fit_set
     &        -3.87698Q+06  
     &        +1.03152Q+03*TT 
     &        -2.48587Q-02*TT**2
     &        +1.67747Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

	else if (dust_nam(i).eq.'MgSiO3[l]') then
          !----------------------------------------------------
          !*** MgSiO3[l]: George's JANAF-fit T=298.15-3000K ***
          !----------------------------------------------------
          pst = bar
          dG = 2.94675Q+06/TT    !fit_set
     &        -2.86104Q+06  
     &        +7.52974Q+02*TT 
     &        -2.55722Q-02*TT**2
     &        +2.36166Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

	else if (dust_nam(i).eq.'MgTiO3[s]') then
          !-------------------------------------------------
          !*** MgSiO3[l]: George's JANAF-fit T=suggested ***
          !-------------------------------------------------
          pst = bar
          dG = 8.18358Q+05/TT    !fit_set
     &        -2.94809Q+06  
     &        +7.57824Q+02*TT 
     &        -1.56613Q-02*TT**2
     &        +1.01510Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

	else if (dust_nam(i).eq.'MgTiO3[l]') then
          !-------------------------------------------------
          !*** MgSiO3[l]: George's JANAF-fit T=suggested ***
          !-------------------------------------------------
          pst = bar
          dG = 2.95447Q+06/TT    !fit_set
     &        -2.88536Q+06  
     &        +7.40614Q+02*TT 
     &        -2.52836Q-02*TT**2
     &        +1.86167Q-06*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

	else if (dust_nam(i).eq.'CaO[s]') then
          !----------------------------------------------
          !*** CaO[s]: George's JANAF-fit T=100-3600K ***
          !----------------------------------------------
          pst = bar
          dG =-4.94275Q+04/TT    !fit_set
     &        -1.06229Q+06  
     &        +2.81700Q+02*TT 
     &        -7.00317Q-03*TT**2
     &        +4.60182Q-07*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

	else if (dust_nam(i).eq.'CaO[l]') then
          !----------------------------------------------
          !*** CaO[s]: George's JANAF-fit T=suggested ***
          !----------------------------------------------
          pst = bar
          dG = 7.88379Q+05/TT    !fit_set
     &        -9.87984Q+05  
     &        +2.61388Q+02*TT 
     &        -8.44845Q-03*TT**2
     &        +6.19197Q-07*TT**3
          dG = dG/(rgas*TT)
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch-dG)

	else if (dust_nam(i).eq.'Na[l]') then
          !---------------------------------------------
          !*** Na[l]: George's JANAF-fit T=100-2400K ***
          !---------------------------------------------
          pst = bar
          !dG =-9.00015Q+04/TT 
     &    !    -1.04357Q+05  
     &    !    +9.80013Q+01*TT 
     &    !    -9.39646Q-03*TT**2
     &    !    +1.61161Q-06*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP(-1.27706Q+04/TT     !fit_set
     &               +2.65686Q+01
     &               -2.74334Q-03*TT  
     &               +1.33155Q-06*TT**2 
     &               -2.85129Q-10*TT**3)
          Sat(i) = nmol(Na)*kT/psat

	else if (dust_nam(i).eq.'KCl[l]') then
          !----------------------------------------------
          !*** KCl[l]: George's JANAF-fit T=100-2400K ***
          !----------------------------------------------
          pst = bar
          !dG =-5.25703Q+04/TT 
     &    !    -6.32071Q+05  
     &    !    +2.48774Q+02*TT 
     &    !    -2.94945Q-02*TT**2
     &    !    +4.27494Q-06*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP(-2.53357Q+04/TT     !fit_set
     &               +3.55589Q+01
     &               -7.28441Q-03*TT  
     &               +2.45727Q-06*TT**2 
     &               -3.78244Q-10*TT**3)
          Sat(i) = nmol(KCl)*kT/psat

	else if (dust_nam(i).eq.'CaCl2[s]') then
          !-------------------------------------
          !*** CaCl2[l]: own fit T=100-2000K ***
          !-------------------------------------
          !psat = EXP(-3.91597Q+04/TT  
     &    !           +3.71795Q+01 
     &    !           -1.93815Q-03*TT  
     &    !           +1.18087Q-07*TT**2)
          !Sat(i) = nmol(CaCl2)*kT/psat
          pst = bar
          dG  = 1.46320Q+05/TT      !fit_set
     &         -4.97354Q-01*LOG(TT) 
     &         -4.36899Q+01 
     &         +2.12939Q-03*TT 
     &         -1.78214Q-07*TT**2
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch+dG)

	else if (dust_nam(i).eq.'CaCl2[l]') then
          !-------------------------------------
          !*** CaCl2[l]: own fit T=298-3000K ***
          !-------------------------------------
          ! --- George's JANAF-fit T=100-3000K ---
          !pst = bar
          !dG = 1.84571Q+05/TT 
     &    !    -1.19801Q+06  
     &    !    +3.78293Q+02*TT 
     &    !    -2.25537Q-02*TT**2
     &    !    +2.04881Q-06*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          !S2 = Sat(i)
          !psat = EXP(-3.68100Q+04/TT  
     &    !           +3.61822Q+01 
     &    !           -3.53647Q-03*TT  
     &    !           +5.03350Q-07*TT**2 
     &    !           -3.05198Q-11*TT**3)
          !Sat(i) = nmol(CaCl2)*kT/psat
          !print*,'CaCl2[l]:',TT,S2,Sat(i)
          pst = bar
          dG  = 1.43602Q+05/TT       !fit_set
     &         -1.39224Q+00*LOG(TT) 
     &         -3.64246Q+01
     &         +3.84930Q-03*TT 
     &         -3.78330Q-07*TT**2
          lbruch = 0.Q0
          do j=1,dust_nel(i)
            el     = dust_el(i,j)
            term   = nat(el)*kT/pst
            lbruch = lbruch + LOG(term)*dust_nu(i,j)
          enddo
          Sat(i) = EXP(lbruch+dG)

	else if (dust_nam(i).eq.'LiCl[l]') then
          !-----------------------------------------------
          !*** LiCl[l]: George's JANAF-fit T=100-2400K ***
          !-----------------------------------------------
          pst = bar
          !dG = 1.74674Q+05/TT 
     &    !    -6.74167Q+05  
     &    !    +2.39152Q+02*TT 
     &    !    -2.00090Q-02*TT**2
     &    !    +3.10843Q-06*TT**3
          !dG = dG/(rgas*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          psat = EXP(-2.38196Q+04/TT     !fit_set
     &               +3.23179Q+01
     &               -4.07306Q-03*TT  
     &               +1.00591Q-06*TT**2 
     &               -9.65764Q-11*TT**3)
          Sat(i) = nmol(LiCl)*kT/psat

        else if (dust_nam(i).eq.'FeO[s]') then 
          !------------------------------
          !***  Sharp & Huebner 1990  ***
          !------------------------------
          !pst = atm
          !dG  =-6.05591Q+4/TT
     &    !     -2.22156Q+5
     &    !     +6.78769Q+1*TT 
     &    !     -1.52287Q-3*TT**2
          !dG = dG/(rgas/cal*TT)
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  lbruch = lbruch + dust_nu(i,j)*LOG(nat(el)*kT/pst)
          !enddo
          !Sat(i) = EXP(lbruch-dG)
          !S2 = Sat(i)
          pst = bar
          !dG = 1.12768E+05/TT 
     &    !    -1.99329E-02*LOG(TT) 
     &    !    -3.43301E+01  
     &    !    +1.03401E-03*TT 
     &    !    -3.64152E-08*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          psat = EXP(-6.30018Q+04/TT     !fit_set
     &               +3.66364Q+01
     &               -2.42990Q-03*TT  
     &               +3.18636Q-07*TT**2)
          Sat(i) = nmol(FeO)*kT/psat

	else if (dust_nam(i).eq.'FeO[l]') then
          !-----------------------------------------
          !*** FeO[l]: own JANAF-fit T=298-5000K ***
          !-----------------------------------------
          pst = bar
          !dG = 1.09737E+05/TT 
     &    !    -1.19870E+00*LOG(TT) 
     &    !    -2.50563E+01  
     &    !    +2.00349E-03*TT 
     &    !    -1.48543E-07*TT**2
          !lbruch = 0.Q0
          !do j=1,dust_nel(i)
          !  el     = dust_el(i,j)
          !  term   = nat(el)*kT/pst
          !  lbruch = lbruch + LOG(term)*dust_nu(i,j)
          !enddo
          !Sat(i) = EXP(lbruch+dG)
          psat = EXP(-6.03086Q+04/TT     !fit_set
     &               +3.48392Q+01
     &               -2.21932Q-03*TT  
     &               +2.77859Q-07*TT**2 
     &               -1.56828Q-11*TT**3)
          Sat(i) = nmol(FeO)*kT/psat

        else
          print*,dust_nam(i) 
          stop 'unbekannte Staubsorte in SUPERSAT '
        endif

      enddo

      RETURN 
      end 
