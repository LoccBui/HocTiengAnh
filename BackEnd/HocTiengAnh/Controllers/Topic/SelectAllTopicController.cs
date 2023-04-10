using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.Topic
{
    [Route("SelectAllTopics")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class SelectAllTopicController : ApiController
    {
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_ShowAllTopic");

            return Json(result);
        }
    }
}
