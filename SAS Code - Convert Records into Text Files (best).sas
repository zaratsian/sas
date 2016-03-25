
*************************************************************************************
*                                                                                   *
*	Create individual text files for each record.                               *
*                                                                                   *
*	This code will convert a table (ie. SAS dataset, excel table, etc) into     * 
*	text files that contain one file per table record.                          *
*                                                                                   *
*	Make sure to specify the file directory and file name.                      *
*	Check log to verify that no values were truncated.                          *
*                                                                                   *
*************************************************************************************;

* Define the libname and filepath for SAS dataset;
libname rawdata 'C:\Users\dazara\Desktop\SAS - Projects\_rawdata';

* What is the dataset name?;
%let in_data = discover_consumeraffairs;

* What is the name of the "text" variable?;
%let in_text = comment;

* Where should the individual text files be sent?;
%let out_data = C:\Users\dazara\Desktop\SAS - Projects\SAS - Project - Discover\docs_consumeraffairs\;


**********************************************************************************;
**********************************************************************************;
**********************************************************************************;


options nonotes;


proc sql noprint;
select count(*)
into :OBSCOUNT
from rawdata.&in_data.;
quit;
%put &OBSCOUNT.;


data rawdata.&in_data.; set rawdata.&in_data.;
	&in_text = compress(&in_text, ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+={[}]|\:;"''?/>.<,', "k");
	run;

%macro filecreate;
	%do x=1 %to &OBSCOUNT.; /* Change this to specify the total number of comments to be extracted into txt file. */
		filename files "&out_data.doc&x..txt" LRECL=32000;
		data _null_;
			set rawdata.&in_data. (firstobs=&x obs=&x);
			file files dsd dlm='09'x;y
			put &in_text.;
		run;
	%end;
%mend;


%filecreate;


*ZEND;
