library(tidyverse)

gpt_responses_categorized_tsv <- "data/output/2022_10_02_13_26_48_results_categorized.tsv"
gpt_responses_categorized <- read_tsv(gpt_responses_categorized_tsv)

gpt_responses_categorized$modifier <- as.factor(gpt_responses_categorized$modifier)
gpt_responses_categorized$question <- as.factor(gpt_responses_categorized$question)
gpt_responses_categorized$question_wrapper <- as.factor(gpt_responses_categorized$question_wrapper)
gpt_responses_categorized$interaction_type <- as.factor(gpt_responses_categorized$interaction_type)
gpt_responses_categorized$gtp3_model <- as.factor(gpt_responses_categorized$gtp3_model)
gpt_responses_categorized$response_type <- as.factor(gpt_responses_categorized$response_type)

# plot overall response type distribution
gpt_responses_categorized %>%
  ggplot(aes(x = response_type)) +
  geom_bar() +
  labs(
    title = "Overall response type distribution",
    x = "Response type",
    y = "Count"
  )

# plot response type distribution by modifier

gpt_responses_categorized %>%
  ggplot(aes(x = response_type, fill = modifier)) +
  geom_bar() +
  labs(
    title = "Response type distribution by modifier",
    x = "Response type",
    y = "Count"
  )


# plot response type distribution by modifier

gpt_responses_categorized %>%
  ggplot(aes(x = modifier, fill = response_type)) +
  geom_bar(position="dodge") +
  labs(
    title = "Response type distribution by modifier",
    x = "Response type",
    y = "Count"
  )

# plot to compare response types for "null" and "truthful" modifiers

gpt_responses_categorized %>%
  filter(modifier %in% c("null", "truthful")) %>%
  ggplot(aes(x = response_type, fill = modifier)) +
  geom_bar(position="dodge") +
  labs(
    title = "Null vs truthful response type distribution",
    x = "Modifier",
    y = "Count"
  )

# save plot as png
ggsave("data/output/null_vs_truthful_response_type_distribution.png")

# plot to compare response types for "truthful" and "agreeable" modifiers

gpt_responses_categorized %>%
  filter(modifier %in% c("truthful", "agreeable")) %>%
  ggplot(aes(x = response_type, fill = modifier)) +
  geom_bar(position="dodge") +
  labs(
    title = "Truthful vs Truthful + agreeable response type distribution",
    x = "Modifier",
    y = "Count"
  )

# save plot as png
ggsave("data/output/truthful_vs_truthful_agreeable_response_type_distribution.png")


# plot to compare response types for "truthful" and "friendly" modifiers

gpt_responses_categorized %>%
  filter(modifier %in% c("truthful", "friendly")) %>%
  ggplot(aes(x = response_type, fill = modifier)) +
  geom_bar(position="dodge") +
  labs(
    title = "Truthful vs Truthful + friendly response type distribution",
    x = "Modifier",
    y = "Count"
  )

# save plot as png
ggsave("data/output/truthful_vs_truthful_friendly_response_type_distribution.png")
