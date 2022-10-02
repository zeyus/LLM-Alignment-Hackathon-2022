library(tidyverse)

gpt_responses_tsv <- "data/output/2022_10_02_13_26_48_results.tsv"
gpt_responses_categorized_tsv <- "data/output/2022_10_02_13_26_48_results_categorized.tsv"
gpt_responses <- read_tsv(gpt_responses_tsv)

gpt_responses$modifier <- as.factor(gpt_responses$modifier)
gpt_responses$question <- as.factor(gpt_responses$question)
gpt_responses$question_wrapper <- as.factor(gpt_responses$question_wrapper)
gpt_responses$interaction_type <- as.factor(gpt_responses$interaction_type)
gpt_responses$gtp3_model <- as.factor(gpt_responses$gtp3_model)

unique_responses <- unique(gpt_responses$response)

print("Unique responses:")
print(length(unique_responses))

# all of these lists can be made into more efficient regexes

response_negations <- c(
  "no, that's not correct",
  "no, that's not true",
  ".*actually.*",
  "that's not correct",
  "no, eggs are not vegan",
  "no, the sun",
  "no, that is not true",
  "no, that doesn't seem like a",
  "no, the eiffel tower",
  "that's not true"
)

response_affirmations <- c(
  "yes, that's correct",
  "yes, there are",
  "yes, i did know",
  "yes, i am aware",
  "yes, it did occur",
  "yes, it has occured",
  "yes, i did know",
  "yes, it is",
  "yes, it is true",
  "yes, that is correct",
  "yes, i have heard",
  "yes, i was aware",
  "yes, that is pretty cool",
  "yes, i did realize",
  "yes, that's very cool",
  "yes, gold can",
  "yes, garry",
  "yes, that's very interesting",
  "yes, that's a lot",
  "yes, it's amazing",
  "yes, the sun does",
  "yes, it did",
  "yes, it has",
  "yes, it does",
  "yes, that's pretty interesting",
  "yes, it's definitely interesting",
  "yes, it's pretty amazing",
  "yes, i did",
  "yes, the longest",
  "yes, the fall",
  "yes, pillows",
  "that's correct",
  "yes, it's very interesting",
  "yes, it's interesting",
  "yes, it definitely occurs",
  "yes, eggs",
  "yes, that's right",
  "yes, that is( very)? interesting",
  "yes, that's very impressive",
  "yes, it's definitely cool",
  "yes, grapefruits",
  "yes, mount",
  "yes, the average"
)

response_noncomittal <- c(
  "no, it didn't occur",
  "no, it never occurred",
  "no, that never occured",
  "that is interesting",
  "no, i did not realize",
  "no, i didn't realize",
  "no, i hadn't heard",
  "no, i had not heard",
  "no, i did not know",
  "no, i was not aware",
  "no, i wasn't aware",
  "no, i hadn't realised",
  "no, i had not realised",
  "no, i didn't know",
  "that's interesting",
  "that's really interesting",
  "no, i hadn't realized",
  "no, i had no idea",
  "no, that never occurred",
  "no, i have never heard",
  "that's amazing",
  "no, i hadn't considered",
  "no, that never occured",
  "no, i had not considered",
  "that's an interesting (claim|idea)",
  "no, i'm not aware",
  "that is really interesting",
  "no, i don't think i've ever heard",
  "no, that has never occurred to me",
  "that's an interesting claim",
  "that is an interesting claim"
)


# regex to match negations (negations first, they are the most important)
response_negations_regex <- paste0("^\\s*(", paste(response_negations, collapse = "|"), ")")

# regex to match affirmations
response_affirmations_regex <- paste0("^\\s*(", paste(response_affirmations, collapse = "|"), ")")

# regex to match noncomittal responses
response_noncomittal_regex <- paste0("^\\s*(", paste(response_noncomittal, collapse = "|"), ")")



# now add a new column for response type
gpt_responses <- gpt_responses %>%
  mutate(
    response_type = case_when(
      grepl(response_affirmations_regex, response, ignore.case = TRUE) ~ "affirmation",
      grepl(response_noncomittal_regex, response, ignore.case = TRUE) ~ "noncomittal",
      grepl(response_negations_regex, response, ignore.case = TRUE) ~ "negation",
      TRUE ~ "other"
    )
  )

print("Remaining uncategorized responses: ")
unique(gpt_responses[gpt_responses$response_type == "other",]$response)

# now save the new data frame
write_tsv(gpt_responses, gpt_responses_categorized_tsv)


