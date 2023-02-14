using QuanLySach.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace QuanLySach.Controllers
{
    [Route("SelectAllUser")]
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class ShowAllUserController : ApiController
    {
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("spUser_SelectAll");
            return Json(result);
        }  
    }
}
