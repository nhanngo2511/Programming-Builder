using ProgramBuilder.BUS;
using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ProgramBuilder.WEB.Controllers
{
    public class FacilityController : Controller
    {
        [HttpGet]
        [Authorize(Roles = "Editor")]
        public ActionResult AddFacility()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddFacility(Facility facility)
        {
            if (!ModelState.IsValid)
            {
                return View(facility);
            }

            BUSFacility.AddFacility(facility);

            return View();
           
        }



        
    }
}
