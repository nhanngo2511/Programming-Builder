
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.DA
{
    public class DAClassroom
    {
        private ProgramBuilderEntities pbDB;

        public List<Classroom> GetClassroomsExeceptClassOffice()
        {
            pbDB = new ProgramBuilderEntities();
            List<Classroom> Clasros = pbDB.Classrooms.Where(x => x.IsOfficeFacility == false).OrderBy(y => y.Name).ToList();

            return Clasros;
        }
        public List<Classroom> GetClassroomsByFacilityID02(int FacilityID)
        {
            pbDB = new ProgramBuilderEntities();
            List<Classroom> Clasros = pbDB.Classrooms.Where(x => x.IsOfficeFacility == true && x.Faculties.Count == 0 && x.FacilityID == FacilityID).ToList();

            return Clasros;

        }

        public Classroom GetClassroomByID(int ID)
        {

            pbDB = new ProgramBuilderEntities();

           return pbDB.Classrooms.Single(x=>x.ID == ID);
        }

        public void AddClassroom(Classroom Clasro)
        {
            pbDB = new ProgramBuilderEntities();
            Clasro.CreationTime = DateTime.Now;

            pbDB.Classrooms.Add(Clasro);
            pbDB.SaveChanges();
        }

        public void EditClassroom(Classroom Clasro)
        {
            pbDB = new ProgramBuilderEntities();

            Classroom clasroResult = pbDB.Classrooms.Where(x => x.ID == Clasro.ID).FirstOrDefault();

            clasroResult.Name = Clasro.Name;
            clasroResult.IsOfficeFacility = Clasro.IsOfficeFacility;
            clasroResult.FacilityID = Clasro.FacilityID;

            pbDB.SaveChanges();
        }

        public void DeleteClassroom(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            Classroom clasro = pbDB.Classrooms.Where(x => x.ID == ID).FirstOrDefault();

            pbDB.Classrooms.Remove(clasro);

            Classroom DefaultClassro = pbDB.Classrooms.First();
            if (DefaultClassro != null)
            {
                DefaultClassro.IsOfficeFacility = false;

                EditClassroom(DefaultClassro);
            }

            pbDB.SaveChanges();

        }


    }
}
