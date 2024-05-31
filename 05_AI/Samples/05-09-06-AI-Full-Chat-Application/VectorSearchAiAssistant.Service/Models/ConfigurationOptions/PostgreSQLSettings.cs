using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.Models.ConfigurationOptions
{
    public record PostgreSQLSettings
    {
        public required string ConnectionString { get; init; }

        public required string Database { get; init; }

        public bool EnableTracing { get; init; }

        public required string IndexName { get; init; }

        public required int VectorSize { get; init; }
        public required int MaxVectorSearchResults { get; init; }
    }
}
