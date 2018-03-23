using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.DA
{
   public class DASyllabus
    {
       private ProgramBuilderEntities pbDB;

       public void AddSyllabus(Syllabus Sylla)
       {
           pbDB = new ProgramBuilderEntities();

           Sylla.CreationTime = DateTime.Now;

           pbDB.Syllabuses.Add(Sylla);

           pbDB.SaveChanges();

       }

       public List<Syllabus> SyllabusesList()
       {
           pbDB = new ProgramBuilderEntities();

           return pbDB.Syllabuses.OrderBy(x => x.CreationTime).ToList();

       }

       public Syllabus GetSyllabusByID(int ID)
       {
           pbDB = new ProgramBuilderEntities();

           return pbDB.Syllabuses.Where(x => x.ID == ID).Single();
       }

       public void EditSyllabus(Syllabus sylla)
       {
           pbDB = new ProgramBuilderEntities();

           Syllabus CurrentSylla = pbDB.Syllabuses.Single(x=>x.ID == sylla.ID);

           CurrentSylla.VietnameseName = sylla.VietnameseName;
           CurrentSylla.EnglishName = sylla.EnglishName;
           CurrentSylla.KnowldgeType = sylla.KnowldgeType;
           CurrentSylla.LearningTimeDetail = sylla.LearningTimeDetail;
           CurrentSylla.Requirement = sylla.Requirement;
           CurrentSylla.Planning = sylla.Planning;
           CurrentSylla.DocumentReference = sylla.DocumentReference;
           CurrentSylla.LearningOutcomeEvaluate = sylla.LearningOutcomeEvaluate;
           CurrentSylla.LecturerContact = sylla.LecturerContact;
           CurrentSylla.ShortDescription = sylla.ShortDescription;
           CurrentSylla.OutcomeContent = sylla.OutcomeContent;
           CurrentSylla.OutcomeMaxtrixMapping = sylla.OutcomeMaxtrixMapping;
           CurrentSylla.OutcomeMappingDescription = sylla.OutcomeMappingDescription;
           CurrentSylla.ClassroomID = sylla.ClassroomID;
           CurrentSylla.CreationTime = DateTime.Now;

           pbDB.SaveChanges();
       }
    }
}
