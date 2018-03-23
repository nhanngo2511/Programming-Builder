using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.BUS
{
   public static class BUSSyllabus
   {
       static DASyllabus DASy = new DASyllabus();
       public static void AddSyllabus(Syllabus Sylla)
       {
           DASy.AddSyllabus(Sylla);
       }

       public static List<Syllabus> SyllabusesList() {
           return DASy.SyllabusesList();
       }

       public static Syllabus GetSyllabusByID(int ID)
       {
          return DASy.GetSyllabusByID(ID);
       }

       public static void EditSyllabus(Syllabus sylla)
       {
           DASy.EditSyllabus(sylla);
       }
   }
}
