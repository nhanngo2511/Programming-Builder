using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.BUS
{
    public static class BUSSubject
    {
        static DASubject DASubj = new DASubject();
        public static void AddSubject(Subject subject, List<int> AccountIDs, List<int> subjectConditionIDs)
        {
            DASubj.AddSubject(subject, subjectConditionIDs, AccountIDs);
        }

        public static void EditSubject(Subject subject, List<int> AccountIDs, List<int> subjectConditionIDs)
        {
            DASubj.EditSubject(subject, AccountIDs, subjectConditionIDs);
        }

        //public static List<KnowledgeSubjectType> GetKnowledgeSubjectTypeBySubjectID(int ID)
        //{
        //    return DASubj.GetKnowledgeSubjectTypeBySubjectID(ID);
        //}

        public static List<Subject> GetSubjectByAccountEditor(int ID) 
        {
            return DASubj.GetSubjectByAccountEditor(ID);
        }

        public static List<Subject> GetSubjects()
        {
           return DASubj.GetSubjects();
        }

        public static List<SubjectType> GetMainSubjectTypes()
        {
            List<SubjectType> SubjTyps = DASubj.GetMainSubjectTypes();

            return SubjTyps;
        }

        public static List<SubjectType> GetSubSubjectTypes(int SubjTypeID)
        {
            List<SubjectType> SubjTyps = DASubj.GetSubSubjectTypes(SubjTypeID);
            return SubjTyps;
        }

        public static List<SubjectType> GetSubTwoSubjectTypes(int SubjTypeID)
        {
            List<SubjectType> SubjTyps = DASubj.GetSubTwoSubjectTypes(SubjTypeID);
            return SubjTyps;
        }

        //public static List<Subject> GetSubjects()
        //{
        //    pbDB = new ProgramBuilderEntities();

        //    pbDB.Configuration.ProxyCreationEnabled = false;

        //    return pbDB.Subjects.ToList();
        //}

        //public static Subject GetSubjectByID(int ID)
        //{
        //    pbDB = new ProgramBuilderEntities();

        //    return pbDB.Subjects.Find(ID);
        //}


        public static List<GetProgramContentByFacultyID_Result> GetProgramContentByFacultyID(int ID)
        {
            return DASubj.GetProgramContentByFacultyID(ID);
        }

        //public static List<Subject> GetSubjectByFacultyID(int ID){

        //    pbDB = new ProgramBuilderEntities();

        //    List<Subject> Subjects = pbDB.Subjects.Where(x => x.Faculties.All(y => y.ID == ID)).ToList();

        //    return Subjects;

        // }


        public static List<Subject> GetSubjectsByFacutyID(int? FacultyID)
        {
            return DASubj.GetSubjectByFacultyID(FacultyID);
        }

        public static Subject GetSubjectByID(int ID)
        {
            return DASubj.GetSubjectByID(ID);
        }
    }

}

