
# Martin R. Vasilev, 2018

rm(list= ls())

load("data/OSFraw_data.Rda")
load("data/OSFdata.Rda")

#raw_data<- raw_data[1:10000,]


# Note: Data always starts at the second word of the first sentence, presumably because the first one has 
# no predictability rating.

# Font is proportion-width Times New Roman

# Empty space is half character before and half character after the word:
df<- data.frame(sub= raw_data$RECORDING_SESSION_LABEL, item= raw_data$trial, seq= raw_data$TRIAL_INDEX,
                xPos= raw_data$CURRENT_FIX_X, 
                yPos= raw_data$CURRENT_FIX_Y,
                x1= rep(NA, nrow(raw_data)),
                x2= rep(NA, nrow(raw_data)),
                y1= rep(NA, nrow(raw_data)),
                y2= rep(NA, nrow(raw_data)),
                fix_num= raw_data$CURRENT_FIX_INDEX,
                fix_dur= raw_data$CURRENT_FIX_DURATION,
                word_text= raw_data$CURRENT_FIX_INTEREST_AREAS,
                word_sent= rep(NA, nrow(raw_data)),
                word_line= rep(NA, nrow(raw_data)),
                line= rep(NA, nrow(raw_data)),
                sent= rep(NA, nrow(raw_data)),
                wordID= raw_data$CURRENT_FIX_INTEREST_AREA_LABEL,
                word_len= rep(NA, nrow(raw_data)),
                predict= rep(NA, nrow(raw_data)),
                blink= raw_data$CURRENT_FIX_BLINK_AROUND)

df$word_text<- as.character(df$word_text)
get_num<- function(string){as.numeric(unlist(gsub("[^0-9]", "", unlist(string)), ""))}
df$word_text<- get_num(df$word_text)

# cmd<- NULL

for(i in 1:nrow(df)){
  a<- which(dat$RECORDING_SESSION_LABEL== df$sub[i] & dat$Text_ID== df$item[i] & dat$Word_Number== df$word_text[i])

  if(length(a)>0){
    
    if(length(a)>1){
      a= a[1]
    }
    df$word_sent[i]<- dat$Word_In_Sentence_Number[a]
    df$sent[i]<- dat$Sentence_Number[a]
    df$word_len[i]<- dat$Word_Length[a]
    #df$wordID[i]<- dat$Word[a]
    df$predict[i]<- dat$OrthographicMatch[a]
    df$x1[i]<- dat$IA_LEFT[a]
    df$x2[i]<- dat$IA_RIGHT[a]
    df$y1[i]<- dat$IA_TOP[a]
    df$y2[i]<- dat$IA_BOTTOM[a]
  }
  
  # if(length(a)>1){
  #   cmd<- c(cmd, i)
  # }
  print(sprintf("%s %s", (round(i/nrow(df),4))*100, "%"))
}

save(df, file= "data/df.Rda")
