*Combining/Merging Population Dat and Final Data Set

rename location country
rename time year
drop _merge

drop indicatorid indicatorname indicatorshortname source sourceyear author locationid continent iso2 iso3 timeid variantid variant sexid sex ageid agestart ageend age categoryid category estimatetypeid estimatetype estimatemethod estimatemethodid

merge 1:m country year using "/Users/jr/Documents/ECON 211/Final Project/Final Project Files/Working_age.dta"
(variable country was str45, now str59 to accommodate using data's values)

rename entity country

drop if _merge != 3

rename value median_age

drop if country == "Czechoslovakia"

rename populationhistoricalestimates  hist_pop_est_mil

rename regime_row_owid autocracy_level


*Final Data Set Work
drop if country == "Africa" || country == "Asia" || country == "North America" || country == "South America" || country == "Europe"


gen closed_autocracies = regime_row_owid == 0

gen electoral_autocracies = regime_row_owid == 1

gen electoral_democracies = regime_row_owid == 2

gen liberal_democracies = regime_row_owid == 3

drop if country == "Somaliland"

drop if country == "Zanzibar"

*All entries that were missing politcal regime data were dropped

*Create country id file

egen country_id=group(country)

gen gdp_total = gdppercapita * hist_pop_est_mil

*Regressions

*Linear
reg gdppercapita closed_autocracies electoral_autocracies electoral_democracies, r

reg gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh, r

reg gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil, r

reg gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil working_pop, r

reg gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil working_pop coup, r


xtset country_id year

xtreg gdppercapita closed_autocracies electoral_autocracies electoral_democracies, fe vce(cluster country_id)

xtreg gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh, fe vce(cluster country_id)

xtreg gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil, fe vce(cluster country_id)

xtreg gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil working_pop, fe vce(cluster country_id)

xtreg gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil working_pop coup, fe vce(cluster country_id)


sum oilproductiontwh autocracy_level gdppercapita hist_pop_est_mil closed_autocracies electoral_autocracies electoral_democracies liberal_democracies working_pop

sum oilproductiontwh autocracy_level gdppercapita hist_pop_est_mil working_pop if autocracy_level == 0 | autocracy_level == 1

sum oilproductiontwh autocracy_level gdppercapita hist_pop_est_mil working_pop if autocracy_level == 2 | autocracy_level == 3


xtreg log_gdppercapita closed_autocracies electoral_autocracies electoral_democracies, fe vce(cluster country_id)

outreg2 using Log_Autocracy, excel append

xtreg log_gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh, fe vce(cluster country_id)

outreg2 using Log_Autocracy, excel append

xtreg log_gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil, fe vce(cluster country_id)

outreg2 using Log_Autocracy, excel append

xtreg log_gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil working_pop, fe vce(cluster country_id)

outreg2 using Log_Autocracy, excel append


reg log_gdppercapita closed_autocracies electoral_autocracies electoral_democracies, fe vce(cluster country_id)

outreg2 using Log_Autocracy_Linear, excel append

reg log_gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh, fe vce(cluster country_id)

outreg2 using Log_Autocracy_Linear, excel append

reg log_gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil, fe vce(cluster country_id)

outreg2 using Log_Autocracy_Linear, excel append

reg log_gdppercapita closed_autocracies electoral_autocracies electoral_democracies oilproductiontwh hist_pop_est_mil working_pop, fe vce(cluster country_id)

outreg2 using Log_Autocracy_Linear, excel append


ivregress 2sls gdppercapita (autocracy_level = coup)

ivregress 2sls gdppercapita (autocracy_level = coup religion)
