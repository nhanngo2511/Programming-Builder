using ProgramBuilder.BUS;
using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PagedList;
using PagedList.Mvc;

namespace ProgramBuilder.WEB.Controllers
{
    public class FacultyController : Controller
    {
        public ActionResult GetFaculties()
        {
            List<Faculty> faculties = BUSFaculty.GetFaculties();

            return Json(faculties, JsonRequestBehavior.AllowGet);
        }


         [Authorize(Roles = "Editor, Deanery")]
        public ActionResult FaculitiesList(int? page = 1) {
            List<Faculty> faculties = BUSFaculty.GetFaculties();
            int pageSize = 5;
            return View(faculties.ToPagedList(page.Value, pageSize));
        }

         [Authorize(Roles = "Editor, Deanery")]
        public ActionResult FacultyDetail(int ID){
            Faculty Facu = BUSFaculty.GetFacultyByID(ID);
            return View(Facu);
        }

        public ActionResult GetFacultyByID(int ID)
        {
            Faculty Facu = BUSFaculty.GetFacultyByID(ID);

            int CreditNumber = BUSFaculty.GetCreditNumberByFacultyID(ID);

            return Json(new {   ID = Facu.ID,
                                VietNameseName = Facu.VietNameseName,
                                EnglishName = Facu.EnglishName,
                                TrainingTime = Facu.TrainingTime,
                                CreditNumber = CreditNumber
                            }, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "Editor")]
        public ActionResult AddFaculty()
        {
            List<Facility> facilities = BUSFacility.GetFacilities();

            ViewBag.facilities = new SelectList(facilities, "ID", "Name");
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddFaculty(Faculty faculty)
        {
            if (!ModelState.IsValid)
            {
                List<Facility> facilities = BUSFacility.GetFacilities();
                ViewBag.facilities = new SelectList(facilities, "ID", "Name");
                return View(faculty);
            }

            BUSFaculty.AddFaculty(faculty);

            return RedirectToAction("FaculitiesList");
        }

        [HttpGet]
        [Authorize(Roles = "Editor")]
        public ActionResult EditFaculty(int ID)
        {

            List<Facility> facilities = BUSFacility.GetFacilities();

            ViewBag.facilities = new SelectList(facilities, "ID", "Name");
            Faculty facu = BUSFaculty.GetFacultyByID(ID);

            return View(facu);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditFaculty(Faculty Facu)
        {
            if (!ModelState.IsValid)
            {
                List<Facility> facilities = BUSFacility.GetFacilities();

                ViewBag.facilities = new SelectList(facilities, "ID", "Name");

                return View(Facu);
            }

            BUSFaculty.EditFaculty(Facu);

            return RedirectToAction("FaculitiesList");

        }
    }
}
