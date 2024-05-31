## Generative Artificial Intelligence (GenAI)

Generative AI is artificial intelligence capable of generating text, images, audio and video content. With the myriad of free or low-cost Generative AI services available online, anyone can use it with as little as a simple text prompt written in a natural language. There is no need to learn a new language such as Python or JavaScript. All that is required is to provide a sentence or two with what and the AI model will provide a response (also called a completion). The applications and everyday impact of the technology are huge; such as helping users write or understand reports, write applications and much more, all in seconds.

GenAI algorithms tend to apply specific Machine Learning models. Some examples include:

- Transformers and Recurrent Neural Nets (RNNs) for text generation
- Generative Adversarial Networks (GANs) for image generation
- Variational Autoencoders (VAEs) for image generation etc.

In the next few sections, we will explore how generative AI is used to unlock new scenarios in various industries and how we address the new challenges and limitations associated with its usage.

Again, check out the YouTube video [AI in a Minute: Generative AI](https://youtu.be/om7iYSucLrk)

## Scenarios

Generative AI has a wide range of applications across various domains and industries including tech, healthcare, entertainment, finance, manufacturing and more. Here are some common tasks that can be accomplished with generative AI:

- Semantic Search:
  - GenAI enables semantic search on data rather than lexicographical search. The latter looks for exact matches to queries whereas semantic search finds content that satisfies the search query intent.
- Chatbots and Virtual Assistants:
  - Develop chatbots that can engage in natural context-aware conversations, for example, to implement self-help for customers.
- Recommendation Systems:
  - Improve recommendation algorithms by generating embeddings or representations of items or users. See [Recommendation System with Azure Database for PostgreSQL Flexible Server and Azure OpenAI](https://learn.microsoft.com/azure/postgresql/flexible-server/generative-ai-recommendation-system) for an example.
- Clustering and segmentation:
  - GenAI-generated embeddings allow clustering algorithms to cluster data so that similar data is grouped. This enables scenarios such as customer segmentation, which allows advertisers to target their customers differently based on their attributes.
- Content Generation:
  - Text Generation: Generate human-like text for applications like chatbots, novel/ poetry creation, and natural language understanding.
  - Image Generation: Create realistic images, artwork, or designs for graphics, entertainment, and advertising.
  - Video Generation: Generate videos, animations, or video effects for film, gaming, and marketing.
  - Music Generation
- Translation:
  - Translate text from one language to another.
- Summarization:
  - Summarize long articles or documents to extract key information.
- Data Augmentation:
  - Generate extra data samples to expand and improve training datasets for machine learning (ML) models.
  - Create synthetic data for scenarios that are difficult or expensive to collect in the real world, such as medical imaging.
- Drug Discovery:
  - Generate molecular structures and predict potential drug candidates for pharmaceutical research.
- Game Development:
  - Create game content, including levels, characters, and textures.
  - Generate realistic in-game environments and landscapes.
- Data Denoising and Completion:
  - Clean noisy data by generating clean data samples.
  - Fill in missing or incomplete data in datasets.

## Tokens

The latest AI works by taking text and converting it to numbers. Large language models (LLMs) such as OpenAI GPT are commonly referred to as Generative Pre-trained Transformer models.

After decades of research in the AI field (and what some would call AI winters), a new type of model architecture called Transformer overcame the limits of RNNs. These new models are capable of taking much longer sequences of text as input than previous models. Transformers are based on the attention mechanism, enabling the model to give different weights to the inputs it receives, `paying more attention` to where the most relevant information is concentrated, regardless of the order in the text sequence.

Most of the generative AI models available today work with textual inputs and outputs and are based on the Transformer style architecture. These models tend to be trained on a huge amount of unlabeled data from varying sources like books, articles and websites. Amazingly, these trained models can be adapted to a wide variety of tasks and generate grammatically correct text with amazing creativity. Not only can these models enhance the capacity of a machine to understand an input text, but they also enable a capacity to generate original responses in human language. 

To do these transformations, the text has to be broken up into chunks that make sense. These chunks are then broken down further into tokens. Models do not tend to be in charge of the chunking aspect of the process, but they are responsible for the tokenization via a Tokenizer model.

### Tokenizer

Large Language Models simply receive text as input and generate text as output. The models, however, work much better with numbers than text sequences.

Every input to a model is processed by a tokenizer before being used by the core part of the model. A token is a chunk of text consisting of a variable number of characters. The tokenizer's main task is splitting the input into an array of tokens. Then, each token is mapped with a token index, which is the integer encoding of the original text chunk.
