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
    [Route("getTeacherByFaculty/{faculty}")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ShowTeacherByFacultyController : ApiController
    {
        [HttpPost]
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
