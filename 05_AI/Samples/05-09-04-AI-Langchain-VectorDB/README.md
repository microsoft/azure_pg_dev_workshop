# Hands-on Lab: LangChain with Azure Database for PostgreSQL Flexible Server (VectorDB)

In this lab, LangChain will be used to chunk and embed various documents using PGVector and OpenAI embeddings. The embeddings will be added to a PostgreSQL database using PGVector.  Once loaded, LangChain will be used to create a Chain that queries the newly added documents.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure Database for PostgreSQL Flexible Server
- Azure OpenAI-enabled subscription

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

### Software pre-requisites

All of this is done already in the lab setup scripts for the Lab virtual machine but is provided here for reference.

- Install [Visual Studio Code](https://code.visualstudio.com/download)
- Install the [`Python`](https://marketplace.visualstudio.com/items?itemName=ms-python.python) extension
- Install [Python 3.11.x](https://www.python.org/downloads/)
- Install the latest [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli-windows?tabs=powershell)

## Exercise 1: LangChain with PostgreSQL (VectorDB)

- Open the `c:\labfiles\microsoft-postgresql-developer-guide\05_AI\Samples\05-09-04-AI-Langchain-VectorDB\ai_langchain_vectordb.ipynb` notebook.
- Follow the instructions in the notebook.
