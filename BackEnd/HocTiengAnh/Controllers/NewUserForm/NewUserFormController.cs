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

namespace HocTiengAnh.Controllers.NewUserForm
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]


    public class NewUserFormController : ApiController
    {
        [HttpPost]
        [Route("addInfoNewSinhVien")]
        public IHttpActionResult AddInfoNewUser(StudentModel student)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", student.AccountID),
                    new SqlParameter("@Name", student.Name),
                    new SqlParameter("@Gender", student.Gender),
                    new SqlParameter("@IDCLASS", student.IDCLASS)
            };

            var result = new DB().GetDataReader("sp_AddNewSinhVien", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
