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

namespace HocTiengAnh.Controllers.DetailClass
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class DetailClassController : ApiController
    {
        [Route("DetailClass")]
        [HttpPost]
        public IHttpActionResult SelectTuVungByTopicID(ClassModel cl)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("IDCLASS", cl.IDCLASS)
                };
            var result = new DB().GetDataReader("sp_ShowDetailClass", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [Route("updateStudentApproved")]
        [HttpPost]
        public IHttpActionResult UpdateStudentApproved(DetailClassModel dcl)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("DetailID", dcl.DetailID)
                };
            var result = new DB().GetDataReader("sp_UpdateApprovedStudent", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
