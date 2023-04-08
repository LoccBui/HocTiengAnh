using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.DetailVocab
{
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class DetailVocabController : ApiController
    {
        [Route("vocabdetail/topicid={id}")]
        [HttpGet]
        public IHttpActionResult SelectTuVungByTopicID(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("TopicID", id)
                };
            var result = new DB().GetDataReader("sp_ShowDetailVocab", param);

            return Json(result);
        }
    }
}
