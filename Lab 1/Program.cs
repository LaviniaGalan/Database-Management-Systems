using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
// SqlCommand - ExecuteScalar, ExecuteNonQuery, ExecuteReader
// SqlDataAdapter - delete/update


namespace Lab1
{
    class Program
    {
        static void Main(string[] args)
        {
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = "Data Source = DESKTOP-ALKE6K0; Initial Catalog = Hospital; " +
                                    "Integrated Security = SSPI";

            conn.Open();

            //Execute Scalar
            SqlCommand aggSelectCmd = new SqlCommand("SELECT MAX(Salary) FROM Doctor", conn);
            int maxSalary = (int)aggSelectCmd.ExecuteScalar();
            Console.WriteLine("The maximum salary from doctors is: " + maxSalary);


            //Execute Non Query
            /*
            SqlCommand insertCmd = new SqlCommand();
            insertCmd.CommandText = "INSERT INTO Medication(MedicationID, ActiveSubstance)" +
                                    "VALUES (100, 'Ibuprofen')";
            insertCmd.CommandType = CommandType.Text;
            insertCmd.Connection = conn;

            insertCmd.ExecuteNonQuery();
            Console.WriteLine("---- Executed insert with ExecuteNonQuery");
            */

            //ExecuteReader
            SqlCommand selectDepatmentsCmd = new SqlCommand("SELECT * FROM Department", conn);
            SqlDataReader deptReader = selectDepatmentsCmd.ExecuteReader();

            Console.WriteLine("All the departments: ");
            while(deptReader.Read())
            {
                Console.WriteLine("{0}, {1}, {2}",
                deptReader.GetInt32(0),
                deptReader.GetString(1),
                deptReader.GetInt32(0));
            }
            deptReader.Close();


            //DATA ADAPTER
            
            DataSet ds = new DataSet();

            SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Medication", conn);
            SqlCommandBuilder cbMedication = new SqlCommandBuilder(da);

            da.Fill(ds, "S");  //the local table equivalent to Department table

            foreach (DataRow dr in ds.Tables["S"].Rows)
                Console.WriteLine("{0}, {1}", dr["MedicationID"], dr["ActiveSubstance"]);

            DataRow drr = ds.Tables["S"].NewRow();
            drr["MedicationID"] = 23456;
            drr["ActiveSubstance"] = "Salycilic Acid";
            ds.Tables["S"].Rows.Add(drr);
            da.Update(ds, "S");

            foreach (DataRow dr in ds.Tables["S"].Rows)
                Console.WriteLine("{0}, {1}", dr["MedicationID"], dr["ActiveSubstance"]);
            

            DataRow row = ds.Tables["S"].Rows[10];
            row.Delete();
            da.Update(ds, "S");

            foreach (DataRow dr in ds.Tables["S"].Rows)
                Console.WriteLine("{0}, {1}", dr["MedicationID"], dr["ActiveSubstance"]);
            conn.Close();

            Console.ReadLine();
        }
    }
}
