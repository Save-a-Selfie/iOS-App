create table users
(
	name text not null primary key
);

create table photos
(
	id integer not null primary key,

	-- GPS data
	latitude numeric not null,
	longitude numeric not null,

	image bytea not null,
	thumbnail bytea not null,

	uploadedby text not null references users(name),
	comment text
);

create view photo_count as 
    select uploadedby as user, count(*) as count from photos
	group by uploadedby;
