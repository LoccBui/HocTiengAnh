﻿using HocTiengAnh.Database;
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
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]
    public class VerifyOTPCodeController : ApiController
    {
        [HttpGet]
        public IHttpActionResult VerifyOTPCode(int id, int otpcode)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@OTPCODE", id),
                    new SqlParameter("@AccountID",otpcode)
                };
            var result = new DB().GetDataReader("sp_confirmOTPCode", param);

            return Json(result);
        }
    }
}
