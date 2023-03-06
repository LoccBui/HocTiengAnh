using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.Manage_Class
{
    [Route("SelectAllClasses")]
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class ShowAllClassController : ApiController
    {
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_ShowAllClass");

            return Json(result);
        }
    }
}
