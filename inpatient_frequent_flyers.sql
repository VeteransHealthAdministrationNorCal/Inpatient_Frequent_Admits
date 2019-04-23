;with tbl1 as (
select top (50)
	spatient.patientsid
	,inpatient.sta3n 
	,count(inpatient.admitdatetime) as admitcount
from
	cdwwork.bisl_r1vx.ar3y_inpat_inpatient as inpatient
	inner join cdwwork.bisl_r1vx_spatient.ar3y_spatient_spatient as spatient
		on inpatient.patientsid = spatient.patientsid
		and inpatient.sta3n = spatient.sta3n
where
	inpatient.sta3n = 612
	and inpatient.admitdatetime between cast(dateadd(year, -1, getdate()) AS datetime) and getdate()
group by
	spatient.patientsid
	,inpatient.sta3n
order by
	admitcount desc
)
select distinct
	spatient.patientname
	,spatient.patientssn
	,tbl1.admitcount
	,inpatient.admitdatetime
	,can.cmort_1y
	,can.pmort_1y
from
	tbl1
	inner join cdwwork.bisl_r1vx.ar3y_inpat_inpatient as inpatient
		on tbl1.patientsid = inpatient.patientsid
		and tbl1.sta3n = inpatient.sta3n
	inner join cdwwork.bisl_r1vx_spatient.ar3y_spatient_spatient as spatient
		on inpatient.patientsid = spatient.patientsid
		and inpatient.sta3n = spatient.sta3n
	left join d05_visn21sites.lsv.mac_canscore_latest as can
		on spatient.patientsid = can.patient_sid
where
	inpatient.admitdatetime between cast(dateadd(year, -1, getdate()) AS datetime) and getdate()
order by
	admitcount desc