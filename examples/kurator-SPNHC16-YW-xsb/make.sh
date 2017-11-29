#!/usr/bin/env bash

# set variables
source ../settings.sh

# create output directories
mkdir -p $FACTS_DIR
mkdir -p $RECON_DIR
mkdir -p $VIEWS_DIR
mkdir -p $RESULTS_DIR
mkdir -p $RUN_DIR

# export YW model and extract facts, and draw complete workflow graph with URI template
$YW_CMD graph
dot -Tpdf $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri.svg

# generate subgraphs for subworkflows
$YW_CMD graph $SCRIPT_DIR/clean_name_date_yw.py -c graph.subworkflow=clean_name_and_date_workflow.clean_scientific_name -c graph.dotfile=$RESULTS_DIR/subgraph_name_val.gv
dot -Tpdf $RESULTS_DIR/subgraph_name_val.gv > $RESULTS_DIR/subgraph_name_val.svg
$YW_CMD graph $SCRIPT_DIR/clean_name_date_yw.py -c graph.subworkflow=clean_name_and_date_workflow.clean_event_date -c graph.dotfile=$RESULTS_DIR/subgraph_date_val.gv
dot -Tpdf $RESULTS_DIR/subgraph_date_val.gv > $RESULTS_DIR/subgraph_date_val.svg

# materialize views of YW facts
$QUERIES_DIR/materialize_yw_views.sh > $VIEWS_DIR/yw_views.P

# draw complete workflow graph (without URI template)
$QUERIES_DIR/render_complete_wf_graph.sh > $RESULTS_DIR/complete_wf_graph.gv
dot -Tpdf $RESULTS_DIR/complete_wf_graph.gv > $RESULTS_DIR/complete_wf_graph.svg

# list workflow outputs
$QUERIES_DIR/list_workflow_outputs.sh > $RESULTS_DIR/workflow_outputs.txt

# run the python script
python $SCRIPT_DIR/clean_name_date_yw.py &> $RUN_DIR/runlog.log 2>&1

# save pure Python script without YW markup
grep -v "@" $SCRIPT_DIR/clean_name_date_yw.py | grep -v "\"\"\"" > $SCRIPT_DIR/clean_name_date.py 

# generate reconfacts.P to facts/ folder 
$YW_CMD recon
# copy recon/reconfacts.P into fact folder
cp -f $RECON_DIR/reconfacts.P $FACTS_DIR



##############
#   Q1_pro   #
##############

# draw worfklow graph upstream of data_with_cleaned_names_and_dates
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh data_with_cleaned_names_and_dates > $RESULTS_DIR/wf_upstream_of_data_with_cleaned_names_and_dates.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_data_with_cleaned_names_and_dates.gv > $RESULTS_DIR/wf_upstream_of_data_with_cleaned_names_and_dates.svg

# draw worfklow graph upstream of date_cleaning_log
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'date_cleaning_log\' > $RESULTS_DIR/wf_upstream_of_date_cleaning_log.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_date_cleaning_log.gv > $RESULTS_DIR/wf_upstream_of_date_cleaning_log.svg

# draw worfklow graph upstream of name_cleaning_log
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'name_cleaning_log\' > $RESULTS_DIR/wf_upstream_of_name_cleaning_log.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_name_cleaning_log.gv > $RESULTS_DIR/wf_upstream_of_name_cleaning_log.svg

# draw worfklow graph upstream of record_id_data
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'record_id_data\' > $RESULTS_DIR/wf_upstream_of_record_id_data.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_record_id_data.gv > $RESULTS_DIR/wf_upstream_of_record_id_data.svg

# draw worfklow graph upstream of data_with_cleaned_names
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'data_with_cleaned_names\' > $RESULTS_DIR/wf_upstream_of_data_with_cleaned_names.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_data_with_cleaned_names.gv > $RESULTS_DIR/wf_upstream_of_data_with_cleaned_names.svg

# draw worfklow graph upstream of original_dataset
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'original_dataset\' > $RESULTS_DIR/wf_upstream_of_original_dataset.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_original_dataset.gv > $RESULTS_DIR/wf_upstream_of_original_dataset.svg


############## 
#   Q2_pro   #
##############

# list script inputs upstream of output data data_with_cleaned_names_and_dates
$QUERIES_DIR/list_inputs_upstream_of_data_q2.sh data_with_cleaned_names_and_dates data_with_cleaned_names_and_dates > $RESULTS_DIR/inputs_upstream_of_data_with_cleaned_names_and_dates.txt

# list script inputs upstream of output data date_cleaning_log
$QUERIES_DIR/list_inputs_upstream_of_data_q2.sh \'date_cleaning_log\' date_cleaning_log > $RESULTS_DIR/inputs_upstream_of_date_cleaning_log.txt

# list script inputs upstream of output data name_cleaning_log
$QUERIES_DIR/list_inputs_upstream_of_data_q2.sh name_cleaning_log name_cleaning_log > $RESULTS_DIR/inputs_upstream_of_name_cleaning_log.txt


##############
#   Q3_pro   #
##############

# draw worfklow graph downstream of original_dataset
$QUERIES_DIR/render_wf_graph_downstream_of_data_q3.sh \'original_dataset\' > $RESULTS_DIR/wf_downstream_of_original_dataset.gv
dot -Tpdf $RESULTS_DIR/wf_downstream_of_original_dataset.gv > $RESULTS_DIR/wf_downstream_of_original_dataset.svg

# draw worfklow graph downstream of local_authority_source
$QUERIES_DIR/render_wf_graph_downstream_of_data_q3.sh \'local_authority_source\' > $RESULTS_DIR/wf_downstream_of_local_authority_source.gv
dot -Tpdf $RESULTS_DIR/wf_downstream_of_local_authority_source.gv > $RESULTS_DIR/wf_downstream_of_local_authority_source.svg

# draw worfklow graph downstream of data_with_cleaned_names
$QUERIES_DIR/render_wf_graph_downstream_of_data_q3.sh data_with_cleaned_names > $RESULTS_DIR/wf_downstream_of_data_with_cleaned_names.gv
dot -Tpdf $RESULTS_DIR/wf_downstream_of_data_with_cleaned_names.gv > $RESULTS_DIR/wf_downstream_of_data_with_cleaned_names.svg

# draw worfklow graph downstream of data_with_cleaned_names_and_dates
$QUERIES_DIR/render_wf_graph_downstream_of_data_q3.sh data_with_cleaned_names_and_dates > $RESULTS_DIR/wf_downstream_of_data_with_cleaned_names_and_dates.gv
dot -Tpdf $RESULTS_DIR/wf_downstream_of_data_with_cleaned_names_and_dates.gv > $RESULTS_DIR/wf_downstream_of_data_with_cleaned_names_and_dates.svg


##############
#   Q4_pro   #
##############

# list script outputs downstream of input data original_dataset
$QUERIES_DIR/list_outputs_downstream_of_data_q4.sh \'original_dataset\' original_dataset > $RESULTS_DIR/outputs_downstream_of_original_dataset.txt

# list script outputs downstream of input data local_authority_source
$QUERIES_DIR/list_outputs_downstream_of_data_q4.sh \'local_authority_source\' local_authority_source > $RESULTS_DIR/outputs_downstream_of_local_authority_source.txt

# list script outputs downstream of input data data_with_cleaned_names
$QUERIES_DIR/list_outputs_downstream_of_data_q4.sh data_with_cleaned_names data_with_cleaned_names > $RESULTS_DIR/outputs_downstream_of_data_with_cleaned_names.txt


##############
#   Q5_pro   #
##############

# draw recon worfklow graph upstream of data_with_cleaned_names_and_dates
$QUERIES_DIR/render_wf_recon_graph_upstream_of_data_q5.sh data_with_cleaned_names_and_dates > $RESULTS_DIR/wf_recon_upstream_of_data_with_cleaned_names_and_dates.gv
dot -Tpdf $RESULTS_DIR/wf_recon_upstream_of_data_with_cleaned_names_and_dates.gv > $RESULTS_DIR/wf_recon_upstream_of_data_with_cleaned_names_and_dates.svg

# draw recon worfklow graph upstream of name_cleaning_log
$QUERIES_DIR/render_wf_recon_graph_upstream_of_data_q5.sh name_cleaning_log > $RESULTS_DIR/wf_recon_upstream_of_name_cleaning_log.gv
dot -Tpdf $RESULTS_DIR/wf_recon_upstream_of_name_cleaning_log.gv > $RESULTS_DIR/wf_recon_upstream_of_name_cleaning_log.svg


##############
#   Q6_pro   #
##############


# draw recon workflow graph with all observables
$QUERIES_DIR/render_recon_complete_wf_graph_q6.sh > $RESULTS_DIR/wf_recon_complete_graph_all_observables.gv
dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_all_observables.gv > $RESULTS_DIR/wf_recon_complete_graph_all_observables.svg
