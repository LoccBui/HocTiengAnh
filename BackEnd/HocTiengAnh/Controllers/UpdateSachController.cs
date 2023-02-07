using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Web.Http;
using QuanLySach.Database;
using QuanLySach.Models;

namespace QuanLySach.Controllers
{
    [Route("UpdateSach")]
    public class UpdateSachController : ApiController
    {
        [HttpPost]
        public string AddSach(SachModel sach)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@TenSach",sach.TenSach),
                    new SqlParameter("@MoTa",sach.MoTa),
                    new SqlParameter("@MaSach", sach.MaSach),
                    new SqlParameter("@Image", sach.Image)
            };

            var result = new DB().GetDataReader("spSach_UpdateSach", param);
            string respone = String.Empty;

            if (result != null)
            {
                respone = "Cập nhật thành công!";
            }
            else
            {
                respone = "Cập nhật không thành công";
            }

            return respone;
        }


    }
}
