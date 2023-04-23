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

namespace HocTiengAnh.Controllers.Topic
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class TopicController : ApiController
    {

        public class NewClassDataModel
        {
            public int AccountID { get; set; }
            public int TopicID { get; set; }
        }

        [HttpPost]
        [Route("getStatusLearning")]
        public IHttpActionResult GetDataUserByID([FromBody] NewClassDataModel data)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", data.AccountID),
                    new SqlParameter("@TopicID", data.TopicID)
                };
            var result = new DB().GetDataReader("sp_GetStatusLearning", param);


            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
