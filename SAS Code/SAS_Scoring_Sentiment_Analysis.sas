/***********************************************************************/
 /*                                                              		*/
 /*    NAME: SENTIMENT ANALYSIS SCORING                          		*/
 /*   TITLE: Scoring SAS datasets inside SAS Sentiment Analysis  		*/
 /* PRODUCT: SAS, Enterprise Guide, SAS Sentiment Analysis				*/
 /* THIRD PARTY SOFTWARE: PYTHON										*/
 /*  SYSTEM: TESTED IN WINDOWS OS                                		*/
 /*   PROCS: SQL PRINTTO IMPORT "DATA STEPS"                       		*/
 /*    DATA: Input data is any SAS dataset or dataset mapped via an   	*/
 /*          Access Engine. Libname needs to be assigned prior to     	*/
 /*          executing the macro 										*/
 /*                                                              		*/
 /*  UPDATE: 07/02/2013							                 		*/
 /*     REF:                                                     		*/
 /*    MISC:                                                     	    */
 /*    DESC: Provides an automated scoring mecanism for SAS Sentiment   */
 /*          Analysis Server. Dataset must be SAS or mapped via an     	*/
 /*          Access engine. The macro partitions a specific character  	*/
 /*			 variable the dataset into individual text files to be      */
 /*			 processed by SAS Sentiment Analysis Server. This macro     */
 /*			 levarages the Python API, so Python needs to be installed  */
 /*			 and configured prior to executing this macro. All 			*/
 /* 		 intermediate data and scripts are created in WORK, they 	*/
 /* 		 will be deleted once SAS is terminated. User can define 	*/
 /* 		 location of the final output dataset. 						*/
 /*                                                             		*/
 /* CREATOR: Vinicius Vivaldi 											*/
 /* CONTRIBUTORS: Dan Zaratsian, Justin Plumley 						*/
 /*																		*/
 /***********************************************************************/

/******************************/
/* ASSIGN LIBRARY - IF NEEDED */
/******************************/
/* Assign library mapping to a SAS dataset (or table mapped via an Access engine) */
libname demodata 'C:\_Datasets';
libname desktop  'C:\users\dazara\desktop';

/****************************/
/* SPECIFY PARAMETERS BELOW */
/****************************/

/* Location of the Python SAM client. This is the location where you should find "SamClientForTM.py" */
%let python_location = C:\Program Files (x86)\Teragram\SAMServer\client_api\python;

/* Sentiment Analysis Project. This is the project uploaded to the SAS Sentiment Analysis Server via the upload 
   task functionality under the "Build" item in the menu bar. The default location for the description of these 
   projects is "C:\Program Files (x86)\Teragram\SAMServer\descriptors"*/
%let SAM_project = banking;

/* Data source to be scored */
%let input_data = demodata.Creditcard_meta;

/* Output location of the final scored dataset*/
%let output_data = desktop.Creditcard_meta_scored2;

/* TEXT variable (field) name to be parsed and scored */
%let TEXT_field = COMMENT; 

/* This is the fully qualified Sentiment Analysis Server name. Default is "LOCALHOST".
   This information should be provided by your SAS adminstrator. If SAS Sentiment Analysis Server is 
   installed in the same location as Python the server name "localhost" should work fine. */
%let SA_Server_name = localhost;

/* This is the port to connect to Sentiment Analysis Server. Default port is "8888".
   This information should be provided by your SAS adminstrator.*/
%let SA_Server_port = 8888;



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
newdir1=dcreate("SAM_TEMP_Files_Data","&SAS_TEMP.");
newdir2=dcreate("SAM_TEMP_Files_Scripts","&SAS_TEMP.");
newdir3=dcreate("SAM_TEMP_Files_Results","&SAS_TEMP.");
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
        Thisfile=cats("&SAS_TEMP.","\SAM_TEMP_Files_Data\",INTERNAL_ID_ZQJ,".txt");
        file textfile filevar=ThisFile lrecl=2048;
   	    put &TEXT_field;
run;

/* Sets log back to default */
proc printto; 
run;

/* Define directories and fully qualified locations of the scripts, scoring code and text data */
%let scriptdir = \SAM_TEMP_Files_Scripts\Score_SA.bat;
%let sascriptloc = &SAS_TEMP&scriptdir;
%let sascriptloc2 = %str(%")&SAS_TEMP&scriptdir%str(%");

%let txtcleandir = \SAM_TEMP_Files_Scripts\Text_clean.bat;
%let txtcleanloc = &SAS_TEMP&txtcleandir;
%let txtcleanloc2 = %str(%")&SAS_TEMP&txtcleandir%str(%");

%let scoreddir = \SAM_TEMP_Files_Results\SAM_results.csv;
%let scoreloc = %str(%")&SAS_TEMP&scoreddir%str(%");

%let datadir = \SAM_TEMP_Files_Data;
%let dataloc = %str(%")&SAS_TEMP&datadir%str(%");
%let dataloc2 = &SAS_TEMP&datadir;


/* Map the location to store the script and scored file - inside SAS Temp */
filename sascript "&sascriptloc.";
filename txtclean "&txtcleanloc.";
filename scored "&scoreloc.";


/* SAMtraining_hybrid_object */

data _null_;
	format cmd2 $5000.;
    cmd0 = "C:";
	cmd1 = "cd &python_location.";
	cmd2 = "python SamClientForTM.py &SA_Server_name.:&SA_Server_port. &SAM_project. &dataloc. &scoreloc.";

	file sascript lrecl=32000;
    put cmd0;
	put cmd1;
	put cmd2;
run;

options noxwait xsync;
/* X command to execute the newly created .bat file and copy identified files to the empty subset directory. */
x "&sascriptloc2.";


/* Import CSV results to create a formatted data set */
proc import file=scored
      out=&output_data (compress=yes) replace dbms=csv;
      getnames=yes;
      /* important to ensure column types are guessed correctly */
      guessingrows=5000;
run;

data &output_data (compress=yes);
set &output_data (rename=(filename=filename_temp));
INTERNAL_ID_ZQJ = input(scan(filename_temp,-2,". \"), best12.);
run;

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

/*
Join final scored table with original table 
*/
proc sql;
create table &output_data.(compress=yes drop=INTERNAL_ID_ZQJ filename_temp) as 

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

/****************************/
/*      CODE ENDS HERE      */
/****************************/

data &output_data.; set &output_data.;
	if _overall_sentiment > 0 then sentiment = 'Positive'; else
	if _overall_sentiment < 0 then sentiment = 'Negative'; else
	sentiment = 'Neutral';
	run;
