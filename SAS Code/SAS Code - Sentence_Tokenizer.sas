
/*******************************************************************************
*
*	Define these parameters
*
********************************************************************************/

/*Define the library where the data set is stored*/
libname adam 'C:\Users\adpilz\Documents\Data';

/*Define the data set for which you desire tokenized sentences*/
%let dsn = adam.POC_BOFA_final;

/*Define the text variable to parse*/
%let textvar = comment;



/*******************************************************************************
*
*	Append this code to the end of the SAS Contextual Analysis Category Code 
*
********************************************************************************/

/*Strip the data and create an index*/
data temp (compress=yes); set &dsn (keep = &textvar);
	my_doc_id= _n_ ;
run;


/*Parse the documents*/
proc hptmine data=temp;
doc_id my_doc_id;
variables &textvar;
	parse 
		notagging nonoungroups nostemming SHOWDROPPEDTERMS
		reducef = 0 
		termwgt = none
		cellwgt = none 
		outterms = terms
		outpos = pos
		(compress=yes);
performance details;
run;


/*Grab the indexes*/
proc sql;
	create table test1 (compress=yes) as
	select DOCUMENT, SENTENCE, min(_START_) as start
	from pos
	group by DOCUMENT, SENTENCE
	order by DOCUMENT, SENTENCE;
quit;

/*Create an additional index*/
data test1 (compress=yes); set test1;
	by DOCUMENT SENTENCE;
	count + 1;
	if first.DOCUMENT then count = 1;
run;

/*Grab the next observation*/
proc sql;
create table sent (compress=yes) as
	select a.* , b.start as next_start
	from test1 as a left join test1 as b 
		on a.DOCUMENT = b.DOCUMENT and a.count = b.count - 1 ;
quit;

/*Clean up*/
proc delete data=test1; run;


/*Join sentences with text*/
proc sql;
	create table sentences (compress=yes) as
	select a.*, b.SENTENCE, b.start , b.next_start  
	from temp as a left join sent as b
		on a.my_doc_id = b.DOCUMENT ;
quit;

/*Clean up*/
proc delete data=sent; run;

/*Extract the sentences*/
data sentences (compress=yes drop = SENTENCE start next_start ); set sentences;
	if next_start = . then next_start = length(&textvar);
		else next_start = next_start;
	tokenized_sentence = substrn(&textvar, start, next_start - start + 1);
run;
 
/*View the data*/
proc print data=sentences (obs=25); run;




