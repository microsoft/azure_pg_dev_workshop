# The Azure PostgreSQL Developer Workshop

#### <i>A Microsoft workshop from the Azure PostgreSQL team</i>

<p style="border-bottom: 1px solid lightgrey;"></p>

<h2><b>About this Workshop</b></h2>

Welcome to this Azure PostgreSQL Developer Workshop.

In this workshop, you will learn how about PostgreSQL fundamentals and how to implement modern data applications that take advantage of Azure Database for PostgreSQL using a hands-on lab approach.

This content is designed for data developers who have a basic working knowledge of PostgreSQL and the SQL language.

This workshop is intended to be taken as a self-paced training.

This **README.MD** file explains how the workshop is structured, what you will learn, and the technologies you will use in this solution.

- [01 Overview](01_Intro/01_Introduction.md)
- [02 Introduction to PostgreSQL](02_IntroToPostgreSQL/02_00_Intro_PostgreSQL.md)
- [03 Getting Started](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/03_GettingStarted/03_00__Getting_Started.md)
- [04 Samples](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/04_00-0_End_To_End_Development.md)
  - [01-0 - Postgres Developer Features](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-01-00-PostgreSQL-Developer-Features/README.md)
  - [01-1 - pgBouncer](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-01-01-pgBouncer/README.md)
  - [01-2 - Logical Replication](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-01-02-Logical-Replication/README.md)
  - [02 - Function Apps (.NET)](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-02-FunctionApp-DotNet/README.md)
  - [03 - Function Apps (Python)](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-03-FunctionApp-Python/README.md)
  - [04 - Function Apps (AKS)](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-04-FunctionApp-AKS/README.md)
  - [05 - Function Apps (Python) with MSI](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-05-FunctionApp-MSI/README.md)
  - [06 - Logic Apps](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-06-LogicApp/README.md)
  - [07 - Azure Data Factory](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-07-AzureDataFactory/README.md)
  - [08 - Azure Synapse Analytics](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-08-AzureSynapseAnalytics/README.md)
  - [09 - Azure Batch](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-09-AzureBatch/README.md)
  - [10 - External Samples](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/04_EndToEndDev/samples/04-10_External_Samples/README.md)
- [10 AI](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/05_AI/05_01_Intro_AI.md)
  - [01 - Generative AI with Azure Database for PostgreSQL Flexible Server](https://github.com/microsoft/azure_pg_dev_workshop/tree/main/05_AI/Samples/05-08-AI-Basics)
  - [02 - Using Hugging Face with Azure Database for PostgreSQL Flexible Server](https://github.com/microsoft/azure_pg_dev_workshop/tree/main/05_AI/Samples/05-09-01-AI-HuggingFace)
  - [03 - LangChain with Azure Database for PostgreSQL Flexible Server (RAG/ReAct)](https://github.com/microsoft/azure_pg_dev_workshop/tree/main/05_AI/Samples/05-09-02-AI-Langchain)
  - [04 - Vector Similarity with PostgreSQL](https://github.com/microsoft/azure_pg_dev_workshop/tree/main/05_AI/Samples/05-09-03-AI-Langchain-Receipes)
  - [05 - LangChain with Azure Database for PostgreSQL Flexible Server (VectorDB)](https://github.com/microsoft/azure_pg_dev_workshop/tree/main/05_AI/Samples/05-09-04-AI-Langchain-VectorDB)
  - [06 - Semantic Kernel with Azure Database for PostgreSQL Flexible Server](https://github.com/microsoft/azure_pg_dev_workshop/tree/main/05_AI/Samples/05-09-05-AI-Semantic-Kernel)
  - [07 - Full Chat Application with Semantic Kernel, PostgreSQL, Azure Open AI](https://github.com/microsoft/azure_pg_dev_workshop/tree/main/05_AI/Samples/05-09-06-AI-Full-Chat-Application)
- [06 Troubleshooting](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/06_Troubleshooting/06_00_Troubleshooting.md)
- [07 Best Practices](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/07_BestPractices/07_00_BestPractices.md)
- [08 Architectures](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/08_Architectures/08_00_Architectures.md)
- [09 Case Studies](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/09_CaseStudies/09_00_CaseStudies.md)
- [10 Zero to Hero](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/10_ZeroToHero/10_00_ZeroToHero.md)
- 11 Appendix
    - [01 Infrastructure Concepts (Monitoring, Networking, Security, Testing, performance)](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/11_01_Infrastructure/11_01_Infrastructure.md)
    - [02 Application Modernization](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/11_02_AppModernization/11_00_AppModernization.md)
        - [01 Sample Application Intro](https://github.com/microsoft/azure_pg_dev_workshop/blob/main/11_02_AppModernization/11_01-Sample-Application-Intro.md)
    - [03 Workshop Setup](https://github.com/microsoft/azure_pg_dev_workshop/tree/main/11_03_Setup)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
