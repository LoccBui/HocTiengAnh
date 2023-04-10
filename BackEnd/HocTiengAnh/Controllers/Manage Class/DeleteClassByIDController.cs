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
    [Route("DeleteClass/{id}")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class DeleteClassByIDController : ApiController
    {
        [HttpDelete]
        public IHttpActionResult DeleteClassByID(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@IDClass", id)
                };
            var result = new DB().GetDataReader("sp_DeleteClassByID", param);

            return Json(result);
        }
    }
}
