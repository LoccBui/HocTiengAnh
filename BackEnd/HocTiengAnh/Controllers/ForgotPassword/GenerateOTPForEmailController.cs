using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.ForgotPassword
{
    [Route("generateOTP/{id}")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class GenerateOTPForEmailController : ApiController
    {
        [HttpGet]
        public IHttpActionResult GenerateOTPForEmail(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", id)
                };
            var result = new DB().GetDataReader("sp_GenerateOTP", param);

            return Json(result);
        }
    }
}
