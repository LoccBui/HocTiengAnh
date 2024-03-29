﻿using HocTiengAnh.Database;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;

namespace HocTiengAnh.Controllers.Topic
{
    public class TopicController : ApiController
    {
        public class NewClassDataModel
        {
            public int AccountID { get; set; }
            public int TopicID { get; set; }
        }


        [HttpPost]
        [Route("getStatusLearning")]
        [Authorize]
        public IHttpActionResult GetDataUserByID([FromBody] NewClassDataModel data)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", data.AccountID),
                    new SqlParameter("@TopicID", data.TopicID)
                };
            var result = new DB().GetDataReader("sp_GetStatusLearning", param);


            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }

        [HttpPost]
        [Authorize]
        [Route("learning/topicid")]
        public IHttpActionResult SelectTuVungByTopicID(NewClassDataModel learn)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("TopicID", learn.TopicID),
                    new SqlParameter("AccountID", learn.AccountID)

                };
            var result = new DB().GetDataReader("sp_SelectTuVungByTopicID", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [HttpGet]
        [Authorize]
        [Route("SelectAllTuVung")]
        public IHttpActionResult SelectAllTuVung()
        {
            var result = new DB().GetDataReader("sp_SelectAllTuVung");

            return Json(result);
        }

        [Route("SelectAllTopics")]
        [HttpGet]
        [Authorize]
        public IHttpActionResult SelectAllTopics()
        {
            var result = new DB().GetDataReader("sp_ShowAllTopic");

            return Json(result);
        }



        [HttpGet]
        [Route("getTopic/{id}")]
        [Authorize]
        public IHttpActionResult ShowTopicByFaculty(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@AccountID", id)
                };
            var result = new DB().GetDataReader("sp_userFalculty", param);

            return Json(result);
        }

    }
}
