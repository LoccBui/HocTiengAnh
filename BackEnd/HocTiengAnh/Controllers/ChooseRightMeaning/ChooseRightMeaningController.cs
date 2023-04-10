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

namespace HocTiengAnh.Controllers.ChooseRightMeaning
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ChooseRightMeaningController : ApiController
    {
        [HttpPost]
        [Route("getVietnameseMeaning")]
        public IHttpActionResult GetVietNameseMeaning(WordModel word)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@Word", word.Word),
                    new SqlParameter("@Vietnamese", word.Vietnamese),

            };

            var result = new DB().GetDataReader("sp_GetVietNameseRightMeaning", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
