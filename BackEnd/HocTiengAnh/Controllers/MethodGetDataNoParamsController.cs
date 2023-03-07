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
    [Route("getData")]
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class MethodGetDataNoParamsController : ApiController
    {
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_SelectAllFaculty");

            return Json(result);
        }
    }
}
