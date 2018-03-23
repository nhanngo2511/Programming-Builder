using ProgramBuilder.BUS;
using ProgramBuilder.DA;
using ProgramBuilder.WEB.HelperAttribute;
using ProgramBuilder.WEB.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using PagedList;
using PagedList.Mvc;

namespace ProgramBuilder.WEB.Controllers
{

    public class ProgramController : Controller
    {

        [Authorize(Roles = "Editor")]
        [Authorize]
        public ActionResult AddProgram()
        {

            var Faculties = BUSFaculty.GetFaculties().Where(x => x.Programs.Count == 0).ToList()
                           .Select(s => new
                           {
                               ID = s.ID,
                               FacultyName = s.VietNameseName + " (" + s.EnglishName + ")"
                           }
                           ).ToList();

            ViewBag.Faculties = new SelectList(Faculties, "ID", "FacultyName");

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [MultipleButton(Name = "action", Argument = "Add")]
        public ActionResult AddProgram(Program Prog)
        {

            if (!ModelState.IsValid)
            {
                var Faculties = BUSFaculty.GetFaculties().Where(x => x.Programs.Count == 0).ToList()
                            .Select(s => new
                            {
                                ID = s.ID,
                                FacultyName = s.VietNameseName + " (" + s.EnglishName + ")"
                            }
                            ).ToList();

                ViewBag.Faculties = new SelectList(Faculties, "ID", "FacultyName");
                return View("AddProgram", Prog);
            }

            BUSProgram.AddProgram(Prog);

            return RedirectToAction("ProgramsList");
        }

        [Authorize(Roles = "Editor")]
        [Authorize]
        public ActionResult EditProgram(int ID)
        {
            Program prog = BUSProgram.GetProgramByID(ID);

            return View(prog);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [MultipleButton(Name = "action", Argument = "Edit")]
        public ActionResult EditProgram(Program prog)
        {
            if (!ModelState.IsValid)
            {
                prog.Faculty = BUSFaculty.GetFacultyByID(prog.FacultyID);
                return View(prog);
            }

            BUSProgram.EditProgram(prog);

            return RedirectToAction("ProgramsList");
        }

        [HttpGet]
        [Authorize(Roles = "Editor, Deanery, Lecturer")]
        public ActionResult ReviewProgram(int ID)
        {
            Program prog = BUSProgram.GetProgramByID(ID);

            return View(prog);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [MultipleButton(Name = "action", Argument = "Review")]
        public ActionResult ReviewProgram(Program program)
        {
            if (!ModelState.IsValid)
            {

                var Faculties = BUSFaculty.GetFaculties()
                            .Select(s => new
                            {
                                ID = s.ID,
                                FacultyName = s.VietNameseName + " (" + s.EnglishName + ")"
                            }
                            ).ToList();

                ViewBag.Faculties = new SelectList(Faculties, "ID", "FacultyName");

                return View("AddProgram", program);
            }

            program.Faculty = BUSFaculty.GetFacultyByID(program.FacultyID);

            program.CreationTime = DateTime.Now;

            return View("ReviewProgram", program);
        }

        [WordDocument]
        [Authorize(Roles = "Editor, Deanery, Lecturer")]
        public ActionResult ExportToWord(int ID)
        {
            Program pro = BUSProgram.GetProgramByID(ID);

            ViewBag.WordDocumentFilename = pro.Name;

            return View("ReviewProgram", pro);

        }

        [Authorize(Roles = "Editor, Deanery, Lecturer")]
        public ActionResult ProgramsList(int? page = 1)
        {
            List<Program> Progs = BUSProgram.GetPrograms().OrderByDescending(x => x.CreationTime).ToList();

            int pageSize = 10;

            return View(Progs.ToPagedList(page.Value, pageSize));

        }


        public ActionResult GetTrainingPLanByFacultyID(int ID)
        {

            Dictionary<int, List<Subject>> TrainingPlans = BUSProgram.GetShortContentDescriptionByFacultyID(ID);

            //List<GetTrainingPlanByFacultyID_Result> TrainingPlans = BUSProgram.GetTrainingPlanByFacultyID(ID);

            List<TrainingPlanViewModel> TrainingPlanViewModels = new List<TrainingPlanViewModel>();

            foreach (KeyValuePair<int, List<Subject>> item in TrainingPlans)
            {
                TrainingPlanViewModel TrainPlaContVM = new TrainingPlanViewModel();

                TrainPlaContVM.SemesterNumber = item.Key;
                TrainPlaContVM.Subjects = item.Value;

                foreach (var itemSub in item.Value)
                {
                    TrainPlaContVM.CreditNumberTotal += itemSub.CreditNumber;
                    TrainPlaContVM.LessonNumber += (itemSub.PracticeNumber + itemSub.TheoryNumber);
                }

                TrainingPlanViewModels.Add(TrainPlaContVM);
            }

            //foreach (var TrainPla in TrainingPlans)
            //{
            //    TrainingPlanViewModel TrainPlaViMo = new TrainingPlanViewModel();

            //    TrainPlaViMo.SemesterNumber = TrainPla.SemesterNumber;
            //    TrainPlaViMo.LessonNumber = TrainPla.LessonNumber.Value;
            //    TrainPlaViMo.CreditNumberTotal = TrainPla.CreditNumberTotal.Value;

            //    string StrSubjectList = TrainPla.SubjectsList.TrimEnd(new[] { '|' });

            //    string[] ArrSubjectList = Regex.Split(StrSubjectList, @"\|\|");

            //    for (int i = 0; i < ArrSubjectList.Length; i++)
            //    {
            //        SubjectViewModel Subject = new SubjectViewModel();

            //        Subject.ID = Int32.Parse(Regex.Split(ArrSubjectList[i], @"\|")[0]);
            //        Subject.PartialCode = Regex.Split(ArrSubjectList[i], @"\|")[1];
            //        Subject.Name = Regex.Split(ArrSubjectList[i], @"\|")[2];
            //        Subject.CreditNumber = Int32.Parse(Regex.Split(ArrSubjectList[i], @"\|")[3]);
            //        Subject.TheoryNumber = Int32.Parse(Regex.Split(ArrSubjectList[i], @"\|")[4]);
            //        Subject.PracticeNumber = Int32.Parse(Regex.Split(ArrSubjectList[i], @"\|")[5]);
            //        Subject.TheoryPraciceNumberTotal = Subject.TheoryNumber + Subject.PracticeNumber;
            //        Subject.SemesterNumber = TrainPla.SemesterNumber;

            //        TrainPlaViMo.SubjectsList.Add(Subject);
            //    }

            //    TrainingPlanViewModels.Add(TrainPlaViMo);
            //}

            string HtmlResult = HelperAttribute.ViewUltility.RenderViewToString(this, "~/Views/Partials/TrainingPlan.cshtml", TrainingPlanViewModels);

            return Json(new { HtmlResult = HtmlResult }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetShortContentDescriptionByFacultyID(int ID)
        {
            Dictionary<int, List<Subject>> QueryResult = BUSProgram.GetShortContentDescriptionByFacultyID(ID);

            List<ShortContentDescriptionVM> shortContVMs = new List<ShortContentDescriptionVM>();

            foreach (KeyValuePair<int, List<Subject>> item in QueryResult)
            {
                ShortContentDescriptionVM shortContVM = new ShortContentDescriptionVM();

                shortContVM.SemesterNumber = item.Key;
                shortContVM.Subjects = item.Value;

                shortContVMs.Add(shortContVM);

            }


            string HtmlResult = HelperAttribute.ViewUltility.RenderViewToString(this, "~/Views/Partials/ShortContentDescription.cshtml", shortContVMs);

            return Json(new { HtmlResult = HtmlResult }, JsonRequestBehavior.AllowGet);

        }

        public ActionResult GetLengthProgramPurposeBySubjectID(int ID)
        {
            int Length = BUSProgram.GetLengthProgramPurposeBySubjectID(ID);
            string Content = BUSProgram.GetContentProgramPurposeBySubjectID(ID);

            return Json(new { Length = Length, Content = Content }, JsonRequestBehavior.AllowGet);
        }


    }
}
