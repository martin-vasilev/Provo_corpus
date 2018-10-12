
# Martin R. Vasilev, 2018

load("data/OSFraw_data.Rda")

raw_data<- raw_data[1:50,]


# Note: Data always starts at the second word of the first sentence, presumably because the first one has 
# no predictability rating.

df<- data.frame(sub= raw_data$RECORDING_SESSION_LABEL, item= raw_data$trial, seq= raw_data$TRIAL_INDEX,
                xPos= raw_data$CURRENT_FIX_X, 
                yPos= raw_data$CURRENT_FIX_Y, 
                fix_num= raw_data$CURRENT_FIX_INDEX,
                fix_dur= raw_data$CURRENT_FIX_DURATION,
                word= raw_data$CURRENT_FIX_INTEREST_AREAS,
                wordID= raw_data$CURRENT_FIX_INTEREST_AREA_LABEL,
                blink= raw_data$CURRENT_FIX_BLINK_AROUND)


r$ppl<- NA
for(i in 1:nrow(r)){
  r$ppl[i]<- (r$IA_RIGHT[i]- r$IA_LEFT[i])/nchar(r$IA_LABEL[i])
}