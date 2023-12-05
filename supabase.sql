


/* 
    supabase uses row level security to control access to data.
*/

-- delete from auth.users cascade;
-- delete from auth.identities cascade;

/* {"email": "1@gmail.com", "password": "password"} */
/* d110f923-d96a-4f83-983b-3a2ff535877f */
/* {"email": "2@gmail.com", "password": "password"} */
/* 98419d5e-4a52-49f4-9360-5404ca5d6a19 */
/* {"email": "3@gmail.com", "password": "password"} */
/* c3572b42-7a9d-436f-8f23-26e921793014 */
/* {"email": "4@gmail.com", "password": "password"} */
/* 898739e2-4838-469b-bbcd-ca81f4dd1859 */
/* {"email": "5@gmail.com", "password": "password"} */
/* c75beab2-f104-4cc5-a726-9ef7e7d6e710 */
/* {"email": "6@gmail.com", "password": "password"} */
/* 8e1202e0-8476-478e-93e1-2446821ab2f7 */
/* {"email": "7@gmail.com", "password": "password"} */
/* f0eb9d63-0510-41a6-a328-aca7b2c7fffa */
/* {"email": "8@gmail.com", "password": "password"} */
/* 35930fef-99ff-4adc-9355-36b539b402f3 */
/* {"email": "9@gmail.com", "password": "password"} */
/* 948916cb-23e8-4f92-bb2c-a0999f6440d9 */
/* {"email": "10@gmail.com", "password": "password"} */
/* f78f125b-ec1e-4dfa-9d21-532d59165cb2 */
/* {"email": "11@gmail.com", "password": "password"} */
/* 6a695c39-8100-4881-9fd6-82742aa1305b */
/* {"email": "12@gmail.com", "password": "password"} */
/* 7a6a03d5-5902-4249-8d7e-2aa040f447b7 */
/* {"email": "13@gmail.com", "password": "password"} */
/* 5a048db3-080a-448f-ae76-483dcf3ea894 */
/* {"email": "14@gmail.com", "password": "password"} */
/* 0d3a14e3-6229-4fc3-b8b2-98be036c99e6 */
/* {"email": "15@gmail.com", "password": "password"} */
/* b849afc0-8f94-47a3-a3bc-b86a36c797de */

-- create view public.users as
-- select id, email, role, email_confirmed_at, last_sign_in_at, created_at, updated_at, phone, is_sso_user, deleted_at from auth.users;
-- revoke all on public.users from anon, authenticated;



drop table if exists airport cascade;
create table airport (
    name varchar(128) primary key,
    city varchar(128)
);
insert into airport (name, city)
    values 
    ('jfk', 'new york city'),
    ('pvg', 'shanghai');



drop table if exists airline cascade;
create table airline (
    name varchar(128) primary key unique
);
insert into airline (name)
    values 
    ('china eastern'),
    ('american airlines');



drop table if exists airplane cascade;
create table airplane (
    airline_name varchar(128) references airline(name),
    airplane_id varchar(128),
    seats integer,
    primary key (airline_name, airplane_id)
);
insert into airplane (airline_name, airplane_id, seats)
    values 
    ('china eastern', 'a1', 7),
    ('china eastern', 'a2', 5),
    ('american airlines', 'b1', 20),
    ('american airlines', 'b2', 50);



drop table if exists flight cascade;
create table flight (
    airline_name varchar(128) references airline(name),
    flight_number varchar(128),
    primary key (airline_name, flight_number),

    airplane_id varchar(128),
    foreign key (airline_name, airplane_id) 
        references airplane(airline_name, airplane_id),

    departure_airport varchar(128) references airport(name),
    arrival_airport varchar(128) references airport(name),
    departure_time timestamp,
    arrival_time timestamp,

    price float,
    seats_ordered integer default 0,
    curr_status varchar(128) default 'upcoming' 
        check (curr_status in ('upcoming', 'in-progress', 'delayed', 'canceled', 'completed'))
);
create index idx_flight_departure_time on flight (departure_time);
create index idx_flight_arrival_time on flight (arrival_time);
create index idx_flight_departure_airport on flight (departure_airport);
create index idx_flight_arrival_airport on flight (arrival_airport);
create index idx_flight_curr_status on flight (curr_status);
insert into flight (seats_ordered, airline_name, flight_number, airplane_id, departure_airport, arrival_airport, departure_time, arrival_time, price, curr_status)
    values 
    (6, 'china eastern', 'mu123', 'a1', 'jfk', 'pvg', '2021-01-01 00:00:00', '2021-01-02 00:00:00', 100, 'upcoming'),
    (0, 'china eastern', 'mu456', 'a2', 'jfk', 'pvg', '2022-02-02 00:00:00', '2021-01-02 00:00:00', 100, 'upcoming'),
    (0, 'american airlines', 'aa123', 'b1', 'jfk', 'pvg', '2022-02-03 00:00:00', '2021-01-02 00:00:00', 100, 'upcoming'),
    (0, 'american airlines', 'aa456', 'b2', 'jfk', 'pvg', '2022-02-03 00:00:00', '2021-01-02 00:00:00', 100, 'upcoming');



/*  now we will use supabase uuid.
    supabase handles authentication for us.
    it supports email, phone, google, github login, etc.
    we can fetch email, password through supabase uuid.

    i have inserted users 1@gmail.com ... 14@gmail.com, with password 'password'
*/

/* {"email": "1@gmail.com", "password": "password"} */
/* d110f923-d96a-4f83-983b-3a2ff535877f */
/* {"email": "2@gmail.com", "password": "password"} */
/* 98419d5e-4a52-49f4-9360-5404ca5d6a19 */
/* {"email": "3@gmail.com", "password": "password"} */
/* c3572b42-7a9d-436f-8f23-26e921793014 */
/* {"email": "4@gmail.com", "password": "password"} */
/* 898739e2-4838-469b-bbcd-ca81f4dd1859 */
/* {"email": "5@gmail.com", "password": "password"} */
/* c75beab2-f104-4cc5-a726-9ef7e7d6e710 */

create or replace function uuid_for(email integer) returns uuid as $$
    select id from auth.users where email = concat($1::varchar(128), '@nyu.edu');
$$ language sql;



drop table if exists customer cascade;
create table customer (
    id uuid primary key references auth.users(id),
    name varchar(128),
    building_number varchar(128),
    street varchar(128),
    city varchar(128),
    state varchar(128),
    phone_number varchar(128),
    passport_number varchar(128),
    passport_expiration date,
    passport_country varchar(128),
    date_of_birth date
);
insert into customer (id, name, building_number, street, city, state, phone_number, passport_number, passport_expiration, passport_country, date_of_birth)
    values 
    (uuid_for(1), 'customer1 name', '1', '1', '1', '1', '1', '1', '2021-01-01', '1', '2000-01-01'),
    (uuid_for(2), 'customer2 name', '1', '1', '1', '1', '1', '1', '2021-01-01', '1', '2000-01-01');


drop table if exists booking_agent cascade;
create table booking_agent (
    id uuid primary key references auth.users(id)
);
insert into booking_agent (id)
    values 
    (uuid_for(3)),
    (uuid_for(4));



/* one booking agent can work for multiple. n-to-n relationship */
drop table if exists works_for cascade;
create table works_for (
    id uuid references auth.users(id),
    airline_name varchar(128) references airline(name),
    primary key (id, airline_name)
);
insert into works_for (id, airline_name)
    values 
    (uuid_for(3), 'china eastern'),
    (uuid_for(4), 'china eastern'),
    (uuid_for(4), 'american airlines');



drop table if exists airline_staff cascade;
create table airline_staff (
    id uuid primary key references auth.users(id),
    airline_name varchar(128) references airline(name),
    first_name varchar(128),
    last_name varchar(128),
    date_of_birth date,
    permission varchar(32) default 'not invited' 
        check (permission in ('not invited', 'normal', 'operator', 'admin'))
);
insert into airline_staff (id, airline_name, first_name, last_name, date_of_birth, permission)
    values 
    (uuid_for(5), 'china eastern', 'airlinestaff1 first name', 'airlinestaff1 last name', '2000-01-01', 'admin'),
    (uuid_for(6), 'china eastern', 'airlinestaff2 first name', 'airlinestaff2 last name', '2000-01-01', 'operator'),
    (uuid_for(7), 'american airlines', 'airlinestaff3 first name', 'airlinestaff3 last name', '2000-01-01', 'admin'),
    (uuid_for(8), 'american airlines', 'airlinestaff4 first name', 'airlinestaff4 last name', '2000-01-01', 'not invited');



drop table if exists ticket cascade;
create table ticket (
    ticket_id serial primary key,
    airline_name varchar(128),
    flight_number varchar(128),
    foreign key (airline_name, flight_number) 
        references flight(airline_name, flight_number),
    
    /* 
    if customers purchased  s directly, agent_id is null, customer_id is not null.
    if agents purchased tickets for customers, both agent_id and customer_id are not null.
    */
    customer_id uuid not null references auth.users(id),
    agent_id uuid references auth.users(id),
    date date
);
insert into ticket (airline_name, flight_number, customer_id, agent_id, date)
    values 
    ('china eastern', 'mu123', uuid_for(1), null, '2021-01-01'),
    ('china eastern', 'mu123', uuid_for(2), null, '2021-01-01'),
    ('china eastern', 'mu123', uuid_for(1), uuid_for(3), '2021-01-01'),
    ('china eastern', 'mu123', uuid_for(2), uuid_for(3), '2021-01-01'),
    ('china eastern', 'mu123', uuid_for(1), uuid_for(4), '2021-01-01'),
    ('china eastern', 'mu123', uuid_for(2), uuid_for(4), '2021-01-01');




/* 
auth.uid is provided by supabase. 
it is the uuid of the current user. 
supabase allows limited sql grammar in the front end, (similar to graphql)
but this is secure, since for tables with row-level-security enabled,
supabase client apps can only see rows where some policy is true.
and they will get an error when changing disallowed rows.
*/
create or replace function hello_world() returns varchar(128) as $$
    select 'hello world'
$$ language sql;

select * from hello_world();

create or replace function get_uid() returns uuid as $$
    select auth.uid()
$$ language sql;

create or replace function get_jwt() returns varchar(128) as $$
    select auth.jwt()
$$ language sql;


create or replace function is_role(role varchar(128)) returns boolean as $$
    select exists (
        select * from airline_staff s
        where 
        s.id = auth.uid()
        and s.permission = is_role.role
    );
$$ language sql;

create or replace function in_airline(airline_name varchar(128)) returns boolean as $$
    select exists (
        select * from airline_staff s
        where 
        s.id = auth.uid()
        and s.airline_name = in_airline.airline_name
    );
$$ language sql;

alter table airport enable row level security;
create policy anyone_view_airport on airport for select to public using (true);
create policy admin_edit_airport  on airport for all 
using (is_role('admin')) with check (is_role('admin'));

alter table airline enable row level security;
create policy anyone_view_airline on airline for select using (true);
create policy admin_edit_airline  on airline for all 
using (is_role('admin')) with check (is_role('admin'));


alter table airplane enable row level security;
create policy anyone_view_airplane on airplane for select using (true);
create policy admin_edit_airplane_of_their_airline on airplane for all 
using (is_role('admin') and in_airline(airline_name))
with check (is_role('admin') and in_airline(airline_name));

alter table flight enable row level security;
create policy anyone_view_flight on flight for select using (true);
create policy admin_edit_flight_of_their_airline on flight for all 
using (is_role('admin') and in_airline(airline_name))
with check (is_role('admin') and in_airline(airline_name));


    

create or replace function operator_edit_status(
    airline_name varchar(128), 
    flight_number varchar(128), 
    new_status varchar(128)
) 
returns void language plpgsql
security definer
as $$
begin
    if not exists (
        select * from airline_staff s
        where 
        s.permission = 'operator' and s.id = auth.uid()
        and s.airline_name = operator_edit_status.airline_name
    ) then
        raise exception 'you are not an operator of this airline.';
    end if;

    update flight f
    set curr_status = new_status
    where f.airline_name = operator_edit_status.airline_name
    and f.flight_number = operator_edit_status.flight_number;
end;
$$;







alter table ticket enable row level security;
create policy anyone_view_ticket on ticket for select using (true);

create policy customer_edit_their_ticket on ticket for all
using (customer_id = auth.uid())
with check (customer_id = auth.uid());

create policy agent_edit_their_ticket on ticket for all
using (agent_id = auth.uid())
with check (agent_id = auth.uid());

create or replace function 
search_uid_by_email(email varchar(128)) returns uuid 
security definer 
as $$
    select id from auth.users 
    where position(search_uid_by_email.email in auth.users.email) > 0
    limit 1;
$$ language sql;

create or replace function purchase_ticket(
    _airline_name varchar(128), 
    _flight_number varchar(128),
    -- nullable:
    agent_id uuid default null,
    customer_id uuid default null
) 
returns void language plpgsql
security definer
as $$
begin
    -- check if flight is full
    if not exists (
        select * from flight f
        where 
        f.airline_name = _airline_name
        and f.flight_number = _flight_number
        and f.seats_ordered < (
            select seats from airplane a
            where a.airline_name = f.airline_name
            and a.airplane_id = f.airplane_id
        )
    ) then
        raise exception 'this flight is full.';
    end if;

    -- if booking agent is specified
    -- check if agent works for the airline
    if agent_id is not null then
        if not exists (
            select * from works_for w
            where w.id = agent_id
            and w.airline_name = _airline_name
        ) then
            raise exception 'this booking agent does not work for this airline.';
        end if;
    end if;


    -- update flight.seats_ordered, insert ticket
    update flight
    set seats_ordered = seats_ordered + 1
    where airline_name = _airline_name
    and flight_number = _flight_number;
    insert into ticket (airline_name, flight_number, customer_id, agent_id, date)
    values (
        _airline_name, 
        _flight_number, 
        purchase_ticket.customer_id,
        purchase_ticket.agent_id,
        current_date
    );
end;
$$;

-- simple sql function, not postgres
-- booking agents can see customers they have purchased tickets for
-- and see the total commission(10% of the price) and ticket counts for each customer
-- sorted by ticket counts
drop function if exists view_commission() cascade;
create or replace function view_commission() returns table(
    customer_id uuid,
    customer_name varchar(128),
    ticket_count bigint,
    commission float
) 
language sql security definer
as $$
    select 
        t.customer_id, 
        c.name as customer_name, 
        count(*) as ticket_count, 
        sum(f.price) * 0.1 as commission
    from ticket t
    join customer c on t.customer_id = c.id
    join flight f on t.airline_name = f.airline_name and t.flight_number = f.flight_number
    where t.agent_id = auth.uid()
    group by t.customer_id, c.name
    order by ticket_count desc;
$$;







alter table customer enable row level security;
create policy customer_edit_their_info on customer for all
using (id = auth.uid())
with check (id = auth.uid());

alter table booking_agent enable row level security;
create policy agent_edit_their_info on booking_agent for all
using (id = auth.uid())
with check (id = auth.uid());

alter table works_for enable row level security;
create policy agent_view_their_airline on works_for for select
using (id = auth.uid());
create policy admin_invite_peer on works_for for all
using (is_role('admin') and in_airline(airline_name))
with check (is_role('admin') and in_airline(airline_name));

alter table airline_staff enable row level security;
create policy staff_edit_their_info on airline_staff for all
using (id = auth.uid())
with check (id = auth.uid());
create policy admin_edit_peer on airline_staff for all
using (is_role('admin') and in_airline(airline_name))
with check (is_role('admin') and in_airline(airline_name));

-- let top_booking_agents = []
-- let top_customers = []
-- let top_detination_airports = []

-- let direct_revenue = 0
-- let agent_revenue = 0
create or replace function top_booking_agents() returns 
table(id uuid, email varchar(128), sales bigint)
as $$
    select 
        s.id, 
        u.email, 
        count(*) as sales
    from ticket t
    join booking_agent s on t.agent_id = s.id
    join auth.users u on s.id = u.id
    where t.airline_name = (
        select airline_name from airline_staff s
        where s.id = auth.uid()
    )
    group by s.id, u.email
    order by sales desc;
$$ language sql security definer;

create or replace function top_customers() returns
table(id uuid, email varchar(128), sales bigint)
as $$
    select 
        c.id, 
        u.email, 
        count(*) as sales
    from ticket t
    join customer c on t.customer_id = c.id
    join auth.users u on c.id = u.id
    where t.airline_name = (
        select airline_name from airline_staff s
        where s.id = auth.uid()
    )
    group by c.id, u.email
    order by sales desc;
$$ language sql security definer;

create or replace function top_destination_airports() returns
table(airport_name varchar(128), sales bigint)
as $$
    select 
        a.name as airport_name, 
        count(*) as sales
    from ticket t
    join flight f on t.airline_name = f.airline_name and t.flight_number = f.flight_number
    join airport a on f.arrival_airport = a.name
    where t.airline_name = (
        select airline_name from airline_staff s
        where s.id = auth.uid()
    )
    group by a.name
    order by sales desc;
$$ language sql security definer;

create or replace function direct_revenue() returns float
as $$
    select 
        sum(f.price) as revenue
    from ticket t
    join flight f on t.airline_name = f.airline_name and t.flight_number = f.flight_number
    where t.airline_name = (
        select airline_name from airline_staff s
        where s.id = auth.uid()
    );
$$ language sql security definer;

create or replace function agent_revenue() returns float
as $$
    select 
        sum(f.price) as revenue
    from ticket t
    join flight f on t.airline_name = f.airline_name and t.flight_number = f.flight_number
    where t.airline_name = (
        select airline_name from airline_staff s
        where s.id = auth.uid()
    )
    and t.agent_id is not null;
$$ language sql security definer;

create or replace function flights_of_my_airline() returns setof flight as $$
    select * from flight f
    where f.airline_name = (
        select airline_name from airline_staff s
        where s.id = auth.uid()
    );
$$ language sql security definer;

create or replace function airplanes_of_my_airline() returns setof airplane as $$
    select * from airplane a
    where a.airline_name = (
        select airline_name from airline_staff s
        where s.id = auth.uid()
    );
$$ language sql security definer;

create or replace function airports_of_my_airline() returns setof airport as $$
-- since airports have no owner airlines, we select all
    select * from airport;
$$ language sql security definer;

create or replace function customers_of_my_airline() returns setof customer as $$
    select * from customer c
    where c.id in (
        select id from works_for w
        where w.airline_name = (
            select airline_name from airline_staff s
            where s.id = auth.uid()
        )
    );
$$ language sql security definer;

create or replace function booking_agents_of_my_airline() returns setof booking_agent as $$
    select * from booking_agent b
    where b.id in (
        select id from works_for w
        where w.airline_name = (
            select airline_name from airline_staff s
            where s.id = auth.uid()
        )
    );
$$ language sql security definer;

create or replace function invite_booking_agent(email varchar(128)) returns void as $$
declare
    _id uuid;
begin
    _id := search_uid_by_email(email);
    if _id is null then
        raise exception 'no such user.';
    end if;

    if not exists (
        select * from booking_agent b
        where b.id = _id
    ) then
        insert into booking_agent (id)
        values (_id);
    end if;

    insert into works_for (id, airline_name)
    values (_id, (
        select airline_name from airline_staff s
        where s.id = auth.uid()
    ));
end;
$$ language plpgsql security definer;

-- recall that one booking agent can work for multiple airlines
-- but one airline staff can only work for one airline
-- we just need to modify airline_staff.airline_name
-- works_for is for booking agents
create or replace function invite_airline_staff(email varchar(128), permission varchar(128)) returns void as $$
declare
    _id uuid;
begin
    _id := search_uid_by_email(email);
    if _id is null then
        raise exception 'no such user.';
    end if;

    if not exists (
        select * from airline_staff b
        where b.id = _id
    ) then
        insert into airline_staff (id, airline_name, permission)
        values (_id, (
            select airline_name from airline_staff s
            where s.id = auth.uid()
        ), permission);
    else
        update airline_staff
        set airline_name = (
            select airline_name from airline_staff s
            where s.id = auth.uid()
        ), permission = permission
        where id = _id;
    end if;
end;
$$ language plpgsql security definer;



