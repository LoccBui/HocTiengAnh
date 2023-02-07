using QuanLySach.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    [Route("SelectSachByID/{MaSach}")]
    public class SelectSachByIDController : ApiController
    {
        [HttpGet]
        public IHttpActionResult SelectSachByID(int MaSach)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@MaSach",MaSach)
                };
            var result = new DB().GetDataReader("spSach_SelectSachByID", param);

            return Json(result);
        }
    }
}
