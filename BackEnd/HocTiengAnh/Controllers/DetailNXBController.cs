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
    [Route("DetailNXB/{MaNXB}")]
    public class DetailNXBController : ApiController
    {
        [HttpGet]
        public IHttpActionResult addSach(int MaNXB)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@MaNXB",MaNXB)
                };
            var result = new DB().GetDataReader("spSach_DetailNXB", param);

            return Json(result);
        }

    }
}
