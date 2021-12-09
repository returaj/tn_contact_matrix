load('./input/KAPPA_WORK.RData')

work = read.csv('./survey/work/census_2011.csv')

total_pop = work$PopPerson

main_worker = work$MainPerson

main_percentage = main_worker / total_pop

main_percentage = c(0, main_percentage)

work_contact = KAPPA_WORK$POLYMOD[1:16,1:16] * main_percentage
WORK_CONTACT = list()
WORK_CONTACT[['tn']] = work_contact

save(WORK_CONTACT, file='./output/tn_contact_work.rdata')

