	/* UNDER CONSTRUCTION DZ-20130808 */

 /***********************************************************************/
 /*                                                              		*/
 /*    NAME: CONTENT CATEGORIZATION SCORING                        		*/
 /*   TITLE: Scoring SAS datasets inside SAS Content Categorization  		*/
 /* PRODUCT: SAS, Enterprise Guide, SAS Content Categorization				*/
 /* THIRD PARTY SOFTWARE: PYTHON										*/
 /*  SYSTEM: TESTED IN WINDOWS OS                                		*/
 /*   PROCS: SQL PRINTTO IMPORT "DATA STEPS"                       		*/
 /*    DATA: Input data is any SAS dataset or dataset mapped via an   	*/
 /*          Access Engine. Libname needs to be assigned prior to     	*/
 /*          executing the macro 										*/
 /*                                                              		*/
 /*  UPDATE: 08/08/2013							                 		*/
 /*     REF:                                                     		*/
 /*    MISC:                                                     	    */
 /*    DESC: Provides an automated scoring mecanism for SAS Sentiment   */
 /*          Analysis Server. Dataset must be SAS or mapped via an     	*/
 /*          Access engine. The macro partitions a specific character  	*/
 /*			 variable the dataset into individual text files to be      */
 /*			 processed by SAS Content Categorization Server. This macro     */
 /*			 levarages the Python API, so Python needs to be installed  */
 /*			 and configured prior to executing this macro. All 			*/
 /* 		 intermediate data and scripts are created in WORK, they 	*/
 /* 		 will be deleted once SAS is terminated. User can define 	*/
 /* 		 location of the final output dataset. 						*/
 /*                                                             		*/
 /* CREATOR: Vinicius Vivaldi, Dan Zaratsian							*/
 /* CONTRIBUTORS: Justin Plumley 										*/
 /*																		*/
 /***********************************************************************/

/******************************/
/* ASSIGN LIBRARY - IF NEEDED */
/******************************/
/* Assign library mapping to a SAS dataset (or table mapped via an Access engine) */
libname demodata 'C:\z\_Projects\Rescon\data';

/****************************/
/* SPECIFY PARAMETERS BELOW */
/****************************/

/* Location of the Python ECC client.  */
%let python_location = C:\Program Files (x86)\Teragram\Teragram Catcon Server\client_api\python;

/* Content Categorization Project. This is the project uploaded to the SAS Content Categorization Server via the upload 
   task functionality under the "Build" item in the menu bar.*/
%let CC_project = jobs_liti;

/* Data source to be scored */
%let input_data = demodata.jobs_cat;

/* Output location of the final scored dataset*/
%let output_data = demodata.jobs_cat_liti;

/* TEXT variable (field) name to be parsed and scored */
%let TEXT_field = description;

/* This is the fully qualified Content Categorization Server name. Default is "LOCALHOST".
   This information should be provided by your SAS adminstrator. If SAS Content Categorization Server is 
   installed in the same location as Python the server name "localhost" should work fine. */
%let CC_Server_name = localhost;

/* This is the port to connect to Content Categorization Server. Default port is "6500".
   This information should be provided by your SAS adminstrator.*/
%let CC_Server_port = 6500;



/****************************/
/*     CODE STARTS HERE     */
/****************************/

/* Identifying the work path */
%let SAS_TEMP = %sysfunc(pathname(work));
%put &SAS_TEMP;

/* 
Creates temporary folders inside SAS Temporary files to store:
	1) Partitioned text files
	2) Scripts to run the scoring code as well as the clean-up code
	3) Location to store the .CSV scored file
*/

data _null_;
newdir1=dcreate("CC_TEMP_Files_Data","&SAS_TEMP.");
newdir2=dcreate("CC_TEMP_Files_Scripts","&SAS_TEMP.");
newdir3=dcreate("CC_TEMP_Files_Results","&SAS_TEMP.");
run;
/*
Create a temporary intermediate table 
*/

data work.intermediate_table1(compress=yes);
set &input_data;
INTERNAL_ID_ZQJ+1;
run;

/* 
Automatically detect the amount of records to convert to text files based on total counts of available records.
This process can probably be faster using a _N_ or OBS function
*/

*let MaxNum=10;

proc sql noprint;
  select count(&TEXT_field.) into: MaxNum
  from work.intermediate_table1;
  quit;
run;


/* Send log to "heaven" */

proc printto log="nul:";
run;


data _null_;
/* Point to the actual SAS dataset that is being parsed parsing. */
set work.intermediate_table1 (keep=&TEXT_field INTERNAL_ID_ZQJ obs=&MaxNum);
		i+1;

/* Define location where text files will be saved */
        Thisfile=cats("&SAS_TEMP.","\CC_TEMP_Files_Data\",INTERNAL_ID_ZQJ,".txt");
        file textfile filevar=ThisFile lrecl=2048;
   	    put &TEXT_field;
run;

/* Sets log back to default */
proc printto; 
run;

/* Define directories and fully qualified locations of the scripts, scoring code and text data */
%let scriptdir = \CC_TEMP_Files_Scripts\Score_SA.bat;
%let sascriptloc = &SAS_TEMP&scriptdir;
%let sascriptloc2 = %str(%")&SAS_TEMP&scriptdir%str(%");

%let txtcleandir = \CC_TEMP_Files_Scripts\Text_clean.bat;
%let txtcleanloc = &SAS_TEMP&txtcleandir;
%let txtcleanloc2 = %str(%")&SAS_TEMP&txtcleandir%str(%");

%let scoreddir = \CC_TEMP_Files_Results\CC_results.txt;
%let scoreloc = %str(%")&SAS_TEMP&scoreddir%str(%");

%let datadir = \CC_TEMP_Files_Data;
%let dataloc = %str(%")&SAS_TEMP&datadir%str(%");
%let dataloc2 = &SAS_TEMP&datadir;


/* Map the location to store the script and scored file - inside SAS Temp */
filename sascript "&sascriptloc.";
filename txtclean "&txtcleanloc.";
filename scored "&scoreloc.";


/* SAMtraining_hybrid_object */

data _null_;
	format cmd2 $5000.;
	cmd1 = "cd &python_location.";
	cmd2 = "python CatConClientTextMiner.py --server &CC_Server_name.:&CC_Server_port. --show-paths --dir &dataloc. --liti-project &CC_project. --extract-li-facts --show-liti-info > &scoreloc.";

	file sascript lrecl=32000;
	put cmd1;
	put cmd2;
run;

options noxwait xsync;
/* X command to execute the newly created .bat file and copy identified files to the empty subset directory. */
x "&sascriptloc2.";


/* Import CSV results to create a formatted data set */
data &output_data (compress=yes);
	infile scored delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
    informat filename $250.;
    informat liti_concept $250.;
    informat liti_match $250.;
	informat liti_match2 $250.;
    format filename $250.;
    format liti_concept $250.;
    format liti_match $250.;
	format liti_match2 $250.;
    input
    filename $ 
    liti_concept $
    liti_match $
	liti_match2 $
;
run;

data &output_data (compress=yes);
set &output_data;
INTERNAL_ID_ZQJ = input(scan(filename,-2,". \"), best12.);
run;

/*
Join final scored table with original table 
*/
proc sql;
create table &output_data.(compress=yes drop=INTERNAL_ID_ZQJ filename) as 

select a.*, b.*
from work.intermediate_table1 a 
	left join &output_data. b 
	on a.INTERNAL_ID_ZQJ = b.INTERNAL_ID_ZQJ 
;
quit;

/*
Deleting intermetdiate table1
*/
proc datasets library=work noprint;
delete intermediate_table1;
quit;


data _null_;
	format cmd2 $5000.;
	cmd1 = "cd &dataloc2.";
	cmd2 = 'del *.txt';

	file txtclean lrecl=32000;
	put cmd1;
	put cmd2;
run;

options noxwait xsync;
/* X command to execute the newly created .bat file and copy identified files to the empty subset directory. */
x "&txtcleanloc2.";

filename scored clear;
filename sascript clear;
filename txtclean clear;


**************************
      CODE ENDS HERE      
**************************;



