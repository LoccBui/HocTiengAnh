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

namespace HocTiengAnh.Controllers.ReviewWord
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ReviewWordController : ApiController
    {
        [HttpPost]
        [Route("rankingTopic")]
        public IHttpActionResult GetRanking(TopicModel topic)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@TopicID", topic.TopicID)
            };

            var result = new DB().GetDataReader("sp_GetRanking", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [HttpPost]
        [Route("getPersonalCollection")]
        public IHttpActionResult GetPersonalCollection(AccountModel acc)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", acc.AccountID)
            };

            var result = new DB().GetDataReader("sp_GetPersonalWordCollection", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
