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
    [EnableCors(origins: "*", headers: "*", methods: "*")]

    public class ManageUsersController : ApiController
    {
        [HttpGet]
        [Route("getAllUsers")]
        public IHttpActionResult JsonResult()
        {
            var result = new DB().GetDataReader("sp_SelectAllUsers");
            return Json(result);

        }


        [HttpPost]
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
        [Route("DeleteUser/{id}")]
        public IHttpActionResult DeleteUser(string id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", id)
            };

            var result = new DB().GetDataReader("sp_DeleteUser", param);

            return Json(result);
        }



    }
}
