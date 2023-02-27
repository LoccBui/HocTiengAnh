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
    [Route("getTopic/{id}")]
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class ShowTopicByFacultyController : ApiController
    {
        [HttpGet]
        public IHttpActionResult ShowTopicByFaculty(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", id)
                };
            var result = new DB().GetDataReader("sp_userFalculty", param);

            return Json(result);
        }
    }
}
