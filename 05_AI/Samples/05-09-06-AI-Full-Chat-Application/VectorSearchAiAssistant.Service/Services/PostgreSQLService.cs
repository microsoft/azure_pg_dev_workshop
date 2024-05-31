using Azure.Search.Documents;
using Azure.Search.Documents.Models;
using Castle.Core.Resource;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.SemanticKernel.AI.Embeddings;
using Microsoft.SemanticKernel.Connectors.Postgres;
using Newtonsoft.Json;
using Npgsql;
using NpgsqlTypes;
using Pgvector;
using System.Diagnostics;
using VectorSearchAiAssistant.SemanticKernel.TextEmbedding;
using VectorSearchAiAssistant.Service.Interfaces;
using VectorSearchAiAssistant.Service.Models;
using VectorSearchAiAssistant.Service.Models.Chat;
using VectorSearchAiAssistant.Service.Models.ConfigurationOptions;
using VectorSearchAiAssistant.Service.Models.Search;
using Message = VectorSearchAiAssistant.Service.Models.Chat.Message;

namespace VectorSearchAiAssistant.Service.Services
{
    /// <summary>
    /// Service to access PostgreSQL.
    /// </summary>
    public class PostgreSQLService : IPostgreSQLService, ICognitiveSearchService
    {
        private PostgresDbClient _client;
        private NpgsqlConnection _connection;
        private NpgsqlDataSource _dataSource;
        private readonly Database _database;
        readonly Dictionary<string, Type> _memoryTypes;

        private IRAGService _ragService;
        //readonly PostgreSQLSearchSettings _settings;
        private readonly PostgreSQLSettings _settings;
        readonly ILogger _logger;

        public PostgreSQLService(
            IRAGService ragService,
        IOptions<PostgreSQLSettings> settings, 
            ILogger<PostgreSQLService> logger)
        {
            _ragService = ragService;   
            _settings = settings.Value;
            ArgumentException.ThrowIfNullOrEmpty(_settings.ConnectionString);
            ArgumentException.ThrowIfNullOrEmpty(_settings.Database);

            _logger = logger;

            _logger.LogInformation("Initializing PostgreSQL service.");

            if (!_settings.EnableTracing)
            {
                Type defaultTrace = Type.GetType("Microsoft.Azure.Cosmos.Core.Trace.DefaultTrace,Microsoft.Azure.Cosmos.Direct");
                TraceSource traceSource = (TraceSource)defaultTrace.GetProperty("TraceSource").GetValue(null);
                traceSource.Switch.Level = SourceLevels.All;
                traceSource.Listeners.Clear();
            }

            CosmosSerializationOptions options = new()
            {
                PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase
            };


            var dataSourceBuilder = new NpgsqlDataSourceBuilder(_settings.ConnectionString);
            dataSourceBuilder.EnableDynamicJson();
            dataSourceBuilder.UseVector();
            _dataSource = dataSourceBuilder.Build();

            _memoryTypes = ModelRegistry.Models.ToDictionary(m => m.Key, m => m.Value.Type);

            _client = new PostgresDbClient(_dataSource, "public", _settings.VectorSize);
            _client.CreateTableAsync(_settings.IndexName).Wait();

            _logger.LogInformation("PostgreSQL service initialized.");
        }

        /// <summary>
        /// Initialize the underlying Azure Cognitive Search index.
        /// </summary>
        /// <param name="typesToIndex">The object types supported by the index.</param>
        /// <returns></returns>
        public async Task Initialize(List<Type> types)
        {
            try
            {
                //https://github.com/pgvector/pgvector-dotnet

                //create the table
                using var cmd = new NpgsqlCommand();
                cmd.Connection = _dataSource.OpenConnection();

                _client.CreateTableAsync(_settings.IndexName).Wait();

                _logger.LogInformation($"Created the {_settings.IndexName} index.");
            }
            catch (Exception e)
            {
                _logger.LogError($"An error occurred while trying to build the {_settings.IndexName} index: {e}");
            }
        }

        public async Task IndexItem(object item)
        {
            await _ragService.AddMemory(item, item.GetType().Name);
        }

        public async Task RemoveItem(object item)
        {
            await _ragService.AddMemory(item, item.GetType().Name);
        }

        public async Task<Response<SearchResults<SearchDocument>>> SearchAsync(SearchOptions options)
        {
            var connection = _dataSource.OpenConnection();

            await using (var cmd = new NpgsqlCommand($"SELECT * FROM {_settings.IndexName} ORDER BY embedding <-> $1 LIMIT 5", connection))
            {
                foreach (var vq in options.VectorQueries)
                {
                    float[] in_vectors = null;
                    var embedding = new Vector(in_vectors);
                    cmd.Parameters.AddWithValue(embedding);

                    await using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            Console.WriteLine(reader.GetValue(0));
                        }
                    }
                }
            }

            return null;
        }

        public async Task Initalize()
        {
            await using (var cmd = new NpgsqlCommand("CREATE EXTENSION IF NOT EXISTS vector", _connection))
            {
                await cmd.ExecuteNonQueryAsync();
            }

            _connection.ReloadTypes();

            await using (var cmd = new NpgsqlCommand("CREATE TABLE vectors (key serial PRIMARY KEY, embedding vector(1536))", _connection))
            {
                await cmd.ExecuteNonQueryAsync();
            }
        }
      
        /// <summary>
        /// Gets a list of all current chat sessions.
        /// </summary>
        /// <returns>List of distinct chat session items.</returns>
        public async Task<List<Session>> GetSessionsAsync()
        {
            List<Session> output = new();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            await using (connection)
            {
                using var cmd = new NpgsqlCommand();
                cmd.Connection = connection;

                cmd.CommandText = $"select data::text from session";
                NpgsqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string data = reader["data"].ToString();
                    Session s = JsonConvert.DeserializeObject<Session>(data);
                    output.Add(s);
                }

                reader.Close();
            }

            return output;
        }

        /// <summary>
        /// Performs a point read to retrieve a single chat session item.
        /// </summary>
        /// <returns>The chat session item.</returns>
        public Task<Session> GetSessionAsync(string id)
        {
            List<Session> sessions = GetSessions($"select data from session where sessionId = '{id}'");

            return Task.FromResult(sessions[0]);
        }

        public List<Session> GetSessions(string sql)
        {
            List<Session> result = new List<Session>();
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.CommandText = sql;
                cmd.Connection = connection;
                NpgsqlDataReader reader = cmd.ExecuteReader();
                List<string> sessions = new List<string>();

                while (reader.Read())
                {
                    sessions.Add(reader["data"].ToString());
                }

                reader.Close();

                foreach (string session in sessions)
                {
                    result.Add(JsonConvert.DeserializeObject<Session>(session));
                }
            }

            return result;
        }

        public List<Message> GetMessages(string sql)
        {
            List<Message> result = new List<Message>();
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.CommandText = sql;
                cmd.Connection = connection;
                NpgsqlDataReader reader = cmd.ExecuteReader();
                List<string> messages = new List<string>();

                while (reader.Read())
                {
                    messages.Add(reader["data"].ToString());
                }

                reader.Close();

                foreach (string message in messages)
                {
                    result.Add(JsonConvert.DeserializeObject<Message>(message));
                }
            }

            return result;
        }

        public List<Product> GetProducts(string sql)
        {
            List<Product> result = new List<Product>();
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.CommandText = sql;
                cmd.Connection = connection;
                NpgsqlDataReader reader = cmd.ExecuteReader();
                List<string> messages = new List<string>();

                while (reader.Read())
                {
                    messages.Add(reader["data"].ToString());
                }

                reader.Close();

                foreach (string message in messages)
                {
                    result.Add(JsonConvert.DeserializeObject<Product>(message));
                }
            }

            return result;
        }

        /// <summary>
        /// Gets a list of all current chat messages for a specified session identifier.
        /// </summary>
        /// <param name="sessionId">Chat session identifier used to filter messsages.</param>
        /// <returns>List of chat message items for the specified session.</returns>
        public Task<List<Message>> GetSessionMessagesAsync(string sessionId)
        {
            List<Message> messages = GetMessages($"SELECT * FROM message WHERE sessionId = '{sessionId}'");

            return Task.FromResult(messages);
        }

        /// <summary>
        /// Creates a new chat session.
        /// </summary>
        /// <param name="session">Chat session item to create.</param>
        /// <returns>Newly created chat session item.</returns>
        public async Task<Session> InsertSessionAsync(Session session)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection = connection;
                cmd.CommandText = $"insert into session (sessionId, data) values (@p1, @p2)";
                cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Text, session.Id);
                cmd.Parameters.AddWithValue("p2", NpgsqlDbType.Jsonb, JsonConvert.SerializeObject(session));
                cmd.Parameters.Add(new NpgsqlParameter { ParameterName = "ret", Direction = System.Data.ParameterDirection.ReturnValue });
                cmd.ExecuteNonQuery();
            }
            return session;
        }

        /// <summary>
        /// Creates a new chat message.
        /// </summary>
        /// <param name="message">Chat message item to create.</param>
        /// <returns>Newly created chat message item.</returns>
        public async Task<Message> InsertMessageAsync(Message message)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.CommandText = $"insert into message (sessionId, data) values (@p1, @p2)  RETURNING id";
                cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Text, message.SessionId);
                cmd.Parameters.AddWithValue("p2", NpgsqlDbType.Jsonb, message);
                cmd.Parameters.Add(new NpgsqlParameter { ParameterName = "ret", Direction = System.Data.ParameterDirection.ReturnValue });
                message.Id = cmd.ExecuteScalar().ToString();
                cmd.ExecuteNonQuery();
            }

            return message;
        }

        /// <summary>
        /// Updates an existing chat message.
        /// </summary>
        /// <param name="message">Chat message item to update.</param>
        /// <returns>Revised chat message item.</returns>
        public async Task<Message> UpdateMessageAsync(Message message)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection = connection;
                cmd.CommandText = $"update message set data = @p1 where id = {message.Id}";
                cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Jsonb, message);
                await cmd.ExecuteNonQueryAsync();
            }

            return message;
        }

        /// <summary>
        /// Updates a message's rating through a patch operation.
        /// </summary>
        /// <param name="id">The message id.</param>
        /// <param name="sessionId">The message's partition key (session id).</param>
        /// <param name="rating">The rating to replace.</param>
        /// <returns>Revised chat message item.</returns>
        public async Task<Message> UpdateMessageRatingAsync(string id, string sessionId, bool? rating)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.CommandText = $"update message set data['rating'] = {rating} where id = {id}";
                await cmd.ExecuteNonQueryAsync();
            }

            return GetMessages($"select * from message with id = {id}")[0];
        }

        /// <summary>
        /// Updates an existing chat session.
        /// </summary>
        /// <param name="session">Chat session item to update.</param>
        /// <returns>Revised created chat session item.</returns>
        public async Task<Session> UpdateSessionAsync(Session session)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection = connection;
                cmd.CommandText = $"update message set data = @p1 where id = {session.Id}";
                cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Jsonb, session);
                await cmd.ExecuteNonQueryAsync();
            }

            return session;
        }

        /// <summary>
        /// Updates a session's name through a patch operation.
        /// </summary>
        /// <param name="id">The session id.</param>
        /// <param name="name">The session's new name.</param>
        /// <returns>Revised chat session item.</returns>
        public async Task<Session> UpdateSessionNameAsync(string id, string name)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection = connection;
                cmd.CommandText = $"update session set data[\"Name\"] = '{name}' where sessionId = '{id}'";
                await cmd.ExecuteNonQueryAsync();
            }

            return GetSessions($"select * from session where sessionId = '{id}'")[0];
        }

        /// <summary>
        /// Batch create or update chat messages and session.
        /// </summary>
        /// <param name="messages">Chat message and session items to create or replace.</param>
        public async Task UpsertSessionBatchAsync(params dynamic[] messages)
        {
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                foreach (object obj in messages)
                {
                    using var cmd = new NpgsqlCommand();
                    cmd.Connection = connection;

                    switch (obj.GetType().Name)
                    {
                        case "Message":
                            Message message = (Message)obj;
                            cmd.CommandText = $@"
                            INSERT INTO message (id, sessionId, data)
                            VALUES(@p1, @p2, @p3)
                            ON CONFLICT (id)
                            DO UPDATE SET data=@p3";
                            cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Text, message.Id);
                            cmd.Parameters.AddWithValue("p2", NpgsqlDbType.Text, message.SessionId);
                            //cmd.Parameters.AddWithValue("p3", NpgsqlDbType.Jsonb, message);
                            cmd.Parameters.AddWithValue("p3", NpgsqlDbType.Jsonb, JsonConvert.SerializeObject(message));
                            await cmd.ExecuteNonQueryAsync();
                            break;
                        case "Session":
                            Session session = (Session)obj;
                            cmd.CommandText = $@"
                            INSERT INTO session (sessionId, data)
                            VALUES(@p1, @p2)
                            ON CONFLICT (sessionId)
                            DO UPDATE SET data=@p2";
                            cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Text, session.SessionId);
                            //cmd.Parameters.AddWithValue("p2", NpgsqlDbType.Jsonb, session);
                            cmd.Parameters.AddWithValue("p2", NpgsqlDbType.Jsonb, JsonConvert.SerializeObject(session));
                            await cmd.ExecuteNonQueryAsync();
                            break;
                    }
                    
                }
            }
        }

        /// <summary>
        /// Batch deletes an existing chat session and all related messages.
        /// </summary>
        /// <param name="sessionId">Chat session identifier used to flag messages and sessions for deletion.</param>
        public async Task DeleteSessionAndMessagesAsync(string sessionId)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection = connection;
                cmd.CommandText = $"delete from session where sessionId = '{sessionId}'";
                await cmd.ExecuteNonQueryAsync();
            }
        }

        /// <summary>
        /// Inserts a product into the product container.
        /// </summary>
        /// <param name="product">Product item to create.</param>
        /// <returns>Newly created product item.</returns>
        public async Task<Product> InsertProductAsync(Product product)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection= connection;
                cmd.CommandText = $"insert into product (id, data) values ('{product.id}', @p1)" +
                    $"ON CONFLICT (id) DO UPDATE SET data=@p1";
                cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Jsonb, JsonConvert.SerializeObject(product));
                //cmd.Parameters.Add(new NpgsqlParameter { ParameterName = "ret", Direction = System.Data.ParameterDirection.ReturnValue });
                await cmd.ExecuteNonQueryAsync();
                //product.id = cmd.Parameters["ret"].Value.ToString();
                return product;
            }

            return null;
        }

        /// <summary>
        /// Inserts a customer into the customer container.
        /// </summary>
        /// <param name="product">Customer item to create.</param>
        /// <returns>Newly created customer item.</returns>
        public async Task<Customer> InsertCustomerAsync(Customer customer)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection = connection;
                cmd.CommandText = $"insert into customer values ('{customer.id}', @p1)" +
                    $"ON CONFLICT (id) DO UPDATE SET data=@p1";
                cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Jsonb, JsonConvert.SerializeObject(customer));
                //cmd.Parameters.Add(new NpgsqlParameter { ParameterName = "ret", Direction = System.Data.ParameterDirection.ReturnValue });
                await cmd.ExecuteNonQueryAsync();
                //customer.id = cmd.Parameters["ret"].Value.ToString();
                return customer;
            }

            return null;
        }

        /// <summary>
        /// Inserts a sales order into the customer container.
        /// </summary>
        /// <param name="product">Sales order item to create.</param>
        /// <returns>Newly created sales order item.</returns>
        public async Task<SalesOrder> InsertSalesOrderAsync(SalesOrder salesOrder)
        {
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection = connection;
                cmd.CommandText = $"insert into salesorder values ('{salesOrder.id}', @p1)" + 
                    $"ON CONFLICT (id) DO UPDATE SET data=@p1";
                cmd.Parameters.AddWithValue("p1", NpgsqlDbType.Jsonb, JsonConvert.SerializeObject(salesOrder));
                //cmd.Parameters.Add(new NpgsqlParameter { ParameterName = "ret", Direction = System.Data.ParameterDirection.ReturnValue });
                await cmd.ExecuteNonQueryAsync();
                //salesOrder.id = cmd.Parameters["ret"].Value.ToString();
                return salesOrder;
            }

            return null;
        }

        /// <summary>
        /// Deletes a product by its Id and category (its partition key).
        /// </summary>
        /// <param name="productId">The Id of the product to delete.</param>
        /// <param name="categoryId">The category Id of the product to delete.</param>
        /// <returns></returns>
        public async Task DeleteProductAsync(string productId, string categoryId)
        {   
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {
                cmd.Connection = connection;
                cmd.CommandText = $"delete from product where id = '{productId}'";
                await cmd.ExecuteNonQueryAsync();
            }
        }

        /// <summary>
        /// Reads all documents retrieved by Vector Search.
        /// </summary>
        /// <param name="vectorDocuments">List string of JSON documents from vector search results</param>
        public async Task<string> GetVectorSearchDocumentsAsync(List<DocumentVector> vectorDocuments)
        {

            List<string> searchDocuments = new List<string>();

            foreach (var document in vectorDocuments)
            {

                try
                {
                    string query = $"select * from {document.containerName}";
                    using var cmd = new NpgsqlCommand();
                    NpgsqlConnection connection = _dataSource.OpenConnection();

                    using (connection)
                    {

                        cmd.CommandText = query;
                        NpgsqlDataReader reader = cmd.ExecuteReader();
                        List<string> items = new List<string>();

                        while (reader.Read())
                        {
                            searchDocuments.Add(reader["data"].ToString());
                        }

                        reader.Close();
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex.Message, ex);

                }
            }

            var resultDocuments = string.Join(Environment.NewLine + "-", searchDocuments);

            return resultDocuments;

        }

        public async Task<CompletionPrompt> GetCompletionPrompt(string sessionId, string completionPromptId)
        {
            List<string> sessions = new List<string>();
            using var cmd = new NpgsqlCommand();
            NpgsqlConnection connection = _dataSource.OpenConnection();

            using (connection)
            {

                cmd.CommandText = $"select * from completionprompt where id = {completionPromptId}";
                NpgsqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    sessions.Add(reader["data"].ToString());
                }

                reader.Close();
            }
            
            List<CompletionPrompt> result = new List<CompletionPrompt>();

            foreach (string session in sessions)
            {
                result.Add(JsonConvert.DeserializeObject<CompletionPrompt>(session));
            }

            return result[0];
        }

        Task<Azure.Response<SearchResults<SearchDocument>>> ICognitiveSearchService.SearchAsync(SearchOptions searchOptions)
        {
            throw new NotImplementedException();
        }
    }
}
