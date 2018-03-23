using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProgramBuilder.WEB.Models
{
    public partial class ClassroomVM
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public bool IsOfficeFacility { get; set; }
        public int FacilityID { get; set; }
        public System.DateTime CreationTime { get; set; }
    }
}