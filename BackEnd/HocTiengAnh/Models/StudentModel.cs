﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HocTiengAnh.Models
{
    public class StudentModel
    {
        public int MaSV { get; set; }
        public int AccountID { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public DateTime DateCreated { get; set; }
        public int IDCLASS { get; set; }
    }
}