#USE "USINGIMPORT DB"
#1. Import the data from the dataset provided to a table in MySQL.
--Answer
--right click on database and select table data import wizard and browse the file 
--and click next give table name if exists click drop table if exists and next, next,next,next and finish.

#2. Write a query that retrieves every row from the table and add a column to generate a ranking based 
#on the tot_sales column values. The highest value should receive a ranking of 1, and 
#the lowest a ranking of 24. Export the result set to a csv file.
select * from sql301w1assignmentdataset;
select *,rank() over(order by tot_sales desc) ranking from sql301w1assignmentdataset;

#3. Modify the query from the previous exercise to generate two sets of rankings 
#from 1 to 12 for 2019 data and one for 2020.Export the result set to a csv file.
select *,rank() over(partition by year_no order by tot_sales desc) set_of_ranking from sql301w1assignmentdataset; 

#4. Write a query that retrieves all 2020 data, and include a column that contains 
#the tot_sales value from the previous month. Export the result set to a csv file.
select *,lag(tot_sales,1,tot_sales) over(order by month_no) salevales from sql301w1assignmentdataset
	where year_no=2020;

#5. Create a table of students belonging to the mechanical department mech_stud (id, name, branch) 
#and create a before insert trigger raising error if you want to insert a student with a different branch.
create table mech_stud(id int primary key auto_increment,
	fullname varchar(100),branch varchar(100) not null);
delimiter //
create trigger beforeinsert before insert on mech_stud for each row
	if new.branch<> 'mech' then
    signal sqlstate '50001' set message_text = "Person doesn't belong to mechanical class";
    end if;//
insert into mech_stud(fullname,branch) values ('abc','mech');
select * from mech_stud;
insert into mech_stud(fullname,branch) values ('xyz','ece');