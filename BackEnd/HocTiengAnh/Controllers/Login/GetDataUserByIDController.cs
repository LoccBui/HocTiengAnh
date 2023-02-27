using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.Login
{
    [Route("user/id={id}")]
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class GetDataUserByIDController : ApiController
    {
        [HttpGet]
        public IHttpActionResult GetDataUserByID(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", id)
                };
            var result = new DB().GetDataReader("sp_AuthUser", param);

            return Json(result);
        }
    }
}
