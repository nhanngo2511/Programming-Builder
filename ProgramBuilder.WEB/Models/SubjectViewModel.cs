using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProgramBuilder.WEB.Models
{
    public class SubjectViewModel
    {

        public int ID { get; set; }

        public SubjectViewModel()
        {
            this.TheoryNumber = 0;
            this.PracticeNumber = 0;

            this.TheoryPraciceNumberTotal = this.TheoryNumber + this.PracticeNumber;

            this.SubjectsRelate = new List<SubjectViewModel>();
        }
        public string PartialCode { get; set; }
        public string Name { get; set; }

        public int TheoryNumber { get; set; }

        public int PracticeNumber { get; set; }

        public int CreditNumber { get; set; }

        public int SemesterNumber { get; set; }

        public int TheoryPraciceNumberTotal { get; set; }

        public List<SubjectViewModel> SubjectsRelate { get; set; }
    }
}