using QuanLySach.Database;
using QuanLySach.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    [Route("AddSach")]
    public class AddSachController : ApiController
    {
        [HttpPost]
        public string AddSach(SachModel sach)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@TenSach",sach.TenSach),
                    new SqlParameter("@MoTa",sach.MoTa),
                    new SqlParameter("@MaNXB",sach.MaNXB),
                    new SqlParameter("@Image", sach.Image)
            };

            var result = new DB().GetDataReader("spSach_AddSach", param);
            string respone = String.Empty;

            if (result != null)
            {
                respone = "Thêm thành công";
            }
            else
            {
                respone = "Thêm không thành công";
            }

            return respone;
        }
    }
}
