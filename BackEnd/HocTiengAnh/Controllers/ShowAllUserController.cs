using QuanLySach.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    [Route("SelectAllUser")]
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
