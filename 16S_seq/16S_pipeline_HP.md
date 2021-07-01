# 16S

### Folder Location:  
/data/putnamlab/hputnam/HoloInt_16S

mkdir /data/putnamlab/hputnam/HoloInt_16S/clean_reads
mkdir /data/putnamlab/hputnam/HoloInt_16S/scripts
mkdir /data/putnamlab/hputnam/HoloInt_16S/raw_qc/
mkdir /data/putnamlab/hputnam/HoloInt_16S/clean_qc/
mkdir /data/putnamlab/hputnam/HoloInt_16S/metadata/

### Raw Data Location: 
/data/putnamlab/KITT/hputnam/20210608_Amplicon/16S_HI/

### Sequence QC
```
nano /data/putnamlab/hputnam/HoloInt_16S/scripts/run_qc.sh
```

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=50GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/hputnam/HoloInt_16S

module load FastQC/0.11.9-Java-11  
module load fastp/0.19.7-foss-2018b  
module load MultiQC/1.9-intel-2020a-Python-3.8.2


#run fastqc on raw data
fastqc /data/putnamlab/KITT/hputnam/20210608_Amplicon/16S_HI/*.fastq.gz -o raw_qc/

#Compile MultiQC report from FastQC files
multiqc raw_qc
mv multiqc_report.html raw_qc/16S_raw_qc_multiqc_report.html

echo "Initial QC of Seq data complete." $(date)
```

```
sbatch /data/putnamlab/hputnam/HoloInt_16S/scripts/run_qc.sh
```

scp hputnam@bluewaves.uri.edu:/data/putnamlab/hputnam/HoloInt_16S/raw_qc/16S_raw_qc_multiqc_report.html /Users/hputnam/MyProjects/Acclim_Dynamics


### Count Sequences
```zgrep -c "@M00763" /data/putnamlab/KITT/hputnam/20210608```

HPW116 has less than 10K


#QIIME

### sample manifest
scp /Users/hputnam/MyProjects/Acclim_Dynamics/16S_seq/HoloInt_sample-manifest.csv hputnam@bluewaves.uri.edu:/data/putnamlab/hputnam/HoloInt_16S/metadata 

### sample metadata
scp /Users/hputnam/MyProjects/Acclim_Dynamics/16S_seq/HoloInt_Metadata.txt hputnam@bluewaves.uri.edu:/data/putnamlab/hputnam/HoloInt_16S/metadata 

### classifier
cd /data/putnamlab/hputnam/HoloInt_16S/metadata

wget https://data.qiime2.org/2021.4/common/silva-138-99-515-806-nb-classifier.qza

```
nano /data/putnamlab/hputnam/HoloInt_16S/scripts/run_qiime2.sh
```

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=300GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/hputnam/HoloInt_16S

# This script imports and QCs the data using DADA2
echo "QIIME2 bash script for 16S v4 samples started running at: "; date


module load QIIME2/2021.4
module list

##############################################################################
# EDIT THIS SECTION

# Put file path here
cd /data/putnamlab/hputnam/HoloInt_16S

# Put metadata file name here
METADATA="metadata/HoloInt_Metadata.txt"

# Put sample manifest file name here
MANIFEST="metadata/HoloInt_sample-manifest.csv"

##############################################################################

# Import data into QIIME
# Paired-end, based on sample-manifest.csv
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $MANIFEST --output-path HoloInt_v4-paired-end-sequences.qza \
  --input-format PairedEndFastqManifestPhred33

# QC using dada2
# Adjust the params based on read length and 16S primer length
qiime dada2 denoise-paired --verbose --i-demultiplexed-seqs HoloInt_v4-paired-end-sequences.qza \
  --p-trunc-len-r 150 --p-trunc-len-f 260 \
  --p-trim-left-r 20 --p-trim-left-f 20 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza \
  --p-n-threads 20

# Summarize feature table and sequences
qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file $METADATA
qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv



# This section assigns taxonomy based on the imported database 

qiime feature-classifier classify-sklearn \
  --i-classifier metadata/silva-138-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza
qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file $METADATA \
  --o-visualization taxa-bar-plots.qzv
qiime metadata tabulate \
  --m-input-file rep-seqs.qza \
  --m-input-file taxonomy.qza \
  --o-visualization tabulated-feature-metadata.qzv


# This script calculates phylogenetic trees for the data

# align and mask sequences
qiime alignment mafft \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza
qiime alignment mask \
  --i-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza

# calculate tree
qiime phylogeny fasttree \
  --i-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza
qiime phylogeny midpoint-root \
  --i-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

# calculate overall diversity
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 95 \
  --m-metadata-file $METADATA \
  --output-dir core-metrics-results

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file $METADATA \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file $METADATA \
  --o-visualization core-metrics-results/evenness-group-significance.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file $METADATA \
  --m-metadata-column CoralType \
  --o-visualization core-metrics-results/unweighted-unifrac-station-significance.qzv \
  --p-pairwise
qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file $METADATA  \
  --m-metadata-column TissueType \
  --o-visualization core-metrics-results/unweighted-unifrac-group-significance.qzv \
  --p-pairwise


# This script calculates the rarefaction curve for the data
qiime diversity alpha-rarefaction \
  --i-table table.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 800 \
  --m-metadata-file $METADATA \
  --o-visualization alpha-rarefaction.qzv

echo "qiime analysis completed $(date)"

```

```
sbatch /data/putnamlab/hputnam/HoloInt_16S/scripts/run_qiime2.sh
```


### Download Data from Server 
```
scp -r hputnam@bluewaves.uri.edu:/data/putnamlab/hputnam/HoloInt_16S/core-metrics-results /Users/hputnam/MyProjects/Acclim_Dynamics/16S_seq

scp -r hputnam@bluewaves.uri.edu:/data/putnamlab/hputnam/HoloInt_16S/*.qz* /Users/hputnam/MyProjects/Acclim_Dynamics/16S_seq/core-metrics-results
```

# Things to Test
1. params based on read length and 16S primer length
 ```e.g., qiime dada2 denoise-paired --verbose --i-demultiplexed-seqs HoloInt_v4-paired-end-sequences.qza \```
2. qiime feature-classifier
[premade classifiers](https://docs.qiime2.org/2021.4/data-resources/#taxonomy-classifiers-for-use-with-q2-feature-classifier) 

