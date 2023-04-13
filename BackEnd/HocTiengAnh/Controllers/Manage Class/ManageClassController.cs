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
        public class NewClassDataModel
        {
            public string ClassName { get; set; }
            public string FacultyName { get; set; }
        }

        [HttpPost]
        [Route("newClass")]
        public IHttpActionResult NewClass([FromBody] NewClassDataModel data)
        {
            SqlParameter[] param = new SqlParameter[] {
            new SqlParameter("@ClassName", data.ClassName),
            new SqlParameter("@FacultyName", data.FacultyName)
        };

            var result = new DB().GetDataReader("sp_AddClass", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


    }
}
