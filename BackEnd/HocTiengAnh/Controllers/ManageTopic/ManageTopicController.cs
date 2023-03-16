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

namespace HocTiengAnh.Controllers.ManageTopic
{
    [EnableCors(origins: "http://localhost:8080", headers: "*", methods: "*")]


    public class ManageTopicController : ApiController
    {
        [HttpGet]
        [Route("detail/topicid={id}")]
        public IHttpActionResult SelectTuVungByTopicID(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("TopicID", id)
                };
            var result = new DB().GetDataReader("sp_SelectTuVungByTopicID", param);

            return Json(result);
        }

        [HttpPost]
        [Route("addNewTopic")]
        public IHttpActionResult AddNewTopic(TopicModel topic)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@IDFACULTY", topic.IDFACULTY),
                    new SqlParameter("@TopicName",topic.TopicName),
                    new SqlParameter("@TopicDescribe",topic.TopicDescribe),
                    new SqlParameter("@QuantityWords", topic.QuantityWords),
                    new SqlParameter("@CreatedBy", topic.CreateBy)
            };

            var result = new DB().GetDataReader("sp_AddNewTopic", param);

            return Json(result);
        }
    }
}
