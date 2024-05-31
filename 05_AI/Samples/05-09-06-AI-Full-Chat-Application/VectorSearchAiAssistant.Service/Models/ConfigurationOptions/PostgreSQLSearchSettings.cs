using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.Models.ConfigurationOptions
{
    public record PostgreSQLSearchSettings
    {
        public required string Schema { get; init; }
        public required string IndexName { get; init; }

        public required int VectorSize { get; init; }
        public required int MaxVectorSearchResults { get; init; }
        public required string ConnectionString { get; init; }
    }
}
