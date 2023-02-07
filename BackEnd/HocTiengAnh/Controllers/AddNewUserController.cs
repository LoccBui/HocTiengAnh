using QuanLySach.Database;
using QuanLySach.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    [Route("AddNewUser")]
    public class AddNewUserController : ApiController
    {
        [HttpPost]
        public string AddSach(UsersModel user)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@Username",user.Username),
                    new SqlParameter("@UserPass",user.Userpass),
            };

            var result = new DB().GetDataReader("spUsers_AddNew", param);
            string respone = String.Empty;

            if (result != null)
            {
                respone = "Thêm thành công";
            }
            else
            {
                respone = "Thêm không thành công";
            }

            return respone;
        }
    }
}
