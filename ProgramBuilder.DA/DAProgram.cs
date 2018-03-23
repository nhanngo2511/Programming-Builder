using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ProgramBuilder.DA
{
    public class DAProgram
    {
        private ProgramBuilderEntities pbDB;

        public void AddProgram(Program Prog)
        {
            pbDB = new ProgramBuilderEntities();

            Prog.CreationTime = DateTime.Now;
            pbDB.Programs.Add(Prog);

            pbDB.SaveChanges();
        }

        //public List<GetTrainingPlanByFacultyID_Result> GetTrainingPlanByFacultyID(int ID)
        //{
        //    return pbDB.GetTrainingPlanByFacultyID(ID).ToList();
        //}

        public Dictionary<int, List<Subject>> GetShortContentDescriptionByFacultyID(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            var Result1 = (from fa in pbDB.Faculties.Where(x => x.ID == ID)
                           from s in fa.Subjects
                           select s).ToList();

            var Result2 = (from s2 in Result1
                          orderby s2.SemesterNumber
                          group s2 by s2.SemesterNumber into grouped
                          select new
                          {
                              semester = grouped.Key,
                              Subjects = grouped.ToList()
                          });

            Dictionary<int, List<Subject>> DictionShortContentDescription = new Dictionary<int, List<Subject>>();

            foreach (var item in Result2)
            {
                List<Subject> subjs = new List<Subject>();

                DictionShortContentDescription.Add(item.semester, item.Subjects);
            }

            return DictionShortContentDescription;

        }

        public void EditProgram(Program Program)
        {
            pbDB = new ProgramBuilderEntities();

            Program Prog = pbDB.Programs.First(x => x.ID == Program.ID);

            Prog.Name = Program.Name;
            Prog.TrainingLevel = Program.TrainingLevel;
            Prog.BranchName = Program.BranchName;
            Prog.EducationType = Program.EducationType;
            Prog.TrainingPurpose = Program.TrainingPurpose;
            Prog.EntranceStudent = Program.EntranceStudent;
            Prog.TrainingTimeDetail = Program.TrainingTimeDetail;
            Prog.KnowledgeTotal = Program.KnowledgeTotal;
            Prog.GraduateCondition = Program.GraduateCondition;
            Prog.PointLadder = Program.PointLadder;
            Prog.TrainingSupport = Program.TrainingSupport;
            Prog.Content = Program.Content;
            Prog.TrainingPlan = Program.TrainingPlan;
            Prog.Status = Program.Status;
            Prog.ShortContentDescription = Program.ShortContentDescription;
            Prog.LecturerList = Program.LecturerList;
            Prog.FacultyID = Program.FacultyID;
            Prog.CreationTime = DateTime.Now;

            pbDB.SaveChanges();

        }


        public Program GetProgramByID(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            return pbDB.Programs.FirstOrDefault(x => x.ID == ID);
        }

        public List<Program> GetPrograms()
        {
            pbDB = new ProgramBuilderEntities();
            return pbDB.Programs.ToList();
                 
        }

        public int GetLengthProgramPurposeBySubjectID(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            Program prog = pbDB.Programs.Where(x => x.Faculty.Subjects.Any(y => y.ID == ID)).Single();

            int Length = Regex.Split(prog.TrainingPurpose, @"<li>").Length;

            return Length;


        }

        public string GetContentProgramPurposeBySubjectID(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            Program prog = pbDB.Programs.Where(x => x.Faculty.Subjects.Any(y => y.ID == ID)).Single();

            return prog.TrainingPurpose;
        }
    }

}

