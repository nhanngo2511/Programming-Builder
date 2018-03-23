using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProgramBuilder.WEB.Models
{

    public class ProgramContentViewModel
    {
        public ProgramContentViewModel()
        {
            this.CreditNumberTotal = 0;
            this.Subjects = new List<SubjectViewModel>();
        }

        public int ID { get; set; }

        public string Name { get; set; }

        public int CreditNumberTotal { get; set; }

        public List<SubjectViewModel> Subjects { get; set; }

    }


}