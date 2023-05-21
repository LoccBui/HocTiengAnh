using HocTiengAnh.Database;
using HocTiengAnh.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace HocTiengAnh.Controllers.DetailLearning
{
    [Authorize]
    [Route("detailLearning")]
    public class DetailLearningController : ApiController
    {
        [HttpPost]
        public IHttpActionResult AddVocabToDetailLearning(DetailLearningModel detail)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", detail.AccountID),
                    new SqlParameter("@VocabID", detail.VocabID),
                    new SqlParameter("@TopicID", detail.TopicID),
                    new SqlParameter("@Level", detail.Level),
                    new SqlParameter("@WrongTimes", detail.WrongTimes),
                    new SqlParameter("@Score", detail.Score)
                };
            var result = new DB().GetDataReader("sp_AddVocabToDetailLearning", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
