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

namespace HocTiengAnh.Controllers.Manage_Users
{
    public class ManageUsersController : ApiController
    {
        [HttpGet]
        [Authorize]
        [Route("getAllUsers")]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_SelectAllUsers");
            return Json(result);

        }


        [HttpPost]
        [Authorize(Roles = "admin")]
        [Route("addNewUser")]
        public IHttpActionResult AddNewUser(AccountModel account) 
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@Username", account.Username),
                    new SqlParameter("@Password",account.Password),
                    new SqlParameter("@Email",account.Email),
                    new SqlParameter("@RoleID", account.RoleID)
            };

            var result = new DB().GetDataReader("sp_AddNewUser", param);

            return Json(result);
        }

        [HttpDelete]
        [Authorize(Roles = "admin")]
        [Route("DeleteUser/{id}")]
        public IHttpActionResult DeleteUser(string id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", id)
            };

            var result = new DB().GetDataReader("sp_DeleteUser", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }



    }
}
