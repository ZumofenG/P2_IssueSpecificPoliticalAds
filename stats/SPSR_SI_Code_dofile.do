*** Author: Zumofen Guillaume, Gerber Marlène
*** Année Politique Suisse (APS), Institute of Political Science, University of Bern
*** Title: Effects of Issue-Specific Political Advertisement in the 2015 Parliamentary Elections of Switzerland
*** Paper for the Special Issue on Swiss national elections 2015 - Swiss Political Science Review

* Do- files with all instructions
clear all
cd "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version"
capture log close
log using ZumofenGerber.log, replace
set more off

use Selects_panel_Version2, replace

***************** Part a. Process dataset - Create variables **************************

* 1. Create variable of interest (VI) - Political advertising (Continuous variable)
generate ad_totSVP_rel=(ad_totSVP_cum/ad_totALL_cum)
generate ad_totFDP_rel=(ad_totFDP_cum/ad_totALL_cum)

* 2. Create dependent variable (DV) - Vote intention at t2 (Binary variable)
generate vote_SVP2=1 if W2_f10850main7==1
replace vote_SVP2=0 if W2_f10850main7!=1
replace vote_SVP2=. if W2_f10850main7==.
generate vote_FDP2=1 if W2_f10850main7==2
replace vote_FDP2=0 if W2_f10850main7!=2
replace vote_FDP2=. if W2_f10850main7==.
* likely voters include "rather not sure to participate"

* 3. Create interaction variable - Vote intention at t1 (Discrete variable)
* 3.1 Vote intention at t1: vote SVP+participate=1, vote no SVP+participate=0, no participation=2
generate vote_SVP1=1 if f1085_90main7==1
replace vote_SVP1=0 if f1085_90main7!=1
replace vote_SVP1=2 if f10800==3 | f10800==4
label define vote_SVP1 0"No SVP vote (w1)" 1"SVP vote (w1)" 2 "No participation (w1)", modify
label value vote_SVP1 vote_SVP1

generate vote_FDP1=1 if f1085_90main7==2
replace vote_FDP1=0 if f1085_90main7!=2
replace vote_FDP1=2 if f10800==3 | f10800==4
label define vote_FDP1 0"No FDP vote (w1)" 1"FDP vote (w1)" 2"No participation", modify
label value vote_FDP1 vote_FDP1

* 3.2 Vote intention at t1: 6 groups (political orientation)
generate vote_group = 0 if f1085_90main7==8
replace vote_group = 1 if f1085_90main7==1
replace vote_group = 2 if f1085_90main7==2
replace vote_group = 3 if f1085_90main7==3 | f1085_90main7==4 | f1085_90main7==5
replace vote_group = 4 if f1085_90main7==6 | f1085_90main7==7
replace vote_group = 5 if f10800==3 | f10800==4
label define vote_group 0"OTHERS vote(w1)" 1"SVP vote(w1)" 2"FDP vote(w1)" 3"CENTER vote(w1)" 4"LEFT vote(w1)" 5"No participation"
label value vote_group vote_group

* 4. Most Important Problem variable: MIP
generate mip_ec_w1=1 if f12700r==2
replace mip_ec_w1=0 if f12700r!=2
replace mip_ec_w1=. if f12700r==.
label define mip_ec_w1 0"MIP≠Economy" 1"MIP=Economy" 
label value mip_ec_w1 mip_ec_w1

generate mip_eu_w1=1 if f12700r==5
replace mip_eu_w1=0 if f12700r!=5
replace mip_eu_w1=. if f12700r==.
label define mip_eu_w1 0"MIP≠EU" 1"MIP=EU" 
label value mip_eu_w1 mip_eu_w1

generate mip_im_w1=1 if f12700r==8
replace mip_im_w1=0 if f12700r!=8
replace mip_im_w1=. if f12700r==.
label define mip_im_w1 0"MIP≠Immigration" 1"MIP=Immigration" 
label value mip_im_w1 mip_im_w1

* 5. Political awareness: Binary variable
generate awareness=0 if knowledge==0 | knowledge==1
replace awareness=1 if knowledge==2
replace awareness=2 if knowledge==3 | knowledge==4
label define awareness 0"Low awareness" 1"Medium awareness" 2"High awareness"
label value awareness awareness

generate code_knowl= W2_f16309r+ W2_f16310r+ W2_f16305r
generate pol_knowl=0 if code_knowl<=1
replace pol_knowl=1 if code_knowl>=2

* 6. Ads variable: dichotomize issue-specific ads
generate ad_ecSVP=1 if ad_economy_SVP>0
replace ad_ecSVP=0 if ad_economy_SVP==0
label define ad_ecSVP 0"No SVP economy ads" 1"SVP economy ads" 
label value ad_ecSVP ad_ecSVP

generate ad_miSVP=1 if ad_migration_SVP>0
replace ad_miSVP=0 if ad_migration_SVP==0
label define ad_miSVP 0"No SVP migration ads" 1"SVP migration ads" 
label value ad_miSVP ad_miSVP

generate ad_euSVP=1 if ad_EU_SVP>0
replace ad_euSVP=0 if ad_EU_SVP==0
label define ad_euSVP 0"No SVP EU ads" 1"SVP EU ads" 
label value ad_euSVP ad_euSVP

generate ad_ecFDP=1 if ad_economy_FDP>0
replace ad_ecFDP=0 if ad_economy_FDP==0
label define ad_ecFDP 0"No FDP economy ads" 1"FDP economy ads" 
label value ad_ecFDP ad_ecFDP

generate ad_miFDP=1 if ad_migration_FDP>0
replace ad_miFDP=0 if ad_migration_FDP==0
label define ad_miFDP 0"No FDP migration ads" 1"FDP migration ads" 
label value ad_miFDP ad_miFDP

generate ad_euFDP=1 if ad_EU_FDP>0
replace ad_euFDP=0 if ad_EU_FDP==0
label define ad_euFDP 0"No FDP EU ads" 1"FDP EU ads" 
label value ad_euFDP ad_euFDP

* 7. Generate variable for multinomial logit regression
gen vote_FDPSVP2 = 0 if vote_SVP2==0 & vote_FDP2==0
replace vote_FDPSVP2 = 1 if vote_FDP2==1
replace vote_FDPSVP2 = 2 if vote_SVP2==1

gen vote_FDPSVP1 = 1 if f1085_90main7==2
replace vote_FDPSVP1 = 2 if f1085_90main7==1
replace vote_FDPSVP1=3 if f1085_90main7>2 & f1085_90main7<.
replace vote_FDPSVP1=0 if f10800==3 | f10800==4

label define vote_FDPSVP1 0 "No intention to vote (w1)" 1 "FDP vote (w1)" 2 "SVP vote (w1)" 3 "OTHER vote (w1)"
label value vote_FDPSVP1 vote_FDPSVP1

* 8. Generate Dummy for EU, since model cannot be computed for participants with no vote intention
gen ad_EU_SVP_d =1 if ad_EU_SVP_cum>0 & ad_EU_SVP_cum<.
replace ad_EU_SVP_d=0 if ad_EU_SVP_cum==0

gen ad_EU_FDP_d =1 if ad_EU_FDP_cum>0 & ad_EU_FDP_cum<.
replace ad_EU_FDP_d=0 if ad_EU_FDP_cum==0

* 9. Awareness variables (w1)
drop competent_economy_SVP competent_economy_FDP competent_EU_FDP competent_EU_SVP competent_migration_SVP competent_migration_FDP
* Drop cares_EU_SVP cares_migration_SVP cares_economy_SVP cares_migration_FDP cares_economy_FDP cares_EU_FDP
gen competent_migration_SVP = 1 if f15330b==4
recode competent_migration_SVP (.=0) if f15330b!=.
gen competent_migration_FDP = 1 if f15330b==1
recode competent_migration_FDP (.=0) if f15330b!=.

gen competent_EU_SVP = 1 if f15330a==4
recode competent_EU_SVP (.=0) if f15330a!=.
gen competent_EU_FDP = 1 if f15330a==1
recode competent_EU_FDP (.=0) if f15330a!=.

gen competent_economy_SVP = 1 if f15330e==4
recode competent_economy_SVP (.=0) if f15330e!=.
gen competent_economy_FDP = 1 if f15330e==1
recode competent_economy_FDP (.=0) if f15330e!=.

gen cares_EU_SVP = 1 if f15320a==4
recode cares_EU_SVP (.=0) if f15320a!=.
gen cares_EU_FDP = 1 if f15320a==1
recode cares_EU_FDP (.=0) if f15320a!=.

gen cares_migration_SVP = 1 if f15320b==4
recode cares_migration_SVP (.=0) if f15320b!=.
gen cares_migration_FDP = 1 if f15320b==1
recode cares_migration_FDP (.=0) if f15320b!=.

gen cares_economy_SVP = 1 if f15320e==4
recode cares_economy_SVP (.=0) if f15320e!=.
gen cares_economy_FDP = 1 if f15320e==1
recode cares_economy_FDP (.=0) if f15320e!=.

* Awareness variables (w2)
gen competent_migration_SVP2 = 1 if W2_f15330b==4
recode competent_migration_SVP2 (.=0) if W2_f15330b!=.
gen competent_migration_FDP2 = 1 if W2_f15330b==1
recode competent_migration_FDP2 (.=0) if W2_f15330b!=.

gen competent_EU_SVP2 = 1 if W2_f15330a==4
recode competent_EU_SVP2 (.=0) if W2_f15330a!=.
gen competent_EU_FDP2 = 1 if W2_f15330a==1
recode competent_EU_FDP2 (.=0) if W2_f15330a!=.

gen competent_economy_SVP2 = 1 if W2_f15330e==4
recode competent_economy_SVP2 (.=0) if W2_f15330e!=.
gen competent_economy_FDP2 = 1 if W2_f15330e==1
recode competent_economy_FDP2 (.=0) if W2_f15330e!=.

gen cares_EU_SVP2 = 1 if W2_f15320a==4
recode cares_EU_SVP2 (.=0) if W2_f15320a!=.
gen cares_EU_FDP2 = 1 if W2_f15320a==1
recode cares_EU_FDP2 (.=0) if W2_f15320a!=.

gen cares_migration_SVP2 = 1 if W2_f15320b==4
recode cares_migration_SVP2 (.=0) if W2_f15320b!=.
gen cares_migration_FDP2 = 1 if W2_f15320b==1
recode cares_migration_FDP2 (.=0) if W2_f15320b!=.

gen cares_economy_SVP2 = 1 if W2_f15320e==4
recode cares_economy_SVP2 (.=0) if W2_f15320e!=.
gen cares_economy_FDP2 = 1 if W2_f15320e==1
recode cares_economy_FDP2 (.=0) if W2_f15320e!=.

* 10. Issue preferences
gen opinion_ec = 1 if f15340e==1
replace opinion_ec = 1 if f15340e==2
replace opinion_ec = 0 if f15340e==3
replace opinion_ec = 0 if f15340e==4
replace opinion_ec = 0 if f15340e==5
label define opinion_ec 1 "Strengthening the economy" 0 "Not strengthening the economy"
label value opinion_ec opinion_ec

gen opinion_EU = 1 if f15340a==5 
replace opinion_EU=0 if f15340a==4
replace opinion_EU=0 if f15340a==3
replace opinion_EU=0 if f15340a==2
replace opinion_EU=0 if f15340a==1
label define opinion_EU 1 "Strongly against EU membership" 0 "Not strongly against EU membership"
label value opinion_EU opinion_EU
* only strongly against (model does not work otherwise)

gen opinion_migr = 1 if f15340b==1
replace opinion_migr = 1 if f15340b==2
replace opinion_migr = 0 if f15340b==3
replace opinion_migr = 0 if f15340b==4
replace opinion_migr = 0 if f15340b==5
label define opinion_migr 1 "In favor of limiting immigration" 0 "Neutral or against limiting immigration"
label value opinion_migr opinion_migr



* 11. Operationalisation of ads variable --> square root
gen ad_totSVP_sqrt = sqrt(ad_totSVP_cum)
gen ad_totFDP_sqrt = sqrt(ad_totFDP_cum)

gen ad_EU_SVP_sqrt = sqrt(ad_EU_SVP_cum)
gen ad_economy_SVP_sqrt = sqrt(ad_economy_SVP_cum)
gen ad_migration_SVP_sqrt = sqrt(ad_migration_SVP_cum)

gen ad_EU_FDP_sqrt = sqrt(ad_EU_FDP_cum)
gen ad_economy_FDP_sqrt = sqrt(ad_economy_FDP_cum)
gen ad_migration_FDP_sqrt = sqrt(ad_migration_FDP_cum)


***************** Part b. Results **************************

label var female "Gender"
label var age "Age"
label var education "Education"
label var income "Income"
label var leftright "Left-Right-Orientation"
label var mip_im_w1 "MIP Migration"
label var mip_eu_w1 "MIP EU"
label var mip_ec_w1 "MIP Economy"
label var opinion_ec "Issue preference: Economy"
label var opinion_EU "Issue preference: EU"
label var opinion_migr "Issue preference: Migration"
label var religion "Religion"
label define religion 0 "No religious affiliation" 1 "Catholic" 2 "Protestant" 3 "Other religion"
label value religion religion
label var language "Language region"
label define language 1 "German" 2 "French" 3 "Italian"
label value language language
label var vote_FDPSVP2 "Vote intention at w2"
label define vote_FDPSVP2 0 "Other party" 1 "FDP" 2 "SVP"
label value vote_FDPSVP2 vote_FDPSVP2
label var vote_FDPSVP1 "Vote intention at w1"
label define vote_FDPSVP1 0 "No intention to vote" 1 "FDP" 2 "SVP" 3 "Other party", modify
label value vote_FDPSVP1 vote_FDPSVP1

* 1. test IIA *
mlogit vote_FDPSVP2 female age catholic protestant other_relig education income leftright french italian mip_ec_w1 mip_im_w1 mip_eu_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_cum ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum ad_totFDP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum vote_FDP1 vote_SVP1 if SVPin==1
mlogtest, iia
* REPEAT independence of irrelevant alternatives holds --> multinomial models would be possible 

* 2. Test whether multilevel structure is appropriate
melogit vote_FDP2 i.vote_FDP1 female age i.religion education knowledge leftright i.language mip_ec_w1 mip_im_w1 mip_eu_w1 opinion_ec opinion_EU opinion_migr ad_totFDP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum || canton_BFS:
melogit vote_SVP2 i.vote_SVP1 female age i.religion education knowledge leftright i.language mip_ec_w1 mip_im_w1 mip_eu_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_cum ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum || canton_BFS:

* 3. H1:"Citizens are reinforced in their vote choice with increasing exposure to the campaign of the party they initially favoured."
* 3.1 H1: Basic model w - Table 2 - Determinants of Vote Intention at Wave 2
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_totFDP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store basic_model

esttab basic_model, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace


* 3.2 H1: Figure 1 - The Influence of Overall Campaign Intensity on Vote Intentions
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt c.ad_totFDP_sqrt##i.vote_FDPSVP1 ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if FDPin==1
est store H1_FDP
quietly margins vote_FDPSVP1, at(ad_totFDP_sqrt=(0(1)11)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
  graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Figure_1_FDP.pdf", as(pdf) replace
 
mlogit vote_FDPSVP2 i.female age i.religion education income pol_int knowledge leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_totSVP_sqrt##i.vote_FDPSVP1 ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store H1_SVP
quietly margins vote_FDPSVP1, at(ad_totSVP_sqrt=(0(1)11)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
  graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Figure_1_SVP.pdf", as(pdf) replace
 
 
 esttab H1_FDP H1_SVP, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace


* 4. H2a: " The higher the exposure to the issue-specific campaign by the advertising party, the higher the chances that a citizen develops a vote intention for that party - given that their issue preferences are in line with the ones portrayed by the party"
*    H2b: " The higher the exposure to the issue-specific campaign of an advertising party, the higher the chances that a citizen is reinforced in their vote intention for that party  - given that their issue preferences are in line with the ones portrayed by the party.

* Figure 2 - The Influence of Issue-Specific Campaigning by Issue Preferences
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt c.ad_economy_FDP_sqrt##i.vote_FDPSVP1##i.opinion_ec ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store H2_FDPeconomy
quietly margins vote_FDPSVP1, at(ad_economy_FDP_sqrt=(0(0.5)5)) over(opinion_ec) predict(outcome(1)) atmeans
marginsplot, title(FDP:Economy ads, position(12) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f2_fdp_eco)

mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt c.ad_economy_SVP_sqrt##i.vote_FDPSVP1##i.opinion_ec ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store H2_SVPeconomy
quietly margins vote_FDPSVP1, at(ad_economy_SVP_sqrt=(0(0.5)3.5)) over(opinion_ec) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f2_svp_eco)

mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt c.ad_EU_FDP_sqrt##i.vote_FDPSVP1##i.opinion_EU if SVPin==1
est store H2_FDPEU
quietly margins vote_FDPSVP1, at(ad_EU_FDP_sqrt=(0(0.25)2.5)) over(opinion_EU) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f2_fdp_eu)

mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt c.ad_EU_SVP_sqrt##i.vote_FDPSVP1##i.opinion_EU ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store H2_SVPEU
quietly margins vote_FDPSVP1, at(ad_EU_SVP_sqrt=(0(0.5)3.5)) over(opinion_EU) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f2_svp_eu)

mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt##i.vote_FDPSVP1##i.opinion_migr ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store H2_SVPMigration
quietly margins vote_FDPSVP1, at(ad_migration_SVP_sqrt=(0(0.5)4)) over(opinion_migr) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_migr) ytitle(Impact on vote intention) xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f2_svp_mig)

mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt c.ad_migration_FDP_sqrt##i.vote_FDPSVP1##i.opinion_migr ad_EU_FDP_sqrt if SVPin==1
quietly margins vote_FDPSVP1, at(ad_migration_FDP_sqrt=(0(0.5)2.5)) over(opinion_migr) predict(outcome(1))
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_migr) ytitle(Impact on vote intention) xtitle(Number of ads) noci legend(cols(1) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S))
* cannot be calculated


* 5. H3a: " The higher the exposure to the issue-specific campaign of an advertising party, the higher the chances that a citizen favoring that party perceives it to be the most competent to solve the issue"
*    H3b: " The higher the exposure to the issue-specific campaign of an advertising  party, the higher the chances that a citizen without vote intentions perceives that party to be the most competent to solve the issue"

logit competent_economy_FDP2 competent_economy_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt c.ad_economy_FDP_sqrt##i.vote_FDPSVP1 ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store competent_ec_FDP
quietly margins vote_FDPSVP1, at(ad_economy_FDP_sqrt=(0(0.5)5)) atmeans 
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Economy ads) ytitle(Impact on CIO) xtitle(Number of issue-specific ads (square root)) noci legend(cols(2) size(small)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f3_fdp_eco)
  graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Figure_3_FDP_Economy.pdf", as(pdf) replace
 
logit competent_economy_SVP2 competent_economy_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt c.ad_economy_SVP_sqrt##i.vote_FDPSVP1 ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store competent_ec_SVP
quietly margins vote_FDPSVP1, at(ad_economy_SVP_sqrt=(0(0.25)3.5)) atmeans 
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Economy ads) ytitle(Impact on CIO) xtitle(Number of issue-specific ads (square root)) noci legend(cols(2) size(small)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f3_svp_eco)
  graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Figure_3_SVP_Economy.pdf", as(pdf) replace
 
logit competent_EU_FDP2 competent_EU_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt c.ad_EU_FDP_sqrt##i.vote_FDPSVP1 if SVPin==1
est store competent_EU_FDP
quietly margins vote_FDPSVP1, at(ad_EU_FDP_sqrt=(0(0.25)2.5)) atmeans 
marginsplot, title(FDP, position(11) color(gs0)) subtitle(EU ads) ytitle(Impact on CIO) xtitle(Number of issue-specific ads (square root)) noci legend(cols(2) size(small)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f3_fdp_eu)
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Figure_3_FDP_EU.pdf", as(pdf) replace
 
logit competent_EU_SVP2 competent_EU_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt c.ad_EU_SVP_sqrt##i.vote_FDPSVP1 ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store competent_EU_SVP
quietly margins vote_FDPSVP1, at(ad_EU_SVP_sqrt=(0(0.25)3.5)) atmeans 
marginsplot, title(SVP, position(11) color(gs0)) subtitle(EU ads) ytitle(Impact on CIO) xtitle(Number of issue-specific ads (square root)) noci legend(cols(2) size(small)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f3_svp_eu)
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Figure_3_SVP_EU.pdf", as(pdf) replace

logit competent_migration_SVP2 competent_migration_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt##i.vote_FDPSVP1 ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store competent_migr_SVP
quietly margins vote_FDPSVP1, at(ad_migration_SVP_sqrt=(0(0.5)4)) atmeans 
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Migration ads) ytitle(Impact on CIO) xtitle(Number of issue-specific ads (square root)) noci legend(cols(2) size(small)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T)) name(f3_svp_mig)
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Figure_3_SVP_Migration.pdf", as(pdf) replace

***************** Part c. Appendix - Robustness check **************************
* Descriptives
gen inmodel=1 if !missing(vote_FDPSVP2, vote_FDPSVP1, female, age, religio, education, income, leftright, language, mip_im_w1, mip_eu_w1, mip_ec_w1, opinion_ec, opinion_EU, ad_totSVP_sqrt, ad_totFDP_sqrt, ad_economy_SVP_sqrt, ad_migration_SVP_sqrt, ad_EU_SVP_sqrt, ad_economy_FDP_sqrt, ad_migration_FDP_sqrt, opinion_migr, ad_EU_FDP_sqrt)
recode inmodel (1=.) if SVPin!=1
tab vote_FDPSVP1 vote_FDPSVP2 
 
* correlations
pwcorr ad_totFDP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if inmodel==1, sig
pwcorr ad_totSVP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt if inmodel==1, sig
 
* Do advertisements differ between newspapers?
oneway ad_totSVP_sqrt source if inmodel==1
oneway ad_totFDP_sqrt source if inmodel==1
oneway ad_migration_SVP_sqrt source if inmodel==1
oneway ad_economy_SVP_sqrt source if inmodel==1
oneway ad_EU_SVP_sqrt source if inmodel==1
oneway ad_economy_FDP_sqrt source if inmodel==1
oneway ad_EU_FDP_sqrt source if inmodel==1
oneway ad_migration_FDP_sqrt source if inmodel==1

* Model 1: CUMULATIVE ads

* Cumulative campaign measure
sum ad_totSVP_cum, d //126 / 86
sum ad_totFDP_cum, d // 132 / 88
sum ad_migration_SVP_cum, d //21 / 17
sum ad_migration_FDP_cum, d //5 / 4
sum ad_economy_SVP_cum, d // 24 / 15
sum ad_economy_FDP_cum, d // 37 / 25
sum ad_EU_SVP_cum, d // 18 / 14
sum ad_EU_FDP_cum, d // 22 / 7

* Basic model*
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_cum ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum ad_totFDP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
est store basic_model_cum
esttab basic_model_cum, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace

* H1
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_cum c.ad_totFDP_cum##i.vote_FDPSVP1 ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
est store H1_FDP_cum
quietly margins vote_FDPSVP1, at(ad_totFDP_cum=(0(5)85)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Absolute number of ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A72_cum.pdf", as(pdf) replace

mlogit vote_FDPSVP2 i.female age i.religion education income pol_int knowledge leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_totSVP_cum##i.vote_FDPSVP1 ad_totFDP_cum ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
est store H1_SVP_cum
quietly margins vote_FDPSVP1, at(ad_totSVP_cum=(0(5)85)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Absolute number of ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A71_cum.pdf", as(pdf) replace

* H2 - Multinomial (FDP economic preferences) CUM*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_cum ad_totFDP_cum ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum c.ad_economy_FDP_cum##i.vote_FDPSVP1##i.opinion_ec ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
est store H2_FDPeconomy_cum
quietly margins vote_FDPSVP1, at(ad_economy_FDP_cum=(0(2)24)) over(opinion_ec) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Absolute number of ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP economic preferences) CUM*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_cum ad_totFDP_cum c.ad_economy_SVP_cum##i.vote_FDPSVP1##i.opinion_ec ad_migration_SVP_cum ad_EU_SVP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
est store H2_SVPeconomy_cum
quietly margins vote_FDPSVP1, at(ad_economy_SVP_cum=(0(2)14)) over(opinion_ec) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_ec)ytitle(Impact on vote intention) xtitle(Absolute number of ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (FDP EU preferences) CUM*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_cum ad_totFDP_cum ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum ad_economy_FDP_cum ad_migration_FDP_cum c.ad_EU_FDP_cum##i.vote_FDPSVP1##i.opinion_EU if SVPin==1
est store H2_FDPEU_cum
quietly margins vote_FDPSVP1, at(ad_EU_FDP_cum=(0(1)6)) over(opinion_EU) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Absolute number of ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP EU preferences) CUM*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_cum ad_totFDP_cum ad_economy_SVP_cum ad_migration_SVP_cum c.ad_EU_SVP_cum##i.vote_FDPSVP1##i.opinion_EU ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
est store H2_SVPEU_cum
quietly margins vote_FDPSVP1, at(ad_EU_SVP_cum=(0(2)14)) over(opinion_EU) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Absolute number of ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP migration preferences) CUM*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU ad_totSVP_cum ad_totFDP_cum ad_economy_SVP_cum c.ad_migration_SVP_cum##i.vote_FDPSVP1##i.opinion_migr ad_EU_SVP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
est store H2_SVPMigration_cum
quietly margins vote_FDPSVP1, at(ad_migration_SVP_cum=(0(2)16)) over(opinion_migr) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_migr) ytitle(Impact on vote intention) xtitle(Absolute number of ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H3 competence issue ownership
 *** PERCEIVED ISSUE OWNERSHIP (Only competence) ***
 * AV competence issue ownership (SVP migration)
logit competent_migration_SVP2 competent_migration_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_cum ad_totFDP_cum ad_economy_SVP_cum c.ad_migration_SVP_cum##i.vote_FDPSVP1 ad_EU_SVP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
quietly margins vote_FDPSVP1, at(ad_migration_SVP_cum=(0(2)16)) atmeans 
marginsplot, title(SVP: Migration ads (cumulative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Absolute number of migration ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_mig_cum.pdf", as(pdf) replace

* AV competence issue ownership (SVP EU)
logit competent_EU_SVP2 competent_EU_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_cum ad_totFDP_cum ad_economy_SVP_cum ad_migration_SVP_cum c.ad_EU_SVP_cum##i.vote_FDPSVP1 ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
quietly margins vote_FDPSVP1, at(ad_EU_SVP_cum=(0(2)14)) atmeans 
marginsplot, title(SVP: EU ads (cumulative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Absolute number of EU ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_eu_cum.pdf", as(pdf) replace

 * AV competence issue ownership (SVP Economy)
 logit competent_economy_SVP2 competent_economy_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_cum ad_totFDP_cum c.ad_economy_SVP_cum##i.vote_FDPSVP1 ad_migration_SVP_cum ad_EU_SVP_cum ad_economy_FDP_cum ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
quietly margins vote_FDPSVP1, at(ad_economy_SVP_cum=(0(2)14)) atmeans 
marginsplot, title(SVP: Economy ads (cumulative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Absolute number of economy ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_eco_cum.pdf", as(pdf) replace

* AV competence issue ownership (FDP economy)
logit competent_economy_FDP2 competent_economy_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_cum ad_totFDP_cum ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum c.ad_economy_FDP_cum##i.vote_FDPSVP1 ad_migration_FDP_cum ad_EU_FDP_cum if SVPin==1
quietly margins vote_FDPSVP1, at(ad_economy_FDP_cum=(0(2)24)) atmeans 
marginsplot, title(FDP: Economy ads (cumulative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Absolute number of economy ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A76_FDP_eco_cum.pdf", as(pdf) replace

* AV competence issue ownership (FDP EU)
logit competent_EU_FDP2 competent_EU_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_cum ad_totFDP_cum ad_economy_SVP_cum ad_migration_SVP_cum ad_EU_SVP_cum ad_economy_FDP_cum ad_migration_FDP_cum c.ad_EU_FDP_cum##i.vote_FDPSVP1 if SVPin==1
quietly margins vote_FDPSVP1, at(ad_EU_FDP_cum=(0(0.5)5)) atmeans 
marginsplot, title(FDP: EU ads (cumulative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Absolute number of EU ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A76_FDP_eu_cum.pdf", as(pdf) replace

* Model 2 - RELATIVE ads
* Relative campaign measure
gen ad_migr_SVP_rel = ad_migration_SVP_cum / ad_migration_ALL_cum
gen ad_migr_FDP_rel = ad_migration_FDP_cum / ad_migration_ALL_cum
gen ad_ec_SVP_rel = ad_economy_SVP_cum / ad_economy_ALL_cum
gen ad_ec_FDP_rel = ad_economy_FDP_cum / ad_economy_ALL_cum
gen ad_EU_SVP_rel = ad_EU_SVP_cum / ad_EU_ALL_cum
gen ad_EU_FDP_rel = ad_EU_FDP_cum / ad_EU_ALL_cum

* Basic model*
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_rel ad_ec_SVP_rel ad_migr_SVP_rel ad_EU_SVP_rel ad_totFDP_rel ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
est store basic_model_rel

esttab basic_model_rel, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace

* H1
sum ad_totFDP_rel, d
sum ad_totSVP_rel, d
sum ad_ec_SVP_rel, d
sum ad_ec_FDP_rel, d
sum ad_EU_SVP_rel, d
sum ad_EU_FDP_rel, d // 0.666
sum ad_migr_SVP_rel, d
* sonst range 0-1 (99% der Fälle in Graph)

mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_rel c.ad_totFDP_rel##i.vote_FDPSVP1 ad_ec_SVP_rel ad_migr_SVP_rel ad_EU_SVP_rel ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
est store H1_FDP_rel
quietly margins vote_FDPSVP1, at(ad_totFDP_rel=(0(0.1)1)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Relative share of total ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A72_rel.pdf", as(pdf) replace

mlogit vote_FDPSVP2 i.female age i.religion education income pol_int knowledge leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_totSVP_rel##i.vote_FDPSVP1 ad_totFDP_rel ad_ec_SVP_rel ad_migr_SVP_rel ad_EU_SVP_rel ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
est store H1_SVP_rel
quietly margins vote_FDPSVP1, at(ad_totSVP_rel=(0(0.1)1)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Relative share of total ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
    graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A71_rel.pdf", as(pdf) replace

* H2 - Multinomial (FDP economic preferences) REL*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_rel ad_totFDP_rel ad_ec_SVP_rel ad_migr_SVP_rel ad_EU_SVP_rel c.ad_ec_FDP_rel##i.vote_FDPSVP1##i.opinion_ec ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
est store H2_FDPec
quietly margins vote_FDPSVP1, at(ad_ec_FDP_rel=(0(0.1)1)) over(opinion_ec) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Relative share of economy ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP economic preferences) REL*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_rel ad_totFDP_rel c.ad_ec_SVP_rel##i.vote_FDPSVP1##i.opinion_ec ad_migr_SVP_rel ad_EU_SVP_rel ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
est store H2_SVPec_rel
quietly margins vote_FDPSVP1, at(ad_ec_SVP_rel=(0(0.1)1)) over(opinion_ec) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Relative share of economy ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (FDP EU preferences) REL*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_rel ad_totFDP_rel ad_ec_SVP_rel ad_migr_SVP_rel ad_EU_SVP_rel ad_ec_FDP_rel ad_migr_FDP_rel c.ad_EU_FDP_rel##i.vote_FDPSVP1##i.opinion_EU if SVPin==1
est store H2_FDPEU_rel
quietly margins vote_FDPSVP1, at(ad_EU_FDP_rel=(0(0.05)0.6)) over(opinion_EU) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Relative share of EU ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP EU preferences) REL*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_rel ad_totFDP_rel ad_ec_SVP_rel ad_migr_SVP_rel c.ad_EU_SVP_rel##i.vote_FDPSVP1##i.opinion_EU ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
est store H2_SVPEU_rel
quietly margins vote_FDPSVP1, at(ad_EU_SVP_rel=(0(0.1)1)) over(opinion_EU) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Relative share of EU ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP migration preferences) REL*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU ad_totSVP_rel ad_totFDP_rel ad_ec_SVP_rel c.ad_migr_SVP_rel##i.vote_FDPSVP1##i.opinion_migr ad_EU_SVP_rel ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
est store H2_SVPMigr_rel
quietly margins vote_FDPSVP1, at(ad_migr_SVP_rel=(0(0.1)1)) over(opinion_migr) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_migr) ytitle(Impact on vote intention) xtitle(Relative share of migration ads) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
* Cannot be calculated: Due to the fact that the SVP was basically the only party that broached the issue of migration during the 2015 electoral campaign, interaction models using the relative share of migration ads per party cannot be calculated.

*** H3 (relative measure) ***
* AV competence issue ownership (SVP Migration)
logit competent_migration_SVP2 competent_migration_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_rel ad_totFDP_rel ad_ec_SVP_rel c.ad_migr_SVP_rel##i.vote_FDPSVP1 ad_EU_SVP_rel ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
quietly margins vote_FDPSVP1, at(ad_migr_SVP_rel=(0(01.1)1)) atmeans 
marginsplot, title(SVP:Migration ads (relative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Absolute number of migration ads) noci legend(cols(2) size(small)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
* Cannot be calculated: Due to the fact that the SVP was basically the only party that broached the issue of migration during the 2015 electoral campaign, interaction models using the relative share of migration ads per party cannot be calculated.

* AV competence issue ownership (SVP EU)
logit competent_EU_SVP2 competent_EU_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_rel ad_totFDP_rel ad_ec_SVP_rel ad_migr_SVP_rel c.ad_EU_SVP_rel##i.vote_FDPSVP1 ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
quietly margins vote_FDPSVP1, at(ad_EU_SVP_rel=(0(0.1)1)) atmeans 
marginsplot, title(SVP: EU ads (relative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Relative share of EU ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
    graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_eu_rel.pdf", as(pdf) replace

 * AV competence issue ownership (SVP Economy)
 logit competent_economy_SVP2 competent_economy_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_rel ad_totFDP_rel c.ad_ec_SVP_rel##i.vote_FDPSVP1 ad_migr_SVP_rel ad_EU_SVP_rel ad_ec_FDP_rel ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
quietly margins vote_FDPSVP1, at(ad_ec_SVP_rel=(0(0.1)1)) atmeans 
marginsplot, title(SVP: Economy ads (relative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Relative share of economy ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
    graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_eco_rel.pdf", as(pdf) replace

* AV competence issue ownership (FDP economy)
logit competent_economy_FDP2 competent_economy_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_rel ad_totFDP_rel ad_ec_SVP_rel ad_migr_SVP_rel ad_EU_SVP_rel c.ad_ec_FDP_rel##i.vote_FDPSVP1 ad_migr_FDP_rel ad_EU_FDP_rel if SVPin==1
quietly margins vote_FDPSVP1, at(ad_ec_FDP_rel=(0(0.1)1)) atmeans 
marginsplot, title(FDP: Economy ads (relative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Relative share of economy ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
    graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A76_FDP_eco_rel.pdf", as(pdf) replace

* AV competence issue ownership (FDP EU)
logit competent_EU_FDP2 competent_EU_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_rel ad_totFDP_rel ad_ec_SVP_rel ad_migr_SVP_rel ad_EU_SVP_rel ad_ec_FDP_rel ad_migr_FDP_rel c.ad_EU_FDP_rel##i.vote_FDPSVP1 if SVPin==1
quietly margins vote_FDPSVP1, at(ad_EU_FDP_rel=(0(0.05)0.6)) atmeans 
marginsplot, title(FDP: EU ads (relative), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Relative share of EU ads) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
    graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A76_FDP_eu_rel.pdf", as(pdf) replace


* Model 3 - Weight ATTENTION to ads
* WEIGHT: INFORMATION PROCESSING STYLES(news attention W2_f13400b)
gen ad_totSVP_attention = ad_totSVP_sqrt*W2_f13400b
gen ad_totFDP_attention = ad_totFDP_sqrt*W2_f13400b
gen ad_migr_SVP_attention = ad_migration_SVP_sqrt*W2_f13400b
gen ad_ec_SVP_attention = ad_economy_SVP_sqrt*W2_f13400b
gen ad_EU_SVP_attention = ad_EU_SVP_sqrt*W2_f13400b
gen ad_ec_FDP_attention = ad_economy_FDP_sqrt*W2_f13400b
gen ad_EU_FDP_attention = ad_EU_FDP_sqrt*W2_f13400b
gen ad_migr_FDP_attention = ad_migration_FDP_sqrt*W2_f13400b

sum ad_totSVP_attention, d
sum ad_totFDP_attention, d
sum ad_migr_SVP_attention, d
sum ad_ec_SVP_attention, d
sum ad_EU_SVP_attention, d
sum ad_ec_FDP_attention, d
sum ad_EU_FDP_attention, d
* 99% of cases

* Basic model *
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_attention ad_ec_SVP_attention ad_migr_SVP_attention ad_EU_SVP_attention ad_totFDP_attention ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
est store basic_model_attention
esttab basic_model_attention, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace

* H1
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_attention c.ad_totFDP_attention##i.vote_FDPSVP1 ad_ec_SVP_attention ad_migr_SVP_attention ad_EU_SVP_attention ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
est store H1_FDP_att
quietly margins vote_FDPSVP1, at(ad_totFDP_attention=(0(2)30)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) weighted by attention) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A72_wei.pdf", as(pdf) replace

mlogit vote_FDPSVP2 i.female age i.religion education income pol_int knowledge leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_totSVP_attention##i.vote_FDPSVP1 ad_totFDP_attention ad_ec_SVP_attention ad_migr_SVP_attention ad_EU_SVP_attention ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
est store H1_SVP_att
quietly margins vote_FDPSVP1, at(ad_totSVP_attention=(0(2)30)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) weighted by attention) noci legend(cols(2) size(small)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A71_wei.pdf", as(pdf) replace

* H2 - Multinomial (FDP economic preferences) ATTENTION*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_attention ad_totFDP_attention ad_ec_SVP_attention ad_migr_SVP_attention ad_EU_SVP_attention c.ad_ec_FDP_attention##i.vote_FDPSVP1##i.opinion_ec ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
est store H2_FDPec_att
quietly margins vote_FDPSVP1, at(ad_ec_FDP_attention=(0(1)12)) over(opinion_ec) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) weighted by attention) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2/H3 - Multinomial (SVP economic preferences) ATTENTION*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_attention ad_totFDP_attention c.ad_ec_SVP_attention##i.vote_FDPSVP1##i.opinion_ec ad_migr_SVP_attention ad_EU_SVP_attention ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
est store H2_SVPec_att
quietly margins vote_FDPSVP1, at(ad_ec_SVP_attention=(0(1)12)) over(opinion_ec) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) weighted by attention) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (FDP EU preferences) ATTENTION*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_attention ad_totFDP_attention ad_ec_SVP_attention ad_migr_SVP_attention ad_EU_SVP_attention ad_ec_FDP_attention ad_migr_FDP_attention c.ad_EU_FDP_attention##i.vote_FDPSVP1##i.opinion_EU if SVPin==1
est store H2_FDPEU_att
quietly margins vote_FDPSVP1, at(ad_EU_FDP_attention=(0(0.5)8)) over(opinion_EU) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) weighted by attention) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP EU preferences) ATTENTION*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_attention ad_totFDP_attention ad_ec_SVP_attention ad_migr_SVP_attention c.ad_EU_SVP_attention##i.vote_FDPSVP1##i.opinion_EU ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
est store H2_SVPEU_att
quietly margins vote_FDPSVP1, at(ad_EU_SVP_attention=(0(1)12)) over(opinion_EU) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) weighted by attention) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
 
* H2 - Multinomial (SVP migr preferences) ATTENTION*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU ad_totSVP_attention ad_totFDP_attention ad_ec_SVP_attention c.ad_migr_SVP_attention##i.vote_FDPSVP1##i.opinion_migr ad_EU_SVP_attention ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
est store H2_SVPMigr_att
quietly margins vote_FDPSVP1, at(ad_migr_SVP_attention=(0(2)16)) over(opinion_migr) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_migr) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) weighted by attention) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

*** H3 (attention) ***
* AV competence issue ownership (SVP Migration)
logit competent_migration_SVP2 competent_migration_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_attention ad_totFDP_attention ad_ec_SVP_attention c.ad_migr_SVP_attention##i.vote_FDPSVP1 ad_EU_SVP_attention ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
quietly margins vote_FDPSVP1, at(ad_migr_SVP_attention=(0(2)16)) atmeans 
marginsplot, title(SVP: Migration ads (attention), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of migration ads (sqrt) weighted by attention) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_mig_wei.pdf", as(pdf) replace

* AV competence issue ownership (SVP EU)
logit competent_EU_SVP2 competent_EU_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_attention ad_totFDP_attention ad_ec_SVP_attention ad_migr_SVP_attention c.ad_EU_SVP_attention##i.vote_FDPSVP1 ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
quietly margins vote_FDPSVP1, at(ad_EU_SVP_attention=(0(1)12)) atmeans 
marginsplot, title(SVP: EU ads (attention), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of EU ads (sqrt) weighted by attention) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_eu_wei.pdf", as(pdf) replace

 * AV competence issue ownership (SVP Economy)
 logit competent_economy_SVP2 competent_economy_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_attention ad_totFDP_attention c.ad_ec_SVP_attention##i.vote_FDPSVP1 ad_migr_SVP_attention ad_EU_SVP_attention ad_ec_FDP_attention ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
quietly margins vote_FDPSVP1, at(ad_ec_SVP_attention=(0(1)12)) atmeans 
marginsplot, title(SVP: Economy ads (attention), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of economy ads (sqrt) weighted by attention) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_eco_wei.pdf", as(pdf) replace

* AV competence issue ownership (FDP economy)
logit competent_economy_FDP2 competent_economy_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_attention ad_totFDP_attention ad_ec_SVP_attention ad_migr_SVP_attention ad_EU_SVP_attention c.ad_ec_FDP_attention##i.vote_FDPSVP1 ad_migr_FDP_attention ad_EU_FDP_attention if SVPin==1
quietly margins vote_FDPSVP1, at(ad_ec_FDP_attention=(0(1)12)) atmeans 
marginsplot, title(FDP: Economy ads (attention), position(12) color(gs0)) ytitle(Impact on CIO)xtitle(Number of economy ads (sqrt) weighted by attention) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A76_FDP_eco_wei.pdf", as(pdf) replace

* AV competence issue ownership (FDP EU)
logit competent_EU_FDP2 competent_EU_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_attention ad_totFDP_attention ad_ec_SVP_attention ad_migr_SVP_attention ad_EU_SVP_attention ad_ec_FDP_attention ad_migr_FDP_attention c.ad_EU_FDP_attention##i.vote_FDPSVP1 if SVPin==1
quietly margins vote_FDPSVP1, at(ad_EU_FDP_attention=(0(1)8)) atmeans 
marginsplot, title(FDP: EU ads (attention), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of EU ads (sqrt) weighted by attention) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A76_FDP_eu_wei.pdf", as(pdf) replace

* MULTICOLLINEARITY: EXCLUDE VARIABLES

* Basic model
* only ad_totSVP_sqrt
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_sqrt if SVPin==1
est store basic_model_totSVP_only
* only ad_totFDP_sqrt
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totFDP_sqrt if SVPin==1
est store basic_model_totFDP_only
esttab basic_model_totSVP_only basic_model_totFDP_only, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace
* only ad_migration_SVP_sqrt
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_migration_SVP_sqrt if SVPin==1
est store basic_model_migrSVP_only
* only ad_migration_FDP_sqrt
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_migration_FDP_sqrt if SVPin==1
est store basic_model_migrFDP_only
esttab basic_model_migrSVP_only basic_model_migrFDP_only, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace* only ad_economy_SVP_sqrt
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_economy_SVP_sqrt if SVPin==1
est store basic_model_ecSVP_only
* only ad_economy_FDP_sqrt
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_economy_FDP_sqrt if SVPin==1
est store basic_model_ecFDP_only
esttab basic_model_ecSVP_only basic_model_ecFDP_only, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace
* only ad_EU_SVP_sqrt
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_EU_SVP_sqrt if SVPin==1
est store basic_model_EUSVP_only
* only ad_EU_FDP_sqrt
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_EU_FDP_sqrt if SVPin==1
est store basic_model_EUFDP_only
esttab basic_model_EUSVP_only basic_model_EUFDP_only, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace

* H1
sum ad_totFDP_sqrt, d
sum ad_totSVP_sqrt, d
sum ad_economy_SVP_sqrt, d
sum ad_economy_FDP_sqrt, d
sum ad_EU_SVP_sqrt, d
sum ad_EU_FDP_sqrt, d 
sum ad_migration_SVP_sqrt, d

mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_totFDP_sqrt##i.vote_FDPSVP1 if SVPin==1
est store H1_FDP_only
quietly margins vote_FDPSVP1, at(ad_totFDP_sqrt=(0(1)9)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) - single campaign variable) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A72_sing.pdf", as(pdf) replace

mlogit vote_FDPSVP2 i.female age i.religion education income pol_int knowledge leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_totSVP_sqrt##i.vote_FDPSVP1 if SVPin==1
est store H1_SVP_only
quietly margins vote_FDPSVP1, at(ad_totSVP_sqrt=(0(1)9)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) - single campaign variable) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A71_sing.pdf", as(pdf) replace

* H2 - Multinomial (FDP economic preferences) SQRT*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr c.ad_economy_FDP_sqrt##i.vote_FDPSVP1##i.opinion_ec if SVPin==1
est store H2_FDPeconomy_only
quietly margins vote_FDPSVP1, at(ad_economy_FDP_sqrt=(0(0.5)5)) over(opinion_ec) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Number of issue-specific ads (sqrt) - single campaign variable) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP economic preferences) SQRT*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr c.ad_economy_SVP_sqrt##i.vote_FDPSVP1##i.opinion_ec if SVPin==1
est store H2_SVPeconomy_only
quietly margins vote_FDPSVP1, at(ad_economy_SVP_sqrt=(0(0.25)3.5)) over(opinion_ec) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_ec) ytitle(Impact on vote intention) xtitle(Number of ads (sqrt) - single campaign variable) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (FDP EU preferences) SQRT*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr c.ad_EU_FDP_sqrt##i.vote_FDPSVP1##i.opinion_EU if SVPin==1
est store H2_FDPEU_only
quietly margins vote_FDPSVP1, at(ad_EU_FDP_sqrt=(0(0.25)2.5)) over(opinion_EU) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Number of issue-specific ads (sqrt) - single campaign variable) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

* H2 - Multinomial (SVP EU preferences) SQRT*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr c.ad_EU_SVP_sqrt##i.vote_FDPSVP1##i.opinion_EU if SVPin==1
est store H2_SVPEU_only
quietly margins vote_FDPSVP1, at(ad_EU_SVP_sqrt=(0(0.25)3.5)) over(opinion_EU) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_EU) ytitle(Impact on vote intention) xtitle(Number of issue-specific ads (sqrt) - single campaign variable) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
 
* H2 - Multinomial (SVP migration preferences) SQRT*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU c.ad_migration_SVP_sqrt##i.vote_FDPSVP1##i.opinion_migr if SVPin==1
est store H2_SVPMigration_only
quietly margins vote_FDPSVP1, at(ad_migration_SVP_sqrt=(0(0.5)4)) over(opinion_migr) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_migr) ytitle(Impact on vote intention) xtitle(Number of issue-specific ads (sqrt) - single campaign variable) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))

*** H3 (single campaign variable) ***
* AV competence issue ownership (SVP Migration)
logit competent_migration_SVP2 competent_migration_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_migration_SVP_sqrt##i.vote_FDPSVP1 if SVPin==1
quietly margins vote_FDPSVP1, at(ad_migration_SVP_sqrt=(0(0.5)4)) atmeans 
marginsplot, title(SVP: Migration ads (single), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of migration ads (sqrt) – single campaign variable) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_mig_sing.pdf", as(pdf) replace

* AV competence issue ownership (SVP EU)
logit competent_EU_SVP2 competent_EU_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_EU_SVP_sqrt##i.vote_FDPSVP1 if SVPin==1
quietly margins vote_FDPSVP1, at(ad_EU_SVP_sqrt=(0(0.25)3.5)) atmeans 
marginsplot, title(SVP: EU ads (single), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of EU ads (sqrt) – single campaign variable) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_eu_sing.pdf", as(pdf) replace

 * AV competence issue ownership (SVP Economy)
logit competent_economy_SVP2 competent_economy_SVP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_economy_SVP_sqrt##i.vote_FDPSVP1 if SVPin==1
quietly margins vote_FDPSVP1, at(ad_economy_SVP_sqrt=(0(0.25)3.5)) atmeans 
marginsplot, title(SVP: Economy ads (single), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of economy ads (sqrt) – single campaign variable) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A75_SVP_eco_sing.pdf", as(pdf) replace

* AV competence issue ownership (FDP economy)
logit competent_economy_FDP2 competent_economy_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_economy_FDP_sqrt##i.vote_FDPSVP1 if SVPin==1
quietly margins vote_FDPSVP1, at(ad_economy_FDP_sqrt=(0(0.5)5)) atmeans 
marginsplot, title(FDP: Economy ads (single), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of economy ads (sqrt) – single campaign variable) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A76_FDP_eco_sing.pdf", as(pdf) replace

* AV competence issue ownership (FDP EU)
logit competent_EU_FDP2 competent_EU_FDP female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_EU_FDP_sqrt##i.vote_FDPSVP1 if SVPin==1
quietly margins vote_FDPSVP1, at(ad_EU_FDP_sqrt=(0(0.25)2.5)) atmeans 
marginsplot, title(FDP: EU ads (single), position(12) color(gs0)) ytitle(Impact on CIO) xtitle(Number of EU ads (sqrt) – single campaign variable) noci legend(cols(2) size(small) order(1 "No intention to vote (w1)" 2 "SVP vote (w1)" 3 "FDP vote (w1)" 4 "OTHER vote (w1)")) graphregion(color(white)) plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash_dot) msymbol(T))
   graph export "/Users/ZumofenG/Documents/OneDrive/PhD/P3_directVSindirect campaign/3rd version/Appendix_Figures/A76_FDP_eu_sing.pdf", as(pdf) replace

**** ANDERES *****

* Descriptives AV
tab vote_FDPSVP1 if inmodel==1, nol // nur knapp 7% haben no intention to vote
tab vote_FDPSVP2 if inmodel==1, nol

gen mobilize_FDP = 1 if vote_FDPSVP1==0 & vote_FDPSVP2==1
gen mobilize_SVP = 1 if vote_FDPSVP1==0 & vote_FDPSVP2==2
gen mobilize_Other = 1 if vote_FDPSVP1==0 & vote_FDPSVP2==0
gen stable_FDP = 1 if vote_FDPSVP1==1 & vote_FDPSVP2==1
gen stable_SVP = 1 if vote_FDPSVP1==2 & vote_FDPSVP2==2
gen stable_Other = 1 if vote_FDPSVP1==3 & vote_FDPSVP2==0
gen change_SVPFDP = 1 if vote_FDPSVP1==2 & vote_FDPSVP2==1
gen change_FDPSVP = 1 if vote_FDPSVP1==1 & vote_FDPSVP2==2
gen change_OtherSVP = 1 if vote_FDPSVP1==3 & vote_FDPSVP2==2
gen change_OtherFDP = 1 if vote_FDPSVP1==3 & vote_FDPSVP2==1
gen change_SVPOther = 1 if vote_FDPSVP1==2 & vote_FDPSVP2==0
gen change_FDPOther = 1 if vote_FDPSVP1==1 & vote_FDPSVP2==0

* Movements on AV between wave 1 and 2
tab mobilize_FDP if inmodel==1
tab mobilize_SVP if inmodel==1
tab mobilize_Other if inmodel==1
tab stable_FDP if inmodel==1
tab stable_SVP if inmodel==1
tab stable_Other if inmodel==1
tab change_FDPSVP if inmodel==1
tab change_FDPOther if inmodel==1
tab change_SVPFDP if inmodel==1
tab change_SVPOther if inmodel==1
tab change_OtherFDP if inmodel==1
tab change_OtherSVP if inmodel==1

* INFORMATION PROCESSING STYLES(knowledge)
label define pol_knowl 0 "less aware" 1 "highly aware"
label value pol_knowl pol_knowl

* TABLE 2
* SVP total 
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec c.ad_totSVP_sqrt##i.pol_knowl ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_totFDP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
quietly margins pol_knowl, at(ad_totSVP_sqrt=(0(1)11)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O))

* FDP total 
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt c.ad_totFDP_sqrt##i.pol_knowl ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
quietly margins pol_knowl, at(ad_totFDP_sqrt=(0(1)11)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O))
 
 * SVP migration
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt##i.pol_knowl ad_EU_SVP_sqrt ad_totFDP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
quietly margins pol_knowl, at(ad_migration_SVP_sqrt=(0(0.5)4)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Campaign effects (migration ads)) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O))

  * SVP economy
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_sqrt c.ad_economy_SVP_sqrt##i.pol_knowl ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_totFDP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
quietly margins pol_knowl, at(ad_economy_SVP_sqrt=(0(0.5)4)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Campaign effects (economy ads)) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O))
 
 
   * SVP EU
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt c.ad_EU_SVP_sqrt##i.pol_knowl ad_totFDP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
quietly margins pol_knowl, at(ad_EU_SVP_sqrt=(0(0.5)4)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Campaign effects (EU ads)) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O))
 
 
  * FDP economy
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_totFDP_sqrt c.ad_economy_FDP_sqrt##i.pol_knowl ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
quietly margins pol_knowl, at(ad_economy_FDP_sqrt=(0(0.5)4)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Campaign effects (economy ads)) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O))
 
 
   * FDP EU
mlogit vote_FDPSVP2 i.vote_FDPSVP1 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_migr opinion_EU opinion_ec ad_totSVP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_totFDP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt c.ad_EU_FDP_sqrt##i.pol_knowl if SVPin==1
quietly margins pol_knowl, at(ad_EU_FDP_sqrt=(0(0.5)4)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Campaign effects (EU ads)) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O))
 
 
* Changes in competence issue ownership
gen inmodel_compEUSVP =1 if !missing(competent_EU_SVP, competent_EU_SVP2, vote_FDPSVP1, female, age, religio, education, income, leftright, language, mip_im_w1, mip_eu_w1, mip_ec_w1, opinion_ec, opinion_EU, ad_totSVP_sqrt, ad_totFDP_sqrt, ad_economy_SVP_sqrt, ad_migration_SVP_sqrt, ad_EU_SVP_sqrt, ad_economy_FDP_sqrt, ad_migration_FDP_sqrt, opinion_migr, ad_EU_FDP_sqrt)
recode inmodel_compEUSVP (1=.) if SVPin!=1

gen inmodel_compEUFDP =1 if !missing(competent_EU_FDP, competent_EU_FDP2, vote_FDPSVP1, female, age, religio, education, income, leftright, language, mip_im_w1, mip_eu_w1, mip_ec_w1, opinion_ec, opinion_EU, ad_totSVP_sqrt, ad_totFDP_sqrt, ad_economy_SVP_sqrt, ad_migration_SVP_sqrt, ad_EU_SVP_sqrt, ad_economy_FDP_sqrt, ad_migration_FDP_sqrt, opinion_migr, ad_EU_FDP_sqrt)
recode inmodel_compEUFDP (1=.) if SVPin!=1

gen inmodel_compmigrSVP =1 if !missing(competent_migration_SVP, competent_migration_SVP2, vote_FDPSVP1, female, age, religio, education, income, leftright, language, mip_im_w1, mip_eu_w1, mip_ec_w1, opinion_ec, opinion_EU, ad_totSVP_sqrt, ad_totFDP_sqrt, ad_economy_SVP_sqrt, ad_migration_SVP_sqrt, ad_EU_SVP_sqrt, ad_economy_FDP_sqrt, ad_migration_FDP_sqrt, opinion_migr, ad_EU_FDP_sqrt)
recode inmodel_compmigrSVP (1=.) if SVPin!=1

gen inmodel_compmigrFDP =1 if !missing(competent_migration_FDP, competent_migration_FDP2, vote_FDPSVP1, female, age, religio, education, income, leftright, language, mip_im_w1, mip_eu_w1, mip_ec_w1, opinion_ec, opinion_EU, ad_totSVP_sqrt, ad_totFDP_sqrt, ad_economy_SVP_sqrt, ad_migration_SVP_sqrt, ad_EU_SVP_sqrt, ad_economy_FDP_sqrt, ad_migration_FDP_sqrt, opinion_migr, ad_EU_FDP_sqrt)
recode inmodel_compmigrFDP (1=.) if SVPin!=1

gen inmodel_compecSVP =1 if !missing(competent_economy_SVP, competent_economy_SVP2, vote_FDPSVP1, female, age, religio, education, income, leftright, language, mip_im_w1, mip_eu_w1, mip_ec_w1, opinion_ec, opinion_EU, ad_totSVP_sqrt, ad_totFDP_sqrt, ad_economy_SVP_sqrt, ad_migration_SVP_sqrt, ad_EU_SVP_sqrt, ad_economy_FDP_sqrt, ad_migration_FDP_sqrt, opinion_migr, ad_EU_FDP_sqrt)
recode inmodel_compecSVP (1=.) if SVPin!=1

gen inmodel_compecFDP =1 if !missing(competent_economy_FDP, competent_economy_FDP2, vote_FDPSVP1, female, age, religio, education, income, leftright, language, mip_im_w1, mip_eu_w1, mip_ec_w1, opinion_ec, opinion_EU, ad_totSVP_sqrt, ad_totFDP_sqrt, ad_economy_SVP_sqrt, ad_migration_SVP_sqrt, ad_EU_SVP_sqrt, ad_economy_FDP_sqrt, ad_migration_FDP_sqrt, opinion_migr, ad_EU_FDP_sqrt)
recode inmodel_compecFDP (1=.) if SVPin!=1

tab inmodel_compEUFDP
tab inmodel_compmigrSVP
tab inmodel_compmigrFDP
tab inmodel_compecSVP
tab inmodel_compecFDP

tab competent_EU_SVP competent_EU_SVP2 if inmodel_compEUSVP==1
tab competent_EU_FDP competent_EU_FDP2 if inmodel_compEUFDP==1
tab competent_migration_SVP competent_migration_SVP2 if inmodel_compmigrSVP==1
tab competent_migration_FDP competent_migration_FDP2 if inmodel_compmigrFDP==1
tab competent_economy_SVP competent_economy_SVP2 if inmodel_compecSVP==1
tab competent_economy_FDP competent_economy_FDP2 if inmodel_compecFDP==1


*** Descriptives for Appendix ***
tab vote_FDPSVP1 if inmodel==1
tab vote_FDPSVP2 if inmodel==1
tab competent_EU_SVP2 if inmodel_compEUSVP==1
tab competent_EU_FDP2 if inmodel_compEUSVP==1
tab competent_migration_SVP2 if inmodel_compmigrSVP==1
tab competent_migration_FDP2 if inmodel_compmigrSVP==1
tab competent_economy_SVP2 if inmodel_compecSVP==1
tab competent_economy_FDP2 if inmodel_compecSVP==1
tab competent_EU_SVP if inmodel_compEUSVP==1
tab competent_EU_FDP if inmodel_compEUSVP==1
tab competent_migration_SVP if inmodel_compmigrSVP==1
tab competent_migration_FDP if inmodel_compmigrSVP==1
tab competent_economy_SVP if inmodel_compecSVP==1
tab competent_economy_FDP if inmodel_compecSVP==1
tab female if inmodel==1
sum age if inmodel==1, d
tab religion if inmodel==1
sum education if inmodel==1, d
sum income if inmodel==1, d
sum leftright if inmodel==1, d
tab language if inmodel==1
tab mip_eu_w1 if inmodel==1
tab mip_im_w1 if inmodel==1
tab mip_ec_w1 if inmodel==1
tab opinion_ec if inmodel==1
tab opinion_EU if inmodel==1
tab opinion_migr if inmodel==1
sum ad_totFDP_sqrt if inmodel==1, d
sum ad_totSVP_sqrt if inmodel==1, d
sum ad_economy_SVP_sqrt if inmodel==1, d
sum ad_economy_FDP_sqrt if inmodel==1, d
sum ad_EU_SVP_sqrt if inmodel==1, d
sum ad_EU_FDP_sqrt if inmodel==1, d 
sum ad_migration_SVP_sqrt if inmodel==1, d
sum ad_migration_FDP_sqrt if inmodel==1, d

* AV competence issue ownership (SVP Migration)
logit competent_migration_SVP2 competent_migration_SVP female age i.religion education income leftright i.vote_FDPSVP1 i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store CIO_migr_SVP

* AV competence issue ownership (FDP Migration)
logit competent_migration_FDP2 competent_migration_FDP female age i.religion education income leftright i.vote_FDPSVP1 i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store CIO_migr_FDP

* AV competence issue ownership (SVP Economy)
logit competent_economy_SVP2 competent_economy_SVP female age i.religion education income leftright i.vote_FDPSVP1 i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store CIO_ec_SVP

* AV competence issue ownership (FDP Economy)
logit competent_economy_FDP2 competent_economy_FDP female age i.religion education income leftright i.vote_FDPSVP1 i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store CIO_ec_FDP


* AV competence issue ownership (SVP EU)
logit competent_EU_SVP2 competent_EU_SVP female age i.religion education income leftright i.vote_FDPSVP1 i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store CIO_EU_SVP


* AV competence issue ownership (FDP EU)
logit competent_EU_FDP2 competent_EU_FDP female age i.religion education income leftright i.vote_FDPSVP1 i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt if SVPin==1
est store CIO_EU_FDP

esttab CIO_EU_SVP CIO_EU_FDP CIO_migr_SVP CIO_migr_FDP CIO_ec_SVP CIO_ec_FDP, cells (b(star fmt(3)) se(par fmt(3))) stats(r2 N) label, using example.rtf, replace


* Include CIO w1 variables in models
*competent_migration_SVP competent_migration_FDP competent_EU_SVP competent_EU_FDP competent_economy_SVP

* H1
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr ad_totSVP_sqrt c.ad_totFDP_sqrt##i.vote_FDPSVP1 ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt ///
competent_migration_SVP competent_migration_FDP competent_EU_SVP competent_EU_FDP competent_economy_SVP competent_economy_FDP if SVPin==1
est store H1_FDP
quietly margins vote_FDPSVP1, at(ad_totFDP_sqrt=(0(1)11)) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) ///
 plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) ///
 plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
graph export "U:\Publikationen\2017 Selects Campagne\Version 2\R2\Additional Analyses\Robustness checks\Figures\H1_FDP_CIO.png", as(png) replace

 
mlogit vote_FDPSVP2 i.female age i.religion education income pol_int knowledge leftright i.language mip_eu_w1 mip_im_w1 mip_ec_w1 opinion_ec opinion_EU opinion_migr c.ad_totSVP_sqrt##i.vote_FDPSVP1 ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt ///
competent_migration_SVP competent_migration_FDP competent_EU_SVP competent_EU_FDP competent_economy_SVP competent_economy_FDP if SVPin==1
est store H1_SVP
quietly margins vote_FDPSVP1, at(ad_totSVP_sqrt=(0(1)11)) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) subtitle(Overall campaign effects) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) ///
 plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) ///
 plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
* Effekt bleibt bestehen
graph export "U:\Publikationen\2017 Selects Campagne\Version 2\R2\Additional Analyses\Robustness checks\Figures\H1_SVP_CIO.png", as(png) replace


* H2/H3 - Multinomial (FDP economic preferences) SQRT*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt c.ad_economy_FDP_sqrt##i.vote_FDPSVP1##i.opinion_ec ad_migration_FDP_sqrt ad_EU_FDP_sqrt ///
competent_migration_SVP competent_migration_FDP competent_EU_SVP competent_EU_FDP competent_economy_SVP competent_economy_FDP if SVPin==1
est store H2_FDPeconomy
quietly margins vote_FDPSVP1, at(ad_economy_FDP_sqrt=(0(0.5)5)) over(opinion_ec) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_ec) ///
 ytitle(Impact on vote intention) xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) ///
 yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) ///
 plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) ///
 plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
graph export "U:\Publikationen\2017 Selects Campagne\Version 2\R2\Additional Analyses\Robustness checks\Figures\H2_FDPec_CIO.png", as(png) replace

* H2/H3 - Multinomial (SVP economic preferences) SQRT*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_EU opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt c.ad_economy_SVP_sqrt##i.vote_FDPSVP1##i.opinion_ec ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt ///
competent_migration_SVP competent_migration_FDP competent_EU_SVP competent_EU_FDP competent_economy_SVP competent_economy_FDP if SVPin==1
est store H2_SVPeconomy

quietly margins vote_FDPSVP1, at(ad_economy_SVP_sqrt=(0(0.5)3.5)) over(opinion_ec) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_ec) ///
ytitle(Impact on vote intention) ///
xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) ///
 graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) ///
 plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) ///
 plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
graph export "U:\Publikationen\2017 Selects Campagne\Version 2\R2\Additional Analyses\Robustness checks\Figures\H2_SVPec_CIO.png", as(png) replace


* H2/H3 - Multinomial (FDP EU preferences) SQRT*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt c.ad_EU_FDP_sqrt##i.vote_FDPSVP1##i.opinion_EU ///
competent_migration_SVP competent_migration_FDP competent_EU_SVP competent_EU_FDP competent_economy_SVP competent_economy_FDP if SVPin==1
est store H2_FDPEU
quietly margins vote_FDPSVP1, at(ad_EU_FDP_sqrt=(0(0.25)2.5)) over(opinion_EU) predict(outcome(1)) atmeans
marginsplot, title(FDP, position(11) color(gs0)) by(opinion_EU) ///
subtitle(Campaign effect: EU ads) ytitle(Impact on vote intention) ///
 xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) yline(0, lcolor(black)) ///
 graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) ///
 plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) ///
 plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
graph export "U:\Publikationen\2017 Selects Campagne\Version 2\R2\Additional Analyses\Robustness checks\Figures\H2_FDPEU_CIO.png", as(png) replace


* H2/H3 - Multinomial (SVP EU preferences) SQRT*
mlogit vote_FDPSVP2 female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_migr ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt ad_migration_SVP_sqrt c.ad_EU_SVP_sqrt##i.vote_FDPSVP1##i.opinion_EU ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt ///
competent_migration_SVP competent_migration_FDP competent_EU_SVP competent_EU_FDP competent_economy_SVP competent_economy_FDP if SVPin==1
est store H2_SVPEU

quietly margins vote_FDPSVP1, at(ad_EU_SVP_sqrt=(0(0.5)3.5)) over(opinion_EU) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_EU) ///
subtitle(Campaign effect: EU ads) ytitle(Impact on vote intention) ///
xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) ///
 yline(0, lcolor(black)) graphregion(color(white)) ///
 plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
 plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) ///
 plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) ///
 plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
graph export "U:\Publikationen\2017 Selects Campagne\Version 2\R2\Additional Analyses\Robustness checks\Figures\H2_SVPEU_CIO.png", as(png) replace

 
* H2/H3 - Multinomial (SVP migration preferences) SQRT*
mlogit vote_FDPSVP2 i.female age i.religion education income leftright i.language mip_im_w1 mip_eu_w1 mip_ec_w1 opinion_ec opinion_EU ad_totSVP_sqrt ad_totFDP_sqrt ad_economy_SVP_sqrt c.ad_migration_SVP_sqrt##i.vote_FDPSVP1##i.opinion_migr ad_EU_SVP_sqrt ad_economy_FDP_sqrt ad_migration_FDP_sqrt ad_EU_FDP_sqrt ///
competent_migration_SVP competent_migration_FDP competent_EU_SVP competent_EU_FDP competent_economy_SVP competent_economy_FDP if SVPin==1
est store H2_SVPMigration
quietly margins vote_FDPSVP1, at(ad_migration_SVP_sqrt=(0(0.5)4)) over(opinion_migr) predict(outcome(2)) atmeans
marginsplot, title(SVP, position(11) color(gs0)) by(opinion_migr) ///
subtitle(Campaign effect: Migration ads) ytitle(Impact on vote intention) ///
xtitle(Number of ads (square root)) noci legend(cols(2) size(small)) ///
yline(0, lcolor(black)) graphregion(color(white)) ///
plot1opts(mcolor(gs0) lcolor(gs0) lpattern(solid) msymbol(D)) ///
plot2opts(mcolor(gs0) lcolor(gs0) lpattern(dot) msymbol(O)) ///
plot3opts(mcolor(gs0) lcolor(gs0) lpattern(longdash) msymbol(S)) ///
plot4opts(mcolor(gs0) lcolor(gs0) lpattern(dash) msymbol(T))
graph export "U:\Publikationen\2017 Selects Campagne\Version 2\R2\Additional Analyses\Robustness checks\Figures\H2_SVPMigr_CIO.png", as(png) replace









