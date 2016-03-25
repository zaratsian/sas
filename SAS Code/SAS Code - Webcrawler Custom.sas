
* 	Begin by creating a list of the URLs of the Web sites where the Web crawler will start;
	data work.links_to_crawl;
	length url $256 ;
	input url $;
	datalines;
	http://www.yahoo.com
	http://www.sas.com
	http://www.google.com
	;
	run;


*	To ensure that we don’t crawl the same URL more than once, create a data set to hold the links that have been
	crawled. The data set will be empty at the start, but a Web site’s URL will be added to the data set when the Web
	Crawler completes the crawl of that site;
	data work.links_crawled;
	length url $256;
	run;


*	Start Crawling - The code takes the first URL out of our work.links_to_crawl data set. On the first
	observation ”_n_ eq 1“,the URL is put into a macro variable named next_url All remaining URLs are put back into
	our seed URL data set so they are available in the next iteration;
	%let next_url = ;
	data work.links_to_crawl;
	set work.links_to_crawl;
	if _n_ eq 1 then call symput("next_url", url);
	else output;
	run;


*	Now download the URL from the Internet. Create a filename reference called _nexturl. We let SAS know it is a URL
	and it can be found at &next_url, which is our macro variable that contains the URL we pulled from our
	work.links_to_crawl data set;
	/* crawl the url */
	filename _nexturl url "&next_url";


*	After the filename reference of the URL is established, identify a place to put the file we download. Create another
	filename reference called htmlfile and put in there the information gathered from url_file.html;
	/* put the file we crawled here */
	filename htmlfile "url_file.html";


*	Next we loop through the data, write it to the htmlfile filename reference, and search for more URLs to add to our
	work.links_to_crawl data set;
	/* find more urls */
	data work._urls(keep=url);
	length url $256 ;
	file htmlfile;
	infile _nexturl length=len;
	input text $varying2000. len;
	put text;
	start = 1;
	stop = length(text);


*	Use regular expressions to help search for URLs on a Web site. Regular expressions are a method of matching
	strings of text, such as characters, words, or patterns of characters. SAS already provides many powerful string
	functions. However, regular expressions often provide a more concise way of manipulating and matching text;
	if _n_ = 1 then do;
	retain patternID;
	pattern = '/href="([^"]+)"/i';
	patternID = prxparse(pattern);
	end;
*	On the first observation, create a patternID that will remain throughout the DATA step run. The pattern to look for is:
	“/href="([^"]+)"/i'”. This means that we are looking for the string 'href=”', then look for any string of characters that is at
	least one character long and does not contain a quotation mark (“), and ends in a quotation mark (“). The 'i' at the
	end means to use a case insensitive method to match our regular expression;


*	Now match the regular expression to the text on a Web site. PRXNEXT takes five arguments: the regular expression
	we want to find, the start position to begin looking for the regular expression, the end position to stop looking for the
	regular expression, the position of the string if it is found, and the length of the string if it is found. Position will be 0 if
	no string is found. PRXNEXT also changes the start parameter so that searching begins again after the last match is
	found;
	call prxnext(patternID, start, stop, text, position, length);


*	The code loops over text on the Web site to find all the links;
	do while (position ^= 0);
	url = substr(text, position+6, length-7);
	output;
	call prxnext(patternID, start, stop, text, position, length);
	end;
	run;


*	If the code finds a URL, it will retrieve only the part of the URL that starts after the first quotation mark. For example,
	if the code finds HREF=”http://www.new-site.com”, then it should keep http://www.new-site.com. Use substr to
	remove the first six characters and the last character before outputting the remainder of the URL to the work._urls
	data set.
	We now insert the URL that the code just crawled into a data set named work.links_crawled in order to keep track
	of where we have been and to make sure we do not navigate there again;
	/* add the current link to the list of urls we have already crawled */
	data work._old_link;
	url = "&next_url";
	run;
	proc append base=work.links_crawled data=work._old_link force;
	run;


*	Next step is to process the list of found URLs in the data set work._urls to make sure that:
		1. we have not already crawled them, in other words URL is not in work.links_crawled).
		2. we do not have URLs queued up to crawl, (in other words URL is not in work.links_to_crawl);
	/*
	* only add urls that we have not already crawled
	* or that are not queued up to be crawled
	*
	*/
	proc sql noprint;
	create table work._append as
	select url
	from work._urls
	where url not in (select url from work.links_crawled)
	and url not in (select url from work.links_to_crawl);
	quit;


*	Then we add URLs yet to be crawled and not already queued to the work.links_to_crawl data set;
	/* add new links */
	proc append base=work.links_to_crawl data=work._append force;
	run;


*At this point the code loops back to the beginning and grabs the next URL out of the work.links_to_crawl data set.
We now have a basic Web crawler! The source code to the full Web crawler can be found at
http://www.sascommunity.org/wiki/Simple_Web_Crawler_with_SAS_Macro_and_SAS_Data_Step.
