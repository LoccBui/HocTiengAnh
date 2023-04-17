using HocTiengAnh.Database;
using HocTiengAnh.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.AnalystLearning
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class AnalystLearningController : ApiController
    {
        [HttpPost]
        [Route("wrongTimesTopic")]
        public IHttpActionResult AnalystMostWrongTopic(TopicModel topicModel)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("TopicID", topicModel.TopicID)
                };
            var result = new DB().GetDataReader("sp_MostWrongWordByTopic", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [HttpPost]
        [Route("topicScore")]
        public IHttpActionResult MostScoreTopic(TopicModel topicModel)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("TopicID", topicModel.TopicID)
                };
            var result = new DB().GetDataReader("sp_MostScoreInTopic", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
