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
    [Route("ChangeToAdmin")]
    public class ChangeToAdminController : ApiController
    {
        [HttpPut]
        public string AddSach(UsersModel user)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@UserID",user.UserID)
            };

            var result = new DB().GetDataReader("spUser_ChangeToAdmin", param);
            string respone = String.Empty;

            if (result != null)
            {
                respone = "Cập nhật quyền thành công!";
            }
            else
            {
                respone = "Cập nhật quyền không thành công";
            }

            return respone;
        }
    }
}
