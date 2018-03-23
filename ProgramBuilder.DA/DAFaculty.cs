using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.DA
{
    public class DAFaculty
    {
        private ProgramBuilderEntities pbDB;
        public List<Faculty> GetFaculties()
        {
            pbDB = new ProgramBuilderEntities();

            List<Faculty> Facus = pbDB.Faculties.ToList();

            return Facus;
        }

        public List<Faculty> GetFacultiesExistSubject()
        {
            pbDB = new ProgramBuilderEntities();

            List<Faculty> Facus = pbDB.Faculties.Where(x => x.Subjects.Count > 0).ToList();
            return Facus;
        }

        public void AddFaculty(Faculty Facu)
        {
            pbDB = new ProgramBuilderEntities();

            Facu.CreationTime = DateTime.Now;

            pbDB.Faculties.Add(Facu);

            pbDB.SaveChanges();

        }

        public void EditFaculty(Faculty Facu)
        {
            pbDB = new ProgramBuilderEntities();

            Faculty facuResult = pbDB.Faculties.Where(x => x.ID == Facu.ID).FirstOrDefault();

            facuResult.VietNameseName = Facu.VietNameseName;
            facuResult.EnglishName = Facu.EnglishName;
            facuResult.PhoneNumber = Facu.PhoneNumber;
            facuResult.TrainingTime = Facu.TrainingTime;
            facuResult.ClassroomID = Facu.ClassroomID;

            pbDB.SaveChanges();

        }

        public Faculty GetFacultyByID(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            Faculty facuResult = pbDB.Faculties.Where(x => x.ID == ID).FirstOrDefault();

            return facuResult;
        }

        public int GetCreditNumberByFacultyID(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            var r = from su in pbDB.Subjects
                    where su.FacultyID.Value == ID
                    select su;
            int sum = r.Sum(x => x.CreditNumber);

            return sum;               

        }

    }
}
