# transform data from MTurk from JSON format to csv

kind.dict <- data.frame(
  kind_label = c("Fep", "Dax", "Blicket"),
  kind_type = c("bird", "flower", "artifact")
)

data.paths <- c("~/projects/genex-master/results/gen_example/")
# data.paths <- c("~/projects/genex/mturk/genex-labeled-1/production-results/")

df.subject <- data.frame()
df.trials <- data.frame()
df.attention <- data.frame()
for (data.path in data.paths){
  result.files <- list.files(data.path, pattern="json")
  
  expt.id <- match(data.path, data.paths)
  for (result_file in result.files) {
    result_json = fromJSON(paste(data.path, result_file, sep ="/"))
    worker.id = result_json$WorkerId
    condition = result_json$answers$condition
    
    df.attention = bind_rows(
      df.attention, 
      data.frame(result_json$answers$sound_check) %>%
        mutate(exptid = expt.id,
               workerid = worker.id)
    )
    
    df.subject = bind_rows(
      df.subject, 
      data.frame(result_json$answers$subject_information) %>% 
        mutate(
          exptid = expt.id,
          workerid = worker.id,
          language = gsub("\"", "", language),
          enjoyment = gsub("\"", "", enjoyment),
          age = gsub("\"", "", age),
          gender = gsub("\"", "", gender),
          problems = gsub("\"", "", problems),
          comments = gsub("\"", "", comments)
        ) 
    )
    
    data.worker <- data.frame(result_json$answers$trials)
    d.condition <- data.frame(result_json$answers$condition)
    names(d.condition) <- "condition"
    
    if (d.condition$condition == "generic") {
      data.worker %>%
        select(type, singular, featureSingular, response) %>%
        mutate(correctId = NA) %>%
        bind_rows(., 
                  data.worker %>%
                    select(type, singular, featureSingular, response) %>%
                    mutate(response = NA, correctId = T,type = 'id')) -> data.worker
      
    }
    
    df.trials = bind_rows(
      df.trials, 
      data.worker %>%
        select(type, singular, featureSingular, response, correctId) %>%
        mutate(response = ifelse(is.na(response), correctId, response),
               featureSingular = ifelse(is.na(featureSingular), "squeaks", featureSingular),
               number = 1) %>%
        select(-correctId) %>%
        rename(trial_type = type, kind_label = singular, feature_label = featureSingular) %>%
        group_by(trial_type) %>%
        mutate(trial_num = cumsum(number)) %>%
        left_join(., kind.dict) %>%
        mutate(exptid = expt.id,
               workerid = worker.id,
               condition = d.condition$condition) %>%
        select(workerid, exptid, condition, trial_type, trial_num, kind_type, kind_label, feature_label, response)
    )
  }
}

# write_csv(df.trials, "../data/expt1/genex-cogsci_expt1-trials.csv")
# write_csv(df.subject, "../data/expt1/genex-cogsci_expt1-participant_information.csv")
# write_csv(df.attention, "../data/expt1/genex-cogsci_expt1-sound_check.csv")

# write_csv(df.trials, "../data/expt2/genex-cogsci_expt2-trials.csv")
# write_csv(df.subject, "../data/expt2/genex-cogsci_expt2-participant_information.csv")
# write_csv(df.attention, "../data/expt2/genex-cogsci_expt2-sound_check.csv")