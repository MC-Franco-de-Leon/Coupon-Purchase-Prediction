# Coupon-Purchase-Prediction
Neural Networks, Bayes Autoregression, Visualization and Collaborative Filtering for Coupons Datasets

## Data source and description
In this repository we analyze data from kaggle competitions 

https://www.kaggle.com/c/coupon-purchase-prediction

## The analysis

* First we translate Japanese characteres using the provided dictionary translations.json  
* As part of the data exploration, we analyzed the 'coupon_detail_train_en.csv' file to find the most active users in terms of using coupons. Then, we visalized the coupon preferences of the top three (here we show only two, however the three images are included in this repository)

**preferences of top users**

![couponsuser1](https://user-images.githubusercontent.com/13289981/39566644-26bafef8-4e71-11e8-8145-bee2f4ef1e55.png)
![couponsuser2](https://user-images.githubusercontent.com/13289981/39566648-285103d4-4e71-11e8-888a-cfe36a316beb.png)

**most popular coupons**

This graph was obtained only considering the top 100 most popular coupons (in terms of being purchased). The top 3 are in the order of thousands (5760,1511,1016), the number fourth has 863 ocurrences and the count drops to 122 for the coupon in the position 99, and 93 for the position 150. There are a lot (at least the last 150) of coupons that were used only once during this period of time (about 8 months), and we need to analize(count) those coupons that were not used at all.  

![top100coupons](https://user-images.githubusercontent.com/13289981/39567372-ae58f2c8-4e73-11e8-987d-ee37b365f5b5.png)

**places with more activity**

Here we can oberve the activity of coupons in terms of the feature 'small_area_name'

![topplaces](https://user-images.githubusercontent.com/13289981/39567374-afdc9bb8-4e73-11e8-8b66-7b023b73e2f6.png)

* We build a model of similarity to recommend what coupons a specific user will mostlikely get. For this purpose the analysis is based on the following features    'I_DATE','USER_ID_hash','COUPON_ID_hash','CAPSULE_TEXT_en','DISPPERIOD','VALIDPERIOD','PRICE','TIME','large_area_name_en','ken_name','small_area_name_en','SEX_ID', and 'AGE'. 

The 'PRICE' feature is computed as 100*DISCOUNT_PRICE/PRICE_RATE 

The 'TIME' feature is ('USABLE_DATE_MO'+USABLE_DATE_TUE+...+'USABLE_DATE_BEFORE_HOLIDAY')/9

We order the new data frame according to the 'I_DATE' field and take 80% for trainig and the last 20% for testing the models. 

We build the models using graphlab, here is a screen shot of the precision-recall results

![precisionrecall](https://user-images.githubusercontent.com/13289981/39565175-df3bfd3e-4e6b-11e8-9bd9-09bf7419d366.jpg)

![line_recall_precision](https://user-images.githubusercontent.com/13289981/39565167-d8073cf4-4e6b-11e8-9be3-0876cf63476b.png)

As you can observe in this results, the cosine and jaccard metrics perform better to predict the preferences of users.

## Codes

* trans (python) to translate Japanese words to English
* similarity (ipynb) executes three similarity recommenders based on three similarity metrics (jaccard, pearson, cosine)
* popular (python) finds the top 10 active users, then displays the coupon preferences of the top three. Finds the most popular coupons, and the cities (small_area_name) with more coupon activity. 
