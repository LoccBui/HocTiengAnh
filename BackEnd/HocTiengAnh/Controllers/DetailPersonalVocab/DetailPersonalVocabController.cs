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
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class DetailPersonalVocabController : ApiController
    {
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
    }
}
