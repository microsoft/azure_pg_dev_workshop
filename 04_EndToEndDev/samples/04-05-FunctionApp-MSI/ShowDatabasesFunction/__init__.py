import logging
from os import access
import azure.functions as func
import psycopg2
import ssl

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    from azure.identity import DefaultAzureCredential, AzureCliCredential, ChainedTokenCredential, ManagedIdentityCredential
    managed_identity = ManagedIdentityCredential()
    scope = "https://management.azure.com"
    token = managed_identity.get_token(scope)
    access_token = token.token

    crtpath = 'BaltimoreCyberTrustRoot.crt.pem'
    #crtpath = 'DigiCertGlobalRootCA.crt.pem'

    # Connect to PostgreSQL
    cnx = psycopg2.connect(database="postgres",
        host="pgsqldevSUFFIXflex16.postgres.database.azure.com",
        user="wsuser",
        password=access_token,
        port="5432",
        sslmode='require',
        sslrootcert=crtpath)

    logging.info(cnx)
    # Show databases
    cursor = cnx.cursor()
    cursor.execute("SELECT datname FROM pg_catalog.pg_database;")
    result_list = cursor.fetchall()
    # Build result response text
    result_str_list = []
    for row in result_list:
        row_str = ', '.join([str(v) for v in row])
        result_str_list.append(row_str)
    result_str = '\n'.join(result_str_list)
    return func.HttpResponse(
        result_str,
        status_code=200
    )