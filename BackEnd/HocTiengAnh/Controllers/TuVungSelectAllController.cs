using HocTiengAnh.Database;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers
{
    [Route("SelectAllTuVung")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class TuVungSelectAllController : ApiController
    {
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_SelectAllTuVung");

            return Json(result);
        }

    }
}
