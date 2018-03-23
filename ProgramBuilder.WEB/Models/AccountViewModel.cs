using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProgramBuilder.WEB.Models
{
    public class AccountViewModel
    {

        public AccountViewModel() {
            this.Faculty = new FacultyViewModel();
        }

        public int ID { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }

        public FacultyViewModel Faculty { get; set; }


    }
}