DROP TABLE IF EXISTS temp_calendar;
DROP TABLE IF EXISTS temp_listings;
DROP TABLE IF EXISTS temp_reviews;

CREATE TABLE temp_calendar (data jsonb);
CREATE TABLE temp_listings (data jsonb);
CREATE TABLE temp_reviews (data jsonb);

\COPY temp_calendar (data) FROM 'C:\labfiles\microsoft-postgres-docs-project\artifacts\data\calendar.json';
\COPY temp_listings (data) FROM 'C:\labfiles\microsoft-postgres-docs-project\artifacts\data\listings.json';
\COPY temp_reviews (data) FROM 'C:\labfiles\microsoft-postgres-docs-project\artifacts\data\reviews.json';    

DROP TABLE IF EXISTS listings;
DROP TABLE IF EXISTS calendar;
DROP TABLE IF EXISTS reviews;

CREATE TABLE listings (
    listing_id int,
    name varchar(50),
    street varchar(50),
    city varchar(50),
    state varchar(50),
    country varchar(50),
    zipcode varchar(50),
    bathrooms int,
    bedrooms int,
    latitude decimal(10,5), 
    longitude decimal(10,5), 
    summary varchar(2000),
    description varchar(2000),
    host_id varchar(2000),
    host_url varchar(2000),
    listing_url varchar(2000),
    room_type varchar(2000),
    amenities jsonb,
    host_verifications jsonb,
    data jsonb);

CREATE TABLE reviews (
    id int, 
    listing_id int, 
    reviewer_id int, 
    reviewer_name varchar(50), 
    date date,
    comments varchar(2000)
    );

CREATE TABLE calendar (
    listing_id int, 
    date date,
    price decimal(10,2), 
    available varchar(50)
    );

INSERT INTO listings
SELECT 
    data['id']::int, 
    replace(data['name']::varchar(50), '"', ''),
    replace(data['street']::varchar(50), '"', ''),
    replace(data['city']::varchar(50), '"', ''),
    replace(data['state']::varchar(50), '"', ''),
    replace(data['country']::varchar(50), '"', ''),
    replace(data['zipcode']::varchar(50), '"', ''),
    data['bathrooms']::int,
    data['bedrooms']::int,
    data['latitude']::decimal(10,5),
    data['longitude']::decimal(10,5),
    replace(data['description']::varchar(2000), '"', ''),        
    replace(data['summary']::varchar(2000), '"', ''),        
    replace(data['host_id']::varchar(50), '"', ''),
    replace(data['host_url']::varchar(50), '"', ''),
    replace(data['listing_url']::varchar(50), '"', ''),
    replace(data['room_type']::varchar(50), '"', ''),
    data['amenities']::jsonb,
    data['host_verifications']::jsonb,
    data::jsonb
FROM temp_listings;    

INSERT INTO reviews
SELECT 
    data['id']::int,
    data['listing_id']::int,
    data['reviewer_id']::int,
    replace(data['reviewer_name']::varchar(50), '"', ''), 
    to_date(replace(data['date']::varchar(50), '"', ''), 'YYYY-MM-DD'),
    replace(data['comments']::varchar(2000), '"', '')
FROM temp_reviews;

INSERT INTO calendar
SELECT 
    data['listing_id']::int,
    to_date(replace(data['date']::varchar(50), '"', ''), 'YYYY-MM-DD'),
    data['price']::decimal(10,2),
    replace(data['available']::varchar(50), '"', '')
FROM temp_calendar;