
*****************************************************************************

This code will run a webcrawl macro (%TMFILTER).

When you use the %TMFILTER macro to retrieve Web pages, you must specify 
values for the URL, DIR, and DESTDIR parameters. 

The %TMFILTER macro extracts text from the Web pages and transforms textual 
data of different formats into a SAS data set. That data set can then be
used as input for the Text Miner node. 

*****************************************************************************;

%TMFILTER
	(url=%NRSTR(http://www.sas.com/technologies/analytics/),        
	depth=1,
	dir=d:\tmfilter\output2\dir,
	destdir=d:\tmfilter\output2\destdir,
	norestrict=,
	dataset=work.output,
	numbytes=32000);


*******************************************************
 General Structure of TMFilter Macro with all options
*******************************************************
%TMFILTER 
	(DIR=path, 
	URL=path, 
	DATASET=libref.output-data-set, 
	DEPTH=n,  
	DESTDIR=path, 
	EXT=extension1 <extension2 extension3...>, 
	FORCE=anything, 
	HOST=name | IP address, 
	LANGUAGE=ALL | language1 <language2 language3...>,  
	MANUAL=anything, 
	MAXSIZE=n, 
	NORESTRICT=anything, 
	NUMBYTES=n,
    PASSWORD=password, 
	USERNAME=username, 
	MAXSIZE=n);

******************************************************************************

REQUIRED ARGUMENTS:

	DIR=path 
	Specifies the path to the directory that contains the documents to process. 
	Any subfolders in this directory are processed recursively. The path might 
	be a UNC (Universal Naming Convention) formatted network path. 

	URL=URL 
	(Web crawling only) specifies the URL—less than or equal to 255 characters 
	in length—of the starting Web page. The value can be either in the form 
	http://www.sas.com or www.sas.com. Web pages that are retrieved are placed 
	in the directory that is specified by the DIR= argument. 

	Note: If the URL contains an ampersand (&), then the ampersand will be 
	misinterpreted as a macro trigger. In this case, you must use %NRSTR function 
	when you specify the URL. 

OPTIONAL ARGUMENTS:

	DATASET=<libref.>output-data-set 
	Specifies the name to give the output data set. It is recommended that you 
	save this data set in a permanent library. If you do not specify this 
	argument, then the name of the output data set is Work.Data. 

	DEPTH=n 
	(For Web crawling only) specifies the number of levels for Web crawling. 
	If you do not specify this argument, then the macro visits all links on 
	the starting Web page and all links on the linked pages (in other words, DEPTH=2). 

	DESTDIR=path 
	Specifies the path to the directory in which to save the output HTML files. 
	Do not make the value of DESTDIR= a subdirectory of the DIR= directory. 
	If you do not specify this argument, then filtered HTML files that correspond 
	to the files in DIR= directory are not produced. 

	EXT=extension1 <extension2 extension3...> 
	Specifies one or more file types to process. Only files (with a listed extension) 
	that are in the directory specified by the DIR= argument are processed. 
	To specify documents with no extension, use a single period (EXT= .). If you do not
	specify this argument, then all applicable file types are processed. 

	FORCE=anything 
	Specifies not to terminate the %TMFILTER macro if the directory specified by the
	DESTDIR= argument is not empty when the macro begins processing. Any value 
	(for example, 1 or 'y') keeps the macro from terminating if the destination 
	directory is not empty. Otherwise, if you do not specify this option or if you 
	do not specify a value for it, the macro terminates if the destination directory is not empty. 

	HOST=name | IP address 
	Specifies the name or IP address of the machine on which to run the %TMFILTER macro. 
	If you do not specify this argument, then the macro assumes that HOST= localhost. 

	LANGUAGE=ALL | language1 <language2 language3...> 
	Specifies one or more languages in which the input documents are written. 
	If a list is supplied, then the %TMFILTER macro automatically detects the language 
	(from those in the list) of each document. To search over all supported languages, 
	specify LANGUAGE=ALL. Automatic detection is not accurate in documents that contain 
	less than 256 characters. 

	MANUAL=anything 
	Indicates that the cfs.exe process was started manually, rather than by the 
	%TMFILTER macro. Any value (for example, 1 or 'y') specifies a manual start. 
	Otherwise, if you do not specify this option or if you do not specify a value for it, 
	then the process is started automatically by the macro. 

	NORESTRICT=anything
	(For Web crawling only) specifies to allow the processing of Web sites outside the 
	domain of the starting URL. Any value (for example, 1 or 'y') lets the macro process 
	Web sites outside of the starting domain. Otherwise, if you do not specify this option 
	or if you do not specify a value for it, only Web pages that are in the same domain as 
	the starting URL are processed. 

	NUMBYTES=n 
	Specifies the length of the TEXT variable in the output data set, in bytes. If you do 
	not specify this argument, then the TEXT variable is restricted to 60 bytes. 

	PASSWORD=password 
	(For Web crawling only) specifies the password to use when the URL input refers to a 
	secured Web site that requires a password. 

	PORT=port-number 
	Specifies the number of the port on which to start the cfs.exe process. If you have 
	started the process manually, then this must be the same port number that was used 
	to start the process. If you do not specify this argument, then the process is 
	started on a random port number. 

	USERNAME=user name 
	(For Web crawling only) specifies the user name to use when the URL input refers to 
	a secured Web site that requires a user name. 

	TIME=n 
	Specifies a time, in seconds, to wait when filtering a file before timing out. 
	If you do not specify this argument, then a value of 1000 seconds is used.
