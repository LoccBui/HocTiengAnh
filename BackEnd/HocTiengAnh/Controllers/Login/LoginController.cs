using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using System.Web.Http.Results;
using HocTiengAnh.Database;

namespace HocTiengAnh.Controllers.Login
{
    [Route("login/{username}/{password}")]
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class LoginController : ApiController
    {
        [HttpPost]
        public IHttpActionResult Login(string username, string password)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("UserName", username),
                    new SqlParameter("UserPass", password)
                };
            var result = new DB().GetDataReader("sp_LoginAccount", param);
          
            return Json(result);




        }
    }
}
