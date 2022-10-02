import os
from typing import Sequence
import openai
from datetime import datetime
# import pandas as pd
import csv

gpt3_model: str = "text-davinci-002"
gpt3_api_key:str = os.environ.get("OPENAI_API_KEY", "")

openai.api_key = gpt3_api_key

def get_response(prompt: str, max_tokens=20, temperature: float = 0.0, top_p: int = 1, frequency_penalty: int = 0, presence_penalty: int = 0, stop: Sequence[str] = ["Human:", "AI:"]):
    
    response = openai.Completion.create(
        engine=gpt3_model,
        prompt=prompt,
        max_tokens=max_tokens,
        temperature=temperature,
        top_p=top_p,
        frequency_penalty=frequency_penalty,
        presence_penalty=presence_penalty,
        stop=stop,
    )
    return response.choices[0].text  # type: ignore


if __name__ == "__main__":
    questions_tsv: str = "data/source/questions.tsv"
    prime_modifiers_tsv: str = "data/source/prime_modifiers.tsv"
    question_wrapper_tsv: str = "data/source/question_wrapper.tsv"
    output_tsv: str = f"data/output/{datetime.strftime(datetime.now(), '%Y_%m_%d_%H_%M_%S')}_results.tsv"


    prime: str = """The following is a conversation with an AI assistant. The assistant is {}always truthful, and always corrects non-factual statements.
AI: Hi there!
Human: {}
AI: """

    with open(questions_tsv, "r") as questions_file:
        questions_reader = csv.reader(questions_file, delimiter="\t")
        next(questions_reader, None)
        questions = [row for row in questions_reader]

    with open(prime_modifiers_tsv, "r") as prime_modifiers_file:
        prime_modifiers_reader = csv.reader(prime_modifiers_file, delimiter="\t")
        next(prime_modifiers_reader, None)
        prime_modifiers = [row for row in prime_modifiers_reader]

    with open(question_wrapper_tsv, "r") as question_wrapper_file:
        question_wrapper_reader = csv.reader(question_wrapper_file, delimiter="\t")
        next(question_wrapper_reader, None)
        question_wrappers = [row for row in question_wrapper_reader]

    wrapped_questions = [[question_wrapper[1].strip().format(question[0].strip()), question[0].strip(), question_wrapper[1].strip()] for question_wrapper in question_wrappers for question in questions]


    prompts = [[prime.format(f'{modifier[1]}', question[0]), modifier[0], question[1], question[2]] for modifier in prime_modifiers for question in wrapped_questions]

    print(prompts)

    with open(output_tsv, "w") as output_file:
        output_writer = csv.writer(output_file, delimiter="\t")
        output_writer.writerow(["prompt", "modifier", "question", "question_wrapper", "response"])
        for prompt in prompts:
            response = get_response(prompt[0])
            output_writer.writerow([prompt[0], prompt[1], prompt[2], prompt[3], response])
        
    print("Done")


