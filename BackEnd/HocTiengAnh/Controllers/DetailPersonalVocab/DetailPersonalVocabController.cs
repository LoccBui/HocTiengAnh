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

namespace HocTiengAnh.Controllers.DetailPersonalVocab
{
    public class DetailPersonalVocabController : ApiController
    {
        [Authorize]
        [HttpPost]
        [Route("detailPersonalVocab")]
        public IHttpActionResult DetailPersonalVocab(PersonalVocabModel personalVocab)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", personalVocab.AccountID),
                    new SqlParameter("@PersonalVocabID", personalVocab.PersonalVocabID),
            };

            var result = new DB().GetDataReader("sp_SelectVocabFromCollection", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [Authorize]
        [HttpPost]
        [Route("deleteVocabOfCollection")]
        public IHttpActionResult DeleteVocabOfCollection(DetailPersonalVocabModel personalVocab)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", personalVocab.AccountID),
                    new SqlParameter("@PersonalDetailID", personalVocab.PersonalDetailID),
            };

            var result = new DB().GetDataReader("sp_DeleteVocabOfPerson", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [Authorize]
        [HttpPatch]
        [Route("changeCollectionName")]
        public IHttpActionResult ChangeCollectionName(PersonalVocabModel personalVocab)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@PersonalVocabID", personalVocab.PersonalVocabID),
                    new SqlParameter("@PersonalVocabName", personalVocab.PersonalVocabName),
            };

            var result = new DB().GetDataReader("sp_ChangePersonalVocabName", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
