*-----------------------------------------------------
*Data Operations
*-----------------------------------------------------
*-----------------------------------------------------
*CSES Module 5
*-----------------------------------------------------

use "cses5.dta",clear /* https://cses.org/data-download/cses-module-5-2016-2021/ */
keep if E1006_NAM=="Turkey"
gen year=E1008

*Turnout
recode E3012_LH (0=0) (1=1) (93/99=.),gen(turnout)

*Party Feeling Thermometer
foreach PFT in A B C D E{
	recode E3017_`PFT' (11/99=.),gen(PFT_`PFT')
}
rename (PFT_A PFT_B PFT_C PFT_D PFT_E) (PFT_AKP PFT_CHP PFT_HDP PFT_MHP PFT_IYI)

*Leader Feeling Thermometer
foreach LFT in A B C D E{
	recode E3018_`LFT' (11/99=.),gen(LFT_`LFT')
}
rename (LFT_A LFT_B LFT_C LFT_D LFT_E) (LFT_AKP LFT_CHP LFT_HDP LFT_MHP LFT_IYI)

*Most Liked Party
recode E3024_3 (792001=1 "AKP") (792002=2 "CHP") (792004=3 "MHP") (792003=4 "HDP") (792005=5 "IYI") (792006/999999=.),gen(mostlike)

*Vote Share of Parties
foreach vote in A B C D E{
	gen voteshare_`vote'=E5001_`vote'/100
}
rename (voteshare_A voteshare_B voteshare_C voteshare_D voteshare_E) (voteshare_AKP voteshare_CHP voteshare_HDP voteshare_MHP voteshare_IYI)

*Party Identification
recode E3024_1 (0=0) (1=1) (7/9=.),gen(PI)

*Perceived Ideological Positions of Parties on the Left-Right scale
foreach ideology in A B C D E{
	recode E3019_`ideology' (11/99=.),gen(position_`ideology')
} 
rename (position_A position_B position_C position_D position_E) (position_AKP position_CHP position_HDP position_MHP position_IYI)

*Ideological Extremity
recode E3020 (11/99=.),gen(selfposition)
gen IE=abs(selfposition-5)
gen IE2=IE*IE

*Age
gen age=E1008-E2001_Y
recode age (-9999/17=.)
gen age2=age*age

*Education
recode E2003 (96=0) (2=1) (3=2) (4=3) (7/9=4) (97=.) ,gen(education)

*Gender 
recode E2002 (2=1) (1=0),gen(gender)

*Residence
recode E2022 (1=0) (2=1) (3=2) (4=3),gen (residence)

*Religiosity (Service Attendance)
recode E2014 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7/9=.),gen(religiosity_s)

keep year turnout PFT* LFT* mostlike voteshare_* PI position* IE* age* education gender residence religiosity_s 

*--------------------------------------------------------------
*Affective Polarization and Perceived Ideological Polarization 
*--------------------------------------------------------------

*Affective Polarization (Unweighted Spread) - Party
egen meanlikeup=rowmean(PFT_*)
foreach i in AKP CHP MHP HDP IYI{
	gen difup_`i'=(PFT_`i'-meanlikeup)^2
}
egen sumdifup=rowtotal(difup*)
egen nonmisp=rownonmiss(PFT_*)
gen uspread_p=sqrt(sumdifup/nonmisp) if nonmisp!=1

*Affective Polarization (Unweighted Spread) - Leader
egen meanlikeul=rowmean(LFT_*)
foreach i in AKP CHP MHP HDP IYI{
	gen diful_`i'=(LFT_`i'-meanlikeul)^2
}
egen sumdiful=rowtotal(diful*)
egen nonmisl=rownonmiss(LFT_*)
gen uspread_l=sqrt(sumdiful/nonmisl) if nonmisl!=1

*Affective Polarization (Weighted Spread) - Party
foreach i in AKP CHP MHP HDP IYI{
	gen wPFT_`i'=(voteshare_`i'*PFT_`i')
}
egen meanlikewp=rowtotal(wPFT*)
egen nonmiswp=rownonmiss(wPFT*)
replace meanlikewp=. if nonmiswp<2
foreach i in AKP CHP MHP HDP IYI{
	gen difwp_`i'=voteshare_`i'*(PFT_`i'-meanlikewp)^2
}
egen sumdifwp=rowtotal(difwp*)
replace sumdifwp=. if nonmiswp<2
gen wspread_p=sqrt(sumdifwp) if nonmisp!=1

*Affective Polarization (Weighted Spread) - Leader
foreach i in AKP CHP MHP HDP IYI{
	gen wLFT_`i'=(voteshare_`i'*LFT_`i')
}
egen meanlikewl=rowtotal(wLFT*)
egen nonmiswl=rownonmiss(wLFT*)
replace meanlikewl=. if nonmiswl<2
foreach i in AKP CHP MHP HDP IYI{
	gen difwl_`i'=voteshare_`i'*(LFT_`i'-meanlikewl)^2
}
egen sumdifwl=rowtotal(difwl*)
replace sumdifwl=. if nonmiswl<2
gen wspread_l=sqrt(sumdifwl) if nonmisl!=1

*Affective Polarization (Max-Min) - Party
egen likemin_p=rowmin(PFT*)
egen likemax_p=rowmax(PFT*)
gen maxmin_p=likemax_p-likemin_p if nonmisp!=1

*Affective Polarization (Max-Min) - Leader
egen likemin_l=rowmin(LFT*)
egen likemax_l=rowmax(LFT*)
gen maxmin_l=likemax_l-likemin_l if nonmisl!=1

*Affective Polarization (Distance) - Party
foreach i in CHP MHP HDP IYI{
	gen distAKP_`i'=(PFT_`i'-PFT_AKP)^2
}
egen sumdistAKP=rowtotal(distAKP_*)
egen nmsAKP=rownonmiss(distAKP_*)
gen udist_p =sqrt((sumdistAKP/nmsAKP)) if mostlike==1

foreach i in AKP MHP HDP IYI{
	gen distCHP_`i'=(PFT_`i'-PFT_CHP)^2
}
egen sumdistCHP=rowtotal(distCHP_*)
egen nmsCHP=rownonmiss(distCHP_*)
replace udist_p=sqrt((sumdistCHP/nmsCHP)) if mostlike==2

foreach i in AKP CHP HDP IYI{
	gen distMHP_`i'=(PFT_`i'-PFT_MHP)^2
}
egen sumdistMHP=rowtotal(distMHP_*)
egen nmsMHP=rownonmiss(distMHP_*)
replace udist_p=sqrt((sumdistMHP/nmsMHP)) if mostlike==3

foreach i in AKP CHP MHP IYI{
	gen distHDP_`i'=(PFT_`i'-PFT_HDP)^2
}
egen sumdistHDP=rowtotal(distHDP_*)
egen nmsHDP=rownonmiss(distHDP_*)
replace udist_p=sqrt((sumdistHDP/nmsHDP)) if mostlike==4

foreach i in AKP CHP MHP HDP{
	gen distIYI_`i'=(PFT_`i'-PFT_IYI)^2
}
egen sumdistIYI=rowtotal(distIYI_*)
egen nmsIYI=rownonmiss(distIYI_*)
replace udist_p=sqrt((sumdistIYI/nmsIYI)) if mostlike==5

*Affective Polarization (Distance) - Leader
foreach i in CHP MHP HDP IYI{
	gen distAKP2_`i'=(LFT_`i'-LFT_AKP)^2
}
egen sumdistAKP2=rowtotal(distAKP2_*)
egen nmsAKP2=rownonmiss(distAKP2_*)
gen udist_l =sqrt((sumdistAKP2/nmsAKP2)) if mostlike==1

foreach i in AKP MHP HDP IYI{
	gen distCHP2_`i'=(LFT_`i'-LFT_CHP)^2
}
egen sumdistCHP2=rowtotal(distCHP2_*)
egen nmsCHP2=rownonmiss(distCHP2_*)
replace udist_l=sqrt((sumdistCHP2/nmsCHP2)) if mostlike==2

foreach i in AKP CHP HDP IYI{
	gen distMHP2_`i'=(LFT_`i'-LFT_MHP)^2
}
egen sumdistMHP2=rowtotal(distMHP2_*)
egen nmsMHP2=rownonmiss(distMHP2_*)
replace udist_l=sqrt((sumdistMHP2/nmsMHP2)) if mostlike==3

foreach i in AKP CHP MHP IYI{
	gen distHDP2_`i'=(LFT_`i'-LFT_HDP)^2
}
egen sumdistHDP2=rowtotal(distHDP2_*)
egen nmsHDP2=rownonmiss(distHDP2_*)
replace udist_l=sqrt((sumdistHDP2/nmsHDP2)) if mostlike==4

foreach i in AKP CHP MHP HDP{
	gen distIYI2_`i'=(LFT_`i'-LFT_IYI)^2
}
egen sumdistIYI2=rowtotal(distIYI2_*)
egen nmsIYI2=rownonmiss(distIYI2_*)
replace udist_l=sqrt((sumdistIYI2/nmsIYI2)) if mostlike==5

*Perceived Ideological Polarization
foreach i in AKP CHP MHP HDP IYI{
	gen wpos_`i'=(voteshare_`i'*position_`i')
}
egen meanpos=rowtotal(wpos_*)
egen nonmispos=rownonmiss(wpos_*)
replace meanpos=. if nonmispos<2
foreach i in AKP CHP MHP HDP IYI{
	gen difpos_`i'=voteshare_`i'*(position_`i'-meanpos)^2
}
egen sumdifpos=rowtotal(difpos_*)
replace sumdifpos=. if nonmispos<2
gen PIP=sqrt(sumdifpos) if nonmispos!=1

*-----------------------------------------------------
* Variable Labels
*-----------------------------------------------------

lab var uspread_p "Aff. Pol. (Unw. Spread) - Party"
lab var uspread_l "Aff. Pol. (Unw. Spread) - Leader"
lab var wspread_p "Aff. Pol. (W. Spread) - Party"
lab var wspread_l "Aff. Pol. (W. Spread) - Leader"
lab var maxmin_p "Aff. Pol. (Max-Min) - Party"
lab var maxmin_l "Aff. Pol. (Max-Min) - Leader"
lab var udist_p "Aff. Pol. (Distance) - Party"
lab var udist_l "Aff. Pol. (Distance) - Leader"
lab var turnout "Turnout"
lab var PFT_AKP "Party Feeling Thermometer - AKP"
lab var PFT_CHP "Party Feeling Thermometer - CHP"
lab var PFT_MHP "Party Feeling Thermometer - MHP"
lab var PFT_HDP "Party Feeling Thermometer - HDP"
lab var PFT_IYI "Party Feeling Thermometer - IYI"
lab var LFT_AKP "Leader Feeling Thermometer - AKP"
lab var LFT_CHP "Leader Feeling Thermometer - CHP"
lab var LFT_MHP "Leader Feeling Thermometer - MHP"
lab var LFT_HDP "Leader Feeling Thermometer - HDP"
lab var LFT_IYI "Leader Feeling Thermometer - IYI"
lab var mostlike "Most Liked Party"
lab var voteshare_AKP "AKP's Vote-share"
lab var voteshare_CHP "CHP's Vote-share"
lab var voteshare_MHP "MHP's Vote-share"
lab var voteshare_HDP "HDP's Vote-share"
lab var voteshare_IYI "IYI's Vote-share"
lab var position_AKP "Perceived Ideological Position - AKP"
lab var position_CHP "Perceived Ideological Position - CHP"
lab var position_MHP "Perceived Ideological Position - MHP"
lab var position_HDP "Perceived Ideological Position - HDP"
lab var position_IYI "Perceived Ideological Position - IYI"
lab var PI "Party Identification"
lab var PIP "Perceived Ideological Polarization"
lab var IE "Ideological Extremity"
lab var age "Age"
lab var education "Education"
lab var gender "Gender"
lab var residence "Rural/Urban Status"
lab var religiosity_s "Religious Service Attendance"

global affpol uspread_p wspread_p maxmin_p uspread_l wspread_l maxmin_l
global controls PI PIP IE age education gender residence
global controls2 PIP IE age education gender residence
global others PFT* LFT* mostlike voteshare_* position* udist_p udist_l year age2 IE2
keep turnout $affpol $controls $controls3 $others
order turnout $affpol $controls $controls3 $others
*-----------------------------------------------------
*Empirical Analyses
*-----------------------------------------------------

*Hypothesis 1
foreach i in $affpol{
	eststo H1_`i': logit turnout `i' $controls,robust
}

*Hypothesis 2
foreach i in $affpol{
	eststo H2_`i': logit turnout i.PI##c.`i' $controls2,robust
}

*-----------------------------------------------------
*Alternative Models
*-----------------------------------------------------

*Mean-Distance Measures of Affective Polarization (Hypothesis 1)
eststo AH1udist_p: logit turnout udist_p $controls
eststo AH1udist_l: logit turnout udist_l $controls
*Mean-Distance Measures of Affective Polarization (Hypothesis 2)
eststo AH2udist_p: logit turnout c.udist_p##i.PI $controls2
eststo AH2udist_l: logit turnout c.udist_l##i.PI $controls2

*Religious Service Attendance
foreach x in religiosity_s {
	foreach i in $affpol{
	eststo AH1`i'_`x': quietly logit turnout `i' $controls `x',robust
	}
	foreach i in $affpol{
	eststo AH2`i'_`x': quietly logit turnout i.PI##c.`i' $controls2 `x' ,robust
	}
}

*-----------------------------------------------------
*Tables and Figures
*-----------------------------------------------------

*Table: Descriptive Statistics
est rest H1_wspread_p
eststo desc: estpost sum turnout $affpol $controls religiosity_s  if e(sample)
esttab desc using "Table4_1.tex", replace cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(0))") collabels("Mean" "Std.Dev." "Min." "Max." "N") noobs nonumber label title("Descriptive Statistics")   

*Table: Cross-correlation Table of Independent Variables
/* ssc install corrtex */
est rest H1_uspread_p
corrtex $affpol if e(sample), casewise file(Table4_2) nbobs sig digits(2) title("Cross-correlation Table of Independent Variables") replace

*Table 5.1 (Hypothesis 1)
esttab H1_uspread_p H1_wspread_p H1_maxmin_p H1_uspread_l H1_wspread_l H1_maxmin_l using "Table.tex", tex replace b(%10.3f) se stats(ll aic bic N, labels("Log likelihood" "AIC" "BIC" "N") ///
fmt(%10.3f %10.0f)) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant)  ///
addnote("The coefficients are logged odds. Robust standard errors are in parentheses. *p<0.1, **p<0.05, ***p<0.01, two-tailed tests.") alignment(l) nonote nogaps nodepvar nonumbers compress noomit nobase mtitle("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") title("The Effect of Affective Polarization on Voter Turnout")  order($affpol $controls)

*Figures (Hypothesis 1)
/*
foreach i in $affpol{
	est rest H1_`i'
	sum `i' $controls if e(sample),detail
}
*/

foreach i in uspread_p wspread_p uspread_l wspread_l{
	est rest H1_`i'
	margins, at(`i'=(0 (0.5) 5) PI=1 (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) yline(0, lwidth(thin) lcolor(red)) graphregion(color(white)) xlabel(#5) name(pp_`i' ,replace)
margins, dydx(`i') at(`i'=(0 (0.5) 5) PI=1 (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) yline(0, lwidth(thin) lcolor(red)) graphregion(color(white)) xlabel(#5) name(me_`i' ,replace)
}

foreach x in maxmin_p maxmin_l{
	est rest H1_`x'
	margins, at(`x'=(0 (1) 10) PI=1 (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) allx yline(0, lwidth(thin) lcolor(red)) graphregion(color(white)) xlabel(#10) name(pp_`x' ,replace)
margins, dydx(`x') at(`x'=(0 (1) 10) PI=1 (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) allx yline(0, lwidth(thin) lcolor(red)) graphregion(color(white)) xlabel(#10) name(me_`x' ,replace)
}

graph combine pp_uspread_p pp_wspread_p pp_maxmin_p pp_uspread_l pp_wspread_l pp_maxmin_l, graphregion(color(white)) title("Predicted Probabilities",size(medsmall) color(black)) rows(2) ycommon name(Figure5_1,replace) l1title("Pr(Turnout=1)",size(medsmall))
graph export "Figure 1.pdf",replace name(Figure5_1)

graph combine me_uspread_p me_wspread_p me_maxmin_p me_uspread_l me_wspread_l me_maxmin_l, graphregion(color(white)) title("Marginal Effects of Affective Polarization on Turnout",size(medsmall) color(black)) rows(2) ycommon name(Figure5_2,replace) l1title("Pr(Turnout=1)",size(medsmall))
graph export "Figure 2.pdf",replace name(Figure5_2)

*Table (Hypothesis 2)
esttab H2_uspread_p H2_wspread_p H2_maxmin_p H2_uspread_l H2_wspread_l H2_maxmin_l using "Table 2.tex",  tex replace b(%10.3f) se stats(ll aic bic N, labels("Log likelihood" "AIC" "BIC" "N") fmt(%10.3f %10.0f)) label starlevels(* 0.1 ** 0.05 *** 0.01) coeflabels(_cons Constant) addnote("The coefficients are logged odds. Robust standard errors are in parentheses. *p<0.1, **p<0.05, ***p<0.01, two-tailed tests.") alignment(l) nonote nogaps nodepvar nonumbers compress noomit nobase mtitle("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") title("The Effect of Affective Polarization on Voter Turnout conditionally on Affective Polarization")  interaction(" $\times$ ") order(PI uspread_p PI#uspread_p wspread_p PI#uwspread_p maxmin_p PI#maxmin_p uspread_l PI#uspread_l wspread_l PI#uwspread_l maxmin_l PI#maxmin_l
*Figure (Hypothesis 2)
foreach i in uspread_p wspread_p uspread_l wspread_l{
est restore H2_`i'
margins, dydx(PI) at(`i'=(0 (0.5) 5) (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") xtitle("`: var lab `i''",color(black)) ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) graphregion(color(white)) yline(0, lwidth(medthick) lcolor(red)) xlabel(#5) name(H2_`i' ,replace)
}

foreach i in maxmin_p maxmin_l{
est restore H2_`i'
margins, dydx(PI) at(`i'=(0 (1) 10) (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") xtitle("`: var lab `i''",color(black)) ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) graphregion(color(white)) yline(0, lwidth(medthick) lcolor(red)) xlabel(#10) name(H2_`i' ,replace)
}

graph combine H2_uspread_p H2_wspread_p H2_maxmin_p H2_uspread_l H2_wspread_l H2_maxmin_l, graphregion(color(white)) title("") rows(2) ycommon name(Figure5_3,replace) l1title("Marginal Effect of Party Identification on Pr(Turnout=1)",size(medsmall) color(black))
graph export "Figure5_3.pdf",replace name(Figure5_3)

/*
*Figures (Hypothesis 2)
foreach i in uspread_p wspread_p uspread_l wspread_l{
est restore H2_`i'
margins,dydx(PI) at(`i'=)
	
}
*/

*-----------------------------------------------------
*Appendix: Additional Tables and Figues (Opsiyonel Figures)
*-----------------------------------------------------

*Figures (Hypothesis 1)
foreach i in uspread_p wspread_p uspread_l wspread_l{
	est rest H1_`i'
	margins, at(`i'=(0 (0.5) 5) PI=(0 1) (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) yline(0, lwidth(thin) lcolor(red)) graphregion(color(white)) xlabel(#5) legend(pos(6) cols(2) order(3 "Non-partisans" 4 "Partisans")) name(pp2_`i' ,replace)
margins, dydx(`i') at(`i'=(0 (0.5) 5) PI=(0 1) (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) yline(0, lwidth(thin) lcolor(red)) graphregion(color(white)) xlabel(#5) legend(pos(6) cols(2) order(3 "Non-partisans" 4 "Partisans")) name(me2_`i' ,replace)
}

foreach x in maxmin_p maxmin_l{
	est rest H1_`x'
	margins, at(`x'=(0 (1) 10) PI=(0 1) (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) allx yline(0, lwidth(thin) lcolor(red)) graphregion(color(white)) xlabel(#10) legend(pos(6) cols(2) order(3 "Non-partisans" 4 "Partisans")) name(pp2_`x' ,replace)
margins, dydx(`x') at(`x'=(0 (1) 10) PI=(0 1) (mean) PIP IE age education=2 gender=1 residence=2) l(95)
marginsplot, ytitle("") title("") ci1opts(color(navy) lwidth(medthick) msize(medlarge)) plot1opts(lcolor(none) msymbol(D) mcolor(navy) msize(medium)) allx yline(0, lwidth(thin) lcolor(red)) graphregion(color(white)) xlabel(#10) legend(pos(6) cols(2) order(3 "Non-partisans" 4 "Partisans")) name(me2_`x' ,replace)
}

grc1leg2 pp2_uspread_p pp2_wspread_p pp2_maxmin_p pp2_uspread_l pp2_wspread_l pp2_maxmin_l, graphregion(color(white)) title("Predicted Probabilities",size(medsmall) color(black)) rows(2) ycommon name(FigureB_1,replace) l1title("Pr(Turnout=1)",size(medsmall)) legendfrom(pp2_uspread_p)
graph export "Figure A.pdf",replace name(FigureB_1)

grc1leg2 me2_uspread_p me2_wspread_p me2_maxmin_p me2_uspread_l me2_wspread_l me2_maxmin_l, graphregion(color(white)) title("Marginal Effects of Affective Polarization on Turnout",size(medsmall) color(black)) rows(2) ycommon name(FigureB_2,replace) l1title("Pr(Turnout=1)",size(medsmall)) legendfrom(me2_uspread_p)
graph export "Figure B.pdf",replace name(FigureB_2)


