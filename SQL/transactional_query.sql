--- Nomor 1

SELECT * FROM public.cars where year>2015;


--- Nomor 2

INSERT INTO public.bids(
	bid_id, ad_id, buyer_id, bid_price, bid_date, bid_status)
	VALUES (5001, 3,29 , 86000000,'2023-10-17','Sent');


--- Nomor 3

WITH newest_seller as (SELECT distinct "A"."seller_id" , "U"."date_created" from public.users as "U" right join public.ads as "A" on  "A"."seller_id" = "U"."user_id" order by "U"."date_created" desc limit 1)
SELECT "C"."product_id", "C"."brand","C"."model", "C"."body_type", "C"."year", "A"."mileage", "A"."ads_price","A"."date_posted_ads", "A"."is_sold"
from public.ads as "A" left join public.cars as "C" on "A"."product_id"="C"."product_id"
left join  public.users as "U" on "A"."seller_id"="U"."user_id" where "A"."seller_id" = (select seller_id from "newest_seller") order by "A"."date_posted_ads" desc


---Nomor 4
SELECT "A"."ad_id", "C"."product_id", "C"."brand","C"."model", "C"."body_type", "C"."year", "A"."mileage", "A"."ads_price","A"."date_posted_ads", "A"."is_sold"
from public.ads as "A" left join public.cars as "C" on "A"."product_id"="C"."product_id" WHERE LOWER("C"."model") LIKE '%yaris%' and "A"."is_sold" = false order by "A"."ads_price" asc


--- Nomor 5
with coord_bandung as(SELECT latitude, longitude from public.cities where city_id=3273)
SELECT "A"."ad_id","C"."product_id", "C"."brand","C"."model", "C"."body_type", "C"."year", "A"."mileage", "A"."ads_price", (round(sqrt (power((select latitude from coord_bandung)-("Ci"."latitude"),2)+power((select longitude from coord_bandung)-("Ci"."longitude"),2)),4)) AS "Distance"
from public.ads as "A" left join public.cars as "C" on "A"."product_id"="C"."product_id"
left join  public.users as "U" on "A"."seller_id"="U"."user_id" 
left join public.cities as "Ci" on "Ci"."city_id" = "U"."city_id" where "A"."is_sold"=False order by "Distance" ASC
