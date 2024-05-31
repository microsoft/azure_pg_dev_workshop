## Types of AI Applications

## Standard Patterns

### RAG

Retrieval Augmented Generation, RAG. Data might exist in a database or web endpoint for example, to ensure this data, or a subset of it, is included at the time of prompting, the relevant data can be fetched and made part of the user's prompt.

LLMs have the limitation that they can use only the data that has been used during their training to generate an answer. This means that they do not know anything about the facts that happened after their training process, and they cannot access non-public information (like company data). This can be overcome through RAG, a technique that augments prompt with external data in the form of chunks of documents, considering prompt length limits. This is supported by Vector database tools (like Azure Vector Search) that retrieve the useful chunks from varied pre-defined data sources and add them to the prompt Context.

This technique is very helpful when a business does not have enough data, enough time, or resources to fine-tune an LLM, but still wishes to improve performance on a specific workload and reduce risks of fabrications, i.e., mystification of reality or harmful content.

### CoT

Chain of Thought (CoT) prompting is relatively new prompting method, that encourages the LLM to explain its reasoning. The main idea of CoT is that by giving the LLM some few shot examples where the reasoning process is explained, the LLM will also show the reasoning process when answering the prompt. This often leads to more accurate results.

Importantly, it has been shown that CoT only yields performance gains when used with models of ∼100B parameters. Smaller models wrote illogical chains of thought, which had worse accuracy than standard prompting. Models usually get performance boosts from CoT prompting in a manner proportional to the size of the model.

### ReAct

ReAct is inspired by the synergies between `reasoning` and `acting` which allow humans to learn new tasks and make decisions or reasoning. ReAct is a general paradigm that combines reasoning and acting when working with LLMs. ReAct prompts LLMs to generate verbal reasoning traces and actions for a task. This allows the system to perform dynamic reasoning to create, maintain, and adjust plans for acting while also enabling interaction to external environments to incorporate additional information into the reasoning.

The first step is to select cases from a training set and compose ReAct-format outcomes. These are used as few-shot examples in the prompts. The examples consist of multiple thought-action-observation steps.

For example, when using LangChain with dataframe agents and the SQL Toolkits with debugging, it is simple to see the output of how the thought, action and observation interactions work. That is typcially done over many iterations until the desired outcome is achieved.

## Text Generation

In a text generation app, natural language is used to interact with the app. Benefits of using a text generation model within an application is that users can interact with a model that has been trained on a vast corpus of information, whereas a traditional app might be limited on what's in a database. So what can a developer build with a text generation app?

- **A chatbot**. A chatbot answering questions about topics, like a company and its products could be a good match.
- **Helper**. LLMs are fantastic at things like summarizing text, getting insights from text, producing text like resumes and more.
- **Code assistant**. Depending on the language model used, coding assistants can help write code. For example, products like GitHub Copilot as well as ChatGPT have skills to help write code.

Chat applications have become integrated into our daily lives, offering more than just a means of casual conversation. They are integral parts of customer service, technical support, and even sophisticated advisory systems. It is very likely that a friend or a colleage has gotten assistance from a chat application recently. As common as they have become, as more advanced technologies like Generative AI are added to these platforms, the operational complexity increases and so do other production challenges.

As we move further into an age defined by automation and seamless human-machine interactions, understanding how generative AI transforms the scope, depth, and adaptability of chat applications becomes essential. This lesson will investigate the aspects of architecture that support these intricate systems, delve into the methodologies for fine-tuning them for domain-specific tasks, and evaluate the metrics and considerations pertinent to ensuring responsible AI deployment.

## Image Generation

There is more to LLMs than text generation. It is also possible to generate images from text descriptions. Having images as a modality can be highly useful in a number of areas from MedTech, architecture, tourism, game development and more. In this chapter, we will investigate the two most popular image generation models, DALL-E and Midjourney. DALL-E and Midjourney allow users to use prompts to generate images.

Image generation applications are a fantastic way to explore the capabilities of Generative AI. They can be used for, for example:

- Image editing and synthesis. These are used to generate images for a variety of use cases, such as image editing and image synthesis.
- Applied to a variety of industries. They can also be used to generate images for a variety of industries like Medtech, Tourism, Game development and more.

When generating images, it is imporant to create boundaries on the creations. For example, we do not want to generate images that are not safe for work, or that are not appropriate for children. This can be accomplished with metaprompts. Metaprompts are text prompts that are used to control the output of a Generative AI model. For example, we can use metaprompts to control the output, and ensure that the generated images are safe for work, or appropriate for children. Metaprompts are positioned before the text prompt, and are used to control the output of the model and embedded in applications to control the output of the model. Encapsulating the prompt input and the meta prompt input in a single text prompt.

### DALL-E

DALL-E, which is a Generative AI model that generates images from text descriptions. DALL-E is a Generative AI model based on the transformer architecture with an autoregressive transformer. An autoregressive transformer defines how a model generates images from text descriptions, it generates one pixel at a time, and then uses the generated pixels to generate the next pixel. Passing through multiple layers in a neural network, until the image is complete. With this process, DALL-E, controls attributes, objects, characteristics, and more in the image it generates. However, DALL-E 2 and 3 have more control over the generated image,

Additionally, DALL-E is a combination of two models, CLIP and diffused attention.

- CLIP, is a model that generates embeddings, which are numerical representations of data, from images and text.
- Diffused attention, is a model that generates images from embeddings. DALL-E is trained on a dataset of images and text and can be used to generate images from text descriptions. For example, DALL-E can be used to generate images of a cat in a hat, or a dog with a mohawk.

### Midjourney

Midjourney works in a similar way to DALL-E, it generates images from text prompts. Midjourney, can also be used to generate images using prompts like “a cat in a hat”, or a “dog with a mohawk”.

## Low Code Applciations

Generative AI can be used for a variety of different areas including low code, but what is low code and how can we add AI to it?

Building apps and solutions has become more easier for traditional developers and non-developers through the use of Low Code Development Platforms. Low Code Development Platforms enable allow users to build apps and solutions with little to no code. This is achieved by providing a visual development environment that enables drag and drop components to build apps and solutions. With low code UIs, users can build apps and solutions faster and with less resources.

The Power Platform provides organizations with the opportunity to empower their teams to build their own solutions through an intuitive low-code or no-code environment. This environment helps simplify the process of building solutions. With Power Platform, solutions can be built in days or weeks instead of months or years. Power Platform consists of five key products:

- Power Apps
- Power Automate
- Power BI
- Power Pages
- Power Virtual Agents

Enhancing low-code development and application with generative AI is a key focus area for Power Platform. The goal is to enable everyone to build AI-powered apps, sites, dashboards and automate processes with AI, without requiring any data science expertise. This goal is achieved by integrating generative AI into the low-code development experience in Power Platform in the form of Copilot and AI Builder.

Some of the Prebuilt AI Models available in Power Platform include:

- Key Phrase Extraction: This model extracts key phrases from text.
- Language Detection: This model detects the language of a text.
- Sentiment Analysis: This model detects positive, negative, neutral, or mixed sentiment in text.
- Business Card Reader: This model extracts information from business cards.
- Text Recognition: This model extracts text from images.
- Object Detection: This model detects and extracts objects from images.
- Form Processing: This model extracts information from forms.
- Invoice Processing: This model extracts information from invoices.

## Copilots

Use Copilot driven functionalities as a feature in app screens to enable users to uncover insights through conversational interactions.

Copilots are available in all the Power Platform products: Power Apps, Power Automate, Power BI, Power Pages and Power Virtual Agents. AI Builder is available in Power Apps and Power Automate.

## External Applications with function calling

Before function calling, responses from an LLM were unstructured and inconsistent. Developers were required to write complex validation code to make sure they can handle each variation of a response. Users could not get answers like "What is the current weather in Stockholm?". This is because models were limited to the data available at that moment in time.

Function Calling is a feature of the Azure Open AI Service to overcome to the following limitations:

- Consistent response format. If we can better control the response format we can more easily integrate the response downstream to other systems.
- External data. Ability to use data from other sources of an application in a chat context.

There are many different use cases where function calls can improve applications such as:

- Calling External Tools. Chatbots are fantastic at providing answers to questions from users. By using function calling, the chatbots can use messages from users to complete certain tasks. For example, a student can ask the chatbot to "Send email to my instructor saying I need more assistance with this subject". This can make a function call to send_email(to: string, body: string)
- Create API or Database Queries. Users can find information using natural language that gets converted into a formatted query or API request. An example of this could be a teacher who requests "Who are the students that completed the last assignment" which could call a function named get_completed(student_name: string, assignment: int, current_status: string)
- Creating Structured Data. Users can take a block of text or CSV and use the LLM to extract valuable information from it. For example, a student can convert a Wikipedia article about peace agreements to create AI flash cards. This can be done by using a function called get_important_facts(agreement_name: string, date_signed: string, parties_involved: list)

## User Experience (UX)

General UX principles apply to chat applications, but here are some additional considerations that become particularly important due to the machine learning components involved.

- Mechanism for addressing ambiguity: Generative AI models occasionally generate ambiguous answers. A feature that allows users to ask for clarification can be helpful should they come across this problem.
- Context retention: Advanced generative AI models have the ability to remember context within a conversation, which can be a necessary asset to the user experience. Giving users the ability to control and manage context improves the user experience, but introduces the risk of retaining sensitive user information. Considerations for how long this information is stored, such as introducing a retention policy, can balance the need for context against privacy.
- Personalization: With the ability to learn and adapt, AI models offer an individualized experience for a user. Tailoring the user experience through features like user profiles not only makes the user feel understood, but it also helps their pursuit of finding specific answers, creating a more efficient and satisfying interaction.
One such example of personalization is the "Custom instructions" settings in OpenAI's ChatGPT. It allows users to provide information about themselves that may be important context for the prompts.

### Accessiblity

Whether a user has visual, auditory, motor, or cognitive impairments, a well-designed chat application should be usable by all. The following list breaks down specific features aimed at enhancing accessibility for various user impairments.

- Features for Visual Impairment: High contrast themes and resizable text, screen reader compatibility.
- Features for Auditory Impairment: Text-to-speech and speech-to-text functions, visual cues for audio notifications.
- Features for Motor Impairment: Keyboard navigation support, voice commands.
- Features for Cognitive Impairment: Simplified language options.

## Key Metrics

To maintain the high-quality performance an application, it is essential to keep track of key metrics and considerations. These measurements not only ensure the functionality of the application but also assess the quality of the AI model and user experience. Below is a list that covers basic, AI, and user experience metrics to consider.

- **Uptime** : Measures the time the application is operational and accessible by users. For example: How will to minimize downtime?
- **Response Time** : The time taken by the application to reply to a user's query. For example: How to optimize query processing to improve response time?
- **Precision** : The ratio of true positive predictions to the total number of positive predictions For example: How to validate the precision of the model?
- **Recall (Sensitivity)** : The ratio of true positive predictions to the actual number of positives For example: How to measure and improve recall?
- **F1 Score** : The harmonic mean of precision and recall, that balances the trade-off between both. For example: What is the target F1 Score? How to balance precision and recall?
- **Perplexity** : Measures how well the probability distribution predicted by the model aligns with the actual distribution of the data. For example: How to minimize perplexity?
- **User Satisfaction Metrics** : Measures the user's perception of the application. Often captured through surveys. For example: How often to collect user feedback? How to adapt based on it?
- **Error Rate** : The rate at which the model makes mistakes in understanding or output. For example: What strategies are there to reduce error rates?
- **Retraining Cycles** : The frequency with which the model is updated to incorporate new data and insights. For example: How often to retrain the model? What triggers a retraining cycle?
- **Anomaly Detection** : Tools and techniques for identifying unusual patterns that do not conform to expected behavior. For example: How to respond to anomalies?

## Libraries and SDKs

When building an AI integreated application, a fantastic first step is to assess what is already out there. Using SDKs and APIs to build chat applications is an advantageous strategy for a variety of reasons. By integrating well-documented SDKs and APIs, applications will be strategically positioned for long-term success, addressing scalability and maintenance concerns.

- Expedites the development process and reduces overhead: Relying on pre-built functionalities instead of the expensive process of building them allows the focus to switch to other important aspects of the application, such as business logic.
- Better performance: When building functionality from scratch, evantually the questions of "How does it scale? Is this application capable of handling a sudden influx of users?" will be asked. Well maintained SDK and APIs often have built in solutions for these concerns.
- Easier maintenance: Updates and improvements are easier to manage as most APIs and SDKs simply require an update to a library when a newer version is released.
- Access to cutting edge technology: Leveraging models that have been fined tuned and trained on extensive datasets provides an application with natural language capabilities.

Accessing functionality of an SDK or API typically involves obtaining permission to use the provided services, which is often through the use of a unique key or authentication token.

There are a few well known libraries for working with LLMs like:

- OpenAI, this library makes it easy to connect to OpenAI models and send in prompts.

Then there are libraries that operate on a higher level like:

- Langchain. Langchain is well known and supports Python.
- Semantic Kernel. Semantic Kernel is a library by Microsoft supporting the languages C#, Python, and Java.
