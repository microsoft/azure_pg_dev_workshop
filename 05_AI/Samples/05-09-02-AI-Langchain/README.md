# Hands-on Lab: LangChain with Azure Database for PostgreSQL Flexible Server (RAG/ReAct)

In this lab, `sqlalchemy` and `psycopg2` will be used to import data from CSV files into a PostgreSQL database.  LangChain will then be used to connect to a PostgreSQL database and query the tables and data within the tables to answer a question. Langchain will have no prior knowledge of the database structure and will attempt to answer the question based on the schema.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure Database for PostgreSQL Flexible Server
- Azure OpenAI-enabled subscription
- Azure Machine Learning Studio

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

### Software pre-requisites

All of this is done already in the lab setup scripts for the Lab virtual machine but is provided here for reference.

- Install [Visual Studio Code](https://code.visualstudio.com/download)
- Install the [`Python`](https://marketplace.visualstudio.com/items?itemName=ms-python.python) extension
- Install [Python 3.11.x](https://www.python.org/downloads/)
- Install the latest [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli-windows?tabs=powershell)

## Exercise 1: LangChain with PostgreSQL

- Open the `c:\labfiles\microsoft-postgresql-developer-guide\05_AI\Samples\05-09-02-Langchain\ai_langchain.ipynb` notebook.
- Follow the instructions in the notebook.
