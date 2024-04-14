
-- Below are few samples used for analysis

-- Creating function for percent_variance --

create function get_percent_variance 
( @load_plan int , @load_process int)
returns decimal(8,2)
as 
begin
    declare @percent_variance decimal(8,2); 
    set @percent_variance = round((cast((@load_plan - @load_process) as decimal(8,2))*100)/@load_plan,2);
    return @percent_variance;
end

-- Creating a temporary table for process details--

with process_load as
(
select date_updated, load_plan, bag_closed, ( process_resort + process_rto + process_fm + process_misroute + semi_large) as load_process , process_resort, process_rto, process_fm, process_misroute, semi_large
from master_data
)
select *,(load_plan - load_process) as variance , dbo.get_percent_variance(load_plan,load_process) as percent_variance
into #process_details
from process_load

--Create a query for sum of process details in category wise and average % variance in monthly basis in year 2022 -- 

select month(date_updated) as date_month,year(date_updated) as date_year,SUM(load_plan) as load_plan,SUM(load_process) as load_process,sum(process_resort) as process_resort,sum(process_rto) as process_rto,sum(process_fm) as process_fm,sum(process_misroute) as process_misroute,sum(semi_large) as semi_large,avg(variance) as avg_variance,avg(percent_variance) as avg_percent_variance
from #process_details
group by month(date_updated),year(date_updated) having year(date_updated) = 2022

-- Creating a temporary table for manpower and IPP details--

with man_ipp as
(
select m.date_updated, (load_process/avail_manpower) as ipp, (p.load_process/p.bag_closed) as spb ,plan_manpower,avail_manpower,absent_manpower,dbo.get_percent_variance(plan_manpower,avail_manpower) as percent_absent
from master_data as m join #process_details as p
on m.date_updated = p.date_updated
)
select *
into #ipp_manpower_details
from man_ipp

--Create a query to find process details and date when ipp was highest--

Select top 1 m.date_updated,ipp,avail_manpower, process_resort,process_fm,process_rto,process_misroute,semi_large
from #ipp_manpower_details as m join #process_details as p
on m.date_updated = p.date_updated 
order by ipp desc

--Create a query to find date and ipp when resort was highest--

Select top 1 m.date_updated,ipp,avail_manpower, process_resort
from #ipp_manpower_details as m join #process_details as p
on m.date_updated = p.date_updated 
order by process_resort desc

--Create a query to find date and ipp when market(fm) was highest--

Select top 1 m.date_updated,ipp,avail_manpower,process_fm
from #ipp_manpower_details as m join #process_details as p
on m.date_updated = p.date_updated 
order by process_fm desc

--Create a query to find date and ipp when processed load was highest--

Select top 1 m.date_updated,ipp,avail_manpower,load_process
from #ipp_manpower_details as m join #process_details as p
on m.date_updated = p.date_updated 
order by load_process desc

-- Create a query for spb as (high (>45), acceptable (35-45) , low ( <35). Count no of days spb was high , low and acceptable in specific month in that year--
with spb_table as
(
select * ,
case
    when spb < 35 then 'low'
	when spb between 35 and 45 then 'acceptable'
	when spb > 45 then 'high'
	else 'invalid'
end as spb_bin
from #ipp_manpower_details
)
select spb_bin, count(spb_bin) as spb_count
from spb_table
where month(date_updated) = 1 and year(date_updated) = 2022
group by spb_bin


-- Creating a temporary table for inbound and outbound details--

with ib_ob as
(
select date_updated, 
(ib_crossshipments + ib_fmshipments + ib_misrouteshipments+ib_resortshipments+ib_rtoshipments+ib_semilarge) as ib_shipments,
ib_crossshipments,
ib_fmshipments,
ib_misrouteshipments,
ib_resortshipments,
ib_rtoshipments,
ib_semilarge,
(ib_crossshipments/ib_crossbags) as spb_cross,
(ib_fmshipments/ib_fmbags) as spb_fm,
(ib_resortshipments/ib_resortbags) as spb_resort,
(ib_rtoshipments/ib_rtobags) as spb_rto,
(ob_shipments/ob_bags) as spb_ob,
ob_shipments
from master_data
)
select *
into #ib_ob_details
from ib_ob

-- Create report for MIS reports ( Process , Manpower and IB & OB details )--

SELECT 
    p.[date_updated],
    p.[load_plan],
    p.load_process,
    p.[process_resort],
    p.[process_rto],
    p.[process_fm],
    p.[process_misroute],
    p.[semi_large],
    p.variance,
    p.percent_variance,
    m.ipp,
    m.spb,
    m.plan_manpower,
    m.avail_manpower,
    m.percent_absent,
    ib.[ib_resortshipments],
    ib.[ib_crossshipments],
    ib.[ib_rtoshipments],
    ib.[ib_misrouteshipments],
    ib.[ib_fmshipments],
    ib.[ib_semilarge],
    ib.ib_shipments,
    ib.ob_shipments,
    ib.spb_ob
INTO mis_report
FROM 
    #process_details AS p 
JOIN 
    #ipp_manpower_details AS m ON p.date_updated = m.date_updated
JOIN 
    #ib_ob_details AS ib ON p.date_updated = ib.date_updated

create view mis_report_view as
(
select * from mis_report
)
drop table mis_report