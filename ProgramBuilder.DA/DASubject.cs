using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.DA
{

    public class DASubject
    {
        private ProgramBuilderEntities pbDB;

        public void AddSubject(Subject subject, List<int> subjectConditionIDs, List<int> AccountIDs)
        {
            pbDB = new ProgramBuilderEntities();

            subject.CreationTime = DateTime.Now;

            pbDB.Subjects.Add(subject);

            pbDB.SaveChanges();

            int CurrentSubjectID = subject.ID;

            Subject CurrentSub = pbDB.Subjects.SingleOrDefault(x => x.ID == CurrentSubjectID);

            for (int i = 0; i < AccountIDs.Count; i++)
            {
                if (AccountIDs[i] == AccountIDs[AccountIDs.Count - 1])
                {
                    AccountIDs.RemoveAt(i);
                    break;
                }
            }

            for (int i = 0; i < AccountIDs.Count; i++)
            {

                int tempAccID = AccountIDs[i];

                SubjectsAccount SubAcc = new SubjectsAccount();

                var acc = (from Acc2 in pbDB.Accounts
                           where Acc2.ID == tempAccID
                           select Acc2).SingleOrDefault();

                SubAcc.Subject = CurrentSub;
                SubAcc.Account = acc;
                SubAcc.IsSyllabusEditor = false;

                if (i == AccountIDs.Count - 1)
                {
                    SubAcc.IsSyllabusEditor = true;
                }

                pbDB.SubjectsAccounts.Add(SubAcc);


            }

            //if (AccountIDs != null)
            //{
            //    foreach (int item in AccountIDs)
            //    {
            //        if (item != AccountID)
            //        {
            //            NewAccountIDs.Add(item);
            //        }
            //    }
            //}

            //NewAccountIDs.Add(AccountID);


            //foreach(int item in NewAccountIDs)
            //{
            //    Account acc = (from Acc2 in pbDB.Accounts
            //                   where Acc2.ID == item
            //                   select Acc2).Single();

            //    SubjectsAccount SubAcc = new SubjectsAccount();
            //    SubAcc.Account = acc;
            //    SubAcc.Subject = CurrentSub;
            //    SubAcc.IsSyllabusEditor = false;

            //    if (item.Equals(AccountID))
            //    {
            //        SubAcc.IsSyllabusEditor = true;
            //    }

            //    pbDB.SubjectsAccounts.Add(SubAcc);
            //}

            if (subjectConditionIDs != null)
            {
                foreach (int subjectConditionID in subjectConditionIDs)
                {
                    Subject relateSub = pbDB.Subjects.SingleOrDefault(x => x.ID == subjectConditionID);

                    CurrentSub.Subjects1.Add(relateSub);

                }
            }

            pbDB.SaveChanges();
        }


        public void EditSubject(Subject subject, List<int> AccountIDs, List<int> subjectConditionIDs)
        {
            pbDB = new ProgramBuilderEntities();

            Subject CurrentSubj = pbDB.Subjects.SingleOrDefault(x => x.ID == subject.ID);

            CurrentSubj.Name = subject.Name;
            CurrentSubj.PartialCode = subject.PartialCode;
            CurrentSubj.CreditNumber = subject.CreditNumber;
            CurrentSubj.TheoryNumber = subject.TheoryNumber;
            CurrentSubj.PracticeNumber = subject.PracticeNumber;
            CurrentSubj.LearningLevel = subject.LearningLevel;
            CurrentSubj.SemesterNumber = subject.SemesterNumber;
            CurrentSubj.Description = subject.Description;
            CurrentSubj.Purpose = subject.Purpose;
            CurrentSubj.SubjectTypeID = subject.SubjectTypeID;
            CurrentSubj.FacultyID = subject.FacultyID;
            CurrentSubj.Form = subject.Form;


            //Remove

            CurrentSubj.SubjectsAccounts.Clear();

            CurrentSubj.Subjects1.Clear();

            // Add 
            for (int i = 0; i < AccountIDs.Count; i++)
            {
                if (AccountIDs[i] == AccountIDs[AccountIDs.Count - 1])
                {
                    AccountIDs.RemoveAt(i);
                    break;
                }
            }

            for (int i = 0; i < AccountIDs.Count; i++)
            {

                int tempAccID = AccountIDs[i];

                SubjectsAccount SubAcc = new SubjectsAccount();

                var acc = (from Acc2 in pbDB.Accounts
                           where Acc2.ID == tempAccID
                           select Acc2).SingleOrDefault();

                SubAcc.Subject = CurrentSubj;
                SubAcc.Account = acc;
                SubAcc.IsSyllabusEditor = false;

                if (i == AccountIDs.Count - 1)
                {
                    SubAcc.IsSyllabusEditor = true;
                }

                pbDB.SubjectsAccounts.Add(SubAcc);

            }

            if (subjectConditionIDs != null)
            {
                foreach (int subjectConditionID in subjectConditionIDs)
                {
                    Subject relateSub = pbDB.Subjects.SingleOrDefault(x => x.ID == subjectConditionID);

                    CurrentSubj.Subjects1.Add(relateSub);

                }
            }


            pbDB.SaveChanges();


        }

        public List<SubjectType> GetMainSubjectTypes()
        {
            pbDB = new ProgramBuilderEntities();

            List<SubjectType> SubjTyps = pbDB.SubjectTypes.Where(x => x.SubSubjectTypeID == null && x.SubTwoSubjectTypeID == null).ToList();

            return SubjTyps;
        }

        public List<SubjectType> GetSubSubjectTypes(int SubjTypeID)
        {
            pbDB = new ProgramBuilderEntities();

            List<SubjectType> SubjTyps = pbDB.SubjectTypes.Where(x => x.SubSubjectTypeID == SubjTypeID && x.SubTwoSubjectTypeID == null).ToList();
            return SubjTyps;
        }

        public List<SubjectType> GetSubTwoSubjectTypes(int SubjTypeID)
        {
            pbDB = new ProgramBuilderEntities();

            List<SubjectType> SubjTyps = pbDB.SubjectTypes.Where(x => x.SubSubjectTypeID == null && x.SubTwoSubjectTypeID == SubjTypeID).ToList();
            return SubjTyps;
        }

        public List<Subject> GetSubjects()
        {
            pbDB = new ProgramBuilderEntities();

            List<Subject> Subjs = pbDB.Subjects.ToList();

            return Subjs;
        }

        public List<GetProgramContentByFacultyID_Result> GetProgramContentByFacultyID(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            List<GetProgramContentByFacultyID_Result> ProgramContent = pbDB.GetProgramContentByFacultyID(ID).ToList();

            return ProgramContent;

            //var subject = from s in pbDB.Subjects
            //              join sof in pbDB.SubjectsOfFaculties.Where(x => x.FacultyID == ID) on s.ID equals sof.SubjectID
            //        select s;


            //var subjectTypes = (from st in pbDB.SubjectTypes
            //        join a in subject on st.ID equals a.SubjectTypeID into stGroup
            //        from stgr in stGroup.DefaultIfEmpty()
            //        select new
            //        {
            //            SubjectTypes = st                        
            //        }).Distinct().ToList();

            //List<SubjectType> SubTyps = new List<SubjectType>();

            //foreach (var SubjTyp in subjectTypes)
            //{
            //    SubjectType subty = new SubjectType();

            //    subty.Name = SubjTyp.SubjectTypes.Name;

            //    foreach (var sub in SubjTyp.SubjectTypes.Subjects)
            //    {
            //        Subject subj = new Subject();

            //        subj.PartialCode = sub.PartialCode;
            //        subj.Name = sub.Name;
            //        subj.CreditNumber = sub.CreditNumber;
            //        subj.SemesterNumber = sub.SemesterNumber;

            //        subty.Subjects.Add(subj);
            //    }                

            //    subty.Name = SubjTyp.SubjectTypes.Name;

            //    SubTyps.Add(subty);

            //}



        }


        public List<Subject> GetSubjectByFacultyID(int? FacultyID)
        {
            pbDB = new ProgramBuilderEntities();

            List<Subject> Subjs = pbDB.Subjects.Where(x => x.FacultyID == FacultyID || FacultyID == null).ToList();

            return Subjs;
        }

        public Subject GetSubjectByID(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            Subject sub = pbDB.Subjects.First(x => x.ID == ID);

            return sub;
        }

        public List<Subject> GetSubjectByAccountEditor(int ID)
        {
            pbDB = new ProgramBuilderEntities();

            List<Subject> subs = (from s in pbDB.Subjects
                                  join sa in pbDB.SubjectsAccounts on s.ID equals sa.SubjectID
                                  where sa.AccountID == ID && sa.IsSyllabusEditor == true && sa.Subject.Faculty.Programs.Count > 0
                                  select s).ToList();

            return subs;

        }

        //public List<KnowledgeSubjectType> GetKnowledgeSubjectTypeBySubjectID(int ID) {

        //    List<KnowledgeSubjectType> ResultLists = new List<KnowledgeSubjectType>();         

        //    var query = (from p in pbDB.SubjectTypes
        //            join f in pbDB.Subjects on p.ID equals f.SubjectTypeID into fg
        //            from fgi in fg.Where(f => f.ID == 18).DefaultIfEmpty()
        //            select new 
        //            {
        //                SubTypeName = p.SubjectType1.Name,
        //                SubTypeID = p.SubjectType1.ID,                      
        //                SubTypeName1 = p.Name,
        //                SubTypeID1 = p.ID,
        //                SubForm = fgi.Form == null ? false : fgi.Form
        //            }).ToList();

        //    foreach (var item in query)
        //    {
        //        KnowledgeSubjectType KnowSubType = new KnowledgeSubjectType();
        //        KnowSubType.SubjectTypeName = item.SubTypeName;
        //        KnowSubType.SubjectTypeID = item.SubTypeID;
        //        KnowSubType.SubjectTypeName1 = item.SubTypeName1;
        //        KnowSubType.SubjectTypeID1 = item.SubTypeID1;
        //        KnowSubType.Form = item.SubForm;

        //        ResultLists.Add(KnowSubType);

        //    }

        //    return ResultLists;
        //}
    }
}
