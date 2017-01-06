#!/usr/bin/env bash
#
# ./run_log_queries.sh &> run_log_queries_output.txt

xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN

[log_query_rules].
[log_queries].
[extractfacts].
[modelfacts].
[reconfacts].

printall('lq0(record_id) - Which records are finally ACCEPTED after both steps of scientific name cleaning and event date cleaning?', lq0(_)).

printall('lq1(CorrectionsCount) - How many records required corrections?', lq1(_)).

printall('lq2(NoncorrectedCount) - How many contained problematic values that could not be corrected?', lq2(_)).

printall('lq3(record_id) - Which records were as good as original after checking?', lq3(_)).

printall('lq4(record_id) - Which records are all the fields that were updated (or determined to be irreparable in any record of the input data set?)' , lq4(_)).

printall('lq5(new_value) - For a particular field (eg., scientificName) what are unique values for which corrections were proposed?', lq5(_)).

printall('lq6(CorrectedSNCount) - … and the count of each across all records?', lq6(_)).

printall('lq7(record_id) - What are all the records that still have problematic values in a particular field and require further attention?', lq7(_)).

printall('lq8(field_name, check_type, source_used, match_method) - What standards, data sources, or validation services were used to judge the validity of values in a particular field or that provided new values for it?', lq8(_,_,_,_)).

printall('lq9(record_id, intermediate_value) - Which records have been updated multiple times in a script and what were those intermediate values?', lq9(_,_)).

END_XSB_STDIN












