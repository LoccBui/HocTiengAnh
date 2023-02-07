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
    [Route("FindSach/{TenSach}/{MaNXB}")]
    public class FindSachInNXBController : ApiController
    {
        [HttpGet]
        public IHttpActionResult SelectSachByID(string TenSach, int MaNXB)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@TenSach",TenSach),
                    new SqlParameter("@MaNXB", MaNXB)
                };
            var result = new DB().GetDataReader("spSach_FindSachInNXB", param);

            return Json(result);
        }
    }
}
