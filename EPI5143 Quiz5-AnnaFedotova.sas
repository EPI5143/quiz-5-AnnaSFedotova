libname classdat '/folders/myfolders/classdata';
run;

*Sorted the admissions*

data diabetes;
set classdat.nhrabstracts;
keep hraEncWID hraAdmDtm;
proc sort = classdat.nhrabstracts out=diabetes;
by hraEncWID;
run;

*sorted the admissions and changed the date/time format for sorting*

data diabetes;
set classdat.nhrabstracts;
date = datepart (hraAdmDtm);
format date date9.;
keep hraEncWID hraAdmDtm date;
where date between '01JAN2003'd and '31DEC2004'd;
run;

*'attempted' to create an indicator variable for diabetes diagnosis*

data diabetes_diagnoses;
set classdat.nhrdiagnosis;
if hdgcd in:('250' 'E10' 'E11')
then DM=1 else DM=0;
run;

*'attempted' to flat-file the diagnoses dataset by the encounter IDs*

data diabetes_diagnoses;
set classdat.nhrdiagnoses;
proc sort = classdat.nhrabstracts out = diabetes_diagnoses;
by hdgHraEncWID;
run;

*'attempted' to rename the encounter ID variable to be consistent across databases for linking*

data encounterIDs;
set classdat.nhrdiagnoses;
proc sort data = classdat.nhrdiagnoses out = encounterIDs (rename = hdgHraEncWID=hraEncWID);
run;

*'attempted' to link the two datasets together'*

data new;
merge diabetes diabetes_diagnoses;
by hraEncWID;
run;

**Unfortunately I did not get the right code, but hope I got the right idea...**