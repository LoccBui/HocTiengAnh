using QuanLySach.Database;
using System.Data;
using System.Data.SqlClient;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    [Route("DeleteSach/{MaSach}")]
    public class DeleteSachController : ApiController
    {
        [HttpDelete]
        public IHttpActionResult DeleteSach(int MaSach)
        {
            SqlParameter[] param = new SqlParameter[] {
                new SqlParameter("@MaSach",MaSach),
            };
            var result = new DB().GetDataReader("spSach_Delete", param);

            return Json(result);
        }
    }
}
