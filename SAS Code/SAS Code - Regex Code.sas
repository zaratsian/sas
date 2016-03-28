



data test2; set test2;
	group_name = prxchange('s/ [0-9]+ .+/ /', -1, table2);
	if prxmatch('/[0-9]+[ ]+hr[ ]+NTC/',group_name) > 0 then group_name = substr(group_name,3,length(group_name));
	run;







data test2; set test2;
   	pattern = prxparse('/[0-9]+\.[0-9]+[ ]+(mg|ml|kg)\/(mg|ml|kg)/');
   		start = 1;
   		stop = length(table2);

		call prxnext(pattern, start, stop, table2, position, length);
		
		if position > 0 then do;
         		group_dose = substr(table2, position, length);
         		put group_dose= position= length=;
         		call prxnext(pattern, start, stop, table2, position, length);
		 		output;
		end;
		else do;
			group_dose=''; output;
		end;
	drop pattern start stop position length;
	run;





	data out&j; set out&j;
   		pattern = prxparse('/(GSK|GI|GR|GF|SQ|SB|SKF|BRL|GW)[\- ]{0,2}[0-9]+[A-Z]{0,3}/');
   		start = 1;
   		stop = length(text);

		call prxnext(pattern, start, stop, text, position, length);
		if position > 0 then do;
      		do while (position > 0);
         		gsk_compound = substr(text, position, length);
         		put gsk_compound= position= length=;
         		call prxnext(pattern, start, stop, text, position, length);
		 		output;
      		end;
		end;
		else do;
			gsk_compound=''; output;
		end;
	drop pattern start stop position length;
	run;









data test2; set test2;
	group_dose = prxchange('s/[0-9]+\.[0-9]{2}/ /', -1, group_dose);
	run;
