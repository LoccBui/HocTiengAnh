using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace HocTiengAnh.Database
{
    public class DB
    {
        SqlConnection con;
        SqlCommand cmd;
        String connStr;

        public DB() {
            connStr = @"Data Source=LOCNE\SQLEXPRESS;Initial Catalog=HocTiengAnh;Integrated Security=True";
            con = new SqlConnection(connStr);
        }

        public DataTable GetDataReader(string spQuery, params SqlParameter[] param)
        {
            DataTable dataTable = null;
            try
            {
                con.Open();
                cmd = new SqlCommand(spQuery, con);
                cmd.CommandType = CommandType.StoredProcedure;
                if (param.Length > 0)
                {
                    foreach (SqlParameter item in param)
                    {
                        cmd.Parameters.Add(item);
                    }
                }

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    dataTable = new DataTable();
                    dataTable.Load(reader);
                }
            }
            catch (Exception)
            {
            }
            finally
            {
                con.Close();
            }
            return dataTable;
        }

    }

}