
*	Read in binary file;
	data rawdata;
	    infile 'C:\Users\dazara\Desktop\SAS - Projects\SAS - Project - SAfrican Hacker\001_Rawdata\SAS_TESTDATA.001' ignoredoseof linesize=32000;
	    input record $32000.;
		run;

*	This code will only keep the characters specified in the list shown below. All other special characters will be dropped;
	data rawdata2; set rawdata;
		text2 = compress(text, ';~-()<>="\/?!''_', "adpk");
		drop text;
		run;

*ZEND;