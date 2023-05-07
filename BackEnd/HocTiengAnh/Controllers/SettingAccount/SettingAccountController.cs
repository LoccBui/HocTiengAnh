using HocTiengAnh.Database;
using HocTiengAnh.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.SettingAccount
{


    public class SettingAccountController : ApiController
    {
        [HttpPost]
        [Route("settingAccount")]
        public IHttpActionResult AuthUser(AccountModel account)
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
        [Authorize]
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

        [HttpPost]
        [Route("updateInfoAccount")]
        public IHttpActionResult UpdateInfoGiaoVien(AccountModel account)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", account.AccountID),
                    new SqlParameter("@Email", account.Email),
                    new SqlParameter("@Name", account.Name),
            };

            var result = new DB().GetDataReader("sp_UpdateInfoAccount", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [HttpPost]
        [Authorize]
        [Route("updateInfoGiaoVien")]
        public IHttpActionResult UpdateInfoGiaoVien(GiaoVienModel gv)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@MaGV", gv.MaGV),
                    new SqlParameter("@Gender", gv.Gender),
            };

            var result = new DB().GetDataReader("sp_UpdateInfoAccountGiaoVien", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [HttpPost]
        [Authorize]
        [Route("updateInfoSinhVien")]
        public IHttpActionResult UpdateInfoSinhVien(StudentModel sv)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@MaSV", sv.MaSV),
                    new SqlParameter("@Gender", sv.Gender),
            };

            var result = new DB().GetDataReader("sp_UpdateInfoAccountSinhVien", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [HttpPost]
        [Route("changePassword")]
        public IHttpActionResult ChangePassword(AccountModel acc)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@Password", acc.Password),
                    new SqlParameter("@AccountID", acc.AccountID)
            };

            var result = new DB().GetDataReader("sp_ChangePassword", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [HttpPost]
        [Route("changeDefaultPersonalVocab")]
        public IHttpActionResult ChangeDefaultPersonalVocab(PersonalVocabModel personalVocab)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", personalVocab.AccountID),
                    new SqlParameter("@PersonalVocabID", personalVocab.PersonalVocabID)
            };

            var result = new DB().GetDataReader("sp_UpdateDefaultPersonalVocab", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [HttpPost]
        [Authorize]
        [Route("createPersonalVocab")]
        public IHttpActionResult CreatePersonalVocab(PersonalVocabModel personalVocab)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", personalVocab.AccountID),
                    new SqlParameter("@PersonalVocabName", personalVocab.PersonalVocabName)
            };

            var result = new DB().GetDataReader("sp_CreateNewPersonalVocab", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }



    }
}
