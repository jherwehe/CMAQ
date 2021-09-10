#! /bin/csh -f

# ===================== SITECMP_v5.3.X Run Script =====================
# Usage: run.sitecmp.csh >&! sitecmp.log &
#
# To report problems or request help with this script/program:
#             http://www.epa.gov/cmaq    (EPA CMAQ Website)
#             http://www.cmascenter.org
# ===================================================================

# ==================================================================
#> Runtime Environment Options
# ==================================================================

#> Choose compiler and set up CMAQ environment with correct 
#> libraries using config.cmaq. Options: intel | gcc | pgi
 setenv compiler intel 

 cd ../../..
 source ./config_cmaq.csh

#> Set General Parameters for Configuring the Simulation
 set VRSN      = v532              #> Code Version
 set PROC      = mpi               #> serial or mpi
 set MECH      = cb6r3_ae7_aq      #> Mechanism ID
 set APPL      = Bench_2016_12SE1        #> Application Name (e.g. Gridname)
                                                      
#> Define RUNID as any combination of parameters above or others. By default,
#> this information will be collected into this one string, $RUNID, for easy
#> referencing in output binaries and log files as well as in other scripts.
 set RUNID = ${VRSN}_${compilerString}_${APPL}

#> Set the build directory if this was not set above 
#> (this is where the executable is located by default).
 if ( ! $?BINDIR ) then
  set BINDIR = ${CMAQ_HOME}/POST/sitecmp/scripts/BLD_sitecmp_${VRSN}_${compilerString}
 endif

#> Set the name of the executable.
 set EXEC = sitecmp_${VRSN}.exe

#> Set output directory
 set POSTDIR = ${CMAQ_DATA}/POST    #> Location where sitecmp file will be written

  if ( ! -e $POSTDIR ) then
	  mkdir $POSTDIR
  endif

# =====================================================================
#> SITECMP Configuration Options
# =====================================================================

# ~~~~~~~~~~~~ START NETWORK SPECIFIC SECTION ~~~~~~~~~~~~~~~~~~~~~~~~~
#> The following environment variables will change depending on what 
#> observation network is being matched with CMAQ output.
#> See the README.md file in this folder for the settings to use for 
#> the following networks: IMPROVE, CASTNET, CSN (formally STN), NADP
#> SEARCH, AIRMON

#> Set TABLE TYPE
 setenv TABLE_TYPE CASTNET

#> Specify the variable names used in your observation inputs
#> and model output files for each of the species you are analyzing below.
#>
#> variable format:
#>    Obs_expression, Obs_units, [Mod_expression], [Mod_unit], [Variable_name]
#>
#> The expression is in the form:
#>       [factor1]*Obs_name1 [+][-] [factor2]*Obs_name2 ...
 setenv AERO_1 "PM25,ug/m3,ATOTIJ,ug/m3,PM_TOT"              # PM2.5 Total Mass
 setenv AERO_2 "PM25,ug/m3,PMIJ_FRM,ug/m3,PM_FRM"          # PM2.5 Total Mass (I+J with FRM adjustment)
 setenv AERO_3 "PM10,ug/m3,ATOTIJK,ug/m3,PM10"       # PM10 Total Mass
 setenv AERO_4 "Isoprene,ppb,ISOP,ppb,Isoprene"            # Isoprene
 setenv AERO_5 "Ethylene,ppb,ETH,ppb,Ethylene"             # Ethene (Ethylene)
 setenv AERO_6 "Ethane,ppb,ETHA,ppb,Ethane"                # Ethane
 setenv AERO_7 "Toluene,ppb,TOL,ppb,Toluene"               # Toluene
 setenv AERO_8 "Acetaldehyde,ppb,ALD2,ppb,Acetaldehyde"    # Acetaldehyde
 setenv AERO_9 "Formaldehyde,ppb,FORM,ppb,Formaldehyde"    # Formaldehyde
 setenv AERO_10 "OC+OC_Blank,ug/m3,AOCIJ,ug/m3,OC"         # OC blank adjusted Mass
 setenv AERO_11 "EC,ug/m3,AECIJ,ug/m3,EC"                  # EC Mass
 setenv AERO_12 "OC+OC_Blank+EC,ug/m3,AOCIJ+AECIJ,,TC"     # Total Carbon
 setenv AERO_13 "Na,ug/m3, ANAIJ,,Na"                      # sodium
 setenv AERO_14 "Cl,ug/m3, ACLIJ,,Cl"                      # chlorine
 setenv AERO_15 "Na+Cl,ug/m3,ACLIJ+ANAIJ,,NaCl"            # sodium chloride
 setenv AERO_16 "SO4,ug/m3,ASO4IJ,ug/m3,SO4"               # PM2.5 Total Mass  
 setenv AERO_17 "NO3,ug/m3,ANO3IJ,ug/m3,NO3"               # PM2.5 Total Mass
 setenv AERO_18 "NH4,ug/m3,ANH4IJ,ug/m3,NH4"               # PM2.5 Total Mass
 
#> PM2.5 Sharp Cutoff Species
#> Requires preprocessing using setenv CCTM_APMDIAG file
 setenv AERO_19 "PM25,ug/m3,PM25_TOT,ug/m3,PM25_TOT"       # PM2.5 Total Mass with sharp cutoff
 setenv AERO_20 "PM25,ug/m3,PM25_FRM,,PM25_FRM"            # PM2.5 Total Mass (cutoff with FRM adjustment)
 setenv AERO_21 "SO4,ug/m3, PM25_SO4,,PM25_SO4"            # sulfate (sharp cutoff)
 setenv AERO_22 "NO3,ug/m3, PM25_NO3,,PM25_NO3"            # nitrate (sharp cutoff)
 setenv AERO_23 "NH4,ug/m3, PM25_NH4,,PM25_NH4"            # ammonium (sharp cutoff)
 setenv AERO_24 "OC+OC_Blank,ug/m3, PM25_OC,,PM25_OC"               # Organic Carbon (sharp cutoff)
 setenv AERO_25 "EC,ug/m3, PM25_EC,,PM25_EC"               # Elemental Carbon (sharp cutoff)
 setenv AERO_26 "OC+OC_Blank+EC,ug/m3,PM25_OC+PM25_EC,,PM25_TC"     # Total Carbon (sharp cutoff)
 
 #> setenv AERO6 species
 #> note we use Sodium Ion instead of sodium (XRF) becasue XRF is not reliable for sodium
 #> all other elemental concentrations (including Cl and K) come from XRF
  setenv AERO_27 "Fe,ug/m3, AFEJ,,Fe"         # iron
  setenv AERO_28 "Al,ug/m3,AALJ,,Al"          # aluminum 
  setenv AERO_29 "Si,ug/m3, ASIJ,,Si"         # silicon
  setenv AERO_30 "Ti,ug/m3, ATIJ,,Ti"         # titanium
  setenv AERO_31 "Ca,ug/m3,ACAJ,,Ca"          # calcium
  setenv AERO_32 "Mg,ug/m3,AMGJ,,Mg"          # magnesium
  setenv AERO_33 "K,ug/m3,AKJ,,K"             # potassium
  setenv AERO_34 "Mg,ug/m3,AMNJ,,Mn"          # manganese
  setenv AERO_35 "2.2*Al+2.49*Si+1.63*Ca+2.42*Fe+1.94*Ti,ug/m3,ASOILJ,,soil" 
  setenv AERO_36 "PM25-SO4-NO3-NH4-OC-EC-[Na]-[Cl]-2.2*Al-2.49*Si-1.63*Ca-2.42*Fe-1.94*Ti , ug/m3, AUNSPEC1IJ,,OTHER"        # PM Other
  setenv AERO_37 "0.8*OC,ug/m3, ANCOMIJ,,NCOM"    # PM Other
  setenv AERO_38 "PM25-SO4-NO3-NH4-OC-EC-[Na]-[Cl]-2.2*Al-2.49*Si-1.63*Ca-2.42*Fe-1.94*Ti-0.8*OC,ug/m3, AUNSPEC2IJ,,OTHER_REM"    # PM Other no NCOM

#>> End Species List <<#

# ~~~~~~~~~~~~ END NETWORK SPECIFIC SECTION ~~~~~~~~~~~~~~~~~~~~~~~~~

#> define time window
 set SDATE = "2016-07-01"    #> beginning date (July 1, 2016)
 set EDATE = "2016-07-14"  #> ending date    (July 14, 2016)
 setenv START_TIME 0      
 setenv END_TIME   230000   

#> Convert SDATE and EDATE to Julian day.
#> (required format for sitecmp START_DATE and END_DATE environment variables)
 setenv START_DATE `date -ud "${SDATE}" +%Y%j`
 setenv END_DATE `date -ud "${EDATE}" +%Y%j` 

#> define the PRECIP variable
 setenv PRECIP RT

#> adjust for daylight savings
 setenv APPLY_DLS N

#> set missing value string
 setenv MISSING '-999'

#> Projection sphere type (use type 20 to match WRF/CMAQ)
 setenv IOAPI_ISPH 20

#> Number of hours to add when retrieving time steps from M3_FILE_n files during processing.
#> This should only be non-zero if the M3_FILE_n files were pre-processed with a utility like m3tshift (default 0).
 setenv TIME_SHIFT 0

#############################################################
#  Input files
#############################################################

#> ioapi input files containing VNAMES (max of 10)
 setenv M3_FILE_1 ${CMAQ_DATA}/POST/COMBINE_ACONC_${RUNID}_201607.nc
         #[Add location of input file, e.g. COMBINE_ACONC file.]

#> SITE FILE containing site-id, longitude, latitude, and optionally 
#> GMT offset, state, county, and elevation (csv format)
#> The column headings for the required variables need to be 
#> stat_id, lon, and lat (case insensitive)
#> The column headings for the optional variables need to be
#> gmt_offset, state, county, and elevation (case insensitive)
#> This file can be downloaded from
#> https://github.com/USEPA/AMET/tree/master/obs/AQ/site_metadata_files
 setenv SITE_FILE AQS_full_site_list.csv
#> On EPA system:
#  setenv SITE_FILE /work/MOD3EVAL/aq_obs/routine/site_metadata_files/AQS_full_site_list.csv

#> input table containing site-id, time-period, and data fields
#> AQS obs data in the format needed for sitecmp are available 
#> from the CMAS Center Data clearinghouse under the heading "2000-2017 North American Air Quality Observation Data":
#> https://www.cmascenter.org/download/data.cfm
#> Hourly AQS observations are located in AMET12_OBSDATA_YYYY.tar.gz for year YYYY.
 setenv IN_TABLE AQS_daily_data_2016.csv
#> One EPA system:
#  setenv IN_TABLE /work/MOD3EVAL/aq_obs/routine/2016/AQS_daily_data_2016.csv

#############################################################
#  Output files
#############################################################

#> output table (comma delimited text file importable to Excel)
 setenv OUT_TABLE ${POSTDIR}/AQS_Daily_CMAQ_${RUNID}_201607.csv

#> Executable call:
 ${BINDIR}/${EXEC}

 set progstat = ${status}
 if ( ${progstat} ) then
   echo "ERROR ${progstat} in $BINDIR/$EXEC"
   exit( ${progstat} )
 endif
   
 exit()
