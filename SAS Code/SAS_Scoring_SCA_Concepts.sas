
/*******************************************************************************
*
*	Append this code to the end of the SAS Contextual Analysis Concept Code 
*
********************************************************************************/

data &input_ds; set &input_ds;
	document_id = _n_;
	run;

proc sql;
	create table output_scored as
	select *
	from &input_ds as a
	left join
	&output_position_ds as b
	on a.document_id = b.document_id;
	quit;

data output_scored; set output_scored;
	if start_offset ne . then
		match = substr(&document_column,start_offset+1,(end_offset-start_offset)+1);
	run;
