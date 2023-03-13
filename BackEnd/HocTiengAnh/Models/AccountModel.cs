using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HocTiengAnh.Models
{
    public class AccountModel
    {
        public int AccountID { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public int Active { get; set; }
        public int RoleID { get; set; }
    }
}