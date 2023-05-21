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
  
    public class ManageClassController : ApiController
    {


        [HttpGet]
        [Route("getClassByID/{id}")]
        [Authorize]

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
        [Authorize(Roles = "admin")]

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


        [Route("DeleteClass/{id}")]
        [Authorize(Roles = "admin")]
        [HttpDelete]
        public IHttpActionResult DeleteClassByID(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@IDClass", id)
                };
            var result = new DB().GetDataReader("sp_DeleteClassByID", param);

            return Json(result);
        }


        [Route("SelectAllFaculty")]
        [Authorize]
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_SelectAllFaculty");

            return Json(result);
        }


        [HttpGet]
        [Route("SelectAllClasses")]
        [Authorize]
        public IHttpActionResult SelectAllClasses()
        {
            var result = new DB().GetDataReader("sp_ShowAllClass");

            return Json(result);
        }


        [HttpPost]
        [Route("getTeacherByFaculty/{faculty}")]
        [Authorize]
        public IHttpActionResult ShowTeacherByFaculty(string faculty)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@FacultyName", faculty)
                };
            var result = new DB().GetDataReader("sp_ShowTeacherNameByFaculty", param);

            return Json(result);
        }



    }
}
