using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.ManageTopic
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ManageTopicController : ApiController
    {
        [HttpGet]
        [Route("getTopic/userid={id}")]
        public IHttpActionResult GetTopicByID(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", id)
                };
            var result = new DB().GetDataReader("sp_ShowTeacherNameByFaculty", param);

            return Json(result);
        }

        [HttpPost, HttpGet]
        [Route("detail/topicid={id}")]
        public IHttpActionResult SelectTuVungByTopicID(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("TopicID", id)
                };
            var result = new DB().GetDataReader("sp_SelectTuVungByTopicID", param);

            return Json(result);
        }
    }
}
