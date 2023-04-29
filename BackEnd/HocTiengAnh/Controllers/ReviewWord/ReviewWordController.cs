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
        [Authorize]
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

        [HttpPost]
        [Route("addToPersonalVocab")]
        public IHttpActionResult GetPersonalCollection(DetailPersonalVocabModel vocabPersonDetail)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@PersonalVocabID", vocabPersonDetail.PersonalVocabID),
                    new SqlParameter("@VocabID", vocabPersonDetail.VocabID),
                    new SqlParameter("@AccountID", vocabPersonDetail.AccountID)
            };

            var result = new DB().GetDataReader("sp_AddToPersonalVocab", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        
        }



        [HttpPost]
        [Route("wordExists")]
        public IHttpActionResult CheckWordExists(DetailPersonalVocabModel vocabPersonDetail)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@PersonalVocabID", vocabPersonDetail.PersonalVocabID),
                    new SqlParameter("@VocabID", vocabPersonDetail.VocabID),
                    new SqlParameter("@AccountID", vocabPersonDetail.AccountID)
            };

            var result = new DB().GetDataReader("sp_CheckWordPersonExists", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
