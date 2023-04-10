﻿using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.Manage_Class
{
    [Route("SelectAllFaculty")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class SelectAllFacultyController : ApiController
    {
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_SelectAllFaculty");

            return Json(result);
        }
    }
}
