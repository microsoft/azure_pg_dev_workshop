## Prompt Engineering

The input of a large language model is known as a prompt, while the output is known as a completion. Completion is a term that refers to the model mechanism of generating the next token to complete the current input. In the next few sections, we will dive deep into what is a prompt and how to design it in a way to get the most out of our model. But for now, let us just say that a prompt may include:

    - An instruction: specifying the type of output we expect from the model. This instruction sometimes might embed some examples or some additional data.
    - A question: asked in the form of a conversation with an agent.
      - Text to complete: which implicitly is an ask for writing assistance.
      - Code with Task:
        - A chunk of code + the task of doing something with it such as explaining and documenting it.
        - A comment asking to generate a piece of code performing a specific task.

Outputs of Generative AI models are not perfect and in some cases, the creativity of the model can work against it. When this happens, the resulting output can be a combination of words that the human user can interpret as a mystification of reality, or even offensive.

Generative AI is not intelligent per se. When compared to the more comprehensive definition of intelligence, including critical and creative reasoning or emotional intelligence; it is not deterministic, and it should not be considered trustworthy, since fabrications, such as erroneous references, content, and statements, may be combined with correct information, and presented persuasively and confidently. Prompt engineering is a method designed to deal with some of these limitations, or at least mitigate them a bit. The idea is to provide enough context for a prompt to ensure the responses required.

Check out the YouTube video [AI in a Minute: Prompt Engineering](https://youtu.be/vGdyePbGNaE) - What it means, how to apply it.

### What is a prompt

Prompts have now become the primary programming interface for generative AI apps. Prompts tell the models what to do and influence the quality of returned responses. How a prompt is written matters greatly to the LLM, a carefully crafted prompt can achieve a better result than one that is not.

Users can now interact with models using familiar paradigms like chat, without needing any technical expertise or training. Most of these models are prompt-based. They send a text input (prompt) and get back the AI response (completion). They can then "chat with the AI" iteratively, in multi-turn conversations, refining their prompt till the response matches their expectations.

### What is prompt engineering

Prompt Engineering is a fast-growing field of study that focuses on the design and optimization of prompts to deliver consistent and quality responses at scale.

Prompt engineering is currently more art than science. The best way to improve our intuition for it is to practice more and adopt a trial-and-error approach that combines application domain expertise with recommended techniques and model-specific optimizations.

We can think of Prompt Engineering as a 2-step process:

- Designing the initial prompt for a given model and objective
- Refining the prompt iteratively to improve the quality of the response

This is a trial-and-error process that requires user intuition and effort to get optimal results.

So why do we need prompt engineering? The answer lies in the fact that current LLMs pose a number of challenges that make reliable and consistent completions more challenging to achieve without putting effort into prompt construction and optimization. For instance:

- Model responses are stochastic. The same prompt will produce different responses with different models or model versions. And it may even produce different results with the same model at different times. Prompt engineering techniques can help us minimize these variations by providing better guardrails.

- Models can fabricate responses. Models are pre-trained with large but finite datasets, meaning they lack knowledge about concepts outside that training scope. As a result, they can produce completions that are inaccurate, imaginary, or directly contradictory to known facts. Prompt engineering techniques help users identify and mitigate such fabrications e.g., by asking AI for citations or reasoning.

- Models capabilities will vary. Newer models or model generations will have richer capabilities but also bring unique quirks and tradeoffs in cost & complexity. Prompt engineering can help us develop best practices and workflows that abstract away differences and adapt to model-specific requirements in scalable, seamless ways.

Let us see this in action in the OpenAI or Azure OpenAI Playground:

- Use the same prompt with different LLM deployments (e.g, OpenAI, Azure OpenAI, Hugging Face) - were there variations?
- Use the same prompt repeatedly with the same LLM deployment (e.g., Azure OpenAI playground) - how did these variations differ?

### Anatomy of a prompt

So why is prompt engineering important? To answer that question, we first need to understand three concepts:

- **Tokenization** = how the model "sees" the prompt
- **Base LLMs** = how the foundation model "processes" a prompt
- **Instruction-Tuned LLMs** = how the model can now see "tasks"

### Tokenization

An LLM sees prompts as a sequence of tokens where different models (or versions of a model) can tokenize the same prompt in different ways. Since LLMs are trained on tokens (and not on raw text), the way prompts get tokenized has a direct impact on the quality of the generated response.

To get an intuition for how tokenization works, try tools like the [OpenAI Tokenizer](https://platform.openai.com/tokenizer?WT.mc_id=academic-105485-koreyst). This tool allows a prompt to be analyzed to see how it gets converted into tokens. It is worth paying attention to how whitespace characters and punctuation marks are handled. Each model and version of a model will generate different results.

Once a prompt is tokenized, the primary function of the Foundation model is to predict the token in that sequence. Since LLMs are trained on massive text datasets, they have a good sense of the statistical relationships between tokens and can make that prediction with some confidence. Note that they do not understand the meaning of the words in the prompt or token; they just see a pattern they can "complete" with their next prediction. They can continue predicting the sequence till terminated by user intervention or some pre-established condition.

Want to see how prompt-based completion works? Enter a prompt into the [Azure OpenAI Studio Chat Playground](https://oai.azure.com/playground?WT.mc_id=academic-105485-koreyst) with the default settings. The system is configured to treat prompts as requests for information and any requests will generate a completion that satisfies this context.

But what if the user wanted to see something specific that met some criteria or task objective? This is where instruction-tuned LLMs come into the picture.

### Instruction Tuned LLMs

An Instruction Tuned LLM starts with the foundation model and fine-tunes it with examples or input/output pairs (e.g., multi-turn "messages") that can contain clear instructions - and the response from the AI attempts to follow that instruction.

This uses techniques like Reinforcement Learning with Human Feedback (RLHF) that can train the model to follow instructions and learn from feedback so that it produces responses that are better suited to practical applications and more relevant to user objectives.

### Prompt Construction

We've seen why prompt engineering is important - now let us understand how prompts are constructed so we can evaluate different techniques for more effective prompt design.

- Basic prompt - A text input sent to the model with no other context.
- Complex prompt -  A collection of messages with input/output pairs reflecting user input and assistant response along with system message setting the context for assistant behavior or personality.
- Instruction prompt - Using extra text to specify a task output in more detail, providing better guidance to the AI. For example, asking for a response in JSON.

### Primary Content

In the above examples, the prompt is open-ended, allowing the LLM to decide what part of its pre-trained dataset is relevant. With the primary content design pattern, the input text is divided into two parts:

- An instruction (action)
- Relevant content (that influences action)

The primary content segment can be used in various ways to drive more effective instructions:

- Examples - instead of telling the model what to do with an explicit instruction, give it examples of what to do and let it infer the pattern.
- Cues - follow the instruction with a "cue" that primes the completion, guiding the model towards more relevant responses.
- Templates - these are repeatable 'recipes' for prompts with placeholders (variables) that can be customized with data for specific use cases.

### Prompt Cues

Another technique for using primary content is to provide cues rather than examples. In this case, we are giving the model a nudge in the right direction by starting it off with a snippet that reflects the desired response format. The model then "takes the cue" to continue in that vein.

### Prompt Templates

A prompt template is a pre-defined recipe for a prompt that can be stored and reused as needed, to drive more consistent user experiences at scale. In its simplest form, it is simply a collection of prompt examples like [this one](https://platform.openai.com/examples?WT.mc_id=academic-105485-koreyst) from OpenAI that provides both the interactive prompt components (user and system messages) and the API-driven request format - to support reuse.

In its more complex form like [this example](https://python.langchain.com/docs/modules/model_io/prompts/prompt_templates/?WT.mc_id=academic-105485-koreyst) from LangChain it contains placeholders that can be replaced with data from a variety of sources (user input, system context, external data sources etc.) to generate a prompt dynamically. This allows us to create a library of reusable prompts that can be used to drive consistent user experiences programmatically at scale.

Finally, the real value of templates lies in the ability to create and publish prompt libraries for vertical application domains - where the prompt template is now optimized to reflect application-specific context or examples that make the responses more relevant and accurate for the targeted user audience. The [Prompts For Edu](https://github.com/microsoft/prompts-for-edu?WT.mc_id=academic-105485-koreyst) repository is a fantastic example of this approach, curating a library of prompts for the education domain with emphasis on key objectives like lesson planning, curriculum design, student tutoring etc.

### Prompting Techniques

Prompting is an emergent property of an LLM meaning that this is not a feature that is built into the model but rather something we discover as we use the model.

There are some basic techniques that we can use to prompt an LLM. Let us explore them.

- Few shot prompting, this is the most basic form of prompting. It is a single prompt with a few examples.
- Chain-of-thought, this type of prompting tells the LLM how to break down a problem into steps.
- Generated knowledge, to improve the response of a prompt, provide generated facts or knowledge to the prompt.
- Least to most, like chain-of-thought, this technique is about breaking down a problem into a series of steps and then ask these steps to be performed in order.
- Self-refine, this technique is about critiquing the LLM's output and then asking it to improve.
- Maieutic prompting. To ensure the LLM answer is correct, ask it to explain various parts of the answer. This is a form of self-refinement.

### Few-shot prompting

Pre-trained LLMs work very well on generalized natural language tasks, even by calling them with a short prompt. However, the more the user can frame their query, with a detailed request and examples – the Context – the more accurate and closest to user's expectations the answer will be.

- Zero-shot : a short prompt, like a sentence to complete or a question
- One-shot : the prompt includes only one example
- Few-shot : it includes multiple examples

This style of prompting is very simple, it may consist of a single prompt and possibly a few examples. This technique is probably what most use when starting to learn about LLMs. Here's an example:

- Prompt: "What is Algebra?"
- Answer: "Algebra is a branch of mathematics that studies mathematical symbols and the rules for manipulating these symbols."

### Chain-of-thought

Chain-of-thought is a very interesting technique as it is about taking the LLM through a series of steps. The idea is to instruct the LLM in such a way that it understands how to do something. Applying chain-of-thought means:

- Give the LLM a similar example.
- Show the calculation, and how to calculate it correctly.
- Provide the original prompt.

For example:

- Prompt: "Lisa has 7 apples, throws 1 apple, gives 4 apples to Bart and Bart gives one back: 7 -1 = 6 6 -4 = 2 2 +1 = 3
Alice has 5 apples, throws 3 apples, gives 2 to Bob and Bob gives one back, how many apples does Alice have?" Answer: 1

Note how we write substantially longer prompts with another example, a calculation and then the original prompt and we arrive at the correct answer 1. Chain-of-thought is a very powerful technique.

### Generated Knowledge

Many times the construction of a prompt will include using a company's data. Part of the prompt will be from the company and the other part should be the actual prompt from the user.

### Least to most

The idea with Least-to-most prompting is to break down a bigger problem into subproblems. That way, the LLM has a guide on how to "conquer" the bigger problem.

### Self refine

With generative AIs and LLMs, by default, do not trust the output. Always verify it. After all, the LLM is just presenting what the next most likely thing to say is, not what's correct. Therefore, a good idea is to ask the LLM to critique itself, which leads us to the self-refine technique.

It works by performing the following steps:

- Initial prompt asking the LLM to solve a problem
- LLM answers
- Critique the answer and ask the AI to improve
- LLM answers again, this time considering the critique and suggest solutions it came up with

Repeat this process as many times as necessary.

### Maieutic prompting

Maieutic prompting is a technique that is like self-refine but it is more about asking the LLM to explain itself. The goal is to reduce inconsistencies in the LLM's output to ensure it arrives at the correct answer. The workflow to follow is:

- Ask the LLM to answer a question
- For each part of the answer, ask the LLM to explain it more in-depth.
- If there are inconsistencies, discard the parts that are inconsistent.

Repeat 2 and 3 until all the parts are explained and a satisfying answer is provided.

### Temperature

Ok, so we've decided we want to limit the output to be more predictable, that is more deterministic. How do we do that?

Temperature is a value between 0 and 1, where 0 is the most deterministic and 1 is the most varied. The default value is 0.7.

### Prompt Engineering Best Practices

Now that we know how prompts can be constructed, we can start thinking about how to design them to reflect best practices. We can think about this in two parts:

- Having the right mindset
- Applying the right techniques

Prompt Engineering is a trial-and-error process so keep three broad guiding factors in mind:

- **Domain Understanding Matters**. Response accuracy and relevance are a function of the domain in which that application or user operates. Apply intuition and domain expertise to customize techniques further. For instance, define domain-specific personalities in system prompts, or use domain-specific templates in user prompts. Provide secondary content that reflects domain-specific contexts, or use domain-specific cues and examples to guide the model toward familiar usage patterns.

- **Model Understanding Matters**. We know models are stochastic by nature. But model implementations can also vary in terms of the training dataset they use (pre-trained knowledge), the capabilities they provide (e.g., via API or SDK) and the type of content they are optimized for (e.g, code vs. images vs. text). Understand the strengths and limitations of the model being used, and use that knowledge to prioritize tasks or build customized templates that are optimized for the model's capabilities.

- **Iteration & Validation Matters**. Models are evolving rapidly, and so are the techniques for prompt engineering. As a domain expert, there may be other context or criteria for the specific application, that may not apply to the broader community. Use prompt engineering tools & techniques to "jump start" prompt construction, then iterate and validate the results using intuition and domain expertise. Record insights and create a knowledge base (e.g, prompt libraries) that can be used as a new baseline by others, for faster iterations in the future.

Additionally there are some other good practices to consider when prompting an LLM:

- **Specify context**. Context matters, the more specific and targeted information like domain, topic, etc. the better.
- **Limit the output**. If a specific number of items or a specific length is required, specify it.
Specify both what and how. Remember to mention both the **want** and **how**, for example "Create a Python Web API with routes products and customers, divide it into 3 files".
- **Use templates**. Often, it will be necessary to enrich prompts with private personal or corporate data. Use templates to do this. Templates can have variables that are replaced with actual data.
- **Spell correctly**. LLMs might provide a correct response to a prompt, but if everything is spelled correctly, better responses will be provided.

### AI Best Practices

- **Evaluate the latest models** : New model generations are likely to have improved features and quality - but may also incur higher costs. Evaluate them for impact, then make migration decisions.
- **Separate instructions & context** : Check if the model/provider defines delimiters to distinguish instructions, primary and secondary content more clearly. This can help models assign weights more accurately to tokens.
- **Be specific and clear** : Give more details about the desired context, outcome, length, format, style etc. This will improve both the quality and consistency of responses. Capture recipes in reusable templates.
- **Be descriptive, use examples** : Models may respond better to a "show and tell" approach. Start with a zero-shot approach where an instruction is provided (but no examples) then try few-shot as a refinement, providing a few examples of the desired output. Use analogies.
- **Use cues to jumpstart completions** : Nudge it towards a desired outcome by giving it some leading words or phrases that it can use as a starting point for the response.
- **Double Down** : Sometimes it may be necessary to repeat a prompt to the model. Give instructions before and after the primary content, use an instruction and a cue, etc. Iterate & validate to see what works.
- **Order Matters** : The order in which information is presented to the model may impact the output, even in the learning examples, thanks to recency bias. Try different options to see what works best.
- **Give the model an “out”** : Give the model a fallback completion response it can provide if it cannot complete the task for any reason. This can reduce the chances of models generating false or fabricated responses.

As with any best practice, remember that mileage may vary based on the model, the task and the domain. Use these as a starting point, and iterate to find what works best. Constantly re-evaluate the prompt engineering process as new models and tools become available, with a focus on process scalability and response quality.
