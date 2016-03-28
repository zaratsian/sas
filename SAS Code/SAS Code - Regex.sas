
data ds1;
   infile datalines delimiter='^';
   format text $32000.; 
   input  text $     ;
   datalines; 
Original Message Follows: ------------------------ Case Id=XYZABC              Hi Dept222,      These items are active, but do not have replenishment codes and OTL. Please perform an AIR set up on these items for this location to provide replenishment.    222 05 6001    222 05 6016    222 05 6011    222 05 6006    222 05 6036    222 05 6021    222 05 6026    222 05 6031    222 05 6056    222 05 6041                                Have a great day!      Thank you, ABC            Original Message Follows: ------------------------          DPCI Info  Dept Class Item POG Quantity Or UPC 222 05 6001    222 05 6016    222 05 6011    222 05 6006    222 05 6036    222 05 6021    222 05 6026    222 05 6031    222 05 6056    222 05 6041     OutofStock Form  Description These DPCIs as well as the following two (222-05-6051, 222-05-6046) is a full complement of merchandise for the "D1" Convertible in the 3/4 Girls Adjacency. I have 0 on-hand for all of this merchandise. Is there an ETA on the arrival of this merchandize.
;
run;


data ds1a; set ds1;
   ExpressionID = prxparse('/[0-9]{3}(\-| )[0-9]{2}(\-| )[0-9]{4}/');
   start = 1;
   stop = length(text);

      /* Use PRXNEXT to find the first instance of the pattern, */
      /* then use DO WHILE to find all further instances.       */
      /* PRXNEXT changes the start parameter so that searching  */
      /* begins again after the last match.                     */
   call prxnext(ExpressionID, start, stop, text, position, length);
      do while (position > 0);
         found = substr(text, position, length);
         put found= position= length=;
         call prxnext(ExpressionID, start, stop, text, position, length);
		 output;
      end;
	keep found;
run;

/*
data ds1a; set ds1a;
	dept 	= substr(found,1,3);
	class 	= substr(found,5,2);
	item 	= substr(found,8,4);
	drop found;
run;
*/


data ds2;
   infile datalines delimiter='^';
   format text $32000.; 
   input  text $     ;
   datalines; 
DPCI Info Dept    Class   Item    POG     Quantity        Or UPC 037     11      0037 037     11      0046          Overstock Form Description     There was a message board to pull these and alot of others. We have not seen the MIR yet. Please Advise. Tier 1  MySupport Root Topic Tier 2  Merchandise Tier 3  Replenishment myAdItem        No subject         T2300: /MySupport Root Topic/Merchandise/Replenishment sb_firstname    Anthony myIssueType     Sweep Request myReoccurring   No sb_create_date  03-16-12 11:23 AM myVisualAdjacency       No myStoreImpact   Department  From:   mys.statusboard@target.com To:     SRC Sent:   n/a Subject:        T2300: /MySupport Root Topic/Merchandise/Replenishment Store:  2300 Solution Object Title:  Overstock Form Remodel Date: Grand Opening Date:     10-14-07 Lifecycle Status:       existing Region: 100 District:       163 Group:  191 TM First Name:  Anthony TM Last Name:   Schuetz TM Job Title:   ETL Hardlines
DPCI Info Dept    Class   Item    POG     Quantity        Or UPC  Description 074     12      1352            6       629268244607    Wall Hanging 1X30X10 074     12      0440            6       629268244430    Wall Hanging 1.25X10X30 074     12      0701            6       629268244546    Wall Hanging 1.25X18X14 074     12      0968            6       629268244577    Wall Hanging 1.25X14X18 074     12      0476            4       629268244515    Wall Hanging 1.25X14X18       ItemScanning Form Description     All of these items belong on POG A111F52 and there was a message board sent out about this issue and that it was fixed but unfortunately at our store it did not work. I have tried tie the UPC to the DPCI under the UPC maintenance menu and it keeps giving me the error: THIS UPC IS ALREADY LINKED TO ANOTHER DPCI. PLEASE CHECK YOUR UPC/DPCI ENTRY. YOU CANNOT SET UP THE SAME UPC TO MORE THAN ONE DPCI. You can physically type in the DPCI and it will ring up in our system but if you scan the barc
DPCI Info Dept    Class   Item    POG     Quantity        Or UPC  Description                                 1       047400518964    4 pk Fusion Proglide Razor refil                                 1       017000044927    Right Guard Aerosol Deodorant                                 1       079568243488    MLB Diary notepad                                 1       049022507494    Toy Story 3 walkie talkies                                 1       746775157562    Fisher Price Doodle Bear                                 5       846259094939    One..Cool Eyes single mask                                 2       03726004        1 oz Secret Body spray     ItemScanning Form Description     Items scanning NOF Tier 1  MySupport Root Topic Tier 2  Merchandise Tier 3  Scanning Issues subject         T2179: /MySupport Root Topic/Merchandise/Scanning Issues sb_firstname    Roxanne myIssueType     NOF sb_create_date  03-17-12 01:18 PM  From:   mys.statusboard@target.com To:     SRC Sent:   n/a Subj
DPCI Info Dept    Class   Item    POG     Quantity        Or UPC 030     09      2243    a030QOG 030     09      2044 030     09      2226 030     09      2227        OutofStock Form Description     POG is about 40% out of stock for over a week now. Tier 1  MySupport Root Topic Tier 2  Merchandise Tier 3  Replenishment myAdItem        No subject         T0093: /MySupport Root Topic/Merchandise/Replenishment sb_firstname    Martin myIssueType     Increase OTL myReoccurring   Yes sb_create_date  03-16-12 10:01 AM myVisualAdjacency       No myStoreImpact   Department/Class  From:   mys.statusboard@target.com To:     SRC Sent:   n/a Subject:        T0093: /MySupport Root Topic/Merchandise/Replenishment Store:  0093 Solution Object Title:  Out of Stock Form Remodel Date: Grand Opening Date:     11-02-80 Lifecycle Status:       existing Region: 200 District:       256 Group:  297 TM First Name:  Martin TM Last Name:   Burns TM Job Title:   ETL GuestExperience&Softlines
;
run;

data ds2a; set ds2;
   regex_dept	= prxparse('/[0-9]{3}/');
   regex_class 	= prxparse('/[0-9]{2}/');
   regex_item 	= prxparse('/[0-9]{4}/');
   regex_POG 	= prxparse('/[0-9]{3}/');
   regex_UPC 	= prxparse('/[0-9]{12,13}/');



   start = 1;
   stop = length(text);

      /* Use PRXNEXT to find the first instance of the pattern, */
      /* then use DO WHILE to find all further instances.       */
      /* PRXNEXT changes the start parameter so that searching  */
      /* begins again after the last match.                     */
   call prxnext(ExpressionID, start, stop, text, position, length);
      do while (position > 0);
         found = substr(text, position, length);
         put found= position= length=;
         call prxnext(ExpressionID, start, stop, text, position, length);
		 output;
      end;
	keep found;
run;

/*
data ds2a; set ds2a;
	dept 	= substr(found,1,3);
	class 	= substr(found,5,2);
	item 	= substr(found,8,4);
	drop found;
run;
