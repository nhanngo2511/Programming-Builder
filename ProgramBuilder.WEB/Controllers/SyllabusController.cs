using ProgramBuilder.BUS;
using ProgramBuilder.DA;
using ProgramBuilder.WEB.HelperAttribute;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace ProgramBuilder.WEB.Controllers
{
    public class SyllabusController : Controller
    {

        [HttpPost]
        [ValidateAntiForgeryToken]
        [MultipleButton(Name = "action", Argument = "Add")]
        public ActionResult AddSyllabus(Syllabus sylla)
        {
            if (!ModelState.IsValid)
            {
                int CurrentAccID = (User as Principal.AuthorizePrincipal).ID;

                var Subjects = BUSSubject.GetSubjectByAccountEditor(CurrentAccID)
                               .Select(s => new
                                               {
                                                   ID = s.ID,
                                                   Name = s.Name + "(" + s.Faculty.VietNameseName + ")"
                                               }
                               ).ToList();

                var Classrooms = BUSClassroom.GetClassroomsExeceptClassOffice()
                                 .Select(s => new
                                 {
                                     ID = s.ID,
                                     Name = s.Name + "  (" + s.Facility.Name + ")" + "  (" + s.Facility.Address + ")"
                                 }
                                 ).ToList();


                ViewBag.Subjects = new SelectList(Subjects, "ID", "Name");

                ViewBag.Classrooms = new SelectList(Classrooms, "ID", "Name");

                return View("AddSyllabus",sylla);
            }

            BUSSyllabus.AddSyllabus(sylla);

            return RedirectToAction("SyllabusesList");
        }
        
        [HttpPost]
        [ValidateAntiForgeryToken]
        [MultipleButton(Name = "action", Argument = "Review")]
        public ActionResult ReviewSyllabus(Syllabus sylla)
        {
            if (!ModelState.IsValid)
            {

                int CurrentAccID = (User as Principal.AuthorizePrincipal).ID;

                var Subjects = BUSSubject.GetSubjectByAccountEditor(CurrentAccID)
                               .Select(s => new
                               {
                                   ID = s.ID,
                                   Name = s.Name + "(" + s.Faculty.VietNameseName + ")"
                               }
                               ).ToList();

                var Classrooms = BUSClassroom.GetClassroomsExeceptClassOffice()
                                 .Select(s => new
                                 {
                                     ID = s.ID,
                                     Name = s.Name + "  (" + s.Facility.Name + ")" + "  (" + s.Facility.Address + ")"
                                 }
                                 ).ToList();


                ViewBag.Subjects = new SelectList(Subjects, "ID", "Name");

                ViewBag.Classrooms = new SelectList(Classrooms, "ID", "Name");
                
                return View("AddSyllabus", sylla);
            }

            sylla.CreationTime = DateTime.Now;
            sylla.Subject = BUSSubject.GetSubjectByID(sylla.SubjectID);
            sylla.Classroom = BUSClassroom.GetClassroomByID(sylla.ClassroomID);

            sylla.Account = BUSAccount.GetAccountByID(sylla.CreatedAccountID);

            return View("ReviewSyllabus", sylla);
        }

         [Authorize(Roles = "Lecturer, Deanery")]
        public ActionResult AddSyllabus()
        {
            int CurrentAccID = (User as Principal.AuthorizePrincipal).ID;

            var Subjects = BUSSubject.GetSubjectByAccountEditor(CurrentAccID)
                           .Select(s => new
                                           {
                                               ID = s.ID,
                                               Name = s.Name + "(" + s.Faculty.VietNameseName + ")"
                                           }
                           ).ToList();

            var Classrooms = BUSClassroom.GetClassroomsExeceptClassOffice()
                             .Select(s => new
                             {
                                 ID = s.ID,
                                 Name = s.Name + "  (" + s.Facility.Name + ")" + "  (" + s.Facility.Address + ")"
                             }
                             ).ToList();


            ViewBag.Subjects = new SelectList(Subjects, "ID", "Name");

            ViewBag.Classrooms = new SelectList(Classrooms, "ID", "Name");

            return View();
        }

        [Authorize(Roles = "Lecturer, Deanery")]
        public ActionResult SyllabusesList()
        {
            int CurrentAccID = (User as ProgramBuilder.WEB.Principal.AuthorizePrincipal).ID;
            List<Syllabus> Syllas = BUSSyllabus.SyllabusesList().Where(x => x.CreatedAccountID == CurrentAccID).ToList();

            return View(Syllas);

        }


        [WordDocument]
        [Authorize(Roles = "Lecturer, Deanery")]
        public ActionResult ExportToWord(int ID)
        {
            Syllabus sylla = BUSSyllabus.GetSyllabusByID(ID);

            ViewBag.WordDocumentFilename = sylla.VietnameseName;

            return View("ReviewSyllabus", sylla);

        }

         [Authorize(Roles = "Lecturer, Deanery")]
        public ActionResult ReviewSyllabus(int ID){

            Syllabus sylla = BUSSyllabus.GetSyllabusByID(ID);

            return View(sylla);
        }

        [Authorize(Roles = "Lecturer, Deanery")]
        public ActionResult EditSyllabus(int ID) {
            int CurrentAccID = (User as Principal.AuthorizePrincipal).ID;

            var Subjects = BUSSubject.GetSubjectByAccountEditor(CurrentAccID)
                           .Select(s => new
                           {
                               ID = s.ID,
                               Name = s.Name + "(" + s.Faculty.VietNameseName + ")"
                           }
                           ).ToList();

            var Classrooms = BUSClassroom.GetClassroomsExeceptClassOffice()
                             .Select(s => new
                             {
                                 ID = s.ID,
                                 Name = s.Name + "  (" + s.Facility.Name + ")" + "  (" + s.Facility.Address + ")"
                             }
                             ).ToList();


            ViewBag.Subjects = new SelectList(Subjects, "ID", "Name");

            ViewBag.Classrooms = new SelectList(Classrooms, "ID", "Name");

            Syllabus sylla = BUSSyllabus.GetSyllabusByID(ID);

            return View(sylla);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditSyllabus(Syllabus sylla)
        {
            if (!ModelState.IsValid)
            {

            int CurrentAccID = (User as Principal.AuthorizePrincipal).ID;

            var Subjects = BUSSubject.GetSubjectByAccountEditor(CurrentAccID)
                           .Select(s => new
                           {
                               ID = s.ID,
                               Name = s.Name + "(" + s.Faculty.VietNameseName + ")"
                           }
                           ).ToList();

            var Classrooms = BUSClassroom.GetClassroomsExeceptClassOffice()
                             .Select(s => new
                             {
                                 ID = s.ID,
                                 Name = s.Name + "  (" + s.Facility.Name + ")" + "  (" + s.Facility.Address + ")"
                             }
                             ).ToList();


            ViewBag.Subjects = new SelectList(Subjects, "ID", "Name");

            ViewBag.Classrooms = new SelectList(Classrooms, "ID", "Name");

            return View(sylla);
            }

            BUSSyllabus.EditSyllabus(sylla);

            return RedirectToAction("SyllabusesList");

        }



    }
}
