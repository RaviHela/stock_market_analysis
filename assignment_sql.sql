
#CSV files were imported using SQL Import wizard. Only relvant columns were exported for the
#purpose of this Assignment.

#############################################################################################
#please run the codes sequentially to get desired results as per assignment.
#############################################################################################

#############################################################################################
#checking if there are unique Dates in each row of the imported table;
select str_to_date(Date, '%d-%M-%Y') as Date,
count(Date) as counts
from `bajaj auto` 
group by Date
having counts > 1;

select str_to_date(Date, '%d-%M-%Y') as Date,
count(Date) as counts
from `eicher motors` 
group by Date
having counts > 1;

select str_to_date(Date, '%d-%M-%Y') as Date,
count(Date) as counts
from `hero motocorp`
group by Date
having counts > 1;

select str_to_date(Date, '%d-%M-%Y') as Date,
count(Date) as counts
from infosys
group by Date
having counts > 1;

select str_to_date(Date, '%d-%M-%Y') as Date,
count(Date) as counts
from tcs
group by Date
having counts > 1;

select str_to_date(Date, '%d-%M-%Y') as Date,
count(Date) as counts
from `tvs motors`
group by Date
having counts > 1;

#all the tables have unique dates in the Date row. can be used as primary key
# for join operations later.

#############################################################################################
#creating stock1 tables

#create bajaj1
create table bajaj1
select str_to_date(Date, '%d-%M-%Y') as "Date", round(`Close Price`, 2) as "Close Price",
round(avg(`Close Price`) over(rows 19 preceding), 2) as "20 Day MA",
round(avg(`Close Price`) over(rows 49 preceding), 2) as "50 Day MA"
from `bajaj auto` order by Date;

alter table bajaj1
add primary key(Date);

#create eicher1
create table eicher1
select str_to_date(Date, '%d-%M-%Y') as "Date", round(`Close Price`, 2) as "Close Price",
round(avg(`Close Price`) over(rows 19 preceding), 2) as "20 Day MA",
round(avg(`Close Price`) over(rows 49 preceding), 2) as "50 Day MA"
from `eicher motors` order by Date;

alter table eicher1
add primary key(Date);


#create hero1
create table hero1
select str_to_date(Date, '%d-%M-%Y') as "Date", round(`Close Price`, 2) as "Close Price",
round(avg(`Close Price`) over(rows 19 preceding), 2) as "20 Day MA",
round(avg(`Close Price`) over(rows 49 preceding), 2) as "50 Day MA"
from `hero motocorp` order by Date;

alter table hero1
add primary key(Date);


#create infosys11
create table infosys1
select str_to_date(Date, '%d-%M-%Y') as "Date", round(`Close Price`, 2) as "Close Price",
round(avg(`Close Price`) over(rows 19 preceding), 2) as "20 Day MA",
round(avg(`Close Price`) over(rows 49 preceding), 2) as "50 Day MA"
from infosys order by Date;

alter table infosys1
add primary key(Date);

#create tcs1
create table tcs1
select str_to_date(Date, '%d-%M-%Y') as "Date", round(`Close Price`, 2) as "Close Price",
round(avg(`Close Price`) over(rows 19 preceding), 2) as "20 Day MA",
round(avg(`Close Price`) over(rows 49 preceding), 2) as "50 Day MA"
from tcs order by Date;

alter table tcs1
add primary key(Date);

#create tvs1
create table tvs1
select str_to_date(Date, '%d-%M-%Y') as "Date", round(`Close Price`, 2) as "Close Price",
round(avg(`Close Price`) over(rows 19 preceding), 2) as "20 Day MA",
round(avg(`Close Price`) over(rows 49 preceding), 2) as "50 Day MA"
from `tvs motors` order by Date;

alter table tvs1
add primary key(Date);

#############################################################################################
#creating master tables
create table master
select b.Date,
 b.`Close Price` as "Bajaj", tc.`Close Price` as "TCS",
 tv.`Close Price` as "TVS", i.`Close Price` as "Infosys",
 e.`Close Price` as "Eicher", h.`Close Price` as "Hero"
	from bajaj1 as b inner join tcs1 as tc
					 inner join tvs1 as tv
                     inner join infosys1 as i
                     inner join eicher1 as e
                     inner join hero1 as h
	where b.Date = tc.Date
	and   b.Date = tv.Date
    and   b.Date = i.Date
    and	  b.Date = e.Date
    and   b.Date = h.Date;
					
#############################################################################################
#STRATEGY:cretae a column flag. whenever 20 Day MA crosses 50 Day MA, mark 1, 0 otherwise
#		Also create a column trend denoting if 20 Day MA is up/down or same as 50 Day MA.
#		The average of the flag value of the row and the row above combined with
#		up/down value of the trend in the row indicates a golden/death cross.

#creating bajaj2
create table bajaj2
select Date, `Close Price`, 
	case when flag = 0.5 and trend  = "up" then "buy"
		 when flag = 0.5 and trend =  "down" then "sell"
		 else "hold"
	end as "Signal"
		from (select *, 
		case when(`20 Day MA` > `50 Day MA`) then "up"
			 when(`20 Day MA` = `50 Day MA`) then "same"
			 else "down"
		end as "trend",
		#(`20 Day MA` > `50 Day MA`)  as "change",  
		avg(`20 Day MA` > `50 Day MA`) over (rows 1 preceding ) as "flag",
        row_number() over(order by Date) as rownum
		from bajaj1) as temp
        where rownum > 49;

#creating eicher2        
create table eicher2
select Date, `Close Price`, 
	case when flag = 0.5 and trend  = "up" then "buy"
		 when flag = 0.5 and trend =  "down" then "sell"
		 else "hold"
	end as "Signal"
		from (select *, 
		case when(`20 Day MA` > `50 Day MA`) then "up"
			 when(`20 Day MA` = `50 Day MA`) then "same"
			 else "down"
		end as "trend",
		#(`20 Day MA` > `50 Day MA`)  as "change",  
		avg(`20 Day MA` > `50 Day MA`) over (rows 1 preceding ) as "flag",
        row_number() over(order by Date) as rownum
		from eicher1) as temp
        where rownum > 49;
        
#creating hero2
create table hero2
select Date, `Close Price`, 
	case when flag = 0.5 and trend  = "up" then "buy"
		 when flag = 0.5 and trend =  "down" then "sell"
		 else "hold"
	end as "Signal"
		from (select *, 
		case when(`20 Day MA` > `50 Day MA`) then "up"
			 when(`20 Day MA` = `50 Day MA`) then "same"
			 else "down"
		end as "trend",
		#(`20 Day MA` > `50 Day MA`)  as "change",  
		avg(`20 Day MA` > `50 Day MA`) over (rows 1 preceding ) as "flag",
        row_number() over(order by Date) as rownum
		from hero1) as temp
        where rownum > 49;


#creating infosys2
create table infosys2
select Date, `Close Price`, 
	case when flag = 0.5 and trend  = "up" then "buy"
		 when flag = 0.5 and trend =  "down" then "sell"
		 else "hold"
	end as "Signal"
		from (select *, 
		case when(`20 Day MA` > `50 Day MA`) then "up"
			 when(`20 Day MA` = `50 Day MA`) then "same"
			 else "down"
		end as "trend",
		#(`20 Day MA` > `50 Day MA`)  as "change",  
		avg(`20 Day MA` > `50 Day MA`) over (rows 1 preceding ) as "flag",
        row_number() over(order by Date) as rownum
		from infosys1) as temp
        where rownum > 49;
        
#creating tcs2
create table tcs2
select Date, `Close Price`, 
	case when flag = 0.5 and trend  = "up" then "buy"
		 when flag = 0.5 and trend =  "down" then "sell"
		 else "hold"
	end as "Signal"
		from (select *, 
		case when(`20 Day MA` > `50 Day MA`) then "up"
			 when(`20 Day MA` = `50 Day MA`) then "same"
			 else "down"
		end as "trend",
		#(`20 Day MA` > `50 Day MA`)  as "change",  
		avg(`20 Day MA` > `50 Day MA`) over (rows 1 preceding ) as "flag",
        row_number() over(order by Date) as rownum
		from tcs1) as temp
        where rownum > 49;
        
#creating tvs2
create table tvs2
select Date, `Close Price`, 
	case when flag = 0.5 and trend  = "up" then "buy"
		 when flag = 0.5 and trend =  "down" then "sell"
		 else "hold"
	end as "Signal"
		from (select *, 
		case when(`20 Day MA` > `50 Day MA`) then "up"
			 when(`20 Day MA` = `50 Day MA`) then "same"
			 else "down"
		end as "trend",
		#(`20 Day MA` > `50 Day MA`)  as "change",  
		avg(`20 Day MA` > `50 Day MA`) over (rows 1 preceding ) as "flag",
        row_number() over(order by Date) as rownum
		from tvs1) as temp
        where rownum > 49;
        
#############################################################################################
#create procedure getSignal

delimiter $$
create procedure getSignalBajaj
(in dt varchar(10), out Sign varchar(4))
begin

select
 if(str_to_date(dt, '%d-%m-%Y') in (select `Date` from bajaj2),
	(select `Signal` from bajaj2 where `Date` = str_to_date(dt, '%d-%m-%Y')),
	"Date Doesn't exist") 
as Sign;
end
$$
delimiter ;

#call procedure, Input to be made in dd-mm-yyyy format.
call getSignalBajaj("20-01-2016", @Sign);

