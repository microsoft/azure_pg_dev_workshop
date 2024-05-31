## Azure Database for PostgreSQL Flexible Server and Artificial Intelligence (AI)

### Vector Databases

A vector database, also known as a vector database management system (DBMS), is a type of database system designed to store, manage, and query vector data efficiently. Traditional relational databases primarily handle structured data in tables, while vector databases are optimized for the storage and retrieval of multidimensional data points represented as vectors. These databases are useful for applications where operations such as similarity searches, geospatial data, recommendation systems, and clustering are involved.

Some key characteristics of vector databases:

- **Vector Storage**: Vector databases store data points as vectors with multiple dimensions. Each dimension represents a feature or attribute of the data point. These vectors could represent a wide range of data types, including numerical, categorical, and textual data.
- **Efficient Vector Operations**: Vector databases are optimized for performing vector operations, such as vector addition, subtraction, dot products, and similarity calculations (for example, cosine similarity or Euclidean distance).
- **Efficient Search**: Efficient indexing mechanisms are crucial for quick retrieval of similar vectors. Vector databases use various indexing mechanisms to enable fast retrieval.
- **Query Languages**: They provide query languages and APIs tailored for vector operations and similarity search. These query languages allow users to express their search criteria efficiently.
- **Similarity Search**: They excel at similarity searches, allowing users to find data points that are like a given query point. This characteristic is valuable in search and recommendation systems.
- **Geospatial Data Handling**: Some vector databases are designed for geospatial data, making them well-suited for applications like location-based services, GIS (Geographic Information Systems), and map-related tasks.
- **Support for Diverse Data Types**: Vector databases can store and manage several types of data, including vectors, images, text and more.

PostgreSQL instances can gain the capabilities of a vector database with the help of the `pgvector` extension.

When considering developing low cost proof of concepts (PoCs), PostgreSQL offers one of the lowest costs when it comes vector search. Additionally, when using the free tiers of the services, Azure Database for PostgreSQL Flexible Server has more storage than Azure AI Search (32GB vs 50MB).

### pgvector extension

The [`pgvector` extension](https://github.com/pgvector/pgvector) adds an open-source vector similarity search to PostgreSQL. By enabling the extension, it is possible to use the various operators and functions on vector based data.

For more information, review [How to enable and use pgvector on Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-use-pgvector).

> NOTE: Although there are other embedding extensions (such as `pg_embedding`) available for PostgreSQL, only the `pgvector` extension is currently available for Azure Database for PostgreSQL Flexible Server.

Once the `pgvector` extension is enabled, the following can be performed within a database:

- Define vector column types (up to 2000 dimensions)
- Perform vector searchs
- Create indexes (HNSW, IVFFlat)

For example, the following SQL will create a table with a vector column:

```sql
CREATE TABLE IF NOT EXISTS products (
    id bigserial primary key,
    description text,
    url text,
    split int,
    descriptions_embeddings vector(384)
)
```

When working with `pgvector` in Python, it is necessary to import the `PGVEctor` module. When using dotnet and the `Npgsql` libraries, ensure the `NpgsqlDataSourceBuilder.UseVector()` method is called when creating datasources.

- [PGVector Extension](https://github.com/pgvector/pgvector)
- [PGVector for dotnet](https://github.com/pgvector/pgvector-dotnet)
- [PGVector for Python](https://github.com/pgvector/pgvector-python)

#### Search

By default, pgvector performs exact nearest neighbor search, which provides perfect recall.

#### Indexing

Add indexes to use approximate nearest neighbor search, which will trade some recall for speed. Unlike typical indexes, it is possible to see different results for queries after adding an approximate index. Supported index types are:

- **HNSW** - creates a multilayer graph. It has better query performance than IVFFlat (in terms of speed-recall tradeoff), but has slower build times and uses more memory. Also, an index can be created without any data in the table since there isn't a training step like IVFFlat.
- **IVFFlat** - divides vectors into lists, and then searches a subset of those lists that are closest to the query vector. It has faster build times and uses less memory than HNSW, but has lower query performance (in terms of speed-recall tradeoff).

#### Functions

- **cosine_distance(vector, vector)** : double precision : cosine distance
- **inner_product(vector, vector)** : double precision : inner product
- **l2_distance(vector, vector)** : double precision : Euclidean distance
- **l1_distance(vector, vector)** : double precision : taxicab distance
- **vector_dims(vector)** : integer : number of dimensions
- **vector_norm(vector)** : double precision : Euclidean norm

### azure_ai extension

Azure Database for PostgreSQL Flexible Server extension for Azure AI enables the use of large language models (LLMS) and build rich generative AI applications within the database.  The Azure AI extension enables the database to call into various Azure AI services including Azure OpenAI and Azure Cognitive Services simplifying the development process allowing seamless integration into those services.

Once enabled, setup the endpoint and key settings for the extension in order to utilize it in queries.

For more information, review the following:

- [Azure Database for PostgreSQL Flexible Server Azure AI Extension (Preview)](https://learn.microsoft.com/azure/postgresql/flexible-server/generative-ai-azure-overview).
- [Integrate Azure AI capabilities into Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-integrate-azure-ai)

### Embedding performance

Co-locate database instance in the same region as the Azure Open AI instance to gain some performance enhancements. When performing a lot of vector embedding operations, ensure resources are located as close as possible to each other.

Also be aware that users are subject to certain request limits for embedding endpoints in Azure Open AI. When too many queries are sent http 429 errors will be presented. Reference [Azure OpenAI Service quotas and limits](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).

### Other vector databases

In production, the Embedding Index would be stored in a vector database such as Azure Cognitive Search, Redis, Pinecone, Weaviate, to name but a few.

### Hybrid Search

In addition or searching on vectors, it is possible to combine other content and metadata to further refine the results that are provided to the target models. This can be helpful for creating category or metadata-based containers in the indexed data.

### Integration with AI Frameworks

PostgreSQL is supported by several popular AI frameworks including:

- [Langchain](https://www.langchain.com/)
- [Semantic Kernal](https://learn.microsoft.com/semantic-kernel/overview/)

Note that these two frameworks are incredibly new and continuing to evolve. Be very cautionous of samples of code found on the internet as the SDKs have likely changed and continue to change with every git commit. Be sure to review what version the code sample actually targets, as it may not work with the latest versions.

#### LangChain

LangChain is an open source framework for building AI applications using language models. LangChain provides tools and abstractions to improve the customization, accuracy, and relevancy of the information the target models generate. Developers can use LangChain components to build custom prompt chains or use several pre-built templates. LangChain also includes features that allow models to gain access to new data without retraining.

Language models excel at responding to user prompts in a general context, but do not perform well when used in a specific domain they were never trained on. Prompts are text strings that are used to help guide an LLM to the target response. For example, an LLM can provide a detailed answer in terms of how to approach the solution to a problem. However, it cannot provide any realtime information of the solution without added context.

To support these types of scenerios, agents must integrate the organizations specific data sources and then apply prompt engineering tactis. Prompt engineering refines inputs to a generative model with a specific structure and context.

LangChain's large set of open source code streamlines many of the intermediate steps when developing AI applications. Using LangChain makes the process of prompt engineering much more efficient. Using its out of box capabilities, it is possible to effortlessly create applications such as chatbots, question-answering, content generation, summarizers, and more.

When using PostgreSQL with LangChain there three potential uses:

- Vector store (also called retreiver)
- Memory Store
- LangChain SqlToolkit

For example, the following psudo code shows how to create a retreiver that can be used in LangChain chains. Everything is taken care of other than populating the PostgreSQL vector collection:

```python
connection_string = f'postgresql+psycopg2://{username}:{password}@{host}:{port}/{dbname}'

embeddings = OpenAIEmbeddings(
    deployment=embedding_model,
    openai_api_base=azure_endpoint,
    openai_api_key=azure_key,
    openai_api_type="azure",
)

collection_name = 'aidata'

db = PGVector(
    collection_name=collection_name,
    connection_string=connection_string,
    embedding_function=embeddings,
)

retriever = db.as_retriever()

prompt = PromptTemplate(
    template=prompt_prefix,
    input_variables=["context", "question"], #"summaries", "question"
)

llm = AzureChatOpenAI(deployment_name=deployment_name,
                        temperature=0,
                        openai_api_base=azure_endpoint,
                        openai_api_key=azure_key,
                        openai_api_type="azure",
                        openai_api_version=api_version,
                        model_version=model_version)

llm_chain = ConversationalRetrievalChain.from_llm(
    llm=llm,
    retriever=retriever,
    return_source_documents=False,
    chain_type="stuff",
    combine_docs_chain_kwargs={"prompt": prompt},
    verbose=True
)

answer = llm_chain.invoke(question, return_only_outputs=True)['answer']
```

In the above example, the `PGVector` module is being used. It has serveral helpful features when working with PostgreSQL and vectors that do not have to be built from scratch. For instance, use the module to automatically create the table structure for vector collections.

A typical table would contain the following:

- uuid: unique ID of the vector
- collection_id: collection ID referencing the collection table
- embedding: a field of type vector that stores the embedding (1536 dimensions)
- document: chunk of text that is vectorized
- cmetadata: JSON field with a link to the source file
- custom_id: an id that is unique for each run

When using LangChain with PGVector, it is possible to be up and running very quickly but limited to what has been implemented in the modules. For example, as of this writing:

- Without custom coding or reverting to SQL statements, it is possible to only search one collection at a time
- Performing searchs will be limited to `cosine similarity` and `exact nearest neighbor`.

When it comes to using it as a memory store, this allows for the searching of items that are necessary to add context to the final prompt. In the following example, Semantic Kernel is used in python to create a `PostgreMemoryStore`:

```python
from semantic_kernel.connectors.memory.postgres import PostgresMemoryStore

connection_string = f"postgresql://{username}:{password}@{host}:{port}/{dbname}"

memory_store = PostgresMemoryStore(connection_string=connection_string, default_dimensionality=1536, min_pool=1, max_pool=10)

await memory_store.create_collection_async(collection_name='aboutMe')
```

And when using the SQLToolkit in LangChain, it looks like the following. This code will attempt to use the data in the `SQLDatabase` object acheive the prompt goals. This includes analyzie the table structure and then reasoning over it to find the data needed to provide the appropriate context to later steps:

```python
db = SQLDatabase.from_uri(connection_string)

toolkit = SQLDatabaseToolkit(db=db, llm=llm)

agent_executor = create_sql_agent(
    llm=llm,
    toolkit=toolkit,
    verbose=True,
    handle_parsing_errors=handle_parsing_errors
)
```

#### Semantic Kernel

Semantic Kernel is an SDK that integrates Large Language Models (LLMs) like OpenAI, Azure OpenAI, and Hugging Face with conventional programming languages like C#, Python, and Java. Semantic Kernel achieves this by allowing for the definition of plugins that can be chained together in just a few lines of code.

A key concept in Semantic Kernel is the kernel itself. It is the main object used to orchestrate  LLM based workflows. A kernel by itself has very limited functionality; all of its features are largely powered by external components. The kernel acts as a processing engine that fulfils a request by invoking appropriate components to complete the given task. This gives Semantic Kernel is its ability to automatically orchestrate plugins with AI.

To make the kernel useful, it must be connected to one or more AI models, which will enable the kernel to understand and generate natural language. Semantic Kernel provides out-of-the-box connectors that make it easy to inject AI models from different sources, such as OpenAI, Azure OpenAI, and Hugging Face. These models are then used to provide services to the kernel during its execution.

Some examples of services include:

- **Text completion**: used to generate natural language
- **Chat**: used to create a conversational experience
- **Text embedding generation**: used to encode natural language into embeddings

Each type of service can support multiple models from different sources at the same time, making it possible to switch between different models, depending on the task and the preference of the user. If no specific service or model is specified, the kernel will default to the first service and model defined.

Semantic Functions are used as the method to interact with a LLM through Semantic Kernel. A semantic function expects a natural language input and uses an LLM to interpret what is being asked, then act accordingly to return a response. In Semantic Kernel, a semantic function is composed of two components:

- **Prompt Template**: the natural language query or command that will be sent to the LLM
- **Configuration object**: contains the settings and options for the semantic function, such as the service that it should use, the parameters it should expect, and the description of what the function does.

The simplest way to get started is by using the kernel's `create_semantic_function` method, which accepts fixed arguments such as `temperature` and `max_tokens` which are usually required by LLMs and uses these to build a config for us.

For example:

```python
prompt = """
{{$input}} is on what continent?
"""

generate_continent_text = kernel.create_semantic_function(
    prompt, max_tokens=100, temperature=0, top_p=0
)
```

When interacting with chat bots, one of the key aspects that makes the experience feel more natural is the ability to retain the context of our previous chats. If all of our chat context history is stored in system RAM then once we shut down the system it would be gone forever. For more intelligent designs, it can be useful to be able to build and persist both short and long term memory for our models to access. One must take care when feeding all of the previous interactions into a future prompt. Models tend to have a fixed size context window (8K, 16K, 32K etc) which determines how large the prompts can be. If an application continues to pass all of the chat history, things will quickly break down. One way to avoid this is to store our memory as separate chunks and only load information that we think may be relevant into the current prompt.

When it comes to **PostresSQL** and Semantic Kernel, like LangChain, PostgreSQL can be used as a vector store or a memory store (chat/context history):

```python
kernel = sk.Kernel()

kernel.add_chat_service(
    "chat_completion",
    AzureChatCompletion(deployment_name=completions_deployment_name, endpoint=azure_endpoint, api_key=azure_key),
)

memory_store = PostgresMemoryStore(connection_string=connection_string, default_dimensionality=1536, min_pool=1, max_pool=10)

await memory_store.create_collection_async(collection_name='aboutMe')

await kernel.memory.save_information_async(collection="aboutMe", id="info1", text="My name is John")

question = "what is my name"

result = await kernel.memory.search_async("aboutMe", question)
```

In addition to all the basic connectors, Semantic Kernel can be made "smarter" through plugins. A plugin in Semantic Kernel is a group of functions that can be loaded into the kernel to be exposed to AI apps and services. The functions within plugins can then be orchestrated by the kernel to accomplish tasks. Semantic Kernel provides several plugins out-of-the-box, which include:

- **ConversationSummarySkill**: Summarize a conversation
- **HttpSkill**: Call external APIs and services
- **TextMemorySkill**: Stores and retrieves text in memory
- **TimeSkill**: Acquire time of day and any other temporal data

 Semantic Kernel provides Planner objects, which can dynamically create chains of functions to achieve goals. With Semantic Kernel planners, an LLM can be used to generate a plan that potentially achieves a user's unique goal. Once the plan is generated, Semantic Kernel will execute the plan for the user and return the results.

 A planner typically takes a user prompt and a kernel and uses the kernel's available services to create a plan of how to perform the task. Plugins tend to be the main building blocks of plans. The planner relies heavily on the plugin descriptions provided. If plugins and functions do not have clear and appropriate descriptions, the planner may not use them correctly (or at all) when building a plan. The planner can combine functions in various and seemingly random ways (remember a LLM is driving) so it is important to ensure to only expose functions that the planner should consider for usage.

 It is also a best practice to run plans several times to ensure consisent and appropriate responses.

### Samples

1. [Basic AI with Azure Database for PostgreSQL Flexible Server](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/05-CloudDeploy-PostgreSQLFlex)
2. [Advanced AI with Azure Database for PostgreSQL Flexible Server](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/05-CloudDeploy-PostgreSQLFlex)
