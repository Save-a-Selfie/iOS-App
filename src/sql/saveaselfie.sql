create database saveaselfie;

create table users
(
	name text not null primary key
);

create table photos
(
	id serial not null primary key,

	-- GPS data
	latitude numeric not null,
	longitude numeric not null,

	image text not null,
	thumbnail text not null,

	uploadedby text,
	comment text
);

create view photo_count as 
    select uploadedby as user, count(*) as count from photos
	group by uploadedby;
