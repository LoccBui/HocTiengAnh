using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.ReviewWord
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ReviewWordController : ApiController
    {
        [HttpPost]
        [Route("ranking/topicid={id}")]
        public IHttpActionResult GetRanking(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@TopicID", id),
            };

            var result = new DB().GetDataReader("sp_GetRanking", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
