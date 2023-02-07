using System.Web.Http;
using QuanLySach.Database;

namespace Sach.Controllers
{
    [Route("SelectAllSach")]
    public class ShowSachController : ApiController
    {
        [HttpGet]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("spSach_SelectAll");
            return Json(result);
        }   
    }
}
