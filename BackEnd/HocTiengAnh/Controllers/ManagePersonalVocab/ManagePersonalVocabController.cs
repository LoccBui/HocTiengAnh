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

namespace HocTiengAnh.Controllers.ManagePersonalVocab
{


    public class ManagePersonalVocabController : ApiController
    {
        [HttpPost]
        [Route("getPersonalVocab")]
        public IHttpActionResult GetPersonalVocab(PersonalVocabModel personalVocab)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", personalVocab.AccountID),
            };

            var result = new DB().GetDataReader("sp_SelectAllPersonalVocab", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [HttpPost]
        [Route("deletePersonalVocab")]
        public IHttpActionResult deletePersonalVocab(PersonalVocabModel personalVocab)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", personalVocab.AccountID),
                    new SqlParameter("@PersonalVocabID", personalVocab.PersonalVocabID),
            };

            var result = new DB().GetDataReader("sp_DeletePersonalVocab", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
