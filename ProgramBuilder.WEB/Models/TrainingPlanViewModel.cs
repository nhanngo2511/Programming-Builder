using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProgramBuilder.WEB.Models
{
    public class TrainingPlanViewModel
    {
        public TrainingPlanViewModel()
        {
            this.CreditNumberTotal = 0;
            this.LessonNumber = 0;
            this.Subjects = new List<Subject>();
        }

        public int SemesterNumber { get; set; }
        public List<Subject> Subjects { get; set; }
        public int CreditNumberTotal { get; set; }
        public int LessonNumber { get; set; }
    }
}