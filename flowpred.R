library(vars)
library(BMR)
library(devtools)
library(readr)
require(reshape2)
library(nnfor)


# Set the working directory
setwd("/home/cristobal/Desktop/kueskichallenge/datatrans")
lags=60

tab =read_csv("couponsflow.csv")
z<-dim(tab)
print(z[1])
tra=35*8
couponstrain=tab[c(1:tra),2];
couponstest=tab[281:359,2]
time1=tab[c(1:tra),3];
time2=tab[281:359,3]

y<-data.matrix(couponstrain)
# let us start with classical VAR
var_obj = new(cvar)
var_obj$build(y,TRUE,lags)
var_obj$estim()
var_obj$boot(10000)
#prior coefficients 
coef_prior <- c(0.9,0.9,0.9,.9,0,0,0,0,0,0,0,0,0)

# create bvar with minnesota prior
bvar_obj <- new(bvarm)
bvar_obj$build(y,TRUE,lags)
bvar_obj$prior(coef_prior,1,1,0.5,0.5,100.0,1.0)
bvar_obj$gibbs(10000)
########
# IRF	 #
########
# Clasical VAR
IRF(var_obj,percentiles=c(0.05,.5,0.95), save=FALSE)
# Clasical Minesotta BVAR
IRF(bvar_obj,percentiles=c(0.05,.5,0.95), save=FALSE)

###############
# Forecasts   #
###############
# Clasical VAR
forecastvar=forecast(var_obj,periods=79,plot=TRUE,confint=0.95,backdata=280)
# Minessota prior BVAR
forecastbvarm=forecast(bvar_obj,periods=79,shocks=TRUE,plot=TRUE,percentiles=c(.05,.5,.95),useMean=FALSE,
                       backdata=280)

###############
# Error   #
###############

aux1=(forecastvar[[1]])
aux=aux1[,1]
print(aux)
print(couponstest)

varresults=forecastvar[[1]]
varforecast=varresults[,1]

bvarresults=forecastbvarm[[1]]
bvarforecast=bvarresults[,1]
########mlp
#print(time1)
myts <- ts(couponstrain,frequency = 70) 
fit <- mlp(myts, hd=c(4,4,4,4,4,4,4,4,4,4),lag=10)
#fit <- mlp(myts, hd=c(2),lags=4)#this has 11 has rmse

plot(fit)
mlpforecast <- forecast(fit,h=79)
plot(mlpforecast)
fore=mlpforecast[2]
fore2<-unlist(fore)


# error results
print('RMSS error for consumption')
rmse<- sqrt(mean((couponstest-varforecast)^2))
print(rmse)
print('Percentage error var')
pe<- 100*rmse/sqrt(mean((couponstest)^2))
print(pe)
rmse<- sqrt(mean((couponstest-bvarforecast)^2))
print(rmse)
print('Percentage error bvar')
pe<- 100*rmse/sqrt(mean((couponstest)^2))
print(pe)
rmse<- sqrt(mean((couponstest-fore2)^2))
print(rmse)
print('Percentage error mlp')
pe<- 100*rmse/sqrt(mean((fore2)^2))
print(pe)
#graph

time <- time2
coupon <- couponstest
var <- varforecast
bvar <- bvarforecast
mlpf<-fore2

freal<-data.frame(time, coupon)
plot(freal, type="o", col="black", pch="o", lty=1, ylim=c(0,600) )
fvar<-data.frame(time, var)
points(fvar, col="red", pch="*")
lines(fvar, col="red",lty=2)
fbvar<-data.frame(time, bvar)
points(fbvar, col="dark green",pch="+")
lines(fbvar, col="dark green", lty=3)
fmlp<-data.frame(time, mlpf)
points(fmlp, col="blue",pch="-")
lines(fmlp, col="blue", lty=3)

