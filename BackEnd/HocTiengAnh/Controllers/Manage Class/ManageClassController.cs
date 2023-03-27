using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.Manage_Class
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]  
    public class ManageClassController : ApiController
    {
        [HttpGet]
        [Route("getClassByID/{id}")]
        public IHttpActionResult GetClassByID(string id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@IDFACULTY", id)
            };

            var result = new DB().GetDataReader("sp_FilterClassByFacultyID", param);

            return Json(result);
        }
        
    }
}
