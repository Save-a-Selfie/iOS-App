create table users
(
	name text not null primary key
);

create type latref as enum ('E', 'W');
create type longref as enum ('N', 'S');

create table photos
(
	id integer not null primary key,

	-- GPS data
	latituderef latref not null,
	latdegrees integer not null,
	latminutes integer not null,
	latseconds numeric not null,
	longituderef longref not null,
	longdegrees integer not null,
	longminutes integer not null,
	longseconds numeric not null,

	image bytea not null,

	uploadedby text not null references users(name),
	comment text
);
