
/*******************************************************************************
*
*	Append this code to the end of the SAS Contextual Analysis Category Code 
*
********************************************************************************/

/*Create temporary ds and an index to match index created by the score code*/
data temp_input_ds(compress=yes); set &input_ds;
	my_document_id = _n_;
run;




/*******************************************************************************
*
*	Remove the 'Top/' and accumulate the keywords 
*
********************************************************************************/

data temp_table (compress=yes drop=term start_offset end_offset); set &output_position_ds (drop= column_name name);
    length keywords $2000.;
    by document_id full_path;
    retain keywords;
	
	/*Remove the header*/
	full_path = tranwrd(full_path, 'Top/' , '');

	/*Accumulate the keywords*/
	if first.full_path then keywords = term;
		else keywords = catx(" | ", keywords, term);
	
	/*Output the data*/
	if last.full_path then output;
run;



/*******************************************************************************
*
*	Create hierarchices from the extraction paths
*
********************************************************************************/

/*Find the maximum category depth in any of the hierarchies and make it a macro variable*/
proc sql noprint;
	select  max(count(full_path, '/')) + 1 as maximum into :max_number_of_levels
	from temp_table;
quit;


data temp_table (drop = ExpressionID start stop position length i level_count compress=yes); set temp_table;

	/*find the depth of the hierarchy for the current observation*/
	level_count = count(full_path, '/') + 1;

	/*Set an array to create the hierarchical structure and capture the named levels*/
	array category_level_{&max_number_of_levels} $100;

	/*set the regex and other initial variables*/
	ExpressionID = prxparse("/[^\/]+/");
	start = 1;
	stop = length(full_path);

	/*Call the regex for the first time*/
	call prxnext(ExpressionID, start, stop, full_path, position, length);

	/*Extract and Iterate*/
	do i = 1 to level_count while (position > 0);
         category_level_{i} = substr(full_path, position, length);
         call prxnext(ExpressionID, start, stop, full_path, position, length);		
	end;
run;





/*******************************************************************************
*
*	Join the tables
*
********************************************************************************/

proc sql;
	create table output_scored (compress=yes drop=my_document_id full_path) as
	select *
	from temp_input_ds as a
	left join
	temp_table as b
	on a.my_document_id = b.document_id;
quit;

/*Cleanup*/
proc delete data=temp_input_ds; run;
proc delete data=temp_table; run;



/*******************************************************************************
*
*	Add 'Unclassified' tags to the entries that didnt make it into a category
*
********************************************************************************/

%let max_number_of_levelsC = &max_number_of_levels;

data output_scored (drop= i j compress=yes);
	set output_scored;
	if category_level_1 = "" then do; 
		array cat{&max_number_of_levels} $ 100 category_level_1-category_level_&max_number_of_levelsC;
			do i=1 to &max_number_of_levels;
				if cat[i] = '' then cat[i] = 'Uncategorized';
			end;
		end;
		else do;
			array cat1{&max_number_of_levels} $ 100 category_level_1-category_level_&max_number_of_levelsC;
				do j=1 to &max_number_of_levels;
					if cat1[j] = '' then cat1[j] = 'Other';
				end; 
			end;
run;




/********************************************************************************
*
*	View and save the data
*
********************************************************************************/
proc print data=output_scored (obs=100);
	var &document_column category_level_: keywords ;
run;



/*******************************************************************************
*
*	Save the data
*
********************************************************************************/

/*libname dat 'C:\Data';*/
/*data dat.your_output_ds ;set output_scored;*/
/*run;*/
