using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QuanLySach.Models
{
    public class SachModel
    {
        public int MaSach { get; set; }
        public string TenSach { get; set; }
        public string MoTa { get; set; }
        public DateTime NgayCapNhat { get; set; }
        public int MaNXB { get; set; }
        public string Image { get; set; }
    }
}