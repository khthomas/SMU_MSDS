####STATs HW4###
#Question 2B#
setwd("C:\\Users\\kthomas\\Documents\\SMU\\MSDS6371 - Stats\\Unit 4")
logging = read.csv("Logging.csv")
logged = logging$PercentLost[logging$Action == "L"]
unlogged = logging$PercentLost[logging$Action == "U"]
wilcox.test(logged, unlogged, correct = TRUE, exact = FALSE, conf.int = TRUE)

#Question 3D#
EduData = read.csv("EducationData.csv")
t.test(Income2005 ~ Educ, data=EduData, var.equal=FALSE, conf.level = 0.95)

#Question 5B#
yoga = read.csv("yoga2.csv")
wilcox.test(yoga$Before, yoga$After, correct = TRUE, exact = FALSE, conf.int = TRUE, paired = TRUE)

#Question 5E

t.test(yoga$Before,yoga$After, paird=TRUE)
