## Common PostgreSQL Apps and Users

In May 2023, 90,000 developers from around the world responded to Stack Overflow's annual survey on which technologies they are currently using and which tools they most want to use. Per the results, PostgreSQL is now the most admired and desired database among all developers, taking over the first place spot from MySQL. 71% of the respondents said they used PostgreSQL with the last year and intend to continue using it.

Reference the [Most Popular Technogies : Databases](https://survey.stackoverflow.co/2023/#section-most-popular-technologies-databases) of the survey.

### Apple

In 2010, Apple replaced MySQL with Postgres as an embedded database in OS X Lion. In earlier versions, Apple focused on Oracle's database solution MySQL. Several factors contributed to the change but since then, Apple systems have supported PostgreSQL. Currently, it is the default database on macOS Server since OS X Server version 10.7. PostgreSQL is also available in the App Store.

### Instacart

Instacart uses PostgreSQL for a majority of its systems. It is interesting to note that they do not use pgBouncer and opted to utilize another open-source tool called `PgCat`. At the time of their decision, common opinion showed that "Pgbouncer does connection pooling very well but does not support replica failover and has limited support for load balancing.". Reference [Adopting PgCat: A Nextgen Postgres Proxy](https://www.instacart.com/company/how-its-made/adopting-pgcat-a-nextgen-postgres-proxy/#:~:text=At%20Instacart%2C%20we%20use%20Postgresql,optimization%20and%20vertically%20scaling%20instances).

### Instagram

The number of Instagram platform users exceeded a billion in 2019. Users publish over 50 million photos a day. Instagram uses many RDBMSs, but PostgreSQL and Cassandra are used for most tasks.

### Reddit

Reddit uses PostgreSQL for the ThingDB model and other basic database-oriented tasks. The ThingDB model is a Postgres mechanism for storing data for most objects (e.g. links, comments, accounts, and subreddits). Reddit uses basic database operations to analyze traffic statistics and information on transactions, ads sales, and subscriptions.

### Spotify

The Spotify infrastructure uses several technologies for storage: Cassandra, PostgreSQL and memcached.

If the feature's data needs to be partitioned, then the squad has to implement the sharding themselves in their services, however many services rely on Cassandra doing full replicas of data between sites. Setting up a full storage cluster with replication and failover between sites is complicated so we are building infrastructure to set up and maintain multi-site Cassandra or PostgreSQL clusters as one unit. For people building apps on the Spotify API there will be a storage as a service option that will not require any setup of any clusters. The storage as a service option will be limited to a very simple key-value store.

### International Space Station

PostgreSQL has also reached space. NASA explored using Nagios on the Space Station and using PostgreSQL to store the data on the Nagios data. They would then replicate that database on the ground.

## 3rd party Azure solutions / Azure Marketplace

The [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps?search=postgres&page=1) provides thousands of certified apps on Azure tailored to meet customer needs. Using `postgres` as the search criteria, review the various available applications that utilize PostgreSQL.
