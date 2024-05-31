using VectorSearchAiAssistant.Service.Interfaces;
using VectorSearchAiAssistant.Service.MemorySource;
using VectorSearchAiAssistant.Service.Models.ConfigurationOptions;
using VectorSearchAiAssistant.Service.Services;

namespace ChatServiceWebApi
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddApplicationInsightsTelemetry();


            builder.Services.AddOptions<PostgreSQLSettings>()
                .Bind(builder.Configuration.GetSection("MSPostgreSQLOpenAI:PostgreSQLSearch"));

            builder.Services.AddOptions<SemanticKernelRAGServiceSettings>()
                .Bind(builder.Configuration.GetSection("MSPostgreSQLOpenAI"));

            builder.Services.AddSingleton<IPostgreSQLService, PostgreSQLService>();

            builder.Services.AddSingleton<IRAGService, SemanticKernelRAGService>();
            builder.Services.AddSingleton<IChatService, ChatService>();

            // Simple, static system prompt service
            //builder.Services.AddSingleton<ISystemPromptService, InMemorySystemPromptService>();

            // System prompt service backed by an Azure blob storage account
            builder.Services.AddOptions<DurableSystemPromptServiceSettings>()
                .Bind(builder.Configuration.GetSection("MSPostgreSQLOpenAI:DurableSystemPrompt"));
            builder.Services.AddSingleton<ISystemPromptService, DurableSystemPromptService>();

            /*
            builder.Services.AddOptions<AzureCognitiveSearchMemorySourceSettings>()
                .Bind(builder.Configuration.GetSection("MSPostgreSQLOpenAI:CognitiveSearchMemorySource"));
            builder.Services.AddTransient<IMemorySource, AzureCognitiveSearchMemorySource>();
            */

            builder.Services.AddOptions<PostgreSQLSearchMemorySourceSettings>()
                .Bind(builder.Configuration.GetSection("MSPostgreSQLOpenAI:PostgreSQLMemorySource"));
            builder.Services.AddTransient<IMemorySource, PostgreSQLSearchMemorySource>();

            builder.Services.AddOptions<BlobStorageMemorySourceSettings>()
                .Bind(builder.Configuration.GetSection("MSPostgreSQLOpenAI:BlobStorageMemorySource"));
            builder.Services.AddTransient<IMemorySource, BlobStorageMemorySource>();

            builder.Services.AddScoped<ChatEndpoints>();

            // Add services to the container.
            builder.Services.AddAuthorization();

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            app.UseExceptionHandler(exceptionHandlerApp
                    => exceptionHandlerApp.Run(async context
                        => await Results.Problem().ExecuteAsync(context)));

            // Configure the HTTP request pipeline.
            app.UseSwagger();
            app.UseSwaggerUI();

            app.UseAuthorization();

            // Map the chat REST endpoints:
            using (var scope = app.Services.CreateScope())
            {
                var service = scope.ServiceProvider.GetService<ChatEndpoints>();
                service?.Map(app);
            }

            app.Run();
        }
    }
}