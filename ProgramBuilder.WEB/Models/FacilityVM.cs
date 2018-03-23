using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ProgramBuilder.WEB.Models
{
    public partial class FacilityVM
    {
        public FacilityVM()
        {
            this.Classrooms = new HashSet<ClassroomVM>();
        }
    
        public int ID { get; set; }
        [Required]
        [StringLength(5)]
        public string Name { get; set; }
        [Required]
        public string Address { get; set; }
        public System.DateTime CreationTime { get; set; }

        public virtual ICollection<ClassroomVM> Classrooms { get; set; }
    }
}