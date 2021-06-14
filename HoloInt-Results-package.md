# Acclimatization Dynamics Results

![expt-sch](https://github.com/hputnam/Acclim_Dynamics/blob/master/Environmental_data/HoloInt-schematic.png?raw=true)

900 corals, 450 *M. capitata* and 450 *P. acuta*, were collected from 6 sites in Kaneohe Bay, Hawai'i. These corals were randomly assigned to one of 4 treatments. 3 tanks per treatment, 12 tanks total. 2 months of treatment and 2 months of recovery in ambient conditions.   

ATAC = Ambient Temperature (27C) Ambient pCO2 (~480 uatm)  
ATHC = Ambient Temperature (27C) High pCO2 (~1,200 uatm)    
HTAC = High Temperature (29.5C) Ambient pCO2 (~480 uatm)  
HTHC = High Temperature (29.5C) High pCO2 (~1,200 uatm)


**Environmental History and Degree Heating Weeks in Kaneohe Bay**

NOAA [CRIMP2: Buoy Position: 21.46°N, 157.80°W](https://www.pmel.noaa.gov/co2/story/CRIMP2) and buoy [info](http://www.soest.hawaii.edu/oceanography/edecarlo/Eric_Decarlo_homepage/CRIMP.html); seems to be closest to our sites. Ask Hollie or Ariana for suggestions of other buoys. Data ranges from 2008-2019. Variables in dataset: SST, SSS, Atm. press, xCO2 water, xCO2 air, fCO2 water, fCO2 air, pH on total scale. Data files found [here](https://www.ncei.noaa.gov/data/oceans/ncei/ocads/data/0157415/).

![CRIMP2 location](http://www.soest.hawaii.edu/oceanography/edecarlo/Eric_Decarlo_homepage/CRIMP_files/image001.jpg)

CRIMP2 Temperature Data

![crimp2temp](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/CRIMP2-Temperature.png?raw=true)

The red line is at 29.5, the average temperature for our data. The warm season of 2016 doesn't have data, maybe we can get this from a different buoy?

CRIMP2 pCO2 Data

pCO2 is projected to increase over next 100 years so this probably isn't as relevant to put environmental data into perspective in publication.

![crimp2pco2](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/CRIMP2-pCO2.png?raw=true)

## Collection Timeline

| Date Collected 	| Site Name         	| Coordinates                	|
|----------------	|-------------------	|----------------------------	|
| 20180904       	| SITE 2 HIMB       	| 21°26'09.8"N 157°47'12.7"W 	|
| 20180905       	| SITE 6 REEF 42.43 	| 21°28'37.9"N 157°49'36.8"W 	|
| 20180906       	| SITE 5 REEF 35.36 	| 21°28'26.0"N 157°50'01.2"W 	|
| 20180907       	| SITE 4 REEF 11.13 	| 21°27'02.9"N 157°47'41.8"W 	|
| 20180908       	| SITE 1 LILIPUNA   	| 21°25'45.9"N 157°47'28.0"W 	|
| 20180910       	| SITE 3 REEF 18    	| 21°27'02.9"N 157°48'40.1"W 	|

Experimental treatment started on 20180922.

*M. capitata* spawning dates:  
*P. acuta* spawning dates:



## Sampling Timeline

|                      	| Acute Stress 	|       	| Chronic Stress 	|      	|      	|      	|      	|      	|      	|      	| Recovery 	|       	|       	|       	|       	|       	|       	|       	|
|----------------------	|--------------	|-------	|----------------	|------	|------	|------	|------	|------	|------	|------	|----------	|-------	|-------	|-------	|-------	|-------	|-------	|-------	|
|                      	| Day 1        	| Day 2 	| Wk 1           	| Wk 2 	| Wk 3 	| Wk 4 	| Wk 5 	| Wk 6 	| Wk 7 	| Wk 8 	| Wk 9     	| Wk 10 	| Wk 11 	| Wk 12 	| Wk 13 	| Wk 14 	| Wk 15 	| Wk 16 	|
| Holobiont Physiology 	| x            	| x     	| x              	| x    	|      	| x    	|      	| x    	|      	| x    	|          	|       	|       	| x     	|       	|       	|       	| x     	|
| Metabolism          	| x            	| x     	| x              	| x    	|      	| x    	|      	| x    	|      	| x    	|          	|       	|       	|       	|       	|       	|       	|       	|
| Growth              	| x            	| x     	| x              	| x    	|      	| x    	|      	| x    	|      	| x    	|          	| x     	|       	| x     	|       	| x     	|       	| x     	|
| Bleaching Score     	|              	|       	| x              	| x    	| x    	| x    	| x    	| x    	| x    	| x    	| x        	| x     	| x     	| x     	| x     	| x     	| x     	| x     	|
| Survivorship        	| x            	| x     	| x              	| x    	| x    	| x    	| x    	| x    	| x    	| x    	| x        	| x     	| x     	| x     	| x     	| x     	| x     	| x     	|
| Molecular            	| 0, 6, 12 hr  	| 24 hr 	| x              	| x    	|      	| x    	|      	| x    	|      	| x    	|          	|       	|       	| x     	|       	|       	|       	| x     	|

**Response variables:**  
Molecular: Symbiont community assemblage (ITS2 Seq), bacterial community assemblage (16S Seq),  Pocillopora acuta identity (mtORF Seq), gene expression patterns (RNASeq), DNA methylation patterns (WGBS; MBD-BS).  
Holobiont physiology: protein content, total antioxidant capacity, chlorophyll concentration, tissue biomass, symbiont density.  
Metabolism: respiration and photosynthetic rates.   

## Experimental Treatments

**Hobo Logger Data**

![hobo](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Hobo-loggers.png?raw=true)

The sharp drops ~1-2 weeks are from removing the hobo loggers from the tanks to download the data. I need to go through and remove these time periods.

![hobo-parsed]()

The above is after parsing when the heaters were off for shocking, the outlets went out, or the hobo loggers were out of the water. 

**Discrete Temperature and pH Measurements**

![discretetemp](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Discrete-Temperature.png?raw=true)

![discreteph](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Discrete-pH.png?raw=true)

![box](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Discrete-Temp-pH-Trt.png?raw=true)

**Discrete Carbonate Chemistry**

![carbchem](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Carbonate-Chemistry.png?raw=true)

## Physiology Sample Sizes

**List of missing corals**:  
The following have been lost in transit from HIMB to URI or misplaced in a freezer in either location. I've checked URI's freezers and neighboring lab's freezers multiple times. This will decrease the sample sizes of several groups down to 2 at the smallest in Day 2 and Week 1.

| Species   	| Plug ID 	| Treatment 	| Sample Date 	|
|-----------	|---------	|-----------	|-------------	|
| Mcapitata 	| 2008    	| HTHC      	| 20180923    	|
| Mcapitata 	| 2512    	| HTHC      	| 20180923    	|
| Pacuta    	| 2522    	| HTHC      	| 20180923    	|
| Pacuta    	| 2523    	| HTHC      	| 20180923    	|
| Pacuta    	| 2752    	| ATHC      	| 20180923    	|
| Pacuta    	| 2880    	| ATHC      	| 20180923    	|
| Mcapitata 	| 2976    	| ATHC      	| 20180923    	|
| Mcapitata 	| 3003    	| ATHC      	| 20180923    	|
| Mcapitata 	| 1603    	| HTHC      	| 20180929    	|
| Pacuta    	| 1739    	| HTHC      	| 20180929    	|
| Mcapitata 	| 2200    	| HTHC      	| 20180929    	|
| Mcapitata 	| 2528    	| ATHC      	| 20180929    	|
| Mcapitata 	| 2740    	| ATHC      	| 20180929    	|
| Pacuta    	| 2859    	| HTHC      	| 20180929    	|
| Pacuta    	| 2981    	| ATHC      	| 20180929    	|
| Pacuta    	| 2984    	| ATHC      	| 20180929    	|

This table applies to respiration rates, photosynthetic rates, chlorophyll, tissue biomass, protein, cell density, and TAC. No data in recovery period for respiration and photosynthetic rates. These are all individual corals (i.e. a week 1 coral will not be in any other timepoint).   
Bleaching score, survivorship, and growth have different sample size values because corals were repetitively measured (i.e. a coral photographed in weeks 1-5 then physiologically sampled in week 6).   

| Species     	| Timepoint 	| Treatment 	| Sample Size 	| Notes                         	|
|-------------	|-----------	|-----------	|-------------	|-------------------------------	|
| M. capitata 	| Day 1     	| ATAC      	| 4           	| Not enough time in the field  	|
| M. capitata 	| Day 1     	| ATHC      	| 2           	| Not enough time in the field  	|
| M. capitata 	| Day 1     	| HTAC      	| 4           	| Not enough time in the field  	|
| M. capitata 	| Day 1     	| HTHC      	| 2           	| Not enough time in the field  	|
| P. acuta    	| Day 1     	| ATAC      	| 4           	| Not enough time in the field  	|
| P. acuta    	| Day 1     	| ATHC      	| 2           	| Not enough time in the field  	|
| P. acuta    	| Day 1     	| HTAC      	| 4           	| Not enough time in the field  	|
| P. acuta    	| Day 1     	| HTHC      	| 2           	| Not enough time in the field  	|
| M. capitata 	| Day 2     	| ATAC      	| 6           	|                               	|
| M. capitata 	| Day 2     	| ATHC      	| 4           	| Corals missing in transit     	|
| M. capitata 	| Day 2     	| HTAC      	| 6           	|                               	|
| M. capitata 	| Day 2     	| HTHC      	| 4           	| Corals missing in transit     	|
| P. acuta    	| Day 2     	| ATAC      	| 6           	|                               	|
| P. acuta    	| Day 2     	| ATHC      	| 4           	| Corals missing in transit     	|
| P. acuta    	| Day 2     	| HTAC      	| 6           	|                               	|
| P. acuta    	| Day 2     	| HTHC      	| 4           	| Corals missing in transit     	|
| M. capitata 	| 1 week    	| ATAC      	| 6           	|                               	|
| M. capitata 	| 1 week    	| ATHC      	| 4           	| Corals missing in transit     	|
| M. capitata 	| 1 week    	| HTAC      	| 6           	|                               	|
| M. capitata 	| 1 week    	| HTHC      	| 4           	| Corals missing in transit     	|
| P. acuta    	| 1 week    	| ATAC      	| 6           	|                               	|
| P. acuta    	| 1 week    	| ATHC      	| 4           	| Corals missing in transit     	|
| P. acuta    	| 1 week    	| HTAC      	| 6           	|                               	|
| P. acuta    	| 1 week    	| HTHC      	| 4           	| Corals missing in transit     	|
| M. capitata 	| 2 week    	| ATAC      	| 6           	|                               	|
| M. capitata 	| 2 week    	| ATHC      	| 6           	|                               	|
| M. capitata 	| 2 week    	| HTAC      	| 6           	|                               	|
| M. capitata 	| 2 week    	| HTHC      	| 6           	|                               	|
| P. acuta    	| 2 week    	| ATAC      	| 6           	|                               	|
| P. acuta    	| 2 week    	| ATHC      	| 6           	|                               	|
| P. acuta    	| 2 week    	| HTAC      	| 6           	|                               	|
| P. acuta    	| 2 week    	| HTHC      	| 6           	|                               	|
| M. capitata 	| 4 week    	| ATAC      	| 6           	|                               	|
| M. capitata 	| 4 week    	| ATHC      	| 6           	|                               	|
| M. capitata 	| 4 week    	| HTAC      	| 6           	|                               	|
| M. capitata 	| 4 week    	| HTHC      	| 6           	|                               	|
| P. acuta    	| 4 week    	| ATAC      	| 6           	|                               	|
| P. acuta    	| 4 week    	| ATHC      	| 6           	|                               	|
| P. acuta    	| 4 week    	| HTAC      	| 6           	|                               	|
| P. acuta    	| 4 week    	| HTHC      	| 6           	|                               	|
| M. capitata 	| 6 week    	| ATAC      	| 6           	|                               	|
| M. capitata 	| 6 week    	| ATHC      	| 6           	|                               	|
| M. capitata 	| 6 week    	| HTAC      	| 6           	|                               	|
| M. capitata 	| 6 week    	| HTHC      	| 6           	|                               	|
| P. acuta    	| 6 week    	| ATAC      	| 6           	|                               	|
| P. acuta    	| 6 week    	| ATHC      	| 6           	|                               	|
| P. acuta    	| 6 week    	| HTAC      	| 6           	|                               	|
| P. acuta    	| 6 week    	| HTHC      	| 6           	|                               	|
| M. capitata 	| 8 week    	| ATAC      	| 6           	|                               	|
| M. capitata 	| 8 week    	| ATHC      	| 6           	|                               	|
| M. capitata 	| 8 week    	| HTAC      	| 6           	|                               	|
| M. capitata 	| 8 week    	| HTHC      	| 6           	|                               	|
| P. acuta    	| 8 week    	| ATAC      	| 6           	|                               	|
| P. acuta    	| 8 week    	| ATHC      	| 6           	|                               	|
| P. acuta    	| 8 week    	| HTAC      	| 6           	|                               	|
| P. acuta    	| 8 week    	| HTHC      	| 6           	|                               	|
| M. capitata 	| 12 week   	| ATAC      	| 5           	| only 5 available to sample    	|
| M. capitata 	| 12 week   	| ATHC      	| 6           	|                               	|
| M. capitata 	| 12 week   	| HTAC      	| 6           	|                               	|
| M. capitata 	| 12 week   	| HTHC      	| 5           	| only 5 available to sample    	|
| P. acuta    	| 12 week   	| ATAC      	| 6           	|                               	|
| P. acuta    	| 12 week   	| ATHC      	| 6           	|                               	|
| P. acuta    	| 12 week   	| HTAC      	| 2           	| only 2 available to sample    	|
| P. acuta    	| 12 week   	| HTHC      	| 0           	| no corals available to sample 	|
| M. capitata 	| 16 week   	| ATAC      	| 6           	|                               	|
| M. capitata 	| 16 week   	| ATHC      	| 5           	| only 5 available to sample    	|
| M. capitata 	| 16 week   	| HTAC      	| 4           	| only 4 available to sample    	|
| M. capitata 	| 16 week   	| HTHC      	| 5           	| only 5 available to sample    	|
| P. acuta    	| 16 week   	| ATAC      	| 6           	|                               	|
| P. acuta    	| 16 week   	| ATHC      	| 6           	|                               	|
| P. acuta    	| 16 week   	| HTAC      	| 0           	| no corals available to sample 	|
| P. acuta    	| 16 week   	| HTHC      	| 0           	| no corals available to sample 	|

Not enough time in the field: We were not able to complete all of Day 1 sampling in the field because we originally included instantaneous calcification in our response variables. After Day 1 we cut out this variable, but this means we have decreased sample sizes for Day 1.

Corals missing in transit: Due to the list of missing corals, several groups on Day 2 and Week 1 will have decreased sample sizes.

Only X number available to sample: Due to lower survivorship in recovery periods, there was limited availability for sampling, resulting a smaller sample size for some groups.  

Some univariate physiology variables will also have decreased sample size groups, see each section for additional notes.

## Univariate Physiology Results   

### Survivorship

![suv](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/All_survivorship.png?raw=true)

This dataset has been QC'd by Emma; final figure as of 20210108.  
Survivorship was measured every day and each coral was noted as dead or alive for that day. This plot was made with [survfit() function](https://www.rdocumentation.org/packages/survival/versions/2.9-6/topics/survfit).

### Color Score

![blch](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Photographic_Bleaching.png?raw=true)

This dataset has been QC'd by Emma; final figure as of 20210218. Corals photographed and red blue green color square quantified in ImageJ.

Week 5 data excluded because we didn't trust that set of values for any treatment.

### Growth

![grw](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Growth.png?raw=true)  

Buoywant weight technique

*P.acuta* Week 10 and 14 have the same value? This is real data, they just have almost identical values for those timepoints. Nothing to change here.

Figure as of 20210218.

### Respiration and photosynthetic rates

![resp](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Respirometry.png?raw=true)

No additional groups with a decreased sample size.  
This dataset has been QC'd by Emma; final figure as of 20210118.

### Tissue Biomass (AFDW)

![AFDW](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Tissue_Biomass.png?raw=true)

![Ratio](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Tissue_Biomass-Ratio.png?raw=true)

This dataset has been QC'd by Emma; final figure as of 20210108.

In addition to the missing list above, we won't have data for:  
- 1174: there was no homogenate tissue in this falcon tube. Aliquots were made so this coral will have Chl, Prot, TAC, cell density.    
- 1327: gained mass in AFDW protocol (not possible); not enough homogenate to do again.  
- 1488: homogenate tube broke (froze and cracked) and we lost half of tissue homogenate. There was not enough left to do AFDW.

**AFDW sample size differences in addition to the 3 above sample size tables.**

| Species     	| Timepoint 	| Treatment 	| Sample Size 	| Notes                                           	|
|-------------	|-----------	|-----------	|-------------	|-------------------------------------------------	|
| P. acuta    	| Day 1     	| HTAC      	| 3           	| 1488 no data; Time limited 1st day in the field 	|
| M. capitata 	| 4 week    	| ATHC      	| 5           	| 2863 will be redone                             	|
| P. acuta    	| 8 week    	| HTAC      	| 5           	| 1327 no data                                    	|
| P. acuta    	| 8 week    	| HTHC      	| 5           	| 1174 no data                                    	|

### Chlorophyll concentration

![chl](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Chlorophyll.png?raw=true)

| Species  	| Timepoint 	| Treatment 	| Sample Size 	| Notes                                       	|
|----------	|-----------	|-----------	|-------------	|---------------------------------------------	|
| P. acuta    	| Day 1     	| HTAC      	| 3           	| 1488 no data; Time limited 1st day in the field 	|

P-1488: I don't trust the aliquots for this sample, no data here. See note from AFDW.   

This dataset has been QC'd by Emma; final figure as of 20210216.

### Host Soluble Protein

![prot](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Host-Soluble-Protein.png?raw=true)

All samples done on BCA purple kit instead of Rapid Gold.

| Species     	| Timepoint 	| Treatment 	| Sample Size 	| Notes                                           	|
|-------------	|-----------	|-----------	|-------------	|-------------------------------------------------	|
| P. acuta    	| Day 1     	| HTAC      	| 3           	| 1488 no data (see notes on Chl and AFDW); Time limited 1st day in the field 	|

This dataset has been QC'd by Emma; final figure as of 20210527.

### Host Total Antioxidant Capacity

![TAC](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Total-Antioxidant-Capacity.png?raw=true)

| Species     	| Timepoint 	| Treatment 	| Sample Size 	| Notes                                           	|
|-------------	|-----------	|-----------	|-------------	|-------------------------------------------------	|
| P. acuta    	| Day 1     	| HTAC      	| 3           	| 1488 no data (see notes on Chl and AFDW); Time limited 1st day in the field 	|

Week 4 ATHC P acuta points look wonky like the protein values. Day 2 and Week 1 have very small sample sizes likely leading to large variation above?  

Still having an issue with the standard curve variation. According to the [assay kit protocol](https://www.cellbiolabs.com/sites/default/files/STA-360-total-antioxidant-capacity-assay-kit.pdf), 1 mM concentration should be around 1.35 Abs490. The closest st. curve was from Nov 10th plate. All points have been projected onto the st. curve from Nov 10th and TAC calculated from this st. curve. **We still need to address this**.

TAC calculation done by:  

1. UAE * 2189. Convert to CRE  
2. CRE.umol.L (from Step 1) * (homog vol/1000)  
3. CRE.umol.mgprot = CRE.umol.L (from Step 2) / (prot ug / 1000)

```
TAC <- left_join(TAC.values, metadata) %>%
   mutate(cre.umol.L = uae.mM * 2189) %>%   # Convert to CRE (see product manual) per unit sample volume
   mutate(cre.umol = cre.umol.L * (vol_mL / 1000),  # Convert to CRE per coral by multiplying by homog. vol.
          cre.umol.mgprot = cre.umol / (prot_ug / 1000))  # Convert to CRE per mg protein by dividing by total protein
```

### Univariate Variability

[Tanner et al](https://reader.elsevier.com/reader/sd/pii/S1095643319303411?token=2AB5B29AAF12986713BC6F350B737384B0236CC06FBD9EFF28A42F6A2027DC768B29120E0EA1E63A2B70A2CE27BE255F)

MAD = Median Absolute Deviation  
- Measures variation within each metric  
- MAD = median(| absolute deviation of each sample group - median of group|)  
- mad function in R

ANOVA on the absolute deviations of each sample group (functionally equivalent to Brown-Forsythe test)

CV = Coefficient of variation  
- magnitudes of individual variation across phys traits  
- CV = (MAD / group mean) x 100

```
mutate(mad = mad(Response.Value, center = median(Response.Value), constant = 1.4826, na.rm = FALSE, low = FALSE, high = FALSE)) %>%
  mutate(cv = ((mad/mean(Response.Value))*100))
  ```

![resp-mad](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/MAD-Resp.png?raw=true)

![Chl-mad](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/MAD-Chl.png?raw=true)

![prot-mad](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/MAD-Prot-TAC.png?raw=true)

![AFDW-mad](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/MAD-AFDW.png?raw=true)

![cv](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/CV-total.png?raw=true)

Next steps:  
- 1.4826 value for non Gaussian distribution   
- stats test that Tanner references (bf test)  
- Color score, Growth  
- Multivariate on gene counts  
- multivariate MAD from prcomp?



### Statistical Methods

Markdown sheet found [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Statistical-methods.md).

## Molecular Response Variables

Sample sizes: n=3 per treatment per timepoint. 251 total.

| Species               	| Timepoint 	| Treatment 	| Sample Size 	| Notes            	|
|-----------------------	|-----------	|-----------	|-------------	|------------------	|
| M. capitata; P. acuta 	| 0 hour    	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 6 hour    	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 12 hour   	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 24 hour   	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 1 week    	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 2 week    	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 4 week    	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 6 week    	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 8 week    	| All       	| 3           	|                  	|
| M. capitata; P. acuta 	| 12 week   	| All       	| 3           	|                  	|
| M. capitata           	| 16 week   	| All       	| 3           	|                  	|
| P. acuta              	| 16 week   	| All       	| 2           	| Only 2 available 	|

### ITS2 Sequencing

Notebook post coming soon. Symbiont Type Profiles made from [SymPortal](https://symportal.org/). We had 17 profiles in our samples. Group label on the x-axis refers to sample. Each bar is one coral.   

Figure 20210120

Sample HP192 Pacuta 1755 4 wk ATAC has the profiles usually associated with Mcap and sample HP193 1246 Mcap 4 wk HTHC has the profiles usually associated with Pacuta. Rebecca did the ITS2 work but these two samples were right next to the each other on the strip tube so likely got switched somewhere in the process?

Why does Mcap 12 hour HTAC have n=4 and Mcap 0 hour HTAC have n=2? Physiology/Molecular fragment that was switched out was from the wrong timepoint?

![relab](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/rel.abund.its2.png?raw=true)


*Mcapitata* PERMANOVA results:

```
Call:
adonis(formula = MC.mat ~ Temperature * CO2 * Timepoint, data = MC.info,      permutations = 999, method = "bray")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                           Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)  
Temperature                 1     0.130 0.12973 0.43631 0.00324  0.709  
CO2                         1     0.054 0.05377 0.18086 0.00134  0.917  
Timepoint                  10     3.823 0.38230 1.28580 0.09534  0.164  
Temperature:CO2             1     0.352 0.35220 1.18455 0.00878  0.292  
Temperature:Timepoint      10     4.400 0.43995 1.47969 0.10972  0.091 .
CO2:Timepoint              10     3.347 0.33472 1.12577 0.08348  0.333  
Temperature:CO2:Timepoint  10     1.828 0.18282 0.61487 0.04559  0.944  
Residuals                  88    26.165 0.29733         0.65251         
Total                     131    40.098                 1.00000         
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

```

*Pacuta* PERMANOVA results:

```
Call:
adonis(formula = PA.mat ~ Temperature * CO2 * Timepoint, data = PA.info,      permutations = 999, method = "bray")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                           Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)  
Temperature                 1    0.0123 0.01232  0.0546 0.00047  0.965  
CO2                         1    0.4337 0.43367  1.9207 0.01644  0.144  
Timepoint                   9    1.2209 0.13566  0.6008 0.04629  0.900  
Temperature:CO2             1    0.8171 0.81712  3.6190 0.03098  0.032 *
Temperature:Timepoint       9    1.8427 0.20475  0.9068 0.06987  0.560  
CO2:Timepoint               9    2.4246 0.26940  1.1931 0.09193  0.273  
Temperature:CO2:Timepoint   9    1.7854 0.19838  0.8786 0.06770  0.603  
Residuals                  79   17.8374 0.22579         0.67632         
Total                     118   26.3742                 1.00000         
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

### mtORF Sequencing

[Notebook post](https://emmastrand.github.io/EmmaStrand_Notebook/mtORF-Amplification-Pocillopora/) for sample processing.

*P. acuta* is all one species and data visualization to come soon.

### 16s Sequencing

We have tested two primers sets and are now planning to move forward with 515F and 806R for V4 region.
This is in progress in the lab at URI.

### Metabolomics

Coral fragments sent to Rutgers for sample processing.

### Gene Expression

RNASeq analysis done by Rutgers team. Gene counts table available.

### DNA Methylation

Methods
Manuscript going out for review on 3 methods to examine methylation in Mcap and Pact under ambient conditions.
https://github.com/hputnam/Meth_Compare
