C ************************************************************
C Source for the library implementing a dummt bias function 
C always returns one
C ************************************************************
      
      subroutine bias_wgt(p, original_weight, bias_weight)
          implicit none
C
C Parameters
C
          include '../../nexternal.inc'
C
C Arguments
C
          double precision p(0:3,nexternal)
          double precision original_weight, bias_weight
C
C local variables
C
          integer i,j
          double precision mass,mass_wgt
C
C local variables defined in the run_card
C
C
C Global variables
C
C Mandatory common block to be defined in bias modules
C
          double precision stored_bias_weight
          data stored_bias_weight/1.0d0/          
          logical impact_xsec, requires_full_event_info
          data impact_xsec/.True./
C         Of course this module does not require the full event
C         information (color, resonances, helicities, etc..)
          data requires_full_event_info/.False./ 
          common/bias/stored_bias_weight,impact_xsec,
     &                requires_full_event_info

C
C Accessingt the details of the event
C
          logical is_a_j(nexternal),is_a_l(nexternal),
     &            is_a_b(nexternal),is_a_a(nexternal),
     &            is_a_onium(nexternal),is_a_nu(nexternal),
     &            is_heavy(nexternal),do_cuts(nexternal)
          common/to_specisa/is_a_j,is_a_a,is_a_l,is_a_b,is_a_nu,
     &                      is_heavy,is_a_onium,do_cuts
C
C    Setup the value of the parameters from the run_card    
C
      include '../bias.inc'

C --------------------
C BEGIN IMPLEMENTATION
C --------------------

c The 'bias_wgt' should be a IR-safe function of the momenta.
c      
c For this to be used, the 'event_norm' option in the run_card should be
c set to
c      'bias' = event_norm      
c
      
      mass_wgt=1d0

C      do i=0,nexternal
      do i=1,nexternal
         do j=i+1,nexternal
            if (is_a_l(i) .and. is_a_l(j)) then 
               mass=dsqrt((p(0,i)+p(0,j))**2 - ( (p(1,i)+p(1,j))**2 + (p(2,i)+p(2,j))**2 + (p(3,i)+p(3,j))**2) )
               mass_wgt=min(mass,300.)**2.7
            endif
         enddo
      enddo

      bias_weight=mass_wgt

      return

      end subroutine bias_wgt
