CREATE TABLE public.cities
(
    city_id int NOT NULL,
    city_name varchar(25) NOT NULL,
    latitude numeric,
    longitude numeric,
    CONSTRAINT pk_city PRIMARY KEY (city_id)
);

CREATE TABLE public.users
(
    user_id int NOT NULL,
    name varchar(50) NOT NULL,
    email varchar(50) NOT NULL,
    phone_number varchar(13) NOT NULL,
    city_id int NOT NULL,
    date_created date NOT NULL,
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES    public.cities (city_id)
);

CREATE TABLE public.cars
(
    product_id int NOT NULL,
    brand varchar(50) NOT NULL,
    model varchar(50) NOT NULL,
    body_type varchar(20) NOT NULL,
    year int NOT NULL,
    price int NOT NULL,
    CONSTRAINT pk_cars PRIMARY KEY (product_id)
);

CREATE TABLE public.ads
(
    ad_id int NOT NULL,
    seller_id int NOT NULL,
    product_id int NOT NULL,
    color varchar(15) NOT NULL,
    mileage int NOT NULL,
    ads_price int NOT NULL,
    description varchar(100),
    negotiable boolean NOT NULL,
    date_posted_ads date NOT NULL,
    is_sold boolean NOT NULL,
    CONSTRAINT pk_ads PRIMARY KEY (ad_id),
    CONSTRAINT fk_user FOREIGN KEY (seller_id) REFERENCES    public.users (user_id),
    CONSTRAINT fk_car FOREIGN KEY (product_id) REFERENCES    public.cars (product_id)
);

CREATE TABLE public.bids
(
    bid_id int NOT NULL,  
    ad_id int NOT NULL,
    buyer_id int NOT NULL,
    bid_price int NOT NULL,
    bid_date date NOT NULL,
    bid_status varchar NOT NULL,
    CONSTRAINT pk_bids PRIMARY KEY (bid_id),
    CONSTRAINT fk_ad FOREIGN KEY (ad_id) REFERENCES    public.ads (ad_id),
    CONSTRAINT fk_user FOREIGN KEY (buyer_id) REFERENCES    public.users (user_id)
);


CREATE TABLE public.payments
(
    payment_id int NOT NULL,  
    payment_type varchar(20) NOT NULL,
    payment_date date NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (payment_id)
);


CREATE TABLE public.deals
(
    deal_id int NOT NULL,  
    ad_id int NOT NULL,
    bid_id int NOT NULL,
    payment_id int NOT NULL,
    CONSTRAINT pk_deals PRIMARY KEY (deal_id),
    CONSTRAINT fk_ad FOREIGN KEY (ad_id) REFERENCES    public.ads (ad_id) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_bid FOREIGN KEY (bid_id) REFERENCES    public.bids (bid_id) DEFERRABLE INITIALLY DEFERRED ,
    CONSTRAINT fk_payment FOREIGN KEY (payment_id) REFERENCES    public.payments (payment_id) DEFERRABLE INITIALLY DEFERRED
);
