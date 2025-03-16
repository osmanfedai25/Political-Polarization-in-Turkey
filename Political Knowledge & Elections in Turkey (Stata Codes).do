** Political Knowledge & Election Proximity in Turkey (EES Data)

/* 1994 */

use EES1994, clear

keep if survey==411 /* Post-election survey */

keep if v12<3 /* Eligible to vote */

/*           IDENTIFIERS                   */
recode country (1=056) (2=208) (3=276) (4=300) (5=380) (6=724) (7=250) (8=372) (9=826) (10=442) (11=528) (12=620) (13=826) (14=278), gen(iso3n) /* COUNTRY CODE */
gen year=1994


/*        DVs          */

forval k=1/11{
gen left`k'=.
capture foreach y in bel den ege fra gb gre irl ita lux net nir por spa wge{
local j=117+`k'
replace left`k'=v`j'_`y' if missing(left`k')
}
}

recode *left* (11/99=.a)

foreach var of varlist *left*{ 
replace `var'=(10*`var'-10)/9
}

forval i=1/11{
by country, sort: egen mleft`i'=mean(left`i')
recode left`i' mleft`i' (missing=.a)
gen abserr`i'=abs(left`i'-mleft`i')
}

levelsof country, loc(levels)
foreach c of loc levels {
capture forval i=1/11{
sum abserr`i' if country==`c'
replace abserr`i'=`r(mean)'+`r(sd)' if missing(abserr`i') & mleft`i'!=.a & country==`c'
}
}

egen pkn=rowtotal(abserr*)
egen pknt=rownonmiss(abserr*)
replace pkn=pkn/pknt

gen altpkn=.
gen dif=.
egen m1b=mean(v119_bel) if v119_bel<11
egen m2b=mean(v120_bel) if v120_bel<11
replace dif=m1b-m2b if country==1
recode v119_bel (11/99=.), gen(belg1)
recode v120_bel (11/99=.), gen(belg2)
replace altpkn=0 if belg2>belg1 | v119_bel==11 | v120_bel==11 
replace altpkn=0 if belg1==belg2 & !missing(belg1, belg2)
replace altpkn=1 if belg1>belg2

egen m1den=mean(v118_den) if v118_den<11
egen m2den=mean(v120_den) if v120_den<11
replace dif=m1den-m2den if country==2
recode v118_den (11/99=.), gen(den1)
recode v120_den (11/99=.), gen(den2)
replace altpkn=0 if den1>den2 | v118_den==11 | v120_den==11 
replace altpkn=0 if den1==den2 & !missing(den1, den2)
replace altpkn=1 if den2>den1

egen m1ege=mean(v118_ege) if v118_ege<11
egen m2ege=mean(v119_ege) if v119_ege<11
replace dif=m1ege-m2ege if country==14
recode v118_ege (11/99=.), gen(ege1)
recode v119_ege (11/99=.), gen(ege2)
replace altpkn=0 if ege1<ege2 | v118_ege==11 | v119_ege==11 
replace altpkn=0 if ege1==ege2 & !missing(ege1, ege2)
replace altpkn=1 if ege2<ege1

egen m1ger=mean(v118_wge) if v118_wge<11
egen m2ger=mean(v119_wge) if v119_wge<11
replace dif=m1ger-m2ger if country==3
recode v118_wge (11/99=.), gen(ger1)
recode v119_wge (11/99=.), gen(ger2)
replace altpkn=0 if ger2>ger1 | v118_wge==11 | v119_wge==11 
replace altpkn=0 if ger1==ger2 & !missing(ger1, ger2)
replace altpkn=1 if ger1>ger2

egen m1gre=mean(v118_gre) if v118_gre<11
egen m2gre=mean(v119_gre) if v119_gre<11
replace dif=m1gre-m2gre if country==4
recode v118_gre (11/99=.), gen(gre1)
recode v119_gre (11/99=.), gen(gre2)
replace altpkn=0 if gre2<gre1 | v118_gre==11 | v119_gre==11 
replace altpkn=0 if gre2==gre1 & !missing(gre1, gre2) 
replace altpkn=1 if gre2>gre1

egen m1irl=mean(v118_irl) if v118_irl<11
egen m2irl=mean(v119_irl) if v119_irl<11
replace dif=m1irl-m2irl if country==8
recode v118_irl (11/99=.), gen(irl1)
recode v119_irl (11/99=.), gen(irl2)
replace altpkn=0 if irl1<irl2 | v118_irl==11 | v119_irl==11 
replace altpkn=0 if irl1==irl2 & !missing(irl1, irl2) 
replace altpkn=1 if irl1>irl2

egen m1ita=mean(v118_ita) if v118_ita<11
egen m2ita=mean(v119_ita) if v119_ita<11
replace dif=m1ita-m2ita if country==5
recode v118_ita (11/99=.), gen(ita1)
recode v119_ita (11/99=.), gen(ita2)
replace altpkn=0 if ita1<ita2 | v118_ita==11 | v119_ita==11 
replace altpkn=0 if ita1==ita2 & !missing(ita1, ita2) 
replace altpkn=1 if ita1>ita2

egen m1lux=mean(v118_lux) if v118_lux<11
egen m2lux=mean(v119_lux) if v119_lux<11
replace dif=m1lux-m2lux if country==10
recode v118_lux (11/99=.), gen(lux1)
recode v119_lux (11/99=.), gen(lux2)
replace altpkn=0 if lux1<lux2 | v118_lux==11 | v119_lux==11 
replace altpkn=0 if lux1==lux2 & !missing(lux1, lux2) 
replace altpkn=1 if lux1>lux2

egen m1net=mean(v118_net) if v118_net<11
egen m2net=mean(v119_net) if v119_net<11
replace dif=m1net-m2net if country==11
recode v118_net (11/99=.), gen(net1)
recode v119_net (11/99=.), gen(net2)
replace altpkn=0 if net1<net2 | v118_net==11 | v119_net==11 
replace altpkn=0 if net1==net2 & !missing(net1, net2) 
replace altpkn=1 if net1>net2

egen m1nir=mean(v119_nir) if v119_nir<11
egen m2nir=mean(v122_nir) if v122_nir<11
replace dif=m1nir-m2nir if country==9
recode v119_nir (11/99=.), gen(nir1)
recode v122_nir (11/99=.), gen(nir2)
replace altpkn=0 if nir1<nir2 | v119_nir==11 | v122_nir==11 
replace altpkn=0 if nir1==nir2 & !missing(nir1, nir2) 
replace altpkn=1 if nir1>nir2

egen m1por=mean(v118_por) if v118_por<11
egen m2por=mean(v121_por) if v121_por<11
replace dif=m1por-m2por if country==12
recode v118_por (11/99=.), gen(por1)
recode v121_por (11/99=.), gen(por2)
replace altpkn=0 if por1<por2 | v118_por==11 | v121_por==11 
replace altpkn=0 if por1==por2 & !missing(por1, por2) 
replace altpkn=1 if por1>por2

egen m1spa=mean(v118_spa) if v118_spa<11
egen m2spa=mean(v119_spa) if v119_spa<11
replace dif=m1spa-m2spa if country==6
recode v118_spa (11/99=.), gen(spa1)
recode v119_spa (11/99=.), gen(spa2)
replace altpkn=0 if spa2<spa1 | v118_spa==11 | v119_spa==11 
replace altpkn=0 if spa1==spa2 & !missing(spa1, spa2) 
replace altpkn=1 if spa2>spa1

egen m1gb=mean(v118_gb) if v118_gb<11
egen m2gb=mean(v119_gb) if v119_gb<11
replace dif=m1gb-m2gb if country==13
recode v118_gb (11/99=.), gen(gb1)
recode v119_gb (11/99=.), gen(gb2)
replace altpkn=0 if gb2>gb1 | v118_gb==11 | v119_gb==11 
replace altpkn=0 if gb1==gb2 & !missing(gb1, gb2) 
replace altpkn=1 if gb2<gb1


/*               IVs                       */
gen female=v346-1 /* FEMALE */

gen education=v345
replace education=v347 if education==0
recode education (0/15=1) (16/19=2) (20/100=3) /* EDUCATION */

gen age=v347 /* AGE */

recode v114 (98/99=.), gen(ideology)
replace ideology = (ideology - 1) * 10/9 /* IDEOLOGY */

recode v368 (1=2) (2=1) (3=1) (4=3) (5=3) (6/9=.), gen(sclass) /* SUBJ. SOCIAL CLASS */

recode v134 (1=4) (2=3) (3=2) (4=1) (5/9=.), gen(polint) /* POLITICAL INTEREST */

recode v370 (4/9=.), gen(residency) /* URBAN/RURAL */

recode v103 (1=4) (2=3) (3=2) (4=1) (5/9=.), gen(pistrength)  /* PARTY IDENTITY STRENGTH */

tostring v6, gen(date)
gen month = substr(date,1,1)
gen day=substr(date,2,3)
destring month, gen(monthn)
destring day, gen(dayn)
gen intdate = mdy(monthn, dayn, year)
format intdate %td /* DATE */

recode v90 (2=0) (3=0) (9=.), gen(turnout)   /* TURNOUT */

keep pkn altpkn iso3n year female education age ideology sclass polint residency pistrength intdate turnout dif

save EES1994_4, replace 
clear all







/* 1999 */

use EES1999, clear

/*           IDENTIFIERS                   */
recode var002 (1=056) (2=208) (3=276) (4=300) (6=724) (7=250) (8=372) (9=380) (10=442) (11=528) (12=620) (13=826) (16=246) (17=752) (18=040), gen(iso3n) /* COUNTRY CODES */
gen year=1999

/*               DVS                   */

forvalues i = 118(1)133 {
recode var`i' (-1=.) (99=.) /* -1'in ne olduğu açıklanmamış 99 ise n/a */
gen varr`i'=(var`i'-1)*10/9
by var002, sort: egen float sd`i' = sd(varr`i') if var`i'<11
by var002, sort: egen float mean`i'=mean(varr`i') if var`i'<11
gen diff`i'=abs(varr`i'-mean`i')
by var002, sort: egen float sddiff`i' = sd(diff`i') if var`i'<11
by var002, sort: egen float meandiff`i'=mean(diff`i') if var`i'<11
replace diff`i'=meandiff`i'+sddiff`i' if var`i'==11 /* DKs */
}
egen pkn=rowtotal(diff*)
egen pknt=rownonmiss(diff*)
replace pkn=pkn/pknt

gen altpkn=.
gen dif=.
egen m1aut=mean(var118) if var118<11 & iso3n==40
egen m2aut=mean(var119) if var119<11 & iso3n==40
replace dif=m1aut-m2aut if iso3n==40
recode var118 (11/99=.) if iso3n==40, gen(aut1)
recode var119 (11/99=.) if iso3n==40, gen(aut2)
replace altpkn=0 if (aut1>aut2 | var118==98 | var119==98) & iso3n==40 
replace altpkn=0 if aut1==aut2 & !missing(aut1, aut2) 
replace altpkn=1 if aut1<aut2 & iso3n==40

egen m1bel=mean(var126) if var126<11 & iso3n==56
egen m2bel=mean(var128) if var128<11 & iso3n==56
replace dif=m1bel-m2bel if iso3n==56
recode var126 (11/99=.) if iso3n==56, gen(bel1)
recode var128 (11/99=.) if iso3n==56, gen(bel2)
replace altpkn=0 if (bel1<bel2 | var126==98 | var128==98) & iso3n==56 
replace altpkn=0 if bel1==bel2 & !missing(bel1, bel2) 
replace altpkn=1 if bel1>bel2 & iso3n==56

egen m1den=mean(var118) if var118<11 & iso3n==208
egen m2den=mean(var119) if var119<11 & iso3n==208
replace dif=m1den-m2den if iso3n==208
recode var118 (11/99=.) if iso3n==208, gen(den1)
recode var119 (11/99=.) if iso3n==208, gen(den2)
replace altpkn=0 if (den1>den2 | var118==98 | var119==98) & iso3n==208 
replace altpkn=0 if den1==den2 & !missing(den1, den2) 
replace altpkn=1 if den1<den2 & iso3n==208

egen m1fin=mean(var118) if var118<11 & iso3n==246
egen m2fin=mean(var119) if var119<11 & iso3n==246
replace dif=m1fin-m2fin if iso3n==246
recode var118 (11/99=.) if iso3n==246, gen(fin1)
recode var119 (11/99=.) if iso3n==246, gen(fin2)
replace altpkn=0 if (fin1>fin2 | var118==98 | var119==98) & iso3n==246 
replace altpkn=0 if fin1==fin2 & !missing(fin1, fin2) 
replace altpkn=1 if fin1<fin2 & iso3n==246

egen m1fr=mean(var118) if var118<11 & iso3n==250
egen m2fr=mean(var119) if var119<11 & iso3n==250
replace dif=m1fr-m2fr if iso3n==250
recode var118 (11/99=.) if iso3n==250, gen(fr1)
recode var119 (11/99=.) if iso3n==250, gen(fr2)
replace altpkn=0 if (fr1>fr2 | var118==98 | var119==98) & iso3n==250 
replace altpkn=0 if fr1==fr2 & !missing(fr1, fr2) 
replace altpkn=1 if fr1<fr2 & iso3n==250

egen m1ger=mean(var118) if var118<11 & iso3n==276
egen m2ger=mean(var119) if var119<11 & iso3n==276
replace dif=m1ger-m2ger if iso3n==276
recode var118 (11/99=.) if iso3n==276, gen(ger1)
recode var119 (11/99=.) if iso3n==276, gen(ger2)
replace altpkn=0 if (ger1<ger2 | var118==98 | var119==98) & iso3n==276 
replace altpkn=0 if ger1==ger2 & !missing(ger1, ger2) 
replace altpkn=1 if ger1>ger2 & iso3n==276

egen m1gre=mean(var118) if var118<11 & iso3n==300
egen m2gre=mean(var119) if var119<11 & iso3n==300
replace dif=m1gre-m2gre if iso3n==300
recode var118 (11/99=.) if iso3n==300, gen(gre1)
recode var119 (11/99=.) if iso3n==300, gen(gre2)
replace altpkn=0 if (gre1>gre2 | var118==98 | var119==98) & iso3n==300 
replace altpkn=0 if gre1==gre2 & !missing(gre1, gre2) 
replace altpkn=1 if gre1<gre2 & iso3n==300

egen m1ire=mean(var118) if var118<11 & iso3n==372
egen m2ire=mean(var119) if var119<11 & iso3n==372
replace dif=m1ire-m2ire if iso3n==372
recode var118 (11/99=.) if iso3n==372, gen(ire1)
recode var119 (11/99=.) if iso3n==372, gen(ire2)
replace altpkn=0 if (ire1<ire2 | var118==98 | var119==98) & iso3n==372 
replace altpkn=0 if ire1==ire2 & !missing(ire1, ire2) 
replace altpkn=1 if ire1>ire2 & iso3n==372

egen m1it=mean(var118) if var118<11 & iso3n==380
egen m2it=mean(var119) if var119<11 & iso3n==380
replace dif=m1it-m2it if iso3n==380
recode var118 (11/99=.) if iso3n==380, gen(it1)
recode var119 (11/99=.) if iso3n==380, gen(it2)
replace altpkn=0 if (it1<it2 | var118==98 | var119==98) & iso3n==380 
replace altpkn=0 if it1==it2 & !missing(it1, it2) 
replace altpkn=1 if it1>it2 & iso3n==380

egen m1lux=mean(var118) if var118<11 & iso3n==442
egen m2lux=mean(var119) if var119<11 & iso3n==442
replace dif=m1lux-m2lux if iso3n==442
recode var118 (11/99=.) if iso3n==442, gen(lux1)
recode var119 (11/99=.) if iso3n==442, gen(lux2)
replace altpkn=0 if (lux1<lux2 | var118==98 | var119==98) & iso3n==442 
replace altpkn=0 if lux1==lux2 & !missing(lux1, lux2) 
replace altpkn=1 if lux1>lux2 & iso3n==442

egen m1net=mean(var118) if var118<11 & iso3n==528
egen m2net=mean(var120) if var120<11 & iso3n==528
replace dif=m1net-m2net if iso3n==528
recode var118 (11/99=.) if iso3n==528, gen(net1)
recode var120 (11/99=.) if iso3n==528, gen(net2)
replace altpkn=0 if (net1>net2 | var118==98 | var120==98) & iso3n==528 
replace altpkn=0 if net1==net2 & !missing(net1, net2) 
replace altpkn=1 if net1<net2 & iso3n==528

egen m1por=mean(var118) if var118<11 & iso3n==620
egen m2por=mean(var119) if var119<11 & iso3n==620
replace dif=m1por-m2por if iso3n==620
recode var118 (11/99=.) if iso3n==620, gen(por1)
recode var119 (11/99=.) if iso3n==620, gen(por2)
replace altpkn=0 if (por1>por2 | var118==98 | var119==98) & iso3n==620 
replace altpkn=0 if por1==por2 & !missing(por1, por2) 
replace altpkn=1 if por1<por2 & iso3n==620

egen m1spa=mean(var118) if var118<11 & iso3n==724
egen m2spa=mean(var119) if var119<11 & iso3n==724
replace dif=m1spa-m2spa if iso3n==724
recode var118 (11/99=.) if iso3n==724, gen(spa1)
recode var119 (11/99=.) if iso3n==724, gen(spa2)
replace altpkn=0 if (spa1<spa2 | var118==98 | var119==98) & iso3n==724 
replace altpkn=0 if spa1==spa2 & !missing(spa1, spa2) 
replace altpkn=1 if spa1>spa2 & iso3n==724

egen m1swe=mean(var119) if var119<11 & iso3n==752
egen m2swe=mean(var124) if var124<11 & iso3n==752
replace dif=m1swe-m2swe if iso3n==752
recode var119 (11/99=.) if iso3n==752, gen(swe1)
recode var124 (11/99=.) if iso3n==752, gen(swe2)
replace altpkn=0 if (swe1>swe2 | var119==98 | var124==98) & iso3n==752 
replace altpkn=0 if swe1==swe2 & !missing(swe1, swe2) 
replace altpkn=1 if swe1<swe2 & iso3n==752

egen m1uk=mean(var118) if var118<11 & iso3n==826
egen m2uk=mean(var119) if var119<11 & iso3n==826
replace dif=m1uk-m2uk if iso3n==826
recode var118 (11/99=.) if iso3n==826, gen(uk1)
recode var119 (11/99=.) if iso3n==826, gen(uk2)
replace altpkn=0 if (uk1<uk2 | var118==98 | var119==98) & iso3n==826 
replace altpkn=0 if uk1==uk2 & !missing(uk1, uk2) 
replace altpkn=1 if uk1>uk2 & iso3n==826


/*               IVs                       */
rename var159 female /* FEMALE */

recode var117 (97/99=.)
gen ideology = (var117 - 1) * 10/9 /* IDEOLOGY */

gen age = 1999 - var160 /* AGE */

gen education=var161
recode education (98/99=.)
replace education=age if education==0
recode education (1/15=1) (16/19=2) (20/97=3)  /* EDUCATION */

recode var076 (8/9=.), gen(polint) /* POLITICAL INTEREST */

recode var080 (-1=.) (8/9=.), gen(pst)
gen pistrength=pst+1 /* PARTY IDENTITY STRENGTH */

recode var165 (2=1) (3=2) (4=3) (5=3) (6/9=.), gen(sclass) /* SUBJ. SOCIAL CLASS */

gen italy=var172
recode italy (-1=.)
gen residency=var171
recode residency (-1=1) if italy<4
recode residency (-1=2) if italy==4
recode residency (-1=3) if italy==5
recode residency (8/9=.) /* URBAN/RURAL */

tostring var009, gen(date)
gen month=substr(date,1,1)
gen day=substr(date,2,3)
destring month, gen(monthn)
destring day, gen(dayn)
gen intdate = mdy(monthn, dayn, year)
format intdate %td /* DATE */
egen mode=mode(intdate)
replace intdate=mode if iso3n==380 /* ITALY */

recode var023 (8/9=.), gen(ftv)
recode var051 (8/9=.), gen(fnewsp) 

recode var100 (8/9=.), gen(eetv)
recode var101 (8/9=.), gen(eenews)
recode var102 (8/9=.), gen(eefriends)
recode var103 (8/9=.), gen(eepublic)
recode var104 (8/9=.), gen(eeweb) 

recode var097 (1/25=1) (95=1) (96=1) (97=0) (else=.), gen(turnout) /* TURNOUT */

keep pkn altpkn iso3n year female education age ideology sclass polint residency pistrength intdate turnout ee* f* dif

save EES1999_4, replace
clear all








/* 2004 */ 

use EES2004

/*           IDENTIFIERS                   */
recode country (1=040) (2=056) (3=826) (4=196) (5=203) (6=208) (7=233) (8=246) (9=250) (10=276) (11=300) (12=348) (13=372) (14=380) (15=428) (16=440) (17=442) (19=528) (20=826) (21=616) (22=620) (23=703) (24=705) (25=724) (26=752), gen(iso3n)  /* COUNTRY CODES */
gen year=2004


/*              DVs                   */
forvalues i = 135(1)148 {
by country, sort: egen float sd`i' = sd(v`i') 
recode v`i' (99=.) if sd`i'==0 /* Sadece N.A. kategorisi var ve her ülkede 10+ parti sorulmamış. DK ve N.A.'ler iç içe. Sorulmayanları da N.A. olarak kodlamışlar. O yüzden ülke bazında eğer tüm responselar N.A. oluyorsa missing kodladım */
by country, sort: egen float sdd`i' = sd(v`i') if v`i'<11
by country, sort: egen float mean`i'=mean(v`i') if v`i'<11
gen diff`i'=abs(v`i'-mean`i')
by country, sort: egen float sddiff`i' = sd(diff`i') if v`i'<11
by country, sort: egen float meandiff`i'=mean(diff`i') if v`i'<11
replace diff`i'=meandiff`i'+sddiff`i' if v`i'==99
}
egen pkn=rowtotal(diff*)
egen pknt=rownonmiss(diff*)
replace pkn=pkn/pknt

gen altpkn=.
gen dif=.
egen m1aut=mean(v135) if v135<11 & iso3n==40
egen m2aut=mean(v136) if v136<11 & iso3n==40
replace dif=m1aut-m2aut if iso3n==40
recode v135 (11/99=.) if iso3n==40, gen(aut1)
recode v136 (11/99=.) if iso3n==40, gen(aut2)
replace altpkn=0 if (aut1>aut2 | v135==99 | v136==99) & iso3n==40 
replace altpkn=0 if aut1==aut2 & !missing(aut1, aut2) 
replace altpkn=1 if aut1<aut2 & iso3n==40

* Belgium -> missing *

egen m1cyp=mean(v135) if v135<11 & iso3n==196
egen m2cyp=mean(v136) if v136<11 & iso3n==196
replace dif=m1cyp-m2cyp if iso3n==196
recode v135 (11/99=.) if iso3n==196, gen(cyp1)
recode v136 (11/99=.) if iso3n==196, gen(cyp2)
replace altpkn=0 if (cyp1>cyp2 | v135==99 | v136==99) & iso3n==196 
replace altpkn=0 if cyp1==cyp2 & !missing(cyp1, cyp2) 
replace altpkn=1 if cyp1<cyp2 & iso3n==196

egen m1cz=mean(v135) if v135<11 & iso3n==203
egen m2cz=mean(v138) if v138<11 & iso3n==203
replace dif=m1cz-m2cz if iso3n==203
recode v135 (11/99=.) if iso3n==203, gen(cz1)
recode v138 (11/99=.) if iso3n==203, gen(cz2)
replace altpkn=0 if (cz1>cz2 | v135==99 | v138==99) & iso3n==203 
replace altpkn=0 if cz1==cz2 & !missing(cz1, cz2) 
replace altpkn=1 if cz1<cz2 & iso3n==203

egen m1den=mean(v135) if v135<11 & iso3n==208
egen m2den=mean(v138) if v140<11 & iso3n==208
replace dif=m1den-m2den if iso3n==208
recode v135 (11/99=.) if iso3n==208, gen(den1)
recode v140 (11/99=.) if iso3n==208, gen(den2)
replace altpkn=0 if (den1>den2 | v135==99 | v140==99) & iso3n==208 
replace altpkn=0 if den1==den2 & !missing(den1, den2) 
replace altpkn=1 if den1<den2 & iso3n==208

egen m1est=mean(v135) if v135<11 & iso3n==233
egen m2est=mean(v136) if v136<11 & iso3n==233
replace dif=m1est-m2est if iso3n==233
recode v135 (11/99=.) if iso3n==233, gen(est1)
recode v136 (11/99=.) if iso3n==233, gen(est2)
replace altpkn=0 if (est1>est2 | v135==99 | v136==99) & iso3n==233 
replace altpkn=0 if est1==est2 & !missing(est1, est2) 
replace altpkn=1 if est1<est2 & iso3n==233

egen m1fin=mean(v135) if v135<11 & iso3n==246
egen m2fin=mean(v136) if v136<11 & iso3n==246
tab m1fin m2fin
replace dif=m1fin-m2fin if iso3n==246
recode v135 (11/99=.) if iso3n==246, gen(fin1)
recode v136 (11/99=.) if iso3n==246, gen(fin2)
replace altpkn=0 if (fin1>fin2 | v135==99 | v136==99) & iso3n==246 
replace altpkn=0 if fin1==fin2 & !missing(fin1, fin2) 
replace altpkn=1 if fin1<fin2 & iso3n==246

egen m1fr=mean(v138) if v138<11 & iso3n==250
egen m2fr=mean(v141) if v141<11 & iso3n==250
tab m1fr m2fr
replace dif=m1fr-m2fr if iso3n==250
recode v138 (11/99=.) if iso3n==250, gen(fr1)
recode v141 (11/99=.) if iso3n==250, gen(fr2)
replace altpkn=0 if (fr1>fr2 | v138==99 | v141==99) & iso3n==250 
replace altpkn=0 if fr1==fr2 & !missing(fr1, fr2) 
replace altpkn=1 if fr1<fr2 & iso3n==250

egen m1ger=mean(v135) if v135<11 & iso3n==276
egen m2ger=mean(v137) if v137<11 & iso3n==276
tab m1ger m2ger
replace dif=m1ger-m2ger if iso3n==276
recode v135 (11/99=.) if iso3n==276, gen(ger1)
recode v137 (11/99=.) if iso3n==276, gen(ger2)
replace altpkn=0 if (ger1<ger2 | v135==99 | v137==99) & iso3n==276 
replace altpkn=0 if ger1==ger2 & !missing(ger1, ger2) 
replace altpkn=1 if ger1>ger2 & iso3n==276

egen m1gre=mean(v135) if v135<11 & iso3n==300
egen m2gre=mean(v136) if v136<11 & iso3n==300
tab m1gre m2gre
replace dif=m1gre-m2gre if iso3n==300
recode v135 (11/99=.) if iso3n==300, gen(gre1)
recode v136 (11/99=.) if iso3n==300, gen(gre2)
replace altpkn=0 if (gre1<gre2 | v135==99 | v136==99) & iso3n==300 
replace altpkn=0 if gre1==gre2 & !missing(gre1, gre2) 
replace altpkn=1 if gre1>gre2 & iso3n==300

egen m1hun=mean(v135) if v135<11 & iso3n==348
egen m2hun=mean(v138) if v138<11 & iso3n==348
tab m1hun m2hun
replace dif=m1hun-m2hun if iso3n==348
recode v135 (11/99=.) if iso3n==348, gen(hun1)
recode v138 (11/99=.) if iso3n==348, gen(hun2)
replace altpkn=0 if (hun1<hun2 | v135==99 | v138==99) & iso3n==348 
replace altpkn=0 if hun1==hun2 & !missing(hun1, hun2) 
replace altpkn=1 if hun1>hun2 & iso3n==348

egen m1ire=mean(v135) if v135<11 & iso3n==372
egen m2ire=mean(v136) if v136<11 & iso3n==372
tab m1ire m2ire
replace dif=m1ire-m2ire if iso3n==372
recode v135 (11/99=.) if iso3n==372, gen(ire1)
recode v136 (11/99=.) if iso3n==372, gen(ire2)
replace altpkn=0 if (ire1<ire2 | v135==99 | v136==99) & iso3n==372 
replace altpkn=0 if ire1==ire2 & !missing(ire1, ire2) 
replace altpkn=1 if ire1>ire2 & iso3n==372

egen m1it=mean(v136) if v136<11 & iso3n==380
egen m2it=mean(v143) if v143<11 & iso3n==380
tab m1it m2it
replace dif=m1it-m2it if iso3n==380
recode v136 (11/99=.) if iso3n==380, gen(it1)
recode v143 (11/99=.) if iso3n==380, gen(it2)
replace altpkn=0 if (it1>it2 | v136==99 | v143==99) & iso3n==380 
replace altpkn=0 if it1==it2 & !missing(it1, it2) 
replace altpkn=1 if it1<it2 & iso3n==380

egen m1lat=mean(v135) if v135<11 & iso3n==428
egen m2lat=mean(v136) if v136<11 & iso3n==428
tab m1lat m2lat
replace dif=m1lat-m2lat if iso3n==428
recode v135 (11/99=.) if iso3n==428, gen(lat1)
recode v136 (11/99=.) if iso3n==428, gen(lat2)
replace altpkn=0 if (lat1<lat2 | v135==99 | v136==99) & iso3n==428 
replace altpkn=0 if lat1==lat2 & !missing(lat1, lat2) 
replace altpkn=1 if lat1>lat2 & iso3n==428

egen m1lux=mean(v138) if v138<11 & iso3n==442
egen m2lux=mean(v140) if v140<11 & iso3n==442
tab m1lux m2lux
replace dif=m1lux-m2lux if iso3n==442
recode v138 (11/99=.) if iso3n==442, gen(lux1)
recode v140 (11/99=.) if iso3n==442, gen(lux2)
replace altpkn=0 if (lux1>lux2 | v138==99 | v140==99) & iso3n==442 
replace altpkn=0 if lux1==lux2 & !missing(lux1, lux2) 
replace altpkn=1 if lux1<lux2 & iso3n==442

egen m1net=mean(v135) if v135<11 & iso3n==528
egen m2net=mean(v136) if v136<11 & iso3n==528
tab m1net m2net
replace dif=m1net-m2net if iso3n==528
recode v135 (11/99=.) if iso3n==528, gen(net1)
recode v136 (11/99=.) if iso3n==528, gen(net2)
replace altpkn=0 if (net1>net2 | v135==99 | v136==99) & iso3n==528 
replace altpkn=0 if net1==net2 & !missing(net1, net2) 
replace altpkn=1 if net1<net2 & iso3n==528

egen m1pol=mean(v138) if v138<11 & iso3n==616
egen m2pol=mean(v141) if v141<11 & iso3n==616
tab m1pol m2pol
replace dif=m1pol-m2pol if iso3n==616
recode v138 (11/99=.) if iso3n==616, gen(pol1)
recode v141 (11/99=.) if iso3n==616, gen(pol2)
replace altpkn=0 if (pol1<pol2 | v138==99 | v141==99) & iso3n==616 
replace altpkn=0 if pol1==pol2 & !missing(pol1, pol2) 
replace altpkn=1 if pol1>pol2 & iso3n==616

egen m1por=mean(v139) if v139<11 & iso3n==620
egen m2por=mean(v140) if v140<11 & iso3n==620
tab m1por m2por
replace dif=m1por-m2por if iso3n==620
recode v139 (11/99=.) if iso3n==620, gen(por1)
recode v140 (11/99=.) if iso3n==620, gen(por2)
replace altpkn=0 if (por1>por2 | v139==99 | v140==99) & iso3n==620 
replace altpkn=0 if por1==por2 & !missing(por1, por2) 
replace altpkn=1 if por1<por2 & iso3n==620

egen m1svk=mean(v135) if v135<11 & iso3n==703
egen m2svk=mean(v138) if v138<11 & iso3n==703
tab m1svk m2svk
replace dif=m1svk-m2svk if iso3n==703
recode v135 (11/99=.) if iso3n==703, gen(svk1)
recode v138 (11/99=.) if iso3n==703, gen(svk2)
replace altpkn=0 if (svk1>svk2 | v135==99 | v138==99) & iso3n==703 
replace altpkn=0 if svk1==svk2 & !missing(svk1, svk2) 
replace altpkn=1 if svk1<svk2 & iso3n==703

egen m1svn=mean(v136) if v136<11 & iso3n==705
egen m2svn=mean(v138) if v138<11 & iso3n==705
tab m1svn m2svn
replace dif=m1svn-m2svn if iso3n==705
recode v136 (11/99=.) if iso3n==705, gen(svn1)
recode v138 (11/99=.) if iso3n==705, gen(svn2)
replace altpkn=0 if (svn1>svn2 | v136==99 | v138==99) & iso3n==705 
replace altpkn=0 if svn1==svn2 & !missing(svn1, svn2) 
replace altpkn=1 if svn1<svn2 & iso3n==705

egen m1spa=mean(v135) if v135<11 & iso3n==724
egen m2spa=mean(v136) if v136<11 & iso3n==724
tab m1spa m2spa
replace dif=m1spa-m2spa if iso3n==724
recode v135 (11/99=.) if iso3n==724, gen(spa1)
recode v136 (11/99=.) if iso3n==724, gen(spa2)
replace altpkn=0 if (spa1<spa2 | v135==99 | v136==99) & iso3n==724 
replace altpkn=0 if spa1==spa2 & !missing(spa1, spa2) 
replace altpkn=1 if spa1>spa2 & iso3n==724

egen m1swe=mean(v136) if v136<11 & iso3n==752
egen m2swe=mean(v139) if v139<11 & iso3n==752
tab m1swe m2swe
replace dif=m1swe-m2swe if iso3n==752
recode v136 (11/99=.) if iso3n==752, gen(swe1)
recode v139 (11/99=.) if iso3n==752, gen(swe2)
replace altpkn=0 if (swe1>swe2 | v136==99 | v139==99) & iso3n==752 
replace altpkn=0 if swe1==swe2 & !missing(swe1, swe2) 
replace altpkn=1 if swe1<swe2 & iso3n==752

egen m1uk=mean(v135) if v135<11 & iso3n==826
egen m2uk=mean(v136) if v136<11 & iso3n==826
tab m1uk m2uk
replace dif=m1uk-m2uk if iso3n==826
recode v135 (11/99=.) if iso3n==826, gen(uk1)
recode v136 (11/99=.) if iso3n==826, gen(uk2)
replace altpkn=0 if (uk1>uk2 | v135==99 | v136==99) & iso3n==826 
replace altpkn=0 if uk1==uk2 & !missing(uk1, uk2) 
replace altpkn=1 if uk1<uk2 & iso3n==826


/*               IVs                       */

*Operationalization of Electoral Proximity
gen month=6
recode month (6=7) if 19<date
recode month (7=8) if 50<date
recode month (8=9) if 77<date
recode month (9=.) if date>200

gen day=12 if date==1

forvalues i=2(1)19{
replace day=11+`i' if date==`i'
}

forval i=20(1)50 {
replace day=`i'-19 if date==`i'
} 

forval i=1(1)6 {
replace day=`i' if date==5`i'
}

forval i=57(1)61 {
replace day=`i'-48 if date==`i'
}

forval i=62(1)77 {
replace day=`i'-46 if date==`i'
}

forval i=78(1)107 {
replace day=`i'-77 if date==`i'
}

gen intdate = mdy(month, day, year)
format intdate %td /* DATE */

gen month1=6
gen day1=19
gen june = mdy(month1, day1, year)
format june %td
gen month2=7
gen day2=15
gen july = mdy(month2, day2, year)
format july %td
gen month3=10
gen day3=1
gen oct = mdy(month3, day3, year)
format oct %td
gen month4=12
gen day4=19
gen dec = mdy(month4, day4, year)
format dec %td
replace intdate=jun if iso3n==40
replace intdate=dec if iso3n==56
replace intdate=july if iso3n==196
replace intdate=jun if iso3n==246
replace intdate=oct if iso3n==372
replace intdate=june if iso3n==380
replace intdate=july if iso3n==440
replace intdate=july if iso3n==442
replace intdate=july if missing(intdate) & iso3n==826
replace intdate=june if iso3n==616
replace intdate=june if iso3n==703 /* Problems with Date */

recode v134 (97/99=.), gen(ideology) /* IDEOLOGY */

recode v217 (1=0) (2=1) (9=.), gen(female) /* FEMALE */

recode v218 (9999=.), gen(yob)
gen age=2004-yob /* AGE */

recode v154 (1=4) (2=3) (3=2) (4=1) (9=.), gen(polint)  /* POLITICAL INTEREST */

recode v212 (1=4) (2=3) (3=2) (4=1) (9=.), gen(pistrength) /* PARTY IDENTIFICATION STRENGTH */
/* OBS.LARIN %42'SI MISSING */

gen education=v216
recode education (99=.)
replace education=age if education==97
recode education (0/15=1) (16/19=2) (20/97=3) /* EDUCATION */

recode v224 (2=1) (3=2) (4=3) (5=3) (6/9=.), gen(sclass) /* SUBJ. SOCIAL CLASS */

gen residency=v225
replace residency=1 if v226==5 | v226==4
replace residency=2 if v226==3
replace residency=3 if v226==2 | v226==1 /* Netherlands */

replace residency=1 if v227==1 | v227==2 | v227==3
replace residency=2 if v227==4 
replace residency=3 if v227==5 | v227==6 /* Poland */
recode residency (9=.) /* URBAN/RURAL */

recode v034 (9=.), gen(ftv)
recode v069 (8/9=.), gen(fnewsp)
recode v113 (1/90=1) (96=1) (94/95=.) (99=.) (91=0) (97=0), gen(turnout) 

recode v105 (1=3) (3=1) (2=2) (else=.), gen(eetv)
recode v106 (1=3) (3=1) (2=2) (else=.), gen(eenews)
recode v107 (1=3) (3=1) (2=2) (else=.), gen(eefriends)
recode v108 (1=3) (3=1) (2=2) (else=.), gen(eepublic)
recode v109 (1=3) (3=1) (2=2) (else=.), gen(eeweb)

keep pkn altpkn iso3n year female education age ideology sclass polint residency pistrength intdate ftv fnewsp ee* turnout

save EES2004_4, replace
clear all






/* 2009 */

use EES2009

/*           IDENTIFIERS                   */
tostring t102, gen(ccode)
gen iso=substr(ccode,2,4)
destring iso, gen(iso3n) /* COUNTRY CODES */
gen year=2009


/*           DVs              */
forvalues i = 1(1)15 {
recode q47_p`i' (99=.) (999=.) /* N.A. ve muhtemelen coding hatası */
by t101, sort: egen float sd`i' = sd(q47_p`i') if q47_p`i'<11
by t101, sort: egen float mean`i'=mean(q47_p`i') if q47_p`i'<11
gen diff`i'=abs(q47_p`i'-mean`i')
by t101, sort: egen float sddiff`i' = sd(diff`i') if q47_p`i'<11
by t101, sort: egen float meandiff`i'=mean(diff`i') if q47_p`i'<11
replace diff`i'=meandiff`i'+sddiff`i' if q47_p`i'>20 /* DK, DK how to place party, Refusal */
}
egen pkn=rowtotal(diff*)
egen pknt=rownonmiss(diff*)
replace pkn=pkn/pknt

gen altpkn=.
gen dif=.

egen m1aut=mean(q47_p1) if q47_p1<11 & iso3n==40
egen m2aut=mean(q47_p2) if q47_p2<11 & iso3n==40
tab m1aut m2aut
replace dif=m1aut-m2aut if iso3n==40
recode q47_p1 (11/99=.) if iso3n==40, gen(aut1)
recode q47_p2 (11/99=.) if iso3n==40, gen(aut2)
replace altpkn=0 if (aut1>aut2 | q47_p1>11 | q47_p2>11) & iso3n==40 
replace altpkn=0 if aut1==aut2 & !missing(aut1, aut2) 
replace altpkn=1 if aut1<aut2 & iso3n==40

egen m1bel=mean(q47_p1) if q47_p1<11 & iso3n==56
egen m2bel=mean(q47_p4) if q47_p4<11 & iso3n==56
tab m1bel m2bel
replace dif=m1bel-m2bel if iso3n==56
recode q47_p1 (11/99=.) if iso3n==56, gen(bel1)
recode q47_p4 (11/99=.) if iso3n==56, gen(bel2)
replace altpkn=0 if (bel1>bel2 | q47_p1>11 | q47_p4>11) & iso3n==56 
replace altpkn=0 if bel1==bel2 & !missing(bel1, bel2) 
replace altpkn=1 if bel1<bel2 & iso3n==56

egen m1bul=mean(q47_p1) if q47_p1<11 & iso3n==100
egen m2bul=mean(q47_p2) if q47_p2<11 & iso3n==100
tab m1bul m2bul
replace dif=m1bul-m2bul if iso3n==100
recode q47_p1 (11/99=.) if iso3n==100, gen(bul1)
recode q47_p2 (11/99=.) if iso3n==100, gen(bul2)
replace altpkn=0 if (bul1>bul2 | q47_p1>11 | q47_p2>11) & iso3n==100 
replace altpkn=0 if bul1==bul2 & !missing(bul1, bul2) 
replace altpkn=1 if bul1<bul2 & iso3n==100

egen m1cyp=mean(q47_p1) if q47_p1<11 & iso3n==196
egen m2cyp=mean(q47_p2) if q47_p2<11 & iso3n==196
tab m1cyp m2cyp
replace dif=m1cyp-m2cyp if iso3n==196
recode q47_p1 (11/99=.) if iso3n==196, gen(cyp1)
recode q47_p2 (11/99=.) if iso3n==196, gen(cyp2)
replace altpkn=0 if (cyp1>cyp2 | q47_p1>11 | q47_p2>11) & iso3n==196 
replace altpkn=0 if cyp1==cyp2 & !missing(cyp1, cyp2) 
replace altpkn=1 if cyp1<cyp2 & iso3n==196

egen m1cz=mean(q47_p1) if q47_p1<11 & iso3n==203
egen m2cz=mean(q47_p4) if q47_p4<11 & iso3n==203
tab m1cz m2cz
replace dif=m1cz-m2cz if iso3n==203
recode q47_p1 (11/99=.) if iso3n==203, gen(cz1)
recode q47_p4 (11/99=.) if iso3n==203, gen(cz2)
replace altpkn=0 if (cz1>cz2 | q47_p1>11 | q47_p4>11) & iso3n==203 
replace altpkn=0 if cz1==cz2 & !missing(cz1, cz2) 
replace altpkn=1 if cz1<cz2 & iso3n==203

egen m1den=mean(q47_p1) if q47_p1<11 & iso3n==208
egen m2den=mean(q47_p3) if q47_p3<11 & iso3n==208
tab m1den m2den
replace dif=m1den-m2den if iso3n==208
recode q47_p1 (11/99=.) if iso3n==208, gen(den1)
recode q47_p3 (11/99=.) if iso3n==208, gen(den2)
replace altpkn=0 if (den1>den2 | q47_p1>11 | q47_p3>11) & iso3n==208 
replace altpkn=0 if den1==den2 & !missing(den1, den2) 
replace altpkn=1 if den1<den2 & iso3n==208

egen m1est=mean(q47_p1) if q47_p1<11 & iso3n==233
egen m2est=mean(q47_p2) if q47_p2<11 & iso3n==233
tab m1est m2est
replace dif=m1est-m2est if iso3n==233
recode q47_p1 (11/99=.) if iso3n==233, gen(est1)
recode q47_p2 (11/99=.) if iso3n==233, gen(est2)
replace altpkn=0 if (est1<est2 | q47_p1>11 | q47_p2>11) & iso3n==233 
replace altpkn=0 if est1==est2 & !missing(est1, est2) 
replace altpkn=1 if est1>est2 & iso3n==233

egen m1fin=mean(q47_p2) if q47_p2<11 & iso3n==246
egen m2fin=mean(q47_p3) if q47_p3<11 & iso3n==246
tab m1fin m2fin
replace dif=m1fin-m2fin if iso3n==246
recode q47_p2 (11/99=.) if iso3n==246, gen(fin1)
recode q47_p3 (11/99=.) if iso3n==246, gen(fin2)
replace altpkn=0 if (fin1>fin2 | q47_p2>11 | q47_p3>11) & iso3n==246 
replace altpkn=0 if fin1==fin2 & !missing(fin1, fin2) 
replace altpkn=1 if fin1<fin2 & iso3n==246

egen m1fr=mean(q47_p3) if q47_p3<11 & iso3n==250
egen m2fr=mean(q47_p6) if q47_p6<11 & iso3n==250
tab m1fr m2fr
replace dif=m1fr-m2fr if iso3n==250
recode q47_p3 (11/99=.) if iso3n==250, gen(fr1)
recode q47_p6 (11/99=.) if iso3n==250, gen(fr2)
replace altpkn=0 if (fr1>fr2 | q47_p3>11 | q47_p6>11) & iso3n==250 
replace altpkn=0 if fr1==fr2 & !missing(fr1, fr2) 
replace altpkn=1 if fr1<fr2 & iso3n==250

egen m1ger=mean(q47_p1) if q47_p1<11 & iso3n==276
egen m2ger=mean(q47_p2) if q47_p2<11 & iso3n==276
tab m1ger m2ger
replace dif=m1ger-m2ger if iso3n==276
recode q47_p1 (11/99=.) if iso3n==276, gen(ger1)
recode q47_p2 (11/99=.) if iso3n==276, gen(ger2)
replace altpkn=0 if (ger1<ger2 | q47_p1>11 | q47_p2>11) & iso3n==276 
replace altpkn=0 if ger1==ger2 & !missing(ger1, ger2) 
replace altpkn=1 if ger1>ger2 & iso3n==276

egen m1gre=mean(q47_p1) if q47_p1<11 & iso3n==300
egen m2gre=mean(q47_p2) if q47_p2<11 & iso3n==300
tab m1gre m2gre
replace dif=m1gre-m2gre if iso3n==300
recode q47_p1 (11/99=.) if iso3n==300, gen(gre1)
recode q47_p2 (11/99=.) if iso3n==300, gen(gre2)
replace altpkn=0 if (gre1<gre2 | q47_p1>11 | q47_p2>11) & iso3n==300 
replace altpkn=0 if gre1==gre2 & !missing(gre1, gre2) 
replace altpkn=1 if gre1>gre2 & iso3n==300

egen m1hun=mean(q47_p1) if q47_p1<11 & iso3n==348
egen m2hun=mean(q47_p7) if q47_p7<11 & iso3n==348
tab m1hun m2hun
replace dif=m1hun-m2hun if iso3n==348
recode q47_p1 (11/99=.) if iso3n==348, gen(hun1)
recode q47_p7 (11/99=.) if iso3n==348, gen(hun2)
replace altpkn=0 if (hun1<hun2 | q47_p1>11 | q47_p7>11) & iso3n==348 
replace altpkn=0 if hun1==hun2 & !missing(hun1, hun2) 
replace altpkn=1 if hun1>hun2 & iso3n==348

egen m1ire=mean(q47_p1) if q47_p1<11 & iso3n==372
egen m2ire=mean(q47_p2) if q47_p2<11 & iso3n==372
tab m1ire m2ire
replace dif=m1ire-m2ire if iso3n==372
recode q47_p1 (11/99=.) if iso3n==372, gen(ire1)
recode q47_p2 (11/99=.) if iso3n==372, gen(ire2)
replace altpkn=0 if (ire1>ire2 | q47_p1>11 | q47_p2>11) & iso3n==372 
replace altpkn=0 if ire1==ire2 & !missing(ire1, ire2) 
replace altpkn=1 if ire1<ire2 & iso3n==372

egen m1ita=mean(q47_p1) if q47_p1<11 & iso3n==380
egen m2ita=mean(q47_p3) if q47_p3<11 & iso3n==380
tab m1ita m2ita
replace dif=m1ita-m2ita if iso3n==380
recode q47_p1 (11/99=.) if iso3n==380, gen(ita1)
recode q47_p3 (11/99=.) if iso3n==380, gen(ita2)
replace altpkn=0 if (ita1<ita2 | q47_p1>11 | q47_p3>11) & iso3n==380 
replace altpkn=0 if ita1==ita2 & !missing(ita1, ita2) 
replace altpkn=1 if ita1>ita2 & iso3n==380

egen m1lat=mean(q47_p3) if q47_p3<11 & iso3n==428
egen m2lat=mean(q47_p7) if q47_p7<11 & iso3n==428
tab m1lat m2lat
replace dif=m1lat-m2lat if iso3n==428
recode q47_p3 (11/99=.) if iso3n==428, gen(lat1)
recode q47_p7 (11/99=.) if iso3n==428, gen(lat2)
replace altpkn=0 if (lat1<lat2 | q47_p3>11 | q47_p7>11) & iso3n==428 
replace altpkn=0 if lat1==lat2 & !missing(lat1, lat2) 
replace altpkn=1 if lat1>lat2 & iso3n==428

egen m1lit=mean(q47_p1) if q47_p1<11 & iso3n==440
egen m2lit=mean(q47_p3) if q47_p3<11 & iso3n==440
tab m1lit m2lit
replace dif=m1lit-m2lit if iso3n==440
recode q47_p1 (11/99=.) if iso3n==440, gen(lit1)
recode q47_p3 (11/99=.) if iso3n==440, gen(lit2)
replace altpkn=0 if (lit1<lit2 | q47_p1>11 | q47_p3>11) & iso3n==440 
replace altpkn=0 if lit1==lit2 & !missing(lit1, lit2) 
replace altpkn=1 if lit1>lit2 & iso3n==440

egen m1lux=mean(q47_p2) if q47_p2<11 & iso3n==442
egen m2lux=mean(q47_p4) if q47_p4<11 & iso3n==442
tab m1lux m2lux
replace dif=m1lux-m2lux if iso3n==442
recode q47_p2 (11/99=.) if iso3n==442, gen(lux1)
recode q47_p4 (11/99=.) if iso3n==442, gen(lux2)
replace altpkn=0 if (lux1>lux2 | q47_p2>11 | q47_p4>11) & iso3n==442 
replace altpkn=0 if lux1==lux2 & !missing(lux1, lux2) 
replace altpkn=1 if lux1<lux2 & iso3n==442

egen m1mal=mean(q47_p1) if q47_p1<11 & iso3n==470
egen m2mal=mean(q47_p2) if q47_p2<11 & iso3n==470
tab m1mal m2mal
replace dif=m1mal-m2mal if iso3n==470
recode q47_p1 (11/99=.) if iso3n==470, gen(mal1)
recode q47_p2 (11/99=.) if iso3n==470, gen(mal2)
replace altpkn=0 if (mal1<mal2 | q47_p1>11 | q47_p2>11) & iso3n==470 
replace altpkn=0 if mal1==mal2 & !missing(mal1, mal2) 
replace altpkn=1 if mal1>mal2 & iso3n==470

egen m1net=mean(q47_p1) if q47_p1<11 & iso3n==528
egen m2net=mean(q47_p2) if q47_p2<11 & iso3n==528
tab m1net m2net
replace dif=m1net-m2net if iso3n==528
recode q47_p1 (11/99=.) if iso3n==528, gen(net1)
recode q47_p2 (11/99=.) if iso3n==528, gen(net2)
replace altpkn=0 if (net1>net2 | q47_p1>11 | q47_p2>11) & iso3n==528 
replace altpkn=0 if net1==net2 & !missing(net1, net2) 
replace altpkn=1 if net1<net2 & iso3n==528

egen m1pol=mean(q47_p9) if q47_p9<11 & iso3n==616
egen m2pol=mean(q47_p10) if q47_p10<11 & iso3n==616
tab m1pol m2pol
replace dif=m1pol-m2pol if iso3n==616
recode q47_p9 (11/99=.) if iso3n==616, gen(pol1)
recode q47_p10 (11/99=.) if iso3n==616, gen(pol2)
replace altpkn=0 if (pol1>pol2 | q47_p9>11 | q47_p2>11) & iso3n==616 
replace altpkn=0 if pol1==pol2 & !missing(pol1, pol2) 
replace altpkn=1 if pol1<pol2 & iso3n==616

egen m1por=mean(q47_p4) if q47_p4<11 & iso3n==620
egen m2por=mean(q47_p5) if q47_p5<11 & iso3n==620
tab m1por m2por
replace dif=m1por-m2por if iso3n==620
recode q47_p4 (11/99=.) if iso3n==620, gen(por1)
recode q47_p5 (11/99=.) if iso3n==620, gen(por2)
replace altpkn=0 if (por1>por2 | q47_p4>11 | q47_p5>11) & iso3n==620 
replace altpkn=0 if por1==por2 & !missing(por1, por2) 
replace altpkn=1 if por1<por2 & iso3n==620

egen m1rom=mean(q47_p1) if q47_p1<11 & iso3n==642
egen m2rom=mean(q47_p2) if q47_p2<11 & iso3n==642
tab m1rom m2rom
replace dif=m1rom-m2rom if iso3n==642
recode q47_p1 (11/99=.) if iso3n==642, gen(rom1)
recode q47_p2 (11/99=.) if iso3n==642, gen(rom2)
replace altpkn=0 if (rom1<rom2 | q47_p1>11 | q47_p2>11) & iso3n==642 
replace altpkn=0 if rom1==rom2 & !missing(rom1, rom2) 
replace altpkn=1 if rom1>rom2 & iso3n==642

egen m1svk=mean(q47_p2) if q47_p2<11 & iso3n==703
egen m2svk=mean(q47_p3) if q47_p3<11 & iso3n==703
tab m1svk m2svk
replace dif=m1svk-m2svk if iso3n==703
recode q47_p2 (11/99=.) if iso3n==703, gen(svk1)
recode q47_p3 (11/99=.) if iso3n==703, gen(svk2)
replace altpkn=0 if (svk1>svk2 | q47_p2>11 | q47_p3>11) & iso3n==703 
replace altpkn=0 if svk1==svk2 & !missing(svk1, svk2) 
replace altpkn=1 if svk1<svk2 & iso3n==703

egen m1svn=mean(q47_p5) if q47_p5<11 & iso3n==705
egen m2svn=mean(q47_p6) if q47_p6<11 & iso3n==705
tab m1svn m2svn
replace dif=m1svn-m2svn if iso3n==705
recode q47_p5 (11/99=.) if iso3n==705, gen(svn1)
recode q47_p6 (11/99=.) if iso3n==705, gen(svn2)
replace altpkn=0 if (svn1<svn2 | q47_p5>11 | q47_p6>11) & iso3n==705 
replace altpkn=0 if svn1==svn2 & !missing(svn1, svn2) 
replace altpkn=1 if svn1>svn2 & iso3n==705

egen m1spa=mean(q47_p1) if q47_p1<11 & iso3n==724
egen m2spa=mean(q47_p2) if q47_p2<11 & iso3n==724
tab m1spa m2spa
replace dif=m1spa-m2spa if iso3n==724
recode q47_p1 (11/99=.) if iso3n==724, gen(spa1)
recode q47_p2 (11/99=.) if iso3n==724, gen(spa2)
replace altpkn=0 if (spa1<spa2 | q47_p1>11 | q47_p2>11) & iso3n==724 
replace altpkn=0 if spa1==spa2 & !missing(spa1, spa2) 
replace altpkn=1 if spa1>spa2 & iso3n==724

egen m1swe=mean(q47_p2) if q47_p2<11 & iso3n==752
egen m2swe=mean(q47_p5) if q47_p5<11 & iso3n==752
tab m1swe m2swe
replace dif=m1swe-m2swe if iso3n==752
recode q47_p2 (11/99=.) if iso3n==752, gen(swe1)
recode q47_p5 (11/99=.) if iso3n==752, gen(swe2)
replace altpkn=0 if (swe1>swe2 | q47_p2>11 | q47_p5>11) & iso3n==752 
replace altpkn=0 if swe1==swe2 & !missing(swe1, swe2) 
replace altpkn=1 if swe1<swe2 & iso3n==752

egen m1uk=mean(q47_p1) if q47_p1<11 & iso3n==826
egen m2uk=mean(q47_p2) if q47_p2<11 & iso3n==826
tab m1uk m2uk
replace dif=m1uk-m2uk if iso3n==826
recode q47_p1 (11/99=.) if iso3n==826, gen(uk1)
recode q47_p2 (11/99=.) if iso3n==826, gen(uk2)
replace altpkn=0 if (uk1>uk2 | q47_p1>11 | q47_p2>11) & iso3n==826 
replace altpkn=0 if uk1==uk2 & !missing(uk1, uk2) 
replace altpkn=1 if uk1<uk2 & iso3n==826



/*               IVs                       */
gen intdate = mdy(t301, t302, t300)
format intdate %td   /* DATE */

recode q46 (77/98=.), gen(ideology)   /* IDEOLOGY */

recode q102 (1=0) (2=1) (7=.), gen(female)   /* FEMALE */

recode q103 (7777=.), gen(yob)
gen age=2009-yob  /* AGE */

recode q78 (1=4) (2=3) (3=2) (4=1) (7/8=.), gen(polint) /* POLITICAL INTEREST */

recode v301 (0=1) (1=2) (7/9=.), gen(pistrength) /* PARTY IDENTIFICATION STRENGTH */

gen education=q100
recode education (77/88=.)
replace education=age if education==98
recode education (0/15=1) (16/19=2) (20/97=3) /* EDUCATION */

recode q114 (2=1) (3=2) (4=3) (5=3) (6/8=.), gen(sclass)  /* SUBJ. SOCIAL CLASS */

recode q115 (4=3) (7/8=.), gen(residency) /* URBAN/RURAL */

foreach var in a b c{
recode q12_`var' (77/99=.), gen(np`var')
}
foreach var in a b c d e {
recode q15`var' (77/99=.), gen(npa`var')
}
gen fnewsp=.
replace fnewsp=max(npa, npb, npc) if q13==2
replace fnewsp=max(npaa, npab, npac, npad, npae) if q13==1   /* FREQ. OF NEWSPAPER */

foreach var in a b c d{
recode q8_`var' (77/99=.), gen(tv`var')
}
foreach var in a b c d e {
recode q11`var' (77/99=.), gen(tva`var')
}
gen ftv=.
replace ftv=max(tva, tvb, tvc) if q9==2
replace ftv=max(tvaa, tvab, tvac, tvad, tvae) if q9==1     /* FREQ. OF TV */

recode q27 (20=1) (77=.) (88=0) (93=.) (94=1) (95=1) (96=0) (99=.) (else=1), gen(turnout)

recode q16 (1=3) (3=1) (2=2) (else=.), gen(eetv)
recode q17 (1=3) (3=1) (2=2) (else=.), gen(eenews)
recode q18 (1=3) (3=1) (2=2) (else=.), gen(eefriends)
recode q19 (1=3) (3=1) (2=2) (else=.), gen(eepublic)
recode q20 (1=3) (3=1) (2=2) (else=.), gen(eeweb)

keep pkn altpkn iso3n year female education age ideology sclass polint residency pistrength intdate ftv fnewsp ee* turnout dif

save EES2009_4, replace
clear all






/* 2014 */

use EES2014

/*           IDENTIFIERS                   */
tostring countrycode, gen(ccode)
gen iso=substr(ccode,2,4)
destring iso, gen(iso3n) /* COUNTRY CODES */
gen year=2014


/*           DVs              */
forvalues i = 1(1)8 {
replace qpp14_`i'=qpp14_`i'-1 if qpp14_`i'>=0 /* 0-10 arası değil 1-11 arası kodlanmış, öncekilerle uygun olması adına böyle kodladım */
by countrycode, sort: egen float sd`i' = sd(qpp14_`i') if qpp14_`i'>=0
by countrycode, sort: egen float mean`i'=mean(qpp14_`i') if qpp14_`i'>=0
gen diff`i'=abs(qpp14_`i'-mean`i')
by countrycode, sort: egen float sddiff`i' = sd(diff`i') if qpp14_`i'>=0
by countrycode, sort: egen float meandiff`i'=mean(diff`i') if qpp14_`i'>=0
recode qpp14_`i' (-7=.) /* -7 = System Missing */
replace diff`i'=meandiff`i'+sddiff`i' if qpp14_`i'<0 /* Do not know party, do not know where to place, refusal */
}
egen pkn=rowtotal(diff*)
egen pknt=rownonmiss(diff*)
replace pkn=pkn/pknt

gen altpkn=.
gen dif=.

egen m1aut=mean(qpp14_1) if qpp14_1>-1 & iso3n==40
egen m2aut=mean(qpp14_2) if qpp14_2>-1 & iso3n==40
tab m1aut m2aut
replace dif=m1aut-m2aut if iso3n==40
recode qpp14_1 (-100/-1=.) if iso3n==40, gen(aut1)
recode qpp14_2 (-100/-1=.) if iso3n==40, gen(aut2)
replace altpkn=0 if (aut1<aut2 | qpp14_1<0 | qpp14_2<0) & iso3n==40 
replace altpkn=0 if aut1==aut2 & !missing(aut1, aut2) 
replace altpkn=1 if aut1>aut2 & iso3n==40

egen m1bel=mean(qpp14_1) if qpp14_1>-1 & iso3n==56
egen m2bel=mean(qpp14_4) if qpp14_4>-1 & iso3n==56
tab m1bel m2bel
replace dif=m1bel-m2bel if iso3n==56
recode qpp14_1 (-100/-1=.) if iso3n==56, gen(bel1)
recode qpp14_4 (-100/-1=.) if iso3n==56, gen(bel2)
replace altpkn=0 if (bel1>bel2 | qpp14_1<0 | qpp14_4<0) & iso3n==56 
replace altpkn=0 if bel1==bel2 & !missing(bel1, bel2) 
replace altpkn=1 if bel1<bel2 & iso3n==56

egen m1bul=mean(qpp14_1) if qpp14_1>-1 & iso3n==100
egen m2bul=mean(qpp14_2) if qpp14_2>-1 & iso3n==100
tab m1bul m2bul
replace dif=m1bul-m2bul if iso3n==100
recode qpp14_1 (-100/-1=.) if iso3n==100, gen(bul1)
recode qpp14_2 (-100/-1=.) if iso3n==100, gen(bul2)
replace altpkn=0 if (bul1<bul2 | qpp14_1<0 | qpp14_2<0) & iso3n==100 
replace altpkn=0 if bul1==bul2 & !missing(bul1, bul2) 
replace altpkn=1 if bul1>bul2 & iso3n==100

egen m1cro=mean(qpp14_1) if qpp14_1>-1 & iso3n==191
egen m2cro=mean(qpp14_3) if qpp14_3>-1 & iso3n==191
tab m1cro m2cro
replace dif=m1cro-m2cro if iso3n==191
recode qpp14_1 (-100/-1=.) if iso3n==191, gen(cro1)
recode qpp14_3 (-100/-1=.) if iso3n==191, gen(cro2)
replace altpkn=0 if (cro1>cro2 | qpp14_1<0 | qpp14_3<0) & iso3n==191 
replace altpkn=0 if cro1==cro2 & !missing(cro1, cro2) 
replace altpkn=1 if cro1<cro2 & iso3n==191

egen m1cyp=mean(qpp14_1) if qpp14_1>-1 & iso3n==196
egen m2cyp=mean(qpp14_4) if qpp14_4>-1 & iso3n==196
tab m1cyp m2cyp
replace dif=m1cyp-m2cyp if iso3n==196
recode qpp14_1 (-100/-1=.) if iso3n==196, gen(cyp1)
recode qpp14_4 (-100/-1=.) if iso3n==196, gen(cyp2)
replace altpkn=0 if (cyp1<cyp2 | qpp14_1<0 | qpp14_4<0) & iso3n==196 
replace altpkn=0 if cyp1==cyp2 & !missing(cyp1, cyp2) 
replace altpkn=1 if cyp1>cyp2 & iso3n==196

egen m1cz=mean(qpp14_3) if qpp14_3>-1 & iso3n==203
egen m2cz=mean(qpp14_7) if qpp14_7>-1 & iso3n==203
tab m1cz m2cz
replace dif=m1cz-m2cz if iso3n==203
recode qpp14_3 (-100/-1=.) if iso3n==203, gen(cz1)
recode qpp14_7 (-100/-1=.) if iso3n==203, gen(cz2)
replace altpkn=0 if (cz1>cz2 | qpp14_3<0 | qpp14_7<0) & iso3n==203 
replace altpkn=0 if cz1==cz2 & !missing(cz1, cz2) 
replace altpkn=1 if cz1<cz2 & iso3n==203

egen m1den=mean(qpp14_1) if qpp14_1>-1 & iso3n==208
egen m2den=mean(qpp14_2) if qpp14_2>-1 & iso3n==208
tab m1den m2den
replace dif=m1den-m2den if iso3n==208
recode qpp14_1 (-100/-1=.) if iso3n==208, gen(den1)
recode qpp14_2 (-100/-1=.) if iso3n==208, gen(den2)
replace altpkn=0 if (den1>den2 | qpp14_1<0 | qpp14_2<0) & iso3n==208 
replace altpkn=0 if den1==den2 & !missing(den1, den2) 
replace altpkn=1 if den1<den2 & iso3n==208

egen m1est=mean(qpp14_3) if qpp14_3>-1 & iso3n==233
egen m2est=mean(qpp14_4) if qpp14_4>-1 & iso3n==233
tab m1est m2est
replace dif=m1est-m2est if iso3n==233
recode qpp14_3 (-100/-1=.) if iso3n==233, gen(est1)
recode qpp14_4 (-100/-1=.) if iso3n==233, gen(est2)
replace altpkn=0 if (est1<est2 | qpp14_3<0 | qpp14_4<0) & iso3n==233 
replace altpkn=0 if est1==est2 & !missing(est1, est2) 
replace altpkn=1 if est1>est2 & iso3n==233

egen m1fin=mean(qpp14_1) if qpp14_1>-1 & iso3n==246
egen m2fin=mean(qpp14_3) if qpp14_3>-1 & iso3n==246
tab m1fin m2fin
replace dif=m1fin-m2fin if iso3n==246
recode qpp14_1 (-100/-1=.) if iso3n==246, gen(fin1)
recode qpp14_3 (-100/-1=.) if iso3n==246, gen(fin2)
replace altpkn=0 if (fin1<fin2 | qpp14_1<0 | qpp14_3<0) & iso3n==246 
replace altpkn=0 if fin1==fin2 & !missing(fin1, fin2) 
replace altpkn=1 if fin1>fin2 & iso3n==246

egen m1fr=mean(qpp14_1) if qpp14_1>-1 & iso3n==250
egen m2fr=mean(qpp14_2) if qpp14_2>-1 & iso3n==250
tab m1fr m2fr
replace dif=m1fr-m2fr if iso3n==250
recode qpp14_1 (-100/-1=.) if iso3n==250, gen(fr1)
recode qpp14_2 (-100/-1=.) if iso3n==250, gen(fr2)
replace altpkn=0 if (fr1<fr2 | qpp14_1<0 | qpp14_2<0) & iso3n==250 
replace altpkn=0 if fr1==fr2 & !missing(fr1, fr2) 
replace altpkn=1 if fr1>fr2 & iso3n==250

egen m1ger=mean(qpp14_1) if qpp14_1>-1 & iso3n==276
egen m2ger=mean(qpp14_2) if qpp14_2>-1 & iso3n==276
tab m1ger m2ger
replace dif=m1ger-m2ger if iso3n==276
recode qpp14_1 (-100/-1=.) if iso3n==276, gen(ger1)
recode qpp14_2 (-100/-1=.) if iso3n==276, gen(ger2)
replace altpkn=0 if (ger1<ger2 | qpp14_1<0 | qpp14_2<0) & iso3n==276 
replace altpkn=0 if ger1==ger2 & !missing(ger1, ger2) 
replace altpkn=1 if ger1>ger2 & iso3n==276

egen m1gre=mean(qpp14_1) if qpp14_1>-1 & iso3n==300
egen m2gre=mean(qpp14_2) if qpp14_2>-1 & iso3n==300
tab m1gre m2gre
replace dif=m1gre-m2gre if iso3n==300
recode qpp14_1 (-100/-1=.) if iso3n==300, gen(gre1)
recode qpp14_2 (-100/-1=.) if iso3n==300, gen(gre2)
replace altpkn=0 if (gre1<gre2 | qpp14_1<0 | qpp14_2<0) & iso3n==300 
replace altpkn=0 if gre1==gre2 & !missing(gre1, gre2) 
replace altpkn=1 if gre1>gre2 & iso3n==300

egen m1hun=mean(qpp14_3) if qpp14_3>-1 & iso3n==348
egen m2hun=mean(qpp14_4) if qpp14_4>-1 & iso3n==348
tab m1hun m2hun
replace dif=m1hun-m2hun if iso3n==348
recode qpp14_3 (-100/-1=.) if iso3n==348, gen(hun1)
recode qpp14_4 (-100/-1=.) if iso3n==348, gen(hun2)
replace altpkn=0 if (hun1<hun2 | qpp14_3<0 | qpp14_4<0) & iso3n==348 
replace altpkn=0 if hun1==hun2 & !missing(hun1, hun2) 
replace altpkn=1 if hun1>hun2 & iso3n==348

egen m1ire=mean(qpp14_1) if qpp14_1>-1 & iso3n==372
egen m2ire=mean(qpp14_2) if qpp14_2>-1 & iso3n==372
tab m1ire m2ire
replace dif=m1ire-m2ire if iso3n==372
recode qpp14_1 (-100/-1=.) if iso3n==372, gen(ire1)
recode qpp14_2 (-100/-1=.) if iso3n==372, gen(ire2)
replace altpkn=0 if (ire1<ire2 | qpp14_1<0 | qpp14_2<0) & iso3n==372 
replace altpkn=0 if ire1==ire2 & !missing(ire1, ire2) 
replace altpkn=1 if ire1>ire2 & iso3n==372

egen m1ita=mean(qpp14_1) if qpp14_1>-1 & iso3n==380
egen m2ita=mean(qpp14_4) if qpp14_4>-1 & iso3n==380
tab m1ita m2ita
replace dif=m1ita-m2ita if iso3n==380
recode qpp14_1 (-100/-1=.) if iso3n==380, gen(ita1)
recode qpp14_4 (-100/-1=.) if iso3n==380, gen(ita2)
replace altpkn=0 if (ita1>ita2 | qpp14_1<0 | qpp14_4<0) & iso3n==380 
replace altpkn=0 if ita1==ita2 & !missing(ita1, ita2) 
replace altpkn=1 if ita1<ita2 & iso3n==380

egen m1lat=mean(qpp14_2) if qpp14_2>-1 & iso3n==428
egen m2lat=mean(qpp14_5) if qpp14_5>-1 & iso3n==428
tab m1lat m2lat
replace dif=m1lat-m2lat if iso3n==428
recode qpp14_2 (-100/-1=.) if iso3n==428, gen(lat1)
recode qpp14_5 (-100/-1=.) if iso3n==428, gen(lat2)
replace altpkn=0 if (lat1>lat2 | qpp14_2<0 | qpp14_5<0) & iso3n==428 
replace altpkn=0 if lat1==lat2 & !missing(lat1, lat2) 
replace altpkn=1 if lat1<lat2 & iso3n==428

egen m1lit=mean(qpp14_2) if qpp14_2>-1 & iso3n==440
egen m2lit=mean(qpp14_4) if qpp14_4>-1 & iso3n==440
tab m1lit m2lit
replace dif=m1lit-m2lit if iso3n==440
recode qpp14_2 (-100/-1=.) if iso3n==440, gen(lit1)
recode qpp14_4 (-100/-1=.) if iso3n==440, gen(lit2)
replace altpkn=0 if (lit1>lit2 | qpp14_2<0 | qpp14_4<0) & iso3n==440 
replace altpkn=0 if lit1==lit2 & !missing(lit1, lit2) 
replace altpkn=1 if lit1<lit2 & iso3n==440

egen m1lux=mean(qpp14_1) if qpp14_1>-1 & iso3n==442
egen m2lux=mean(qpp14_2) if qpp14_2>-1 & iso3n==442
tab m1lux m2lux
replace dif=m1lux-m2lux if iso3n==442
recode qpp14_1 (-100/-1=.) if iso3n==442, gen(lux1)
recode qpp14_2 (-100/-1=.) if iso3n==442, gen(lux2)
replace altpkn=0 if (lux1<lux2 | qpp14_1<0 | qpp14_2<0) & iso3n==442 
replace altpkn=0 if lux1==lux2 & !missing(lux1, lux2) 
replace altpkn=1 if lux1>lux2 & iso3n==442

egen m1mal=mean(qpp14_1) if qpp14_1>-1 & iso3n==470
egen m2mal=mean(qpp14_2) if qpp14_2>-1 & iso3n==470
tab m1mal m2mal
replace dif=m1mal-m2mal if iso3n==470
recode qpp14_1 (-100/-1=.) if iso3n==470, gen(mal1)
recode qpp14_2 (-100/-1=.) if iso3n==470, gen(mal2)
replace altpkn=0 if (mal1>mal2 | qpp14_1<0 | qpp14_2<0) & iso3n==470 
replace altpkn=0 if mal1==mal2 & !missing(mal1, mal2) 
replace altpkn=1 if mal1<mal2 & iso3n==470

egen m1net=mean(qpp14_1) if qpp14_1>-1 & iso3n==528
egen m2net=mean(qpp14_2) if qpp14_2>-1 & iso3n==528
tab m1net m2net
replace dif=m1net-m2net if iso3n==528
recode qpp14_1 (-100/-1=.) if iso3n==528, gen(net1)
recode qpp14_2 (-100/-1=.) if iso3n==528, gen(net2)
replace altpkn=0 if (net1<net2 | qpp14_1<0 | qpp14_2<0) & iso3n==528 
replace altpkn=0 if net1==net2 & !missing(net1, net2) 
replace altpkn=1 if net1>net2 & iso3n==528

egen m1pol=mean(qpp14_1) if qpp14_1>-1 & iso3n==616
egen m2pol=mean(qpp14_4) if qpp14_4>-1 & iso3n==616
tab m1pol m2pol
replace dif=m1pol-m2pol if iso3n==616
recode qpp14_1 (-100/-1=.) if iso3n==616, gen(pol1)
recode qpp14_4 (-100/-1=.) if iso3n==616, gen(pol2)
replace altpkn=0 if (pol1>pol2 | qpp14_1<0 | qpp14_2<0) & iso3n==616 
replace altpkn=0 if pol1==pol2 & !missing(pol1, pol2) 
replace altpkn=1 if pol1<pol2 & iso3n==616

egen m1por=mean(qpp14_1) if qpp14_1>-1 & iso3n==620
egen m2por=mean(qpp14_4) if qpp14_4>-1 & iso3n==620
tab m1por m2por
replace dif=m1por-m2por if iso3n==620
recode qpp14_1 (-100/-1=.) if iso3n==620, gen(por1)
recode qpp14_4 (-100/-1=.) if iso3n==620, gen(por2)
replace altpkn=0 if (por1<por2 | qpp14_1<0 | qpp14_4<0) & iso3n==620 
replace altpkn=0 if por1==por2 & !missing(por1, por2) 
replace altpkn=1 if por1>por2 & iso3n==620

egen m1rom=mean(qpp14_1) if qpp14_1>-1 & iso3n==642
egen m2rom=mean(qpp14_2) if qpp14_2>-1 & iso3n==642
tab m1rom m2rom
replace dif=m1rom-m2rom if iso3n==642
recode qpp14_1 (-100/-1=.) if iso3n==642, gen(rom1)
recode qpp14_2 (-100/-1=.) if iso3n==642, gen(rom2)
replace altpkn=0 if (rom1>rom2 | qpp14_1<0 | qpp14_2<0) & iso3n==642 
replace altpkn=0 if rom1==rom2 & !missing(rom1, rom2) 
replace altpkn=1 if rom1<rom2 & iso3n==642

egen m1svk=mean(qpp14_1) if qpp14_1>-1 & iso3n==703
egen m2svk=mean(qpp14_4) if qpp14_4>-1 & iso3n==703
tab m1svk m2svk
replace dif=m1svk-m2svk if iso3n==703
recode qpp14_1 (-100/-1=.) if iso3n==703, gen(svk1)
recode qpp14_4 (-100/-1=.) if iso3n==703, gen(svk2)
replace altpkn=0 if (svk1<svk2 | qpp14_1<0 | qpp14_4<0) & iso3n==703 
replace altpkn=0 if svk1==svk2 & !missing(svk1, svk2) 
replace altpkn=1 if svk1>svk2 & iso3n==703

egen m1svn=mean(qpp14_1) if qpp14_1>-1 & iso3n==705
egen m2svn=mean(qpp14_2) if qpp14_2>-1 & iso3n==705
tab m1svn m2svn
replace dif=m1svn-m2svn if iso3n==705
recode qpp14_1 (-100/-1=.) if iso3n==705, gen(svn1)
recode qpp14_2 (-100/-1=.) if iso3n==705, gen(svn2)
replace altpkn=0 if (svn1>svn2 | qpp14_1<0 | qpp14_2<0) & iso3n==705 
replace altpkn=0 if svn1==svn2 & !missing(svn1, svn2) 
replace altpkn=1 if svn1<svn2 & iso3n==705

egen m1spa=mean(qpp14_1) if qpp14_1>-1 & iso3n==724
egen m2spa=mean(qpp14_2) if qpp14_2>-1 & iso3n==724
tab m1spa m2spa
replace dif=m1spa-m2spa if iso3n==724
recode qpp14_1 (-100/-1=.) if iso3n==724, gen(spa1)
recode qpp14_2 (-100/-1=.) if iso3n==724, gen(spa2)
replace altpkn=0 if (spa1<spa2 | qpp14_1<0 | qpp14_2<0) & iso3n==724 
replace altpkn=0 if spa1==spa2 & !missing(spa1, spa2) 
replace altpkn=1 if spa1>spa2 & iso3n==724

egen m1swe=mean(qpp14_1) if qpp14_1>-1 & iso3n==752
egen m2swe=mean(qpp14_2) if qpp14_2>-1 & iso3n==752
tab m1swe m2swe
replace dif=m1swe-m2swe if iso3n==752
recode qpp14_1 (-100/-1=.) if iso3n==752, gen(swe1)
recode qpp14_2 (-100/-1=.) if iso3n==752, gen(swe2)
replace altpkn=0 if (swe1>swe2 | qpp14_1<0 | qpp14_2<0) & iso3n==752 
replace altpkn=0 if swe1==swe2 & !missing(swe1, swe2) 
replace altpkn=1 if swe1<swe2 & iso3n==752

egen m1uk=mean(qpp14_1) if qpp14_1>-1 & iso3n==826
egen m2uk=mean(qpp14_2) if qpp14_2>-1 & iso3n==826
tab m1uk m2uk
replace dif=m1uk-m2uk if iso3n==826
recode qpp14_1 (-100/-1=.) if iso3n==826, gen(uk1)
recode qpp14_2 (-100/-1=.) if iso3n==826, gen(uk2)
replace altpkn=0 if (uk1<uk2 | qpp14_1<0 | qpp14_2<0) & iso3n==826 
replace altpkn=0 if uk1==uk2 & !missing(uk1, uk2) 
replace altpkn=1 if uk1>uk2 & iso3n==826




/*               IVs                       */
recode p1 (1/2=5) (3/29=6), gen(month)
gen day=30 if p1==1
replace day=31 if p1==2
forvalues i=3(1)29 {
replace day=`i'-2 if p1==`i'
}
gen intdate = mdy(month, day, year)
format intdate %td   /* DATE */

recode qpp13 (-100/-1=.), gen(ideology)    
replace ideology=ideology-1 /* IDEOLOGY */

gen female=d10-1  /* FEMALE */

rename vd11 age   /* AGE */

recode d8 (-9/-8=.) (5=1), gen(education)
recode education (4=2) if age<20
recode education (4=3) if age>19 /* EDUCATION */

recode d61r (-8=.), gen(sclass) /* SUBJ. SOCIAL CLASS */

recode qpp22 (-7=0) if qpp22==-7 & qpp21==1
recode qpp22 (-9/-7=.)
gen pistrength=qpp22+1 /* PARTY IDENTIFICATION STRENGTH */

recode qp6_9 (-9=.) (1=4) (2=3) (3=2) (4=1), gen(polint) /* POLITICAL INTEREST */

recode d25 (-9=.), gen(residency) /* URBAN/RURAL */

recode qpp4 (2=0), gen(turnout)

forval i=1(1)3{
recode qp9_`i' (-9=.) (1=5) (2=4) (3=3) (4=2) (5=1) (6=0), gen(fm`i')
} /* FREQ. OF TV, NEWSP, INTERNET */

recode qp11_1 (1=3) (3=1) (2=2) (else=.), gen(eetv)
recode qp11_2 (1=3) (3=1) (2=2) (else=.), gen(eenews)
recode qp11_3 (1=3) (3=1) (2=2) (else=.), gen(eefriends)
recode qp11_4 (1=3) (3=1) (2=2) (else=.), gen(eepublic)
recode qp11_5 (1=3) (3=1) (2=2) (else=.), gen(eeweb)

keep pkn altpkn iso3n year female education age ideology sclass polint residency pistrength intdate ee* turnout fm* dif

save EES2014_4, replace
clear all








/* 2019 */

usespss "EES2019.sav"

/*           IDENTIFIERS                   */
tostring countrycode, gen(ccode)
gen iso=substr(ccode,2,4)
destring iso, gen(iso3n) /* COUNTRY CODES */
gen year=2019

/* DV */
forvalues i = 1(1)9 {
by countrycode, sort: egen float sd`i' = sd(q13_`i') if q13_`i'<=10
by countrycode, sort: egen float mean`i'=mean(q13_`i') if q13_`i'<=10
gen diff`i'=abs(q13_`i'-mean`i')
by countrycode, sort: egen float sddiff`i' = sd(diff`i') if q13_`i'<=10
by countrycode, sort: egen float meandiff`i'=mean(diff`i') if q13_`i'<=10
replace diff`i'=meandiff`i'+sddiff`i' if q13_`i'>10 /* no answer, do not know how to place, refusal */
}
egen pkn=rowtotal(diff*)
egen pknt=rownonmiss(diff*)
replace pkn=pkn/pknt

gen altpkn=.
gen dif=.

egen m1aut=mean(q13_1) if q13_1<11 & iso3n==40
egen m2aut=mean(q13_2) if q13_2<11 & iso3n==40
tab m1aut m2aut
replace dif=m1aut-m2aut if iso3n==40
recode q13_1 (11/99=.) if iso3n==40, gen(aut1)
recode q13_2 (11/99=.) if iso3n==40, gen(aut2)
replace altpkn=0 if (aut1<aut2 | q13_1>10 | q13_2>10) & iso3n==40 
replace altpkn=0 if aut1==aut2 & !missing(aut1, aut2) 
replace altpkn=1 if aut1>aut2 & iso3n==40

egen m1bel=mean(q13_5) if q13_5<11 & iso3n==56
egen m2bel=mean(q13_7) if q13_7<11 & iso3n==56
tab m1bel m2bel
replace dif=m1bel-m2bel if iso3n==56
recode q13_5 (11/99=.) if iso3n==56, gen(bel1)
recode q13_7 (11/99=.) if iso3n==56, gen(bel2)
replace altpkn=0 if (bel1<bel2 | q13_5>10 | q13_7>10) & iso3n==56 
replace altpkn=0 if bel1==bel2 & !missing(bel1, bel2) 
replace altpkn=1 if bel1>bel2 & iso3n==56

/* Bulgaria missing */

egen m1cro=mean(q13_1) if q13_1<11 & iso3n==191
egen m2cro=mean(q13_2) if q13_2<11 & iso3n==191
tab m1cro m2cro
replace dif=m1cro-m2cro if iso3n==191
recode q13_1 (11/99=.) if iso3n==191, gen(cro1)
recode q13_2 (11/99=.) if iso3n==191, gen(cro2)
replace altpkn=0 if (cro1>cro2 | q13_1>10 | q13_2>10) & iso3n==191 
replace altpkn=0 if cro1==cro2 & !missing(cro1, cro2) 
replace altpkn=1 if cro1<cro2 & iso3n==191

egen m1cyp=mean(q13_1) if q13_1<11 & iso3n==196
egen m2cyp=mean(q13_2) if q13_2<11 & iso3n==196
tab m1cyp m2cyp
replace dif=m1cyp-m2cyp if iso3n==196
recode q13_1 (11/99=.) if iso3n==196, gen(cyp1)
recode q13_2 (11/99=.) if iso3n==196, gen(cyp2)
replace altpkn=0 if (cyp1>cyp2 | q13_1>10 | q13_2>10) & iso3n==196 
replace altpkn=0 if cyp1==cyp2 & !missing(cyp1, cyp2) 
replace altpkn=1 if cyp1<cyp2 & iso3n==196

egen m1cz=mean(q13_3) if q13_3<11 & iso3n==203
egen m2cz=mean(q13_5) if q13_5<11 & iso3n==203
tab m1cz m2cz
replace dif=m1cz-m2cz if iso3n==203
recode q13_3 (11/99=.) if iso3n==203, gen(cz1)
recode q13_5 (11/99=.) if iso3n==203, gen(cz2)
replace altpkn=0 if (cz1<cz2 | q13_3>10 | q13_5>10) & iso3n==203 
replace altpkn=0 if cz1==cz2 & !missing(cz1, cz2) 
replace altpkn=1 if cz1>cz2 & iso3n==203

egen m1den=mean(q13_1) if q13_1<11 & iso3n==208
egen m2den=mean(q13_2) if q13_2<11 & iso3n==208
tab m1den m2den
replace dif=m1den-m2den if iso3n==208
recode q13_1 (11/99=.) if iso3n==208, gen(den1)
recode q13_2 (11/99=.) if iso3n==208, gen(den2)
replace altpkn=0 if (den1>den2 | q13_1>10 | q13_2>10) & iso3n==208 
replace altpkn=0 if den1==den2 & !missing(den1, den2) 
replace altpkn=1 if den1<den2 & iso3n==208

egen m1est=mean(q13_1) if q13_1<11 & iso3n==233
egen m2est=mean(q13_2) if q13_2<11 & iso3n==233
tab m1est m2est
replace dif=m1est-m2est if iso3n==233
recode q13_1 (11/99=.) if iso3n==233, gen(est1)
recode q13_2 (11/99=.) if iso3n==233, gen(est2)
replace altpkn=0 if (est1<est2 | q13_1>10 | q13_2>10) & iso3n==233 
replace altpkn=0 if est1==est2 & !missing(est1, est2) 
replace altpkn=1 if est1>est2 & iso3n==233

egen m1fin=mean(q13_1) if q13_1<11 & iso3n==246
egen m2fin=mean(q13_2) if q13_2<11 & iso3n==246
tab m1fin m2fin
replace dif=m1fin-m2fin if iso3n==246
recode q13_1 (11/99=.) if iso3n==246, gen(fin1)
recode q13_2 (11/99=.) if iso3n==246, gen(fin2)
replace altpkn=0 if (fin1>fin2 | q13_1>10 | q13_2>10) & iso3n==246 
replace altpkn=0 if fin1==fin2 & !missing(fin1, fin2) 
replace altpkn=1 if fin1<fin2 & iso3n==246

egen m1fr=mean(q13_1) if q13_1<11 & iso3n==250
egen m2fr=mean(q13_7) if q13_7<11 & iso3n==250
tab m1fr m2fr
replace dif=m1fr-m2fr if iso3n==250
recode q13_1 (11/99=.) if iso3n==250, gen(fr1)
recode q13_7 (11/99=.) if iso3n==250, gen(fr2)
replace altpkn=0 if (fr1<fr2 | q13_1>10 | q13_7>10) & iso3n==250 
replace altpkn=0 if fr1==fr2 & !missing(fr1, fr2) 
replace altpkn=1 if fr1>fr2 & iso3n==250

egen m1ger=mean(q13_1) if q13_1<11 & iso3n==276
egen m2ger=mean(q13_2) if q13_2<11 & iso3n==276
tab m1ger m2ger
replace dif=m1ger-m2ger if iso3n==276
recode q13_1 (11/99=.) if iso3n==276, gen(ger1)
recode q13_2 (11/99=.) if iso3n==276, gen(ger2)
replace altpkn=0 if (ger1<ger2 | q13_1>10 | q13_2>10) & iso3n==276 
replace altpkn=0 if ger1==ger2 & !missing(ger1, ger2) 
replace altpkn=1 if ger1>ger2 & iso3n==276

egen m1gre=mean(q13_1) if q13_1<11 & iso3n==300
egen m2gre=mean(q13_2) if q13_2<11 & iso3n==300
tab m1gre m2gre
replace dif=m1gre-m2gre if iso3n==300
recode q13_1 (11/99=.) if iso3n==300, gen(gre1)
recode q13_2 (11/99=.) if iso3n==300, gen(gre2)
replace altpkn=0 if (gre1>gre2 | q13_1>10 | q13_2>10) & iso3n==300 
replace altpkn=0 if gre1==gre2 & !missing(gre1, gre2) 
replace altpkn=1 if gre1<gre2 & iso3n==300

egen m1hun=mean(q13_2) if q13_2<11 & iso3n==348
egen m2hun=mean(q13_3) if q13_3<11 & iso3n==348
tab m1hun m2hun
replace dif=m1hun-m2hun if iso3n==348
recode q13_2 (11/99=.) if iso3n==348, gen(hun1)
recode q13_3 (11/99=.) if iso3n==348, gen(hun2)
replace altpkn=0 if (hun1<hun2 | q13_2>10 | q13_3>10) & iso3n==348 
replace altpkn=0 if hun1==hun2 & !missing(hun1, hun2) 
replace altpkn=1 if hun1>hun2 & iso3n==348

egen m1ire=mean(q13_1) if q13_1<11 & iso3n==372
egen m2ire=mean(q13_3) if q13_3<11 & iso3n==372
tab m1ire m2ire
replace dif=m1ire-m2ire if iso3n==372
recode q13_1 (11/99=.) if iso3n==372, gen(ire1)
recode q13_3 (11/99=.) if iso3n==372, gen(ire2)
replace altpkn=0 if (ire1<ire2 | q13_1>10 | q13_3>10) & iso3n==372 
replace altpkn=0 if ire1==ire2 & !missing(ire1, ire2) 
replace altpkn=1 if ire1>ire2 & iso3n==372

egen m1ita=mean(q13_1) if q13_1<11 & iso3n==380
egen m2ita=mean(q13_4) if q13_4<11 & iso3n==380
tab m1ita m2ita
replace dif=m1ita-m2ita if iso3n==380
recode q13_1 (11/99=.) if iso3n==380, gen(ita1)
recode q13_4 (11/99=.) if iso3n==380, gen(ita2)
replace altpkn=0 if (ita1>ita2 | q13_1>10 | q13_4>10) & iso3n==380 
replace altpkn=0 if ita1==ita2 & !missing(ita1, ita2) 
replace altpkn=1 if ita1<ita2 & iso3n==380

egen m1lat=mean(q13_4) if q13_4<11 & iso3n==428
egen m2lat=mean(q13_5) if q13_5<11 & iso3n==428
tab m1lat m2lat
replace dif=m1lat-m2lat if iso3n==428
recode q13_4 (11/99=.) if iso3n==428, gen(lat1)
recode q13_5 (11/99=.) if iso3n==428, gen(lat2)
replace altpkn=0 if (lat1<lat2 | q13_4>10 | q13_5>10) & iso3n==428 
replace altpkn=0 if lat1==lat2 & !missing(lat1, lat2) 
replace altpkn=1 if lat1>lat2 & iso3n==428

egen m1lit=mean(q13_2) if q13_2<11 & iso3n==440
egen m2lit=mean(q13_7) if q13_7<11 & iso3n==440
tab m1lit m2lit
replace dif=m1lit-m2lit if iso3n==440
recode q13_2 (11/99=.) if iso3n==440, gen(lit1)
recode q13_7 (11/99=.) if iso3n==440, gen(lit2)
replace altpkn=0 if (lit1>lit2 | q13_2>10 | q13_7>10) & iso3n==440 
replace altpkn=0 if lit1==lit2 & !missing(lit1, lit2) 
replace altpkn=1 if lit1<lit2 & iso3n==440

egen m1lux=mean(q13_1) if q13_1<11 & iso3n==442
egen m2lux=mean(q13_3) if q13_3<11 & iso3n==442
tab m1lux m2lux
replace dif=m1lux-m2lux if iso3n==442
recode q13_1 (11/99=.) if iso3n==442, gen(lux1)
recode q13_3 (11/99=.) if iso3n==442, gen(lux2)
replace altpkn=0 if (lux1<lux2 | q13_1>10 | q13_3>10) & iso3n==442 
replace altpkn=0 if lux1==lux2 & !missing(lux1, lux2) 
replace altpkn=1 if lux1>lux2 & iso3n==442

egen m1mal=mean(q13_1) if q13_1<11 & iso3n==470
egen m2mal=mean(q13_2) if q13_2<11 & iso3n==470
tab m1mal m2mal
replace dif=m1mal-m2mal if iso3n==470
recode q13_1 (11/99=.) if iso3n==470, gen(mal1)
recode q13_2 (11/99=.) if iso3n==470, gen(mal2)
replace altpkn=0 if (mal1>mal2 | q13_1>10 | q13_2>10) & iso3n==470 
replace altpkn=0 if mal1==mal2 & !missing(mal1, mal2) 
replace altpkn=1 if mal1<mal2 & iso3n==470

egen m1net=mean(q13_1) if q13_1<11 & iso3n==528
egen m2net=mean(q13_2) if q13_2<11 & iso3n==528
tab m1net m2net
replace dif=m1net-m2net if iso3n==528
recode q13_1 (11/99=.) if iso3n==528, gen(net1)
recode q13_2 (11/99=.) if iso3n==528, gen(net2)
replace altpkn=0 if (net1>net2 | q13_1>10 | q13_2>10) & iso3n==528 
replace altpkn=0 if net1==net2 & !missing(net1, net2) 
replace altpkn=1 if net1<net2 & iso3n==528

egen m1pol=mean(q13_1) if q13_1<11 & iso3n==616
egen m2pol=mean(q13_4) if q13_4<11 & iso3n==616
tab m1pol m2pol
replace dif=m1pol-m2pol if iso3n==616
recode q13_1 (11/99=.) if iso3n==616, gen(pol1)
recode q13_4 (11/99=.) if iso3n==616, gen(pol2)
replace altpkn=0 if (pol1>pol2 | q13_1>10 | q13_2>10) & iso3n==616 
replace altpkn=0 if pol1==pol2 & !missing(pol1, pol2) 
replace altpkn=1 if pol1<pol2 & iso3n==616

egen m1por=mean(q13_1) if q13_1<11 & iso3n==620
egen m2por=mean(q13_3) if q13_3<11 & iso3n==620
tab m1por m2por
replace dif=m1por-m2por if iso3n==620
recode q13_1 (11/99=.) if iso3n==620, gen(por1)
recode q13_3 (11/99=.) if iso3n==620, gen(por2)
replace altpkn=0 if (por1<por2 | q13_1>10 | q13_3>10) & iso3n==620 
replace altpkn=0 if por1==por2 & !missing(por1, por2) 
replace altpkn=1 if por1>por2 & iso3n==620

egen m1rom=mean(q13_1) if q13_1<11 & iso3n==642
egen m2rom=mean(q13_5) if q13_5<11 & iso3n==642
tab m1rom m2rom
replace dif=m1rom-m2rom if iso3n==642
recode q13_1 (11/99=.) if iso3n==642, gen(rom1)
recode q13_5 (11/99=.) if iso3n==642, gen(rom2)
replace altpkn=0 if (rom1>rom2 | q13_1>10 | q13_5>10) & iso3n==642 
replace altpkn=0 if rom1==rom2 & !missing(rom1, rom2) 
replace altpkn=1 if rom1<rom2 & iso3n==642

egen m1svk=mean(q13_4) if q13_4<11 & iso3n==703
egen m2svk=mean(q13_5) if q13_5<11 & iso3n==703
tab m1svk m2svk
replace dif=m1svk-m2svk if iso3n==703
recode q13_4 (11/99=.) if iso3n==703, gen(svk1)
recode q13_5 (11/99=.) if iso3n==703, gen(svk2)
replace altpkn=0 if (svk1>svk2 | q13_4>10 | q13_5>10) & iso3n==703 
replace altpkn=0 if svk1==svk2 & !missing(svk1, svk2) 
replace altpkn=1 if svk1<svk2 & iso3n==703

egen m1svn=mean(q13_1) if q13_1<11 & iso3n==705
egen m2svn=mean(q13_2) if q13_2<11 & iso3n==705
tab m1svn m2svn
replace dif=m1svn-m2svn if iso3n==705
recode q13_1 (11/99=.) if iso3n==705, gen(svn1)
recode q13_2 (11/99=.) if iso3n==705, gen(svn2)
replace altpkn=0 if (svn1<svn2 | q13_1>10 | q13_2>10) & iso3n==705 
replace altpkn=0 if svn1==svn2 & !missing(svn1, svn2) 
replace altpkn=1 if svn1>svn2 & iso3n==705

egen m1spa=mean(q13_1) if q13_1<11 & iso3n==724
egen m2spa=mean(q13_2) if q13_2<11 & iso3n==724
tab m1spa m2spa
replace dif=m1spa-m2spa if iso3n==724
recode q13_1 (11/99=.) if iso3n==724, gen(spa1)
recode q13_2 (11/99=.) if iso3n==724, gen(spa2)
replace altpkn=0 if (spa1>spa2 | q13_1>10 | q13_2>10) & iso3n==724 
replace altpkn=0 if spa1==spa2 & !missing(spa1, spa2) 
replace altpkn=1 if spa1<spa2 & iso3n==724

egen m1swe=mean(q13_1) if q13_1<11 & iso3n==752
egen m2swe=mean(q13_2) if q13_2<11 & iso3n==752
tab m1swe m2swe
replace dif=m1swe-m2swe if iso3n==752
recode q13_1 (11/99=.) if iso3n==752, gen(swe1)
recode q13_2 (11/99=.) if iso3n==752, gen(swe2)
replace altpkn=0 if (swe1>swe2 | q13_1>10 | q13_2>10) & iso3n==752 
replace altpkn=0 if swe1==swe2 & !missing(swe1, swe2) 
replace altpkn=1 if swe1<swe2 & iso3n==752

egen m1uk=mean(q13_1) if q13_1<11 & iso3n==826
egen m2uk=mean(q13_2) if q13_2<11 & iso3n==826
tab m1uk m2uk
replace dif=m1uk-m2uk if iso3n==826
recode q13_1 (11/99=.) if iso3n==826, gen(uk1)
recode q13_2 (11/99=.) if iso3n==826, gen(uk2)
replace altpkn=0 if (uk1<uk2 | q13_1>10 | q13_2>10) & iso3n==826 
replace altpkn=0 if uk1==uk2 & !missing(uk1, uk2) 
replace altpkn=1 if uk1>uk2 & iso3n==826



/*               IVs                       */
recode Q11 (97/98=.), gen(ideology)      /* IDEOLOGY */

gen age=2019-D4_1   /* AGE */
  
recode D7 (2=1) (3=2) (4/5=3) (6/99=.), gen(sclass) /* SOCIAL CLASS */

recode EDU (99=.), gen(education)
recode education (97=2) if age<20
recode education (97=3) if age>19 /* EDUCATION */

rename D8 residency /* URBAN/RURAL */

recode Q26 (98/99=.) (1=4) (2=3) (3=2), gen(pistrength)
forvalues i=1(1)28 {
replace pistrength=1 if Q25==`i'01
} 
recode pistrength (0=.) /* PARTY IDENTIFICATION STRENGTH */

recode Q21 (1=4) (2=3) (3=2) (4=1) (98/99=.), gen(polint)  /* POLITICAL INTEREST */

gen female=D3-1
recode female (2=.) /* FEMALE */

gen month=substr(meta_end_date,1,2)
gen day=substr(meta_end_date,4,2)
destring day month, replace
gen intdate=mdy(month, day, year)
format intdate %td  /* DATE */ 

recode Q9 (90/96=1) (97=0) (98/99=.) (else=1), gen(turnout) /* TURNOUT */

keep pkn altpkn intdate female iso3n year education age ideology sclass polint residency pistrength turnout dif

save EES2019_4, replace
clear all




/* INTEGRATED DATAFILE */
use EES1994_4
append using "EES1999_4.dta" "EES2004_4.dta" "EES2009_4.dta" "EES2014_4.dta" "EES2019_4.dta"
gen countryyear=iso3n*10000+year
gen pkn2=10-pkn
gen partydif=abs(dif)

/* Merging Datasets */
merge m:1 year iso3n using "C:\Users\Asus\Desktop\Tez\Chapter 1\Nelda\electiondates_1.dta"
rename _merge _merge1
merge m:1 year iso3n using "C:\Users\Asus\Desktop\Tez\Chapter 1\V-Dem\v-demmedia.dta"
rename _merge _merge2
merge m:1 iso3n year using "C:\Users\Asus\Desktop\Tez\Chapter 1\Freedom House\freedomhouse.dta"
rename _merge _merge3
merge m:1 iso3n year using "C:\Users\Asus\Desktop\Tez\Chapter 1\EES\ageofdemocracy.dta"

gen difpe=intdate-pedate
gen difne=nedate-intdate
replace difpe=39 if difne==-39
replace difpe=3 if difne==-3
replace difpe=2 if difne==-2
replace difpe=1 if difne==-1 
recode difne (-39=1421) (-3=1457) (-2=1458) (-1=1459) /* Recoding Negative Distances */
gen dist=min(difpe, difne) if !missing(difpe, difne)
gen distm=dist/30
gen cycle=nedate-pedate
gen ratio=difpe/cycle
save EES_int4, replace
