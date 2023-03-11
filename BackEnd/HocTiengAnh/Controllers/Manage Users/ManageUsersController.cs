using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.Manage_Users
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ManageUsersController : ApiController
    {
        [HttpGet]
        [Route("getAllUsers")]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_SelectAllUsers");

            return Json(result);
        }
    }
}
