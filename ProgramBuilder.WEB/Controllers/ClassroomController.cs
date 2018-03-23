using ProgramBuilder.BUS;
using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ProgramBuilder.WEB.Controllers
{
    public class ClassroomController : Controller
    {
        [Authorize(Roles = "Admin")]
        public ActionResult Index(int? FacilityID) {

            List<Facility> Facilities = BUSFacility.GetFacilities();
            ViewBag.Facilities = new SelectList(Facilities, "ID", "Name");

            List<Classroom> Clasro = BUSClassroom.GetClassroomsByFacilityID02(FacilityID.HasValue ? FacilityID.Value : Facilities.First().ID);

            return View(Clasro);
        }

       [Authorize(Roles = "Admin")]
        public ActionResult AddClassroom() {
            List<Facility> Facilities = BUSFacility.GetFacilities();
            ViewBag.Facilities = new SelectList(Facilities, "ID", "Name");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddClassroom(Classroom clasro) {
            if (!ModelState.IsValid)
            {
                List<Facility> Facilities = new List<Facility>();
                ViewBag.Facilities = new SelectList(Facilities, "ID", "Name");

                return View(clasro);
            }

            BUSClassroom.AddClassroom(clasro);

            return RedirectToAction("Index");
        }

        public ActionResult GetClassroomsByFacilityID02(int ID)
        {

            List<Classroom> classes = BUSClassroom.GetClassroomsByFacilityID02(ID);

            var newclasses = classes
                             .Select(s => new
                             {
                                 ID = s.ID,
                                 Name = s.Name
                             }
                             ).ToList();


            return Json(newclasses, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetClassroomsExeceptClassOffice()
        {
            List<Classroom> Classes = BUSClassroom.GetClassroomsExeceptClassOffice();

            var Classrooms = BUSClassroom.GetClassroomsExeceptClassOffice()
                              .Select(s => new
                              {
                                  ID = s.ID,
                                  Name = s.Name + "(" + s.Facility.Address + ")"
                              }
                              ).ToList();

            return Json(Classrooms,JsonRequestBehavior.AllowGet);
        }

    }
}
