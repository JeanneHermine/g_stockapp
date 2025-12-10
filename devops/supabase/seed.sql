create type user_role as enum ('admin','manager','cashier','viewer');

create table products (
  id uuid primary key default gen_random_uuid(),
  sku text unique not null,
  name text not null,
  price numeric not null,
  stock int not null default 0,
  store_id uuid not null
);

alter table products enable row level security;
