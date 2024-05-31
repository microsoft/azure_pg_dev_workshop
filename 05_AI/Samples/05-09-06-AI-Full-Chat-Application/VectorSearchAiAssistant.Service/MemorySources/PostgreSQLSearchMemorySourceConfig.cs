using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.MemorySource
{
    public class PostgreSQLSearchMemorySourceConfig
    {
        public List<FacetedQueryMemorySource> FacetedQueryMemorySources { get; set; }
    }
}
