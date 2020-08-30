using System;
using System.IO;
using Lucene.Net.Index;
using Lucene.Net.Search;
using Lucene.Net.Store;
using Lucene.Net.Util;

namespace searcher
{
  class Program
  {
    static void Main(string[] args)
    {
       var AppLuceneVersion = LuceneVersion.LUCENE_48;
      // search with a phrase
      var phrase = new MultiPhraseQuery();
      phrase.Add(new Term("hanzi", "我"));
      // re-use the writer to get real-time updates
      var reader =  DirectoryReader.Open( FSDirectory.Open(new DirectoryInfo("../../output/lucene")));
      var searcher = new IndexSearcher(reader);
      var hits = searcher.Search(phrase, 20 /* top 20 */).ScoreDocs;
      foreach (var hit in hits)
      {
        var foundDoc = searcher.Doc(hit.Doc);
        var docId = foundDoc.Get("doc_id");
        Console.WriteLine($"{hit.Score} {docId}");
      }
    }
  }
}
