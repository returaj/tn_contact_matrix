library(foreign)

# India dataset
print('Loading India Data')
pr_dataset = read.dta('./survey/pr/IAPR74FL.DTA')

# HV024: Region of residence in which the household resides
print('Filtering Tamil Nadu data')
tn = pr_dataset[pr_dataset$hv024 %in% 'tamil nadu', ]

# num of household : 26033
tn_surveyed_household = length(unique(tn$hhid))

# num of individual : 101,108
tn_surveyed_individual = nrow(tn)

# number of individual in a age group 0-5, 6-10, 11-15, ... 95-100
print('create individual age group')
tn_age5 = tabulate((1 + floor(tn$hv105 / 5))) # hv105: individual's age

# create age-age map in a household
print('create age-age map in a household')
unihh = unique(tn$hhid)
age1 = age2 = id1 = id2 = vector("list", length=length(unihh))
for (h in 1:length(unihh)) {
  members = which(tn$hhid == unihh[h])
  num_members = tn$hv009[members[1]] # can also use length(members), here hv009:number of members in houshold
  if (num_members > 1) {
    i1 = rep(1:num_members, num_members)
    i2 = rep(1:num_members, each=num_members)
    ages = tn$hv105[members] # hv105: age of the family member
    a1 = ages[i1]
    a2 = ages[i2]
    age1[[h]] = a1
    age2[[h]] = a2
    id1[[h]] = i1
    id2[[h]] = i2
  }
}
age1 = unlist(age1)
age2 = unlist(age2)
id1 = unlist(id1)
id2 = unlist(id2)

same_mapping_id = which(id1 == id2)
age1 = age1[-same_mapping_id]
age2 = age2[-same_mapping_id]
id1 = id1[-same_mapping_id]
id2 = id2[-same_mapping_id]

# household contact matrix of all the survey individual
print('household contacts of all the individual')
M = matrix(0, 100, 100)
M5 = matrix(0, 20, 20)
for (i in 1:100) {
  for (j in 1:100) {
    M[i, j] = sum((age1 == i) * (age2 == j), na.rm=TRUE)
  }
}

for (i in 1:100) {
  i5 = ceiling(i/5)
  for (j in 1:100) {
    j5 = ceiling(j/5)
    M5[i5, j5] = M5[i5, j5] + M[i, j]
  }
}

# per person age contact
print('per person age contact')
HAM = matrix(0, 20, 20)
for (indiv_age in 1:20) {
  HAM[indiv_age, ] = M5[indiv_age, ] / tn_age5[indiv_age]
}
HAM = HAM[1:16, 1:16]

HAM_INDIA = list()
HAM_INDIA[['tn']] = HAM

load('./input/KAPPA_HOME.RData')
HomeContact = list()
home_contact = KAPPA_HOME$POLYMOD[1:16, 1:16] * HAM_INDIA$tn
HomeContact[['tn']] = home_contact
save(HomeContact, file='./output/tn_contact_home.rdata')





