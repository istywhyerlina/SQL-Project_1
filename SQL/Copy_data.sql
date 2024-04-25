COPY cities(city_id,city_name,latitude,longitude)
FROM 'C:\Users\Public\Documents\cities.csv'
DELIMITER ','
CSV HEADER;

COPY users(user_id,name,email,phone_number,city_id,date_created)
FROM 'C:\Users\Public\Documents\users.csv'
DELIMITER ','
CSV HEADER;

COPY cars(product_id,brand	,model,body_type,year,price)
FROM 'C:\Users\Public\Documents\cars.csv'
DELIMITER ','
CSV HEADER;

COPY ads(ad_id,seller_id,product_id,color,mileage,ads_price,description,negotiable,date_posted_ads,is_sold)
FROM 'C:\Users\Public\Documents\ads.csv'
DELIMITER ','
CSV HEADER;

COPY bids(bid_id,ad_id,buyer_id,bid_price,bid_date,bid_status)
FROM 'C:\Users\Public\Documents\bids.csv'
DELIMITER ','
CSV HEADER;

COPY payments(payment_id,payment_type,payment_date)
FROM 'C:\Users\Public\Documents\payments.csv'
DELIMITER ','
CSV HEADER;

COPY deals(deal_id,ad_id,bid_id,payment_id)
FROM 'C:\Users\Public\Documents\deals.csv'
DELIMITER ','
CSV HEADER;
