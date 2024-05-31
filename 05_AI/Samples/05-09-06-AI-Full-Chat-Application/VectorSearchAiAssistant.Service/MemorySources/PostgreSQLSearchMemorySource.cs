using Azure.Search.Documents;
using Microsoft.Extensions.Logging;
using Azure.Search.Documents.Models;
using Azure.Storage.Blobs;
using Newtonsoft.Json;
using Microsoft.Extensions.Options;
using VectorSearchAiAssistant.Service.Interfaces;

namespace VectorSearchAiAssistant.Service.MemorySource
{
    public class PostgreSQLSearchMemorySource : IMemorySource
    {
        private readonly PostgreSQLSearchMemorySourceSettings _settings;
        private readonly ILogger _logger;

        private PostgreSQLSearchMemorySourceConfig _config;

        public PostgreSQLSearchMemorySource(
            IOptions<PostgreSQLSearchMemorySourceSettings> settings,
            ILogger<PostgreSQLSearchMemorySource> logger)
        {
            _settings = settings.Value;
            _logger = logger;
        }


        /// <summary>
        /// This function runs faceted queries to count all of the products in a product category and all the products for the company.
        /// This data is then vectorized and stored in semantic kernel's short term memory to use as a source of data for any vector queries.
        /// </summary>
        /// <returns></returns>
        public async Task<List<string>> GetMemories()
        {
            var memories = new List<string>();

            //get list of all products
            //TODO

            /*
            foreach (var table in this._settings.Tables)
            {
                memories.Add(string.Format(facetTemplates[facet.Key],facetResult.Value, facetResult.Count));totalCount += facetResult.Count.Value;
            }
            */

            //This is the faceted query for counting all the products
            //memories.Add(string.Format(memorySource.TotalCountMemoryTemplate, totalCount));

            return memories;
        }
    }
}
