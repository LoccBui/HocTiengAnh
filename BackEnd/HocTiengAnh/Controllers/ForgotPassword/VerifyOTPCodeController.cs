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
    [Route("verify/{id}/{otpcode}")]

    public class VerifyOTPCodeController : ApiController
    {
        [HttpGet]
        public IHttpActionResult VerifyOTPCode(int id, int otpcode)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@OTPCODE", otpcode),
                    new SqlParameter("@AccountID",id)
                };
            var result = new DB().GetDataReader("sp_confirmOTPCode", param);

            return Json(result);
        }
    }
}
