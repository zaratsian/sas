
*************************************************************************************************;
*This code retrieves a list of synonyms from www.thesaurus.com and outputs the results
*into a CSV file.


*Enter your keyword or phrase here;
	%let keyword = happy;

*Enter your output filepath here;
	%let output_file = 'C:\Users\dazara\Desktop\synonyms.csv';


*All other parts of the code should not need to be modified)
*************************************************************************************************;


%let url_firstpart = http://thesaurus.com/browse/;
%let url_thirdpart = ?s=t;
%let urlstring = &url_firstpart.&keyword.&url_thirdpart; 

filename foo url "&urlstring." debug lrecl=32000;

data dataset1;
    infile foo length=len;
    input record $varying32000. len;
	run;

data dataset2; set dataset1;
	str_extract1 = find(record,'onmousedown="return hotwordOneClick(this);" href="http://thesaurus.com/browse/');

	if prxmatch('/td valign\=\"top\"\>Synonyms\:\<\/td\>/',record) >= 1 then keep=1;
	else if prxmatch('/td valign\=\"top\"\>Antonyms\:\<\/td\>/',record) >= 1 then keep=2;

	if str_extract1 > 0 then do;
		str_extract2 = substr(record,str_extract1,length(record)-str_extract1);
		end = find(str_extract2,'">');
		str_extract3 = substr(str_extract2,79,end-79);
		end;

	if str_extract1 > 0 or keep > 0;
	run;

data dataset3; set dataset2;
	if keep = 1 then keep2 = 1; else if keep = 2 then keep2 = 2;
	keep2 + 0;
	run;

data ant syn; set dataset3;
	parent_term = symget('keyword');
	if keep2 = 1 then synonym_term = str_extract3;
	if keep2 = 2 then antonym_term = str_extract3;

	if keep2 = 1 then output syn;
	if keep2 = 2 then output ant;
	run;

data ant; set ant (keep = antonym_term);
	if antonym_term ne '';
	run;

data syn; set syn (keep = synonym_term parent_term);
	if synonym_term ne '';
	run;

data dataset4; merge syn ant; run;

proc datasets library=work;
	delete ant syn dataset1 dataset2 dataset3;
 	run;

proc export data=dataset4
   outfile=&output_file.
   dbms=csv
   replace;
run;

*ZEND;





