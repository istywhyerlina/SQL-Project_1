CREATE FUNCTION ck_city_id(int) RETURNS integer
    AS $$ SELECT case when $1 in (select city_id from public.cities) then 1 else 0 end $$
    LANGUAGE SQL;

alter table users
add constraint chk_CheckFunction
check (ck_city_id(city_id)  = 1)

CREATE FUNCTION ck_date_ads(date,int) RETURNS integer
    AS $$ SELECT case when date_created<=$1 then 1 else 0 end from public.users where user_id=$2 $$
    LANGUAGE SQL;

alter table ads
add constraint chk_CheckFunction
check (ck_date_ads(date_posted_ads,seller_id)  = 1)

CREATE FUNCTION ck_negotiable_true(int,int) RETURNS integer
    AS $$ SELECT case 
    when $2=(select ads_price from ads where ad_id=$1) and (select negotiable from ads where ad_id=$1)=false then 1 
    when $2<(select ads_price from ads where ad_id=$1) or $2>(select ads_price from ads where ad_id=$1) and (select negotiable from ads where ad_id=$1)=true then 1 else 0 end $$
    LANGUAGE SQL;

alter table bids
add constraint chk_Checknegotiable
check (ck_negotiable_true(ad_id, bid_price)  = 1)

CREATE FUNCTION ck_buyer_id(int,int) RETURNS integer
    AS $$ SELECT case 
    when $2!=(select seller_id from ads where ad_id=$1) then 1 
    else 0 end $$
    LANGUAGE SQL;

alter table bids
add constraint chk_buyer_id
check (ck_negotiable_true(ad_id, buyer_id)  = 1)

CREATE FUNCTION ck_date_bid(date,int) RETURNS integer
    AS $$ SELECT case when date_posted_ads<=$1 then 1 else 0 end from public.ads where ad_id=$2 $$
    LANGUAGE SQL;

alter table bids
add constraint chk_CheckFunction
check (ck_date_bid(bid_date,ad_id)  = 1)

CREATE FUNCTION ck_bid_status(int,varchar) RETURNS integer
    AS $$ SELECT case when (select is_sold from ads where ad_id=$1)=false and $2='Sent' then 1 
    when(select is_sold from ads where ad_id=$1)=true and $2 in ('Rejected','Succeed') then 1 
    else 0 end $$
    LANGUAGE SQL;

alter table bids
add constraint chk_bid_status
check (ck_bid_status(ad_id,bid_status)  = 1)

CREATE FUNCTION ck_date_payment(int,int) RETURNS integer
    AS $$ SELECT case when (select payment_date from payments where payment_id=$1)>=(select bid_date from bids where bid_id=$2) then 1 else 0 end  $$
    LANGUAGE SQL;

alter table deals
add constraint chk_date_payment
check (ck_date_payment(payment_id,bid_id)  = 1)
