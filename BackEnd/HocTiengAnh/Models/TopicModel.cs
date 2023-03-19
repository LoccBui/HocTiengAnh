using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HocTiengAnh.Models
{
    public class TopicModel
    {
        public int TopicID { get; set; }
        public int IDFACULTY { get; set; }
        public string TopicName { get; set; }
        public string TopicDescribe { get; set; }
        public int QuantityWords { get; set; }
        public int Active { get; set; }
        public string CreatedBy { get; set; }
    }
}