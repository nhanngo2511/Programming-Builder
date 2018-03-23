using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.BUS
{
   public static class BUSClassroom
    {

       static DAClassroom DACl = new DAClassroom();

       public static List<Classroom> GetClassroomsByFacilityID02(int FacilityID)
       {

           List<Classroom> Clasros = DACl.GetClassroomsByFacilityID02(FacilityID);

           return Clasros;

       }

       public static Classroom GetClassroomByID(int ID)
       {
           return DACl.GetClassroomByID(ID);
       }

       public static List<Classroom> GetClassroomsExeceptClassOffice()
       {
           return DACl.GetClassroomsExeceptClassOffice();
       }
       public static void AddClassroom(Classroom Clasro)
       {
           DACl.AddClassroom(Clasro);
       }

       public static void EditClassroom(Classroom Clasro)
       {
           DACl.EditClassroom(Clasro);
       }

       public static void DeleteClassroom(int ID)
       {
           DACl.DeleteClassroom(ID);
       }
    }
}
