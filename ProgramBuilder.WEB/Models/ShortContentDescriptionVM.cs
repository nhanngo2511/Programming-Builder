using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProgramBuilder.WEB.Models
{
    public class ShortContentDescriptionVM
    {
        public ShortContentDescriptionVM() {
            this.Subjects = new List<Subject>();
        }

        public int SemesterNumber { get; set; }

        public List<Subject> Subjects { get; set; }

    }
}