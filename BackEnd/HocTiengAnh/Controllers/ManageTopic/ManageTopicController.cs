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
        [Route("detail/topicid={id}")]
        [HttpGet]
        public IHttpActionResult SelectTuVungByTopicID(int id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("TopicID", id)
                };
            var result = new DB().GetDataReader("sp_SelectTuVungByTopicID", param);

            return Json(result);
        }
         
        [Route("addNewTopic")]
        [HttpPost]
        public IHttpActionResult AddNewTopic(TopicModel topic)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@IdFaculty", topic.IDFACULTY),
                    new SqlParameter("@TopicName",topic.TopicName),
                    new SqlParameter("@TopicDescribe",topic.TopicDescribe),
                    new SqlParameter("@QuantityWords", topic.QuantityWords),
                    new SqlParameter("@CreatedBy", topic.CreatedBy)
            };

            var result = new DB().GetDataReader("sp_AddTopic", param);

            if (result == null) 
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [HttpDelete]
        [Route("DeleteTopic/{id}")]
        public IHttpActionResult DeleteTopic(string id)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@TopicID", id)
            };

            var result = new DB().GetDataReader("sp_DeleteTopicByID", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [Route("addVocabToNewTopic")]
        [HttpPost]
        public IHttpActionResult AddVocabToNewTopic(WordModel word)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@TopicID", word.TopicID),
                    new SqlParameter("@Word", word.Word),
                    new SqlParameter("@IPA", word.IPA),
                    new SqlParameter("@Label", word.Label),
                    new SqlParameter("@Lemma", word.Lemma),
                    new SqlParameter("@Vietnamese", word.Vietnamese),
                    new SqlParameter("@Cluster",word.Cluster),
                    new SqlParameter("@Position",word.Position),
                    new SqlParameter("@Example", word.Example),
                    new SqlParameter("@VN_Example", word.VN_Example),
                    new SqlParameter("@Resources", word.Resources)
            };

            var result = new DB().GetDataReader("sp_AddVocabToNewTopic", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [Route("updateVocabByTopicID")]
        [HttpPut]
        public IHttpActionResult UpdateVocabByTopicID(WordModel word)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@VocabID", word.VocabID),
                    new SqlParameter("@TopicID", word.TopicID),
                    new SqlParameter("@Word", word.Word),
                    new SqlParameter("@IPA", word.IPA),
                    new SqlParameter("@Label", word.Label),
                    new SqlParameter("@Lemma", word.Lemma),
                    new SqlParameter("@Vietnamese", word.Vietnamese),
                    new SqlParameter("@Cluster",word.Cluster),
                    new SqlParameter("@Position",word.Position),
                    new SqlParameter("@Example", word.Example),
                    new SqlParameter("@VN_Example", word.VN_Example),
                    new SqlParameter("@Resources", word.Resources),
                    new SqlParameter("@Active", word.Active)
            };

            var result = new DB().GetDataReader("sp_UpdateVocab", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }


        [Route("updateTopic")]
        [HttpPut]
        public IHttpActionResult UpdateTopic(TopicModel topic)
        {
            SqlParameter[] param = new SqlParameter[] {
                    new SqlParameter("@TopicID", topic.TopicID),
                    new SqlParameter("@TopicName", topic.TopicName),
                    new SqlParameter("@TopicDescribe", topic.TopicDescribe)
            };

            var result = new DB().GetDataReader("sp_UpdateTopic", param);

            if (result == null)
            {
                return BadRequest("Error occurred while executing stored procedure.");
            }
            return Json(result);
        }
    }
}
