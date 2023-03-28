﻿using HocTiengAnh.Database;
using HocTiengAnh.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.NewGiaoVienForm
{
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class NewGiaoVienFormController : ApiController
    {
        [HttpPost]
        [Route("addInfoNewGiaoVien")]
        public IHttpActionResult AddInfoNewUser(GiaoVienModel teacher)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", teacher.AccountID),
                    new SqlParameter("@Name", teacher.Name),
                    new SqlParameter("@Gender", teacher.Gender)
            };

            var result = new DB().GetDataReader("sp_AddInfoGiaoVien", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
        
    }
}
