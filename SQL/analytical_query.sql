--- Nomor 1
SELECT "C"."model",COUNT(DISTINCT "C"."product_id") as "Count Product", COUNT(DISTINCT "A"."ad_id") as "Count Ad", COUNT("B"."bid_id") as "Count Bid" FROM public.cars as "C" right join public.ads as "A" on "C"."product_id"="A"."product_id" right join public.bids as "B" on "A"."ad_id" = "B"."ad_id" 
group by "C"."model" order by "Count Bid" desc


---Nomor 2
select "Ci"."city_name","C"."brand", "C"."model","C"."year","C"."price" as "initial price", round(avg("A"."ads_price"),2) as avg_car_city_ad
from public.ads as "A" left join public.cars as "C" on "A"."product_id"="C"."product_id"
left join  public.users as "U" on "A"."seller_id"="U"."user_id" 
left join public.cities as "Ci" on "Ci"."city_id" = "U"."city_id" group by "Ci"."city_name","C"."brand", "C"."model","C"."year","C"."price"


---Nomor 3 
with ordered_bid as(select * from bids order by bid_date asc),
bid_nextbid as(select C.model,B.buyer_id,B.bid_date,lead(B.bid_date,1) over(partition by C.model, B.buyer_id order by B.bid_date ) as "next bid", rank() over(partition by c.model, b.buyer_id order by b.bid_date) from ordered_bid as B left join ads as A on B.ad_id=A.ad_id left join cars as C on A.product_id = C.product_id)

select * from bid_nextbid where rank=1


---Nomor 4
WITH bid_6_month as(select *, extract(month from age((select max(bid_date) from bids)::date, bid_date::date )) as monthdiff from bids where extract(month from age((select max(bid_date) from bids)::date, bid_date::date ))<6),
avg_price as(select  "C"."model", round(avg("A"."ads_price"),2) as avg_car_city_ad 
from public.ads as "A" left join public.cars as "C" on "A"."product_id"="C"."product_id"
left join  public.users as "U" on "A"."seller_id"="U"."user_id" 
left join public.cities as "Ci" on "Ci"."city_id" = "U"."city_id"
group by "C"."model"),
avg_bid_price_6month as(
select  "C"."model", round(avg("B"."bid_price"),2) as avg_car_city_bid 
from public.ads as "A" 
right join bid_6_month as "B" on "A"."ad_id"= "B"."ad_id"
left join public.cars as "C" on "A"."product_id"="C"."product_id"
left join  public.users as "U" on "A"."seller_id"="U"."user_id" 
left join public.cities as "Ci" on "Ci"."city_id" = "U"."city_id" 
group by "C"."model")

select "A".model, "A".avg_car_city_ad,"B".avg_car_city_bid, ("A".avg_car_city_ad - "B".avg_car_city_bid) as difference, ("A".avg_car_city_ad - "B".avg_car_city_bid)/"A".avg_car_city_ad*100 as difference_percent  from avg_price as "A" join avg_bid_price_6month as "B" on "A".model = "B".model



---Nomor 5
WITH bid_month_diff as(select *, extract(month from age((select max(bid_date) from bids)::date, bid_date::date )) as monthdiff from bids)
select  distinct "C"."model",
avg("B"."bid_price") FILTER (WHERE monthdiff=0) as m_min_1,
avg("B"."bid_price") FILTER (WHERE monthdiff=1) as m_min_2,
avg("B"."bid_price") FILTER (WHERE monthdiff=2) as m_min_3,
avg("B"."bid_price") FILTER (WHERE monthdiff=3) as m_min_4,
avg("B"."bid_price") FILTER (WHERE monthdiff=4) as m_min_5,
avg("B"."bid_price") FILTER (WHERE monthdiff=5) as m_min_6

from public.ads as "A" 
right join bid_month_diff as "B" on "A"."ad_id"= "B"."ad_id"
left join public.cars as "C" on "A"."product_id"="C"."product_id"
left join  public.users as "U" on "A"."seller_id"="U"."user_id" 
left join public.cities as "Ci" on "Ci"."city_id" = "U"."city_id" 
group by "C"."model"
