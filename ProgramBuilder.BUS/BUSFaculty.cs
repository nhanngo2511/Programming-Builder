using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.BUS
{
    public static class BUSFaculty
    {
        static DAFaculty DAFacu = new DAFaculty();

        public static List<Faculty> GetFacultiesExistSubject() {
            List<Faculty> Faculties = DAFacu.GetFacultiesExistSubject();
            return Faculties;
        }

        public static List<Faculty> GetFaculties()
        {
            List<Faculty> Faculties = DAFacu.GetFaculties();           

            return Faculties;
        }

        public static void AddFaculty(Faculty Facu)
        {
            DAFacu.AddFaculty(Facu);
        }

        public static void EditFaculty(Faculty Facu)
        {
            DAFacu.EditFaculty(Facu);
        }

        public static Faculty GetFacultyByID(int ID)
        {
            Faculty facu = DAFacu.GetFacultyByID(ID);
            return facu;
        }

        public static int GetCreditNumberByFacultyID(int ID) {
            return DAFacu.GetCreditNumberByFacultyID(ID);
        }
    }
}
