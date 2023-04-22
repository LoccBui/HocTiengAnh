using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HocTiengAnh.Models
{
    public class DetailPersonalVocabModel
    {
        public int PersonalDetailID { get; set; }
        public int PersonalVocabID { get; set; }
        public int VocabID { get; set; }
        public int AccountID { get; set; }
    }
}