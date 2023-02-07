using QuanLySach.Database;
using System.Data;
using System.Web;
using System.Web.Http;

namespace QuanLySach.Controllers
{
    public class SachController : ApiController
    {
        [HttpGet]
        public IHttpActionResult GetStudentName()
        {
            var result = new DB().GetDataReader("spSach_SelectAll", null);

            return Json(result);
        }


        [HttpPost]
        public IHttpActionResult GetStudentName(string username, string password)
        {
            var result = new DB().GetDataReader("spSach_UserLogin", null);

            DataTable table = new DataTable(); 

            return Json(result);
        }
    
    }
}
