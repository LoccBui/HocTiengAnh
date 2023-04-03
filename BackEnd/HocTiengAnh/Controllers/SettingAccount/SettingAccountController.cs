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

namespace HocTiengAnh.Controllers.SettingAccount
{
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]

    public class SettingAccountController : ApiController
    {
        [HttpPost]
        [Route("settingAccount")]
        public IHttpActionResult SettingAccount(AccountModel account)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", account.AccountID)
            };

            var result = new DB().GetDataReader("sp_GetDataAccount", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [HttpPost]
        [Route("changeAvatar")]
        public IHttpActionResult ChangeAvatar(AccountModel account)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", account.AccountID),
                    new SqlParameter("@Image", account.Image)
            };

            var result = new DB().GetDataReader("sp_ChangeAvatar", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
