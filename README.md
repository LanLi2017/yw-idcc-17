# yw-idcc-17
Examples of YW provenance queries highlighted in the IDCC'17 presentation, paper, and demo.

# Introduction

The purpose of this demo is to demonstrate the `Yesworkflow` (YW) query ability to use the **prospective provenance** created by YW, the **retrospective provenance** and **hybrid provenance** together to answer queries that can not be answered solely by prospective provenance or retrospective provenance.

The prospective provenance in this demo is created by YW which models conventional scripts and programs as scientific workflows. YW can provide a number of the benefits of using a scientific workflow management system without having to rewrite scripts and other scientific software. A YW user simply adds special YW comments to existing scripts. These comments declare how data is used and results produced, step by step, by the script. Then, YW interprets these comments and produces graphical output that reveals the stages of computation and the flow of data in the script.

There are various approaches to capture retrospective provenance. Retrospective provenance observables, e.g., from `DataONE RunManagers` (file-level), `ReproZip` (OS-level), or `noWorkflow` (Python code-level) only yield isolated fragments of the overall data lineage and processing history. In this demo, two types of retrospective provenance observables are used: `yw-recon` and `DataONE RunManager`. The `yw-recon` can search the file system for files that match the URI templates declared for @IN and @OUT ports in the script. On the other hand, `DataONE RunManager` can record a list of input and output files for a script run. 

The  following tools are used  in our demo project:
  *  [YesWorkflow](https://github.com/yesworkflow-org/yw-prototypes)
  *  [noWorkflow](https://github.com/gems-uff/noworkflow)
  *  [yw-recon](https://github.com/yesworkflow-org/yw-tapp-15-recon)  
  *  [yw-matlab bridge](https://github.com/yesworkflow-org/yw-matlab)
  *  [DataONE recordr R package](https://github.com/NCEAS/recordr)
  *  [DataONE Matlab Toolbox](https://github.com/DataONEorg/matlab-dataone)
  
Our system demonstration will illustrate the variety of provenance information that we are able to capture, query, and visualize using a
combination of tools for exposing both prospective and retrospective provenance. We show how prospective provenance can be declared using YesWorkflow (YW) annotations that reveal
the fine-grained (variable level) dataflow graph implicit in scripts, and how this prospective provenance can be integrated with the coarse-grained (file-level) retrospective provenance
information recorded by the DataONE Run Managers for MATLAB and R, fine-grained retrospective provenance captured by noWorkflow, user-exported log file at any fine-grained level. We demonstrate the usefulness of integrating prospective and retrospective provenance in this way with queries:

1. **Prospective provenance queries in the context of a single script**. This can expose and test data dependencies at the workflow-level.

2. **Retrospective provenance queries in the context of a single run of a single script**: captures actual input and output files of a script run and other runtime observables.

3. **Hybrid provenance query in the context of a single script and single run**: blends retrospective and prospective provenance, yielding new knowledge artefacts.

4. **Provenance query in the context of multiple scripts and multiple runs**: query and visualize data dependencies across multiple script runs

Our demonstration queries and provenance reports thus yield a more complete and comprehensible picture of data provenance from multiple script runs.

# Layouts of Repository

| Directory | Description                                                          |
|-----------| :--------------------------------------------------------------------|
|examples/ |   Contains examples demonstrating the queries in the queries folder |
|queries/ | it stores the scripts to the nine demo queries we asked.|
|rules/| it contains a set of Prolog rules for generating prospective yesworkflow views rules (`yw_rules.P` and `yw_views.P`), retrospective reconstructed rules (`recon_rules.P`), graph rendering rules (`gv_rules.P`), and populating graph rules (`yw_graph_rules.P`).|
|OHIBC_Howe_Sound_project/| A R workflow project `OHIBC_HOWE_Sound` that is a real-life use case and consists of multiple R scripts.|
|docker/| Contains a docker image that can help users to reproduce the demonstrated provenance queries.|
|yw_jar/| Contains two version YesWorkflow Java library.|
|poster_template/| Contains the poster and other publications.|
|SQLiteToYaml/| Contains Java program is used to convert Sqlite database into yaml file to be queried by YesWorkflow.|

The example subfolders also have a typical folder structure:

`yw-idcc-17/examples/<my_example>/` 

Subfolders that all `<my_example>` folders have:

| Directory | Description                                                          |
|-----------| :--------------------------------------------------------------------|
| script/ | the example script or scripts that make up  \<my_example\> |
| facts/ | the YW facts for \<my_example\>, generated by running YW on the example script(s)|
| views/ | materialized views for \<my_example\>|
| recon/ | reconstructed provenance used for \<my_example\>|
| results/ | all artifacts generated by make.sh|
|supplementary/ | a folder with supplementary files and information about the example|
| clean.sh | removes generated demo artifacts for \<my_example\> |
| make.sh | creates demo artifacts for \<my_example\> |
Please 
Note: after running `clean.sh` and `make.sh`, you can use git status to see what demo artifacts have just been created.

```
simulate_data_collection/
├── clean.sh
├── facts
│   ├── yw_extract_facts.P
│   └── yw_model_facts.P
├── make.sh
├── results
├── script
│   ├── calibration.img
│   ├── cassette_q55_spreadsheet.csv
│   └── simulate_data_collection.py
└── views
    └── yw_views.P
 ```
 
# Installing, Browsing, and Running the Demo

## Installing Instructions

The bash scritps have been tested on Mac and Windows platform.

1. The following free software are required in order to run  this demo.

  * **Java**: please install Java SE Development Kit 8 by navigating to http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html  to view JDK dowloads. Accept all default installation configuration. Please confirm if Java is available by typing the command below. If not, please locate the directory containing the JDK executables (`C:\Program Files\Java\jdk1.8.0_121\bin`) and add the direcoty containing the JDK executables to my Windows `path` variable. 
  
	```sh
	   C:\Users\tmcphill> java -version 
	   java version "1.8.0_121" 
	   Java(TM) SE Runtime Environment (build 1.8.0_121-b13) 
	   Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode) 
 
	   C:\Users\tmcphill>
     ``` 	 
  * **XSB**: a Logic Programming and Deductive Database system for Unix and Windows ([XSB homepage]
  (http://xsb.sourceforge.net)). The download and installation page for XSB is at [here] (http://xsb.sourceforge.net/downloads/downloads.html) or please navigate to the page https://sourceforge.net/projects/xsb/files/xsb/. The version 3.7 is the newest version. Download the XSB executable `xsb-3.7.0.exe` for Windows platform. Run the downloaded installer file and accept all default configuration.
   This is the extra steps for Windows users. Please determine the directory containing the XSB executable: 
   
    ```sh
      C:\Program Files (x86)\XSB\config\x64-pc-windows\bin  
      C:\Program Files (x86)\XSB\config\x86-pc-windows\bin 
    ``` 
  Then, add the path to the XSB executable to my windows path variable `Control Panel -> System and Security -> System -> Advanced System Settings -> Environment Variables -> Path`. Typing `xsb` in a command console in order to confirm that XSB can run from the command prompt.   
 
    ```sh
	 C:\Users\tmcphill> xsb 
	 [xsb_configuration loaded] 
	 [sysinitrc loaded] 
	 [xsbbrat loaded] 
 
	 XSB Version 3.6. (Gazpatcho) of April 22, 2015 
	 [x64-pc-windows; mode: optimal; engine: slg-wam; scheduling: local] 
	 [Build date: 2015-04-22] 
 
	 | ?- halt. 
 
	 End XSB (cputime 0.05 secs, elapsetime 4.22 secs)
   ```
  * **Graphviz**: a Graph Visuzlization Software for Unix and Windows.  It is available at [Graphviz homepage](http://www.graphviz.org). The download and installation page for Graphviz is at  [here](http://www.graphviz.org/Download.php). For Windows platform, please download `graphviz-2.38.msi` installer package and start the installer file. You might accept all default configurations. Please confirm if the `dot` command is available by typing the command below. If not, then first determined directory containing dot.exe binary (`C:\Program Files (x86)\Graphviz2.38\bin`) and added the directory containing the dot executable to my Windows PATH variable.
 
    ```sh
     C:\Users\tmcphill> dot
       'dot' is not recognized as an internal or external command,
        operable program or batch file. 
    ```
 
 * **SQLite**:  a high-reliability, embedded, zero-configuration, public-domain, SQL database engine.  It is availabe at [SQLite homepage](https://www.sqlite.org). 
 
2. **Install Git for Windows**: please download `Git` for Windows from https://git-for-windows.github.io/. Run the downloaded `Git-2.11.1-64-bit.exe` and accept default configuration. Then, finish installation. Please check the `git` command in the command shell by: 
  
   ```sh
     C:\Users\tmcphill> git --version 
     git version 2.11.1.windows.1
   ```	   
   You might add the `path to bash executable` included with "Git for Windows" (`C:\Program Files\Git\bin`) to my Windows `path` variable so that the bash script can run on the command prompt directly.
   
3. Clone the `yw-idcc-17` git repo to your local machine using the command
   
   ```sh
   git clone https://github.com/yesworkflow-org/yw-idcc-17.git
   ```
   
4. Run the demo from the command shell. For Windows users, you can either run from `Git shell` which contains the `bash` command or run from the command prompt directly.

## Running the Demo 
1. Go to the examples/ folder. There are two types of examples demonstrated. One is single script implemented in various programming languages and the other is a R workflow project. We have provided four examples here:  
   * **Type I**: Single script in various programming languages: a MATLAB example (`C3C4/`) and four Python examples (`LIGO/`, `Twitter/`, `simulate_data_collection/` and `kurator-SPNHC16-YW-xsb/`).
   * **Type II**: A real-life R workflow project `OHIBC_HOWE_Sound_project/`.
   
2. Go to  one of the above example. First, run the cleaning script by calling `bash clean.sh` or `./clean.sh`

3. Run the demo example by calling `bash make.sh` or `./make.sh`.

4. Go to `results/` folder and check the generated provenance query result. For Mac users, you might use `open` command to access the PDF files, while for Windows users, you might use `start` command to access the PDF files.
    
## Developing your own Demo
1. Copy your example folder under examples/ folder. 

2. Reorganize your directory layout for your example to be the same as `C3C4`, `LIGO`, and `simulate_data_collection`. Create a `recon/` folder which contains your `reconfacts.P`.

3. Copy two script files `clean.sh` and `make.sh` from the `simulate_data_collection` of the existing three examples to your own example folder. 

4. Open `make.sh` and customize the scripting name, outputfile name, parameter data object name to your example.

5. Run `bash make.sh`.
    

# Demo Queries

Please read [Query README](https://github.com/idaks/dataone-ahm-2016-poster/blob/master/queries/README.md) in the demo repo.

# How to run the Demo using Docker

We have created a Docker image (`yesworkflow/provenance-demo`) to help readers to explore the YesWorkflow demonstrated provenance queries. In the `yesworkflow/provenance-demo` image, the XSB, Graphivz, YesWorkflow, noWorkflow, dataone demo queries are installed. Users can boot up a Docker container to run the demo provenance queries using this image within seconds, without the need to manually install packages. 

## Installing Docker

Here are instructions for each OS: 
  * [Mac OS](https://docs.docker.com/engine/installation/mac/)
  * [Linux](https://docs.docker.com/engine/installation/linux/ubuntulinux/)
  * [Windows](https://docs.docker.com/engine/installation/windows/)
  
As part of this installation process, you’ll need to use a shell prompt. There’s a special version of the shell that comes pre-configured for using Docker commands. Users need to use the above shell prompt in order to run a Docker command or type a specific Docker command. Here is how to open it:

  * Mac OS – launch the `Docker Quickstart Terminal` application from Launchpad. 
  * Linux – launch any bash shell prompt, and `docker` will already be available.
  * Windows – click the `Docker Quickstart Terminal` icon on your desktop. 

## Downloading Docker image

Users can use the following command to download the image from Docker Hub which is similar to GitHub. The command syntax is `docker pull IMAGE_NAME`. The name of our current provenance query image is yesworkflow/provenance-demo. Users can type the following command into a shell prompt.

`docker pull yesworkflow/provenance-demo` 

This will download the image from `Docker Hub` for Docker images.

## Running a container from a Docker image

Once downloaded the image, users can run it using the command `docker run`. Executing `docker run` will create a Docker container which is isolated from the user's local computer. Here are some configuration options for `docker run`.

  * `-i`: interactive session
  * `-t`: TTY
  * `-v H:C`: mount the host path on your computer `H` at the path `C` inside the Docker container. 
  
The full command to run the provenance query looks like:
  
  `docker run -it -v $HOME:$HOME yesworkflow/provenance-demo`  
  
Then, users can go to ... to check the query results.


## Publications
1. Q Zhang, Y Cao, Q Wang, D Vu, P Thavasimani, T McPhillips, P Missier, B Ludäscher. Revealing the Detailed Lineage of Script Outputs Using Hybrid Provenance. IDCC 2017 (Practice Paper track).
2. Y Cao, P Slaughter, C Jones, MB Jones, Q Wang, D Vu, P Thavasimani, Q Zhang, T McPhillips, P Missier, L Walker, D Vieglais, B Ludäscher. Demonstrating Hybrid Provenance Queries from Script Runs. IDCC 2017 (Demo).

## DataSet Citation
1. BS Halpern, C Longo, D Hardy, KL McLeod, JF Samhouri, SK Katona, et al. (2012) An index to assess the health and benefits of the global ocean. Nature. 2012;488: 615–620. doi:10.1038/nature11397.
2. Y Wei, S Liu, D Huntzinger, A Michalak, N Viovy, W Post, C Schwalm, K Schaefer, A Jacobson, C Lu, H Tian, D Ricciuto, R Cook, J Mao, X Shi. (2014) NACP MsTMIP: Global and North American Driver Data for Multi-Model Intercomparison. http://dx.doi.org/10.3334/ORNLDAAC/1220
3. LIGO Open Science Center: Signal Processing with GW150914 Open Data. https://losc.ligo.org/events/GW150914/



