using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers
{
    [Route("getEmail/{email}")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ValidEmailController : ApiController
    {
        [HttpGet]
        public IHttpActionResult ValidEmail(string email)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@Email", email)
                };
            var result = new DB().GetDataReader("sp_CheckEmailValid", param);

            return Json(result);
        }
    }
}
