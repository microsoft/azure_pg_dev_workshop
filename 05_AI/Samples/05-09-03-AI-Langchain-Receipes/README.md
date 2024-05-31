# Hands-on Lab: Vector Similarity with PostgreSQL

In this lab, `psycopg2` will be used to connect to a PostgreSQL database and create various tables. Pandas will then be used to populate the tables from CSV data that have content and embeddings. Search queries will be performed against the vector embeddings for similar and not similar items.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure Database for PostgreSQL Flexible Server

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

### Software pre-requisites

All of this is done already in the lab setup scripts for the Lab virtual machine but is provided here for reference.

- Install [Visual Studio Code](https://code.visualstudio.com/download)
- Install the [`Python`](https://marketplace.visualstudio.com/items?itemName=ms-python.python) extension
- Install [Python 3.11.x](https://www.python.org/downloads/)
- Install the latest [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli-windows?tabs=powershell)

## Exercise 1: Vector Similarity with PostgreSQL

- Open the `c:\labfiles\microsoft-postgresql-developer-guide\05_AI\Samples\05-09-03-AI-Langchain-Receipes\ai_receipes.ipynb` notebook.
- Follow the instructions in the notebook.
