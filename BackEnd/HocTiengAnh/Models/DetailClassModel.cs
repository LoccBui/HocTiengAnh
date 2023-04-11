using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HocTiengAnh.Models
{
    public class DetailClassModel
    {
        public int DetailID { get; set; }
        public int MaSV { get; set; }
        public int MaGV { get; set; }
        public int IDCLASS { get; set; }
        public int IsApproved { get; set; }
    }
}