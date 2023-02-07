using QuanLySach.Database;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    [Route("AuthLogin/{username}/{password}")]
    public class UserController : ApiController
    {
        [HttpGet]
        public IHttpActionResult UserLogin(string username, string password)
        {
                SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("UserName",username),
                    new SqlParameter("UserPass", password)
                };
                var result = new DB().GetDataReader("spSach_UserLogin", param);

                return Json(result);
            
               
        }
    }
}
