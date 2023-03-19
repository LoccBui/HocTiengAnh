using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HocTiengAnh.Models
{
    public class WordModel
    {
        public int VocabID { get; set; }
        public int TopicID { get; set; }
        public int Frequency { get; set; }
        public string Word { get; set; }
        public string IPA { get; set; }
        public string Label { get; set; }
        public string Lemma { get; set; }
        public string Vietnamese { get; set; }
        public string Cluster { get; set; }
        public string Position { get; set; }
        
        public string Example { get; set; }
        public string VN_Example { get; set; }
        public string Resources { get; set; }
        public int Active { get; set; }
        public int Learned { get; set; }
        public int Level { get; set; }

    }
}