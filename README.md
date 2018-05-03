# Coupon-Purchase-Prediction
Neural Networks, Bayes Autoregression, Visualization and Collaborative Filtering for Coupons Datasets

## Data source and description
In this repository we analyze data from kaggle competitions 

https://www.kaggle.com/c/coupon-purchase-prediction

## The analysis

* First we translate Japanese characteres using the provided dictionary translations.json  
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
