load('input/schoolage.rdata')
load('input/KAPPA_SCHOOL.RData')

schoolpop = as.numeric(school[school$iso %in% 'IND',grep(pattern = 'age',x = colnames(school))])

SCHOOL_CONTACT = list()
SCHOOL_CONTACT[['tn']] = KAPPA_SCHOOL$POLYMOD[1:16, 1:16] * schoolpop
save(SCHOOL_CONTACT, file='./output/tn_contact_school.rdata')

