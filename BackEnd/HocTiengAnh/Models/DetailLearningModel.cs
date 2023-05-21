using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HocTiengAnh.Models
{
    public class DetailLearningModel
    {
        public int AccountID { get; set; }
        public int VocabID { get; set; }
        public int TopicID { get; set; }
        public int Level { get; set; }
        public int WrongTimes { get; set; }
        public int Score { get; set; }
    }
}