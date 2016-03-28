
/*******************************************************************************
*
*	Append this code to the end of the SAS Contextual Analysis Category Code 
*
********************************************************************************/

data &input_ds; set &input_ds;
	document_id = _n_;
	run;




/*******************************************************************************
*
*	Remove the 'Top/' text from the hierarchy strings 
*
********************************************************************************/


data &output_position_ds; set &output_position_ds (drop= term column_name );
	full_path = tranwrd(full_path, 'Top/' , '');
run;







/**************************************************************************************
*	
*	Concatenate offsets if length of returned offsets from last step are too long
*	Remove the dupes where the same doc maps to the same lowest level in the hierarchy
*
***************************************************************************************/



data temp_table;
    length correct_offsets $100.;
    set &output_position_ds ;
	by document_id full_path;
    retain correct_offsets;

	if first.full_path then correct_offsets=cats(start_offset, ',', end_offset);

	else correct_offsets = cats(correct_offsets,"|",cats(start_offset, ',', end_offset));
	
	if last.full_path then output;
run;







/*******************************************************************************
*
*	Create hierarchices from the extraction paths
*
********************************************************************************/


/*Find the maximum offset depth in any of the category paths and make it a macro variable*/
proc sql noprint;
	select  max(count(correct_offsets, '|')) + 1 as maximum into :max_number_of_offs
	from temp_table;
quit;



/*MOVE THE OFFSETS TO THE ARRAY FIELDS*/
data &output_position_ds (drop = ExpressionID start stop position length i level_count ); set temp_table;

	/*find the depth of the hierarchy for the current observation*/
	level_count = count(correct_offsets, '|') + 1;

	/*Set an array to create the hierarchical structure and capture the named levels*/
	array offset_number_{&max_number_of_offs} $30;

	/*set the regex and other initial variables*/
	ExpressionID = prxparse("/[0-9,]+/");
	start = 1;
	stop = length(correct_offsets);

	/*Call the regex for the first time*/
	call prxnext(ExpressionID, start, stop, correct_offsets, position, length);

	/*Extract and Iterate*/
	do i = 1 to level_count while (position > 0);
         offset_number_{i} = substr(correct_offsets, position, length);
         call prxnext(ExpressionID, start, stop, correct_offsets, position, length);		
	end;
run;


proc print data=&output_position_ds (obs=100);
run;









/*******************************************************************************
*
*	Create hierarchices from the extraction paths
*
********************************************************************************/

/*Find the maximum category depth in any of the hierarchies and make it a macro variable*/
proc sql noprint;
	select  max(count(full_path, '/')) + 1 as maximum into :max_number_of_levels
	from &output_position_ds;
quit;


data &output_position_ds (drop = ExpressionID start stop position length i level_count ); set &output_position_ds;

	/*find the depth of the hierarchy for the current observation*/
	level_count = count(full_path, '/') + 1;

	/*Set an array to create the hierarchical structure and capture the named levels*/
	array category_level_{&max_number_of_levels} $30;

	/*set the regex and other initial variables*/
	ExpressionID = prxparse("/[a-zA-Z0-9_]+/");
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
	create table output_scored as
	select *
	from &input_ds as a
	left join
	&output_position_ds as b
	on a.document_id = b.document_id;
quit;






/*******************************************************************************
*
*	Concatenate all the keyword matches into a single field
*
********************************************************************************/


data output_scored (drop= start_offset end_offset i position length begin end  keyword_:  offset_number_: );
length keywords $1000.;
set output_scored;

	array offset_number_{&max_number_of_offs} $30;
	array keyword_{&max_number_of_offs} $100;

	do i = 1 to &max_number_of_offs;
		if offset_number_[i] not in ('') then 
			do;
			call scan(offset_number_[i], 1, position, length);
			begin = substrn(offset_number_[i], position, length);

			call scan(offset_number_[i], 2, position, length);
			end = substrn(offset_number_[i], position, length) + 2;

			keyword_[i] = substrn(&document_column, begin, end - begin);
			end;
		else;
	end;

	do i = 1 to &max_number_of_offs;
		call catx(' | ', keywords, keyword_[i]);
	end;
run;








/*******************************************************************************
*
*	Add 'Unclassified' tags to the entries that didnt make it into a category
*
********************************************************************************/



%let max_number_of_levelsC = &max_number_of_levels;


data output_scored (drop= i j);
	set output_scored;
	if category_level_1 = "" then do; 
		array cat{&max_number_of_levels} $ 30 category_level_1-category_level_&max_number_of_levelsC;
			do i=1 to &max_number_of_levels;
				if cat[i] = '' then cat[i] = 'Uncategorized';
			end;
		end;
		else do;
			array cat1{&max_number_of_levels} $ 30 category_level_1-category_level_&max_number_of_levelsC;
				do j=1 to &max_number_of_levels;
					if cat1[j] = '' then cat1[j] = 'Other';
				end; 
			end;
run;



  


/********************************************************************************
*
*	View the data
*
********************************************************************************/


proc print data=output_scored (obs=100);
	var category_level_1 category_level_2 category_level_3 keywords ;
run;






/*******************************************************************************
*
*	Save the data
*
********************************************************************************/

/*libname adam 'C:\Users\adpilz\Documents\adams_sca_projects\WellsFargo_OpRisk\Data';*/
/**/
/*data adam.adpilz_op_risk_scored ;set output_scored;*/
/*run;*/
