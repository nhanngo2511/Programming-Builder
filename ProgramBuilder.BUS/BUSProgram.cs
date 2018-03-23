using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ProgramBuilder.BUS
{
    public static class BUSProgram
    {
        static DAProgram DAProg = new DAProgram();
        public static void AddProgram(Program program)
        {
            DAProg.AddProgram(program);
        }

        public static void EditProgram(Program program)
        {
            DAProg.EditProgram(program);
        }



        //public static Program GetProgramByID(int ID)
        //{
        //    pbDB = new ProgramBuilderEntities();

        //    return pbDB.Programs.Find(ID);
        //}

        public static Dictionary<int, List<Subject>> GetShortContentDescriptionByFacultyID(int ID) { 
            return DAProg.GetShortContentDescriptionByFacultyID(ID);
        }

        //public static List<GetTrainingPlanByFacultyID_Result> GetTrainingPlanByFacultyID(int ID)
        //{
        //    return DAProg.GetTrainingPlanByFacultyID(ID);
        //}

        public static Program GetProgramByID(int ID)
        {
           return DAProg.GetProgramByID(ID);
        }

        public static List<Program> GetPrograms()
        {
            return DAProg.GetPrograms();
        }

        public static int GetLengthProgramPurposeBySubjectID(int ID){
           return DAProg.GetLengthProgramPurposeBySubjectID(ID);
        }

        public static string GetContentProgramPurposeBySubjectID(int ID)
        {
            string TrainingPurpose = DAProg.GetContentProgramPurposeBySubjectID(ID);

            string[] tempArr = Regex.Split(TrainingPurpose, @"<li>");

            string TrainingPurposeFinal = "";

            for (int i = 0; i < tempArr.Length; i++)
            {
                TrainingPurposeFinal += "<p>" + (i + 1).ToString() + " ." + tempArr[i].Replace("</li>","</p>");
            }

            return TrainingPurposeFinal;
        }
    }
}
