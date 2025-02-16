# This does XXXXX
# Code developed by Vera Choo, with reference from: XXXX

library(shiny)
library(dplyr)
library(skimr)
library(tidyr)
library(ggplot2)
library(plotly)
library(rsconnect)
setwd("C:/Users/Vera/Desktop/FALL 2019/TRIP/WEB/SURVEYS")
#setwd("C:/Users/ejparajon/Google Drive/TRIP/Database Management/Shiny App material/Faculty Survey App/CSVs")
fac04<-read.csv("FS2004.csv",stringsAsFactors=TRUE,na.strings="")
fac06<-read.csv("FS2006.csv",stringsAsFactors=TRUE,na.strings="")
fac08<-read.csv("FS2008.csv",stringsAsFactors=TRUE,na.strings="")
fac11<-read.csv("Faculty Survey 4 Wave Data 1.0.csv",stringsAsFactors=TRUE,na.strings="")
fac14<-read.csv("TRIP_FacultySurvey_2014_Full_2.0.1.csv",stringsAsFactors=TRUE,na.strings="")
fac17<-read.csv("TRIP_FacultySurvey_2017_Intl_Clean_1.1_new.csv",stringsAsFactors=TRUE,encoding="UTF-8",na.strings="")
#fac17_cb<-read.csv("TRIP_FacultySurvey_2017_Codebook.csv",stringsAsFactors=TRUE,na.strings="")

# create codebook #
qid_overtime<-read.csv("FacultySurvey_QIDovertime.csv",stringsAsFactors=FALSE,na.strings="")
qid_overtime$qid_all<-""
qid_overtime$qid_all[qid_overtime$`2004`!="" & qid_overtime$`2006`!="" & qid_overtime$`2008`!="" & qid_overtime$`2011`!="" & qid_overtime$`2014`!="" & qid_overtime$`2017`!=""]<-"ref"
names(qid_overtime)[4:9]<-c("2004","2006","2008","2011","2014","2017")
qid_overtime$Question_text<-gsub("\n"," ",qid_overtime$Question_text)
qid_overtime$Question_text<-trimws(qid_overtime$Question_text)
qid_overtime<-qid_overtime[,c(2,4:9)]
qid_all<-qid_overtime[,c(1:7)][qid_overtime$`2004`!="" & qid_overtime$`2006`!="" & qid_overtime$`2008`!="" & qid_overtime$`2011`!="" & qid_overtime$`2014`!="" & qid_overtime$`2017`!="",]
#qid_2004<-qid_overtime[,c(1:3)] %>% filter(2004!="")
#qid_2006<-qid_overtime[,c(1,2,4)] %>% filter(2006!="")
#qid_2008<-qid_overtime[,c(1,2,5)] %>% filter(2008!="")
#qid_2011<-qid_overtime[,c(1,2,6)] %>% filter(2011!="")
#qid_2014<-qid_overtime[,c(1,2,7)] %>% filter(2014!="")
#qid_2017<-qid_overtime[,c(1,2,8)] %>% filter(2017!="")

#qid_list<-list("qid_all"=qid_all, "qid_2004"=qid_2004,"qid_2006"=qid_2006,"qid_2008"=qid_2008,"qid_2011"=qid_2011,"qid_2014"=qid_2014,"qid_2017"=qid_2017,"qid_questions"=qid_questions)
#lapply(1:length(qid_list), function(i) write.csv(qid_list[[i]], file = paste0(names(qid_list[i]), ".csv"), row.names = FALSE))
#list<-lapply(1:7, function(i) noquote(paste0(qid_list[[i]][,3],collapse=",")))

# new datasets #
#fac04<-fac11 %>% filter(surveyYear==2004) %>% select(surveyCountry,fsqg_99,fsqg_108,fsqg_1139,fsqg_100,fsqg_737,fsqg_87_459:fsqg_87_465,fsqg_318_1837:fsqg_318_123129,fsqg_320,fsqg_1242_122629:fsqg_1242_122631,fsqg_1243_122632:fsqg_1243_122634,fsqg_59,fsqg_69_331:fsqg_69_339,fsqg_793,fsqg_88,fsqg_83,fsqg_706,fsqg_1238_122608:fsqg_1238_122613,fsqg_1090,fsqg_57,fsqg_84,fsqg_85_447:fsqg_85_455,fsqg_86,fsqg_1122_3555:fsqg_1122_3559,fsqg_66_5409:fsqg_66_5413,fsqg_1153_4940:fsqg_1153_4989,fsqg_1091_3437:fsqg_1091_3440,fsqg_1092_683:fsqg_1092_686,contains("fsqg_1093"),fsqg_39,fsqg_316_123058:fsqg_316_123086,fsqg_707,fsqg_708_400:fsqg_708_6067,fsqg_80,fsqg_81_427:fsqg_81_6080,fsqg_1,fsqg_2_1950,fsqg_6_38:fsqg_6_123128,fsqg_848_22:fsqg_848_5559,fsqg_7,fsqg_1043,fsqg_8,fsqg_819,fsqg_117,fsqg_327_1951:fsqg_327_1955,fsqg_1235_122596:fsqg_1235_122598,fsqg_13,fsqg_1236_122599:fsqg_1236_122601,fsqg_327_1951:fsqg_327_1955,fsqg_10,fsqg_1237_122602:fsqg_1237_122607)

#fac06<-fac11 %>% filter(surveyYear==2006) %>% select(respondentBirthYear,respondentGender,surveyCountry,fsqg_29,fsqg_180,fsqg_181,fsqg_1233_122567,fsqg_1234_122582:fsqg_1234_122595,fsqg_108,fsqg_1139,fsqg_647,fsqg_100,fsqg_178,fsqg_179_1042:fsqg_179_3951,contains("fsqg_1227"),contains("fsqg_1261"),fsqg_318_1837:fsqg_318_123129,fsqg_320,fsqg_1227_122510:fsqg_1227_122515,fsqg_1016_743:fsqg_1016_6264,fsqg_793,fsqg_88,fsqg_83,fsqg_706,fsqg_172,fsqg_173,fsqg_174_998:fsqg_174_1007,fsqg_144_737:fsqg_144_741,fsqg_1122_3555:fsqg_1122_3559,fsqg_1121_5484:fsqg_1121_5488,fsqg_1153_4940:fsqg_1153_4989,fsqg_1091_3437:fsqg_1091_3440,fsqg_1092_683:fsqg_1092_686,fsqg_1095_695:fsqg_1095_698,contains("fsqg_1093"),fsqg_39,fsqg_316_123058:fsqg_316_123086,fsqg_707,fsqg_708_400:fsqg_708_6067,fsqg_80,fsqg_81_427:fsqg_81_6080,fsqg_6_38:fsqg_6_123128,fsqg_1040_1917,fsqg_848_22:fsqg_848_5559,fsqg_1043,fsqg_31_175,fsqg_1044_176,fsqg_117,fsqg_122_629:fsqg_122_632,fsqg_13,fsqg_1225_122501:fsqg_1225_122503,fsqg_122_629:fsqg_122_632)

#fac08<-fac11 %>% filter(surveyYear==2008) %>% select(respondentBirthYear,respondentGender,surveyCountry,fsqg_29,fsqg_635,fsqg_180,fsqg_181,fsqg_1251_122693:fsqg_1251_122711,fsqg_1252_122712:fsqg_1252_122729,fsqg_1141,fsqg_1144,fsqg_108,fsqg_1139,fsqg_647,fsqg_100,fsqg_668,fsqg_178,fsqg_179_1042:fsqg_179_3951,fsqg_714_3952:fsqg_714_5701,fsqg_1248_122672:fsqg_1248_122678,fsqg_1248_122672:fsqg_1248_122678,fsqg_1247_122655:fsqg_1247_122671,fsqg_1016_743:fsqg_1016_6264,fsqg_793,fsqg_88,fsqg_83,fsqg_706,fsqg_1071,fsqg_1090,fsqg_1070,fsqg_1123_5467:fsqg_1123_5471,fsqg_1122_3555:fsqg_1122_3559,fsqg_1121_5484:fsqg_1121_5488,fsqg_1153_4940:fsqg_1153_4989,fsqg_1091_3437:fsqg_1091_3440,fsqg_1092_683:fsqg_1092_686,fsqg_1109_5807:fsqg_1109_5810,fsqg_1095_695:fsqg_1095_698,contains("fsqg_1093"),fsqg_39,fsqg_794,fsqg_1068,fsqg_707,fsqg_708_400:fsqg_708_6067,fsqg_80,fsqg_81_427:fsqg_81_6080,fsqg_663,fsqg_6_38:fsqg_6_123128,fsqg_1040_1917,fsqg_848_22:fsqg_848_5559,fsqg_1043,fsqg_819,fsqg_1045_5569,fsqg_1244_122635:fsqg_1244_122638,fsqg_1245_122639:fsqg_1245_122646)

#fac11<-fac11 %>% filter(surveyYear==2011) %>% select(respondentBirthYear,respondentGender,surveyCountry,fsqg_29,fsqg_635,fsqg_949,fsqg_180,fsqg_181,fsqg_879_4838:fsqg_879_4866,fsqg_808_4472:fsqg_1252_122730,fsqg_1144,fsqg_668,fsqg_737,fsqg_178,fsqg_179_1042:fsqg_179_3951,fsqg_714_3952:fsqg_714_5701,fsqg_621,fsqg_626,fsqg_1016_743:fsqg_1016_6264,fsqg_795,fsqg_793,fsqg_88,fsqg_83,fsqg_706,fsqg_992,fsqg_84,fsqg_1123_5467:fsqg_1123_5471,fsqg_1122_3555:fsqg_1122_3559,fsqg_1121_5484:fsqg_1121_5488,fsqg_1153_4940:fsqg_1153_4989,fsqg_1091_3437:fsqg_1091_3440,contains("fsqg_1272"),contains("fsqg_1017"),fsqg_630_3441:fsqg_630_3444,contains("fsqg_1256"),contains("fsqg_1257"),fsqg_39,fsqg_794,fsqg_707,fsqg_708_400:fsqg_708_6067,fsqg_80,fsqg_81_427:fsqg_81_6080,fsqg_663,fsqg_784_4244:fsqg_784_4247,fsqg_644,fsqg_848_22:fsqg_848_5559,fsqg_643_3524:fsqg_643_3539,fsqg_1044_176,fsqg_624,fsqg_852,fsqg_833,fsqg_834,fsqg_835,fsqg_639,fsqg_701,fsqg_1320,fsqg_1264_122851:fsqg_1264_122858)

#fac14<-fac14 %>% select(surveyCountry,qg_231_1891,qg_99,qg_427_3218:qg_427_3229_other,qg_230,qg_92,qg_408_3073,qg_113,qg_113,qg_241,qg_105,qg_153_1487:qg_153_4082,qg_151_1517:qg_151_4083,qg_171_1523,qg_263_2143,qg_271,qg_142,qg_131,qg_104,qg_146_1146:qg_146_1169,qg_399_3020:qg_399_3019,qg_507,qg_508,qg_509_4182:qg_509_4188,qg_510_4190:qg_510_4197_other,qg_159_644:qg_159_642,qg_154_686:qg_154_684,qg_470,qg_260,qg_127,qg_97,qg_95,qg_117,qg_102,qg_103,qg_145_1074:qg_145_1079,qg_423,qg_158_633:qg_158_629,qg_184_1424:qg_184_1427,qg_183_693:qg_183_697,qg_182_669:qg_182_673,qg_185_674:qg_185_677,contains("qg_388"),contains("qg_236"),contains("qg_188"),contains("qg_235"),qg_93,qg_141,qg_118,qg_149_892:qg_149_2985,qg_89,qg_144_3216:qg_144_1041,qg_221_1834:qg_221_1835,qg_221_1838:qg_221_3974,qg_115,qg_139,qg_111,qg_398_3001:qg_398_3010,qg_243,qg_256_2071:qg_256_2082,qg_429,qg_430,qg_255_2057:qg_255_4051,qg_479_3987,qg_479_3989,qg_479_3991)

#fac17<-fac17 %>% select(birth_year,gender,contact_group,qg_230,qg_92,qg_112b,Q102_1,Q102_2,Q102_3,Q102_4,Q102_5,Q102_6,Q102_7,Q102_8,Q102_9:Q102_11_TEXT,qg_105,Q105,qg_153,qg_151,qg_171_1,qg_263_1,Q143_1,qg_271,Q4492,qg_104,qg_146,qg_154,qg_470,qg_260,Q10,qg_97,qg_95,qg_117,qg_117a,qg_117b,qg_117c,Q298_1:Q298_5,qg_183_1:qg_183_5,qg_182_1:qg_182_5,qg_185_1:qg_185_4,contains("Q291"),contains("qg_235"),qg_93,qg_118,qg_149,qg_89,qg_144,contains("Q101"),qg_139,qg_243)


new_surveys<-list("FS2004"=fac04,"FS2006"=fac06,"FS2008"=fac08,"FS2011"=fac11,"FS2014"=fac14,"FS2017"=fac17)

#lapply(1:6, function(i) write.csv(new_surveys[[i]], file = paste0(names(new_surveys[i]), ".csv"), row.names = FALSE))


z<-data.frame(snap[[10]] %>% select(response=qg_153))
z<-data.frame(response=unlist(strsplit(as.character(z$response), ",")))
z<-z %>% group_by(response) %>% drop_na() %>% summarize(n=n()) %>% mutate(per=round(n/sum(n)*100,2), year=2017) %>% drop_na() %>% top_n(8,per)
z<-rbind(z[1:8,],z[1:8,])


















