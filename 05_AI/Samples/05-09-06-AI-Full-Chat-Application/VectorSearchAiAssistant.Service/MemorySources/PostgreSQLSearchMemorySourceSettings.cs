using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.MemorySource
{
    public record PostgreSQLSearchMemorySourceSettings
    {
        public required List<string> Tables { get; init; }
        public required string ConnectionString { get; init; }
    }
}
