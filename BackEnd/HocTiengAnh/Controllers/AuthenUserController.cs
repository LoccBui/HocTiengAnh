using QuanLySach.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    [Route("AuthenUser/{UserID}")]
    public class AuthenUserController : ApiController
    {
         [HttpGet]
        public IHttpActionResult SelectSachByID(int UserID)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@UserID", UserID)
                };
            var result = new DB().GetDataReader("spUser_AuthenUser", param);

            return Json(result);
        }
    }
}
