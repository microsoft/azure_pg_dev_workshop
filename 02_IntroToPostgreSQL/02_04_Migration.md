## Migrate to Azure Database for Flexible Server

### From on-premises to Flexible Server

Migration from external sources such as other cloud providers or instances running on-premises will require the movement of database artifacts and data. There are currently several tools available to do this:

- Database tools
  - [Azure Database Migration Service (DMS)](https://learn.microsoft.com/azure/dms/tutorial-postgresql-azure-postgresql-online)
  - [pg_dump and pg_restore](https://learn.microsoft.com/azure/postgresql/migrate/how-to-migrate-using-dump-and-restore)
- [Azure Portal](https://learn.microsoft.com/azure/postgresql/migrate/how-to-migrate-single-to-flexible-portal)
- [Azure CLI](https://learn.microsoft.com/azure/postgresql/migrate/how-to-migrate-single-to-flexible-cli)

In addition to any migration pre-requisites, a network path must exist between the on-premises instance/tool and the remote Azure Database for PostgreSQL Flexible Server instance. This can be more complicated than at first glance depending on several different network topology possibilities.

### Offline vs Online migrations

For smaller and less used databases, the migration process is likely to be quick and effortless. However, in larger and more heavily used environments, choosing a migration path will be a vital decision to ensure applications and end users are not subject to lengthy downtime and productivity loss.

There are two potential migration paths:

- **Offline Migration** – In an offline migration, all applications connecting to the source instance are stopped and the database(s) is copied to the Flexible Server.

- **Online Migration** - In an online migration, applications connecting to the source instance are not stopped while database(s) are copied to the target server. The initial copy of the databases is followed by replication to keep the target server synchronized with the source server. A cutover is performed when the target server is in complete sync with the source server resulting in minimal downtime.
