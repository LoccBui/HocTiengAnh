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

namespace HocTiengAnh.Controllers.ListenAndChoose
{
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class ListenAndChooseController : ApiController
    {
        [HttpPost]
        [Route("getDataListenAndChoose")]
        public IHttpActionResult AddInfoNewUser(WordModel word)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@Word", word.Word)
            };

            var result = new DB().GetDataReader("sp_GetDataListenAndChoose", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
