using QuanLySach.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    [Route("SelectAllNXB")]

    public class ShowAllNXBController : ApiController
    {
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("spSach_SelectAllNXB");
            return Json(result);
        }  
    }
}
