
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

# load text coordinates (from Tim):
load("corpus/text_coords.Rda")
coords<- text_coords; rm(text_coords)
colnames(coords)<- c("item", "word_text", "word_ID", "word_line", "line", "x1", "x2", "y1", "y2")


line1<- c(70, 154)
line2<- c(155, 246)
line3<- c(247, 338)
line4<- c(339, 422)

for(i in 1:nrow(df)){
  #a<- which(dat$RECORDING_SESSION_LABEL== df$sub[i] & dat$Text_ID== df$item[i] & dat$Word_Number== df$word_text[i])
  a<- which(dat$Text_ID== df$item[i] & dat$Word_Number== df$word_text[i])
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
  
  ### Lines:
  b<- which(coords$item== df$item[i] & coords$x1== df$x1[i]& coords$x2== df$x2[i] & coords$y1== df$y1[i] & coords$y2== df$y2[i])
  
  if(length(b)>0){
    df$line[i]<- coords$line[b]
    df$word_line[i]<- coords$word_line[b]
  }
  
  
  # if(length(a)>1){
  #   cmd<- c(cmd, i)
  # }
  if(i%%1000==0){
    print(sprintf("%s %s", (round(i/nrow(df),4))*100, "%"))
  }
  
  
}
save(df, file= "data/df.Rda")


df$line[which(is.na(df$line)& df$yPos>= line1[1] & df$yPos<= line1[2])]<- 1
df$line[which(is.na(df$line)& df$yPos>= line2[1] & df$yPos<= line2[2])]<- 2
df$line[which(is.na(df$line)& df$yPos>= line3[1] & df$yPos<= line3[2])]<- 3
df$line[which(is.na(df$line)& df$yPos>= line4[1] & df$yPos<= line4[2])]<- 4

save(df, file= "data/df.Rda")


load("data/df.Rda")

df$VA<- 0.33


#########
# map return_sweep stuff:



new<- NULL
nsubs<- unique(df$sub)

for(i in 1:length(nsubs)){
  n<- subset(df, sub== nsubs[i])
  nitems<- unique(n$item)
  
  for(j in 1:length(nitems)){
    m<- subset(n, item== nitems[j])
    
    curr_line<- 1
    
    m$Rtn_sweep<- NA
    m$Rtn_sweep_type<- NA
    
    m$prevX<- NA
    m$nextX<- NA
    
    for(k in 1:nrow(m)){
      if(k>1& k< nrow(m)){
        
        if(is.na(m$line[k])){
          next
        }
        
        if(curr_line< m$line[k]){
          m$Rtn_sweep[k]<- 1
          curr_line<- curr_line+1
          
          if(m$xPos[k]>m$xPos[k+1]){
            m$Rtn_sweep_type[k]<- "under-sweep"
          }else{
            m$Rtn_sweep_type[k]<- "accurate"
          }
            
        }else{
          m$Rtn_sweep[k]<- 0
        }
        
        
      }else{
        m$Rtn_sweep[k]<- NA
        m$Rtn_sweep_type[k]<- NA
      }
      
      # map previous and next fixation
      if(k>1){
        m$prevX[k]<- m$xPos[k-1]
      }
      
      if(k<nrow(m)){
        m$nextX[k]<- m$xPos[k+1]
      }
      
    } # end of k
    
    new<- rbind(new, m)
  } # end of j
  cat(i); cat(" ")
  
} # end of i

# remove blinks from data

new<- subset(new, blink=="NONE")
new$blink<- NULL


############################################
# Extra code for corr_sacc project:
############################################

# add previous fixation to the data set

new$prev_fix_dur<- NA
new_dat<- NULL

nsubs<- unique(new$sub)

for(i in 1:length(nsubs)){
  cat(i); cat(' ')
  n<- subset(new, sub== nsubs[i])
  
  nitems<- unique(n$item)
  
  for(j in 1:length(nitems)){
    m<- subset(n, item== nitems[j])
    
    for(k in 1:nrow(m)){
      if(k>1){
        m$prev_fix_dur[k]<- m$fix_dur[k-1] 
      }
      
      if(k==1){
        m$prev_fix_dur[k]<-NA
      }
      
    }
    new_dat<- rbind(new_dat, m)
  }
}

new<- new_dat

new_dat<- NULL

# #######################################
# # Calculate character from start of line:
# 
# load("corpus/text_coords.Rda")
# 
# new_dat<- NULL
# 
# new$launch_site<- NA # launch site relative to start of the line:
# new_dat<- NULL
# 
# nsubs<- unique(new$sub)
# 
# for(i in 1:length(nsubs)){
#   cat(i); cat(' ')
#   n<- subset(new, sub== nsubs[i])
#   
#   nitems<- unique(n$item)
#   
#   for(j in 1:length(nitems)){
#     
#     m<- subset(n, item== nitems[j])
#     
#     new_dat<- rbind(new_dat, m)
#     
#   }
#   
# }


###########################################





library(EMreading)
new$wordID<- iconv(new$wordID, "ASCII", "UTF-8", sub="byte")
new<- Frequency(new, database = "SUBTLEX-US")

DPP<- 40/1600 # degree per pixel in the experiment 
# monitor subtended 40 deg and resolution was 1600 pixels

new$LandStartVA<- (new$xPos-171)*DPP
new$prevVA<- (new$prevX-171)*DPP

save(new, file= 'data/provo_all_fix.Rda')


provo<- subset(new, Rtn_sweep==1)
provo$undersweep_prob<- ifelse(provo$Rtn_sweep_type=="under-sweep", 1,0)


save(provo, file= "data/provo.Rda")
write.csv(provo, file= "data/provo.csv")

