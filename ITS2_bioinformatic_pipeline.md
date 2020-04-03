# ITS2 Sequencing Bioinformatic pipeline

Original: 20200325 E.L. Strand
Last Revised: 20200325 E.L. Strand

Contents
- [**Background_Information**](#Background_Information)
- [**SymPortal_Setup**](#SymPortal_Setup)
- [**Downloading_Data**](#Downloading_Data)
- [**Running_analysis**](#Running_analysis)


#### <a name="Background_Information"></a> **Background_Information**

The coral holobiont, which consists of the coral host, endosymbionts (Symbiodiniaceae), and the microbiome, works as a three-part symbiotic relationship in response to environmental stress. This project investigated how Symbiodiniaceae assemblage and community structure change over acute and chronic thermal and/or pCO2 stress, ambient condition recovery, and recurrent thermal stress time points.

After extracting DNA from coral tissue and isolating the Internal Transcribed Spacer 2 (ITS2), a region of ribosomal DNA, we can compare these sequences to a known database to genetically identify samples.

Resources:
- Internal Transcribed Spacer 2 (ITS2) is a region of ribosomal DNA: [Universal DNA Barcode](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2948509/)
- DNA Barcoding Explained: [International Barcode of Life](https://ibol.org/about/dna-barcoding/), [Barcoding 101](https://dnabarcoding101.org/lab/)

Putnam lab protocols used:
- [DNA Extraction](https://emmastrand.github.io/EmmaStrand_Notebook/Zymo-Duet-RNA-DNA-Extraction-Protocol/)
- [ITS2 Polymerase Chain Reaction (PCR)](https://emmastrand.github.io/EmmaStrand_Notebook/ITS2-Sequencing-Protocol/)
- [DNA quantity check: Qubit](https://emmastrand.github.io/EmmaStrand_Notebook/Qubit-Protocol/)
- [DNA quality check: Gel Electrophoresis](https://emmastrand.github.io/EmmaStrand_Notebook/Gel-Electrophoresis-Protocol/)

Next Generation Sequencing (NGS) Data Analysis Resources:
- [SymPortal: A novel analytical framework and platform for coral algal symbiont next‐generation sequencing ITS2 profiling; Hume et al 2019](https://onlinelibrary.wiley.com/doi/pdf/10.1111/1755-0998.13004)
- [SymPortal Webpage](https://symportal.org/)
- [Next Generation Sequencing vs Sangar Sequencing](https://www.illumina.com/science/technology/next-generation-sequencing/ngs-vs-sanger-sequencing.html)

NGS ITS2 datasets can be run remotely or locally by submitting to SymPortal online and with the following protocol, respectively. See Hume et al 2019 above for pros/cons to both approaches.

The below analysis was completed on a KITT server and using a macOS Catalina 10.15.4.

#### <a name="SymPortal_Setup"></a> **SymPortal_Setup**

Based on instructions from [Benjamin C.C. Hume's SymPortal_framework github repository](https://github.com/didillysquat/SymPortal_framework/wiki/SymPortal-setup).

1. Git clone the SymPortal repository to obtain a copy of the code. See [Github's webpage](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository) to set up Github prior to this protocol.

```
$ git clone https://github.com/didillysquat/SymPortal_framework.git
```

2. Rename the file settings_blank.py to settings.py.

```
$ mv settings_blank.py settings.py
```
3. Create a new secret key using [Django Secret Key]() and insert that key in `SECRET_KEY = ''` within the settings.py file.

```
$ nano settings.py

Scroll to the bottom of the file and change SECRET_KEY = '' to reflect your key (SECRET_KEY = 'XXX', where XXX is your new key).

Click Control-X to exit out of nano viewer, Click Y to save changes, and Enter to save under the same file name.
```

4. Edit the username and user email in the `sp_config.py` file. This will become log in details for DataSet and DataAnalysis objects in Sym_Portal.

```
$ nano sp_config.py

change user_name = "undefined" to your preferred username.
change user_email = "undefined" to your preferred email address.

Click Control-X to exit out of nano viewer, Click Y to save changes, and Enter to save under the same file name.
```

5. Set up a new [Conda](https://conda.io/en/latest/) environment. Conda allows for easy searching and installing of packages for any language. [Installing Conda for new users](https://conda.io/projects/conda/en/latest/user-guide/install/index.html).

```
Updating Conda
$ conda update conda
Click y when asked to proceed or not.

$ conda info
Output:

     active environment : symportal_python2
    active env location : /home/estrand/miniconda3/envs/symportal_python2
            shell level : 2
       user config file : /home/estrand/.condarc
 populated config files : /home/estrand/.condarc
          conda version : 4.8.3
    conda-build version : not installed
         python version : 3.7.6.final.0
       virtual packages : __cuda=9.1
                          __glibc=2.17
       base environment : /home/estrand/miniconda3  (writable)
           channel URLs : https://conda.anaconda.org/conda-forge/linux-64
                          https://conda.anaconda.org/conda-forge/noarch
                          https://conda.anaconda.org/bioconda/linux-64
                          https://conda.anaconda.org/bioconda/noarch
                          https://repo.anaconda.com/pkgs/main/linux-64
                          https://repo.anaconda.com/pkgs/main/noarch
                          https://repo.anaconda.com/pkgs/r/linux-64
                          https://repo.anaconda.com/pkgs/r/noarch
                          https://conda.anaconda.org/r/linux-64
                          https://conda.anaconda.org/r/noarch
          package cache : /home/estrand/miniconda3/pkgs
                          /home/estrand/.conda/pkgs
       envs directories : /home/estrand/miniconda3/envs
                          /home/estrand/.conda/envs
               platform : linux-64
             user-agent : conda/4.8.3 requests/2.23.0 CPython/3.7.6 Linux/3.10.0-693.21.1.el7.x86_64 rhel/7.4 glibc/2.17
                UID:GID : 1024:1027
             netrc file : None
           offline mode : False

Creating a new Conda environment
$ conda create -n symportal_python python=3.6
Click y when asked to proceed or not.

Activate the new Conda environment
$ conda activate symportal_python

Install the remaining packages.
(symportal_python) $ python3 -m pip install numpy==1.16.2
(symportal_python) $ python3 -m pip install -r requirements.txt

Sym_Portal recommends using pip install instead of the conda install command because some packages are not available in anacoda repository. See SymPortal_setup link above for further details.
```
6. Create a database with empty tables to house the SymPortal's reference sequences. The default is a [SQLite](https://www.sqlite.org/index.html) database. The command migrate will take the tables defined in the [Djano app](https://www.djangoproject.com/) `dbApp/models.py` using the `manage.py` file.

```
$ python3.6 manage.py migrate

Output:
Operations to perform:
  Apply all migrations: dbApp
Running migrations:
  Applying dbApp.0001_initial... OK

Output will be the file db.sqlite3. This is a SQL database with empty tables.
```

7. Fill in the SQL database with SymPortal's reference sequences. See [SymPortal_Setup](https://github.com/didillysquat/SymPortal_framework/wiki/SymPortal-setup) for details on data standardization across reference sequences. All named sequences in the current SymPortal database are in `refSeqDB.fa`.

```
$ python3.6 populate_db_ref_seqs.py
```

8. Download and test the following programs: [mothur version 1.39.5](https://bioconda.github.io/recipes/mothur/README.html), [BLAST+ executables: blastn; makeblastdb](https://bioconda.github.io/recipes/blast/README.html), [IQtree](https://bioconda.github.io/recipes/iqtree/README.html), and [mafft](https://bioconda.github.io/recipes/mafft/README.html).

```
$ conda install mothur
Click y when asked to proceed or not.

Testing program dependencies to make sure each is in the `PATH` variable.
$ which mothur
Output: ~/miniconda3/envs/symportal_python/bin/mothur.

Check program version number.
$ mothur -v
Output:
Linux 64Bit Version
Mothur version=1.39.5
Release Date=3/20/2017

$ conda install blast
Click y when asked to proceed or not.

$ which blastn
Output: ~/miniconda3/envs/symportal_python/bin/blastn

$ blastn -version
Output:
blastn: 2.9.0+
 Package: blast 2.9.0, build Sep 28 2019 00:38:34

$ which makeblastdb
Output: ~/miniconda3/envs/symportal_python/bin/makeblastdb

$ makeblastdb -version
Output:
makeblastdb: 2.9.0+
 Package: blast 2.9.0, build Sep 28 2019 00:38:34

$ conda install iqtree
Click y when asked to proceed or not.

$ which iqtree
output: ~/miniconda3/envs/symportal_python/bin/iqtree

$ iqtree -version
Output:
IQ-TREE multicore version 1.6.12 for Linux 64-bit built Mar 16 2020
Developed by Bui Quang Minh, Nguyen Lam Tung, Olga Chernomor,
Heiko Schmidt, Dominik Schrempf, Michael Woodhams.

$ conda install mafft
Click y when asked to proceed or not.

$ which mafft
Output: ~/miniconda3/envs/symportal_python/bin/mafft

$ mafft --version
Output: v7.455 (2019/Dec/7)
```

9. Confirm that all installations are correct by running the test.py module within SymPortal (takes ~30 minutes to run).

```
$ python3 -m tests.tests
End of output:

ANALYSIS COMPLETE: DataAnalysis:
 name: testing
 UID: 1

DataSet analysis_complete_time_stamp: 2020-03-30_15-49-08.079263

Cleaning up after previous data analysis test: 1
Deleting /home/estrand/ITS2/SymPortal_framework/outputs/analyses/1
Cleaning up after previous data loading test: 1
Deleting /home/estrand/ITS2/SymPortal_framework/outputs/loaded_data_sets/1
```

Troubleshooting:

```
Error:
mothur: error while loading shared libraries: libreadline.so.7: cannot open shared object file: No such file or directory

Solution: Installing readline version 7.0
$ conda install readline=7.0
```

#### <a name="Downloading_Data"></a> **Downloading_Data**
Based on instructions from [Benjamin C.C. Hume's SymPortal_framework github repository: Running SymPortal](https://github.com/didillysquat/SymPortal_framework/wiki/Running-SymPortal) but using a small subset of own data for testing.

1. Creating a blank database worksheet. Download the template from Hume's example dataset: [here](https://drive.google.com/file/d/1TNVreqCdqkoFNtCXVtmg8BgxWa4fclEY/view). See the pre-filled example spreadsheet [here](https://drive.google.com/drive/folders/1qOZy7jb3leU_y4MtXFXxy-j1vOr1U-86).

Add the desired columns to the right of the 'sampling_info' section. Here we added 'Treatment', 'Tank', and 'Timepoint'. Datasheet must be filled in with coral ID information prior to uploading to KITT server and loading to the SymPortal database.

```
Uploading datasheet to KITT server. Run this command in a new terminal window outside of KITT.

$ scp -P XXXX ~/MyProjects/Acclim_Dynamics/ITS2_subset.xlsx XXXX@kitt.uri.edu:/home/estrand/ITS2/Few_ITS2/
$ scp -P XXXX ~/MyProjects/Acclim_Dynamics/ITS2_Full.xlsx XXXX@kitt.uri.edu:/home/estrand/ITS2/FULL_ITS2/

XXXX indicates personal password and user information for KITT server.
```
2. Loading the test dataset to the database. This step will also include quality control filtering steps as described in the Running SymPortal link above.

```
Few_ITS2
$ ./main.py --load /home/estrand/ITS2/Few_ITS2 --name first_loading --num_proc 3 --data_sheet /home/estrand/ITS2/Few_ITS2/ITS2_subset.xlsx

End of output:

DATA LOADING COMPLETE
DataSet id: 4
DataSet name: first_loading
DataSet loading_complete_time_stamp: 2020-03-30_17-25-08.147412

Full_ITS2
$ ./main.py --load /home/estrand/ITS2/FULL_ITS2 --name first_loading --num_proc 3 --data_sheet /home/estrand/ITS2/FULL_ITS2/ITS2_Full.xlsx

End of output:
DATA LOADING COMPLETE
DataSet id: 5
DataSet name: first_loading
DataSet loading_complete_time_stamp: 2020-03-31_23-03-43.621114

num_proc 3 indicates using 3 processors to run the subset. Please be mindful of your individual processor limit, especially on a shared server.
DataSet id number is higher because I ran a few test loadings with one or two samples to double check this worked. Each time the new loading overrode the previous one under the name first_loading.
```

Troubleshooting:

```
Error: -bash: ./main.py: No such file or directory`
Solution: Must be in the SymPortal_framework directory to run any .py commands or files.

Error:
Creating data_set_sample objects
Sample fastq pairs list empty
Solution: ITS2_subset.xlsx datasheet is likely empty. Forward and reverse pair information must be filled in.
```

3. Check the dataset loading.

```
$ python3.6 main.py --display_data_sets
Few_ITS2 Output:
3: first_loading	2020-03-30_16-39-46.644400
4: first_loading	2020-03-30_16-57-13.928018

FULL_ITS2 Output:
5: first_loading	2020-03-31_18-49-02.076040

In the future I would change the name of the data sets from first_loading to a more specific name for even further clarification.
```

#### <a name="Running_analysis"></a> **Running_analysis**

1. Running the analysis on single or multiple datasets uploaded. The number corresponds to the dataset ID from step 2 of downloading data.

```
Few_ITS2: $ ./main.py --analyse 4 --name first_analysis --num_proc 3
FULL_ITS2: $ ./main.py --analyse 5 --name first_analysis --num_proc 3

Few_ITS2 end of output:
ANALYSIS COMPLETE: DataAnalysis:
 name: first_analysis
 UID: 2

DataSet analysis_complete_time_stamp: 2020-03-30_17-49-03.127592

FULL_ITS2 end of output:
ANALYSIS COMPLETE: DataAnalysis:
 name: first_analysis
 UID: 3

DataSet analysis_complete_time_stamp: 2020-04-01_09-28-45.840199

```

2. Checking dataset analysis instances.

```
$ ./main.py --display_analyses
Few_ITS2 output:
2: first_analysis	2020-03-30_17-26-48.150823

FULL_ITS2 output:
3: first_analysis	2020-04-01_08-55-07.023480
```

3. To output the ITS2 sequence count table and figures (DIVs):

```
$ ./main.py --print_output_seqs 4
File formats:
DIV table output files:
./outputs/non_analysis/time_stamp/1.DIVs.absolute.txt
./outputs/non_analysis/time_stamp/1.DIVs.relative.txt
./outputs/non_analysis/time_stamp/1.DIV.fasta

Copy just the DIV outfiles to own repo (outside of KITT terminal)
$ scp -r -P XXXX XXXX@kitt.uri.edu:/home/estrand/ITS2/SymPortal_framework/outputs/non_analysis/2020-03-30_17-51-51.940845 ~/MyProjects/Acclim_Dynamics/
Rename the output repo
$ mv ~/MyProjects/Acclim_Dynamics/2020-03-30_17-51-51.940845 ~/MyProjects/Acclim_Dynamics/Few_ITS2_DIVs
```

This step will output pre-med-seq and post-med-seq folders with the DIV tables and visualizations. Med refers to minimum entropy decomposition, which is a form of quality control used in SymPortal that partitions the dataset into operational taxonomical units. Read more about this [in Eren et al 2015](https://www.nature.com/articles/ismej2014195.pdf).

4. To output the ITS2 sequences (DIVs) and the ITS2 type profile tables and figures:

```
Few_ITS2: $ ./main.py --print_output_types 4 --data_analysis_id 2 --num_proc 3
FULL_ITS2: $ ./main.py --print_output_types 5 --data_analysis_id 3 --num_proc 3
## 4 is the dataset ID from downloading and 2 is the data analysis id.
## See above for DIV dataset file format

ITS2 type profile output files:
/SymPortal_framework/outputs/analyses/2/time_stamp/its2_type_profiles/1_1.profiles.absolute.txt
/SymPortal_framework/outputs/analyses/2/time_stamp/its2_type_profiles/1_1.profiles.relative.txt

Copy just ITS2 type profiles to own github repo (outside of KITT terminal)
$ scp -r -P XXXX XXXX@kitt.uri.edu:/home/estrand/ITS2/SymPortal_framework/outputs/analyses/2/2020-03-30_18-38-09.663871/its2_type_profiles/ ~/MyProjects/Acclim_Dynamics/

Copy entire output folder to own github repo (outisde of KITT terminal)
$ scp -r -P XXXX XXXX@kitt.uri.edu:/home/estrand/ITS2/SymPortal_framework/outputs/analyses/2/2020-03-30_18-38-09.663871 ~/MyProjects/Acclim_Dynamics/
```

[Full ITS2 post-med seq ouput](https://github.com/hputnam/Acclim_Dynamics/tree/master/ITS_Output/FULL_ITS2/post_med_seqs)  
[Full ITS2 type profiles](https://github.com/hputnam/Acclim_Dynamics/tree/master/ITS_Output/FULL_ITS2/its2_type_profiles)
