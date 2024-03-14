create database Project3;
use Project3;
create table users(
user_id	int,
created_at	varchar(100),
company_id	int,
language	varchar(50),
activated_at varchar(100),
state varchar(50));
SHOW variables LIKE 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
INTO TABLE users
FIELDS terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 ROWS;

SELECT * FROM users;

alter table users add column temp_created_at datetime;
UPDATE users SET temp_created_at = str_to_date(created_at,'%d-%m-%Y %H:%i');
alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;

alter table users add column temp_activated_at datetime;
UPDATE users SET temp_activated_at = str_to_date(activated_at,'%d-%m-%Y %H:%i');
alter table users drop column activated_at;
alter table users change column temp_activated_at activated_at datetime;

CREATE TABLE `events`(
user_id	INT NULL,
occurred_at	VARCHAR(100) NULL,
event_type	VARCHAR(50) NULL,
event_name	VARCHAR(100) NULL,
location VARCHAR(50) NULL,
device VARCHAR(50) NULL,
user_type INT NULL);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
INTO TABLE `events`
FIELDS terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 ROWS;

select * from `events`;

alter table `events` add column temp_occurred_at datetime;
UPDATE `events` SET temp_occurred_at = str_to_date(occurred_at,'%d-%m-%Y %H:%i');
alter table `events` drop column occurred_at;
alter table `events` change column temp_occurred_at occurred_at datetime;

create table emailEvents(
user_id	int,
occurred_at VARCHAR(100),
action VARCHAR(100),
user_type INT);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
INTO TABLE emailEvents
FIELDS terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 ROWS;

select * from emailEvents;

alter table emailEvents add column temp_occurred_at datetime;
UPDATE emailEvents SET temp_occurred_at = str_to_date(occurred_at,'%d-%m-%Y %H:%i');
alter table emailEvents drop column occurred_at;
alter table emailEvents change column temp_occurred_at occurred_at datetime;