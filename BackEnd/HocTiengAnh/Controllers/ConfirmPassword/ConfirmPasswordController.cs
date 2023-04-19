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

namespace HocTiengAnh.Controllers.ConfirmPassword
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ConfirmPasswordController : ApiController
    {
        [HttpPost]
        [Route("getUsername")]
        public IHttpActionResult GetDataUserByID(AccountModel account)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@Email", account.Email)
                };
            var result = new DB().GetDataReader("sp_GetUsername", param);


            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
