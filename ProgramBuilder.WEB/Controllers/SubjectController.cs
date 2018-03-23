using ProgramBuilder.BUS;
using ProgramBuilder.DA;
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
    public class SubjectController : Controller
    {
        [Authorize(Roles = "Editor")]
        [HttpGet]
        public ActionResult AddSubject()
        {
            var Faculties = BUSFaculty.GetFaculties()
                            .Select(s => new
                                            {
                                                ID = s.ID,
                                                FacultyName = s.VietNameseName + " (" + s.EnglishName + ")"
                                            }
                            ).ToList();
            var Accounts = BUSAccount.GetAccounts().OrderBy(x => x.FullName).OrderBy(x => x.Faculty.VietNameseName)
                           .Select(s => new
                                          {
                                              ID = s.ID,
                                              Name = s.FullName + " (" + s.Faculty.VietNameseName + ")"
                                          }
                           ).ToList();

            ViewBag.Faculties = new SelectList(Faculties, "ID", "FacultyName");
            ViewBag.Subjects = new SelectList(BUSSubject.GetSubjects(), "ID", "Name");
            ViewBag.Accounts = new SelectList(Accounts, "ID", "Name", "--- Chọn giảng viên ---");

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddSubject(Subject subject, List<int> AccountIDs, List<int> subjectConditionIDs)
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
                var Accounts = BUSAccount.GetAccounts()
                               .Select(s => new
                               {
                                   ID = s.ID,
                                   Name = s.FullName + " (" + s.Faculty.VietNameseName + ")"
                               }
                               ).ToList();

                ViewBag.Faculties = new SelectList(Faculties, "ID", "FacultyName");
                ViewBag.Subjects = new SelectList(BUSSubject.GetSubjects(), "ID", "Name");
                ViewBag.Accounts = new SelectList(Accounts, "ID", "Name", "--- Chọn giảng viên ---");

                return View(subject);
            }

            BUSSubject.AddSubject(subject, AccountIDs, subjectConditionIDs);

            return RedirectToAction("SubjectsList");
        }

        public ActionResult GetMainSubjectTypes()
        {

            var subjecttypes = BUSSubject.GetMainSubjectTypes()
                               .Select(s => new
                                            {
                                                ID = s.ID,
                                                Name = s.Name
                                            }
                               ).ToList();

            return Json(subjecttypes, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetSubSubjectTypes(int ID)
        {

            var subjecttypes = BUSSubject.GetSubSubjectTypes(ID)
                               .Select(s => new
                                            {
                                                ID = s.ID,
                                                Name = s.Name
                                            }
                               ).ToList();

            return Json(subjecttypes, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetSubTwoSubjectTypes(int ID)
        {

            var subjecttypes = BUSSubject.GetSubTwoSubjectTypes(ID)
                              .Select(s => new
                                          {
                                              ID = s.ID,
                                              Name = s.Name
                                          }
                              ).ToList();

            return Json(subjecttypes, JsonRequestBehavior.AllowGet);
        }



        public ActionResult GetProgramContentByFacultyID(int ID)
        {

            List<GetProgramContentByFacultyID_Result> ProgContResult = BUSSubject.GetProgramContentByFacultyID(ID);

            List<ProgramContentViewModel> ProgContVMs = new List<ProgramContentViewModel>();

            foreach (var item in ProgContResult)
            {
                ProgramContentViewModel ProgContVM = new ProgramContentViewModel();

                ProgContVM.ID = item.ID;
                ProgContVM.Name = item.SubjectTypeName;
                ProgContVM.CreditNumberTotal = item.CreditNumberTotal.HasValue ? item.CreditNumberTotal.Value : 0;

                if (!String.IsNullOrEmpty(item.SubjectsList))
                {
                    string StrSubjectList = item.SubjectsList.TrimEnd(new[] { '|' });

                    string[] ArrSubjectList = Regex.Split(StrSubjectList, @"\|\|");

                    for (int i = 0; i < ArrSubjectList.Length; i++)
                    {
                        SubjectViewModel Subject = new SubjectViewModel();

                        Subject.ID = Int32.Parse(Regex.Split(ArrSubjectList[i], @"\|")[0]);
                        Subject.PartialCode = Regex.Split(ArrSubjectList[i], @"\|")[1];
                        Subject.Name = Regex.Split(ArrSubjectList[i], @"\|")[2];
                        Subject.CreditNumber = Int32.Parse(Regex.Split(ArrSubjectList[i], @"\|")[3]);
                        Subject.SemesterNumber = Int32.Parse(Regex.Split(ArrSubjectList[i], @"\|")[4]);

                        ProgContVM.Subjects.Add(Subject);
                    }
                }
                ProgContVMs.Add(ProgContVM);

            }

            string HtmlResult = HelperAttribute.ViewUltility.RenderViewToString(this, "~/Views/Partials/ProgramContent.cshtml", ProgContVMs);

            return Json(new { HtmlResult = HtmlResult }, JsonRequestBehavior.AllowGet);
        }



        public ActionResult GetSubjects()
        {
            List<Subject> Subjects = BUSSubject.GetSubjects();

            return Json(Subjects, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "Editor, Deanery")]
        public ActionResult SubjectsList(int? FacultyID, int? page = 1)
        {
            List<Faculty> Faculties = BUSFaculty.GetFaculties();
            ViewBag.Faculties = new SelectList(Faculties, "ID", "VietNameseName", "--- Tất cả ---");

            List<Subject> Subjects = BUSSubject.GetSubjectsByFacutyID(FacultyID).OrderByDescending(x=>x.CreationTime).ToList();

            int pageSize = 5;
            return View(Subjects.ToPagedList(page.Value, pageSize));
        }

        [HttpPost]
        public ActionResult SubjectsList(int? FacultyID) {
            return RedirectToAction("SubjectsList", new { FacultyID = FacultyID });
        }

        [Authorize(Roles = "Editor, Deanery")]
        public ActionResult SubjectDetail(int ID) {
            Subject sub = BUSSubject.GetSubjectByID(ID);

            return View(sub);
        }

        public ActionResult GetSubjectID(int ID)
        {
            //string HtmlResult = HelperAttribute.ViewUltility.RenderViewToString(this,"~/Views/Partials/KnowledgeSubjectType.cshtml", null);

            Subject sb = BUSSubject.GetSubjectByID(ID);

            string subtype = (sb.SubjectType.SubSubjectTypeID == 1 || sb.SubjectType.SubSubjectTypeID == null) ? "Kiến thức giáo dục đại cương" : "Kiến thức giáo dục chuyên nghiệp";
            string subtype1 = (sb.ID == 7 || sb.ID == 9) ? "Kiến thức cơ sở ngành" : "Kiến thức chuyên ngành";
            string SubjectForm = (sb.Form == true) ? "Bắt buộc": "Tùy chọn";

            List<string> SubjectRelateList = new List<string>();
            foreach (var item in sb.Subjects1)
            {
                SubjectRelateList.Add(item.Name);
            }

            return Json(new 
                        {
                            SubjectName = sb.Name, 
                            SubjectType = subtype, 
                            SubjectType1 = subtype1, 
                            SubjectForm = SubjectForm,

                            CreditNumber = sb.CreditNumber,
                            LearningLevel = sb.LearningLevel,
                            TheoryNumber = sb.TheoryNumber,
                            PracticeNumber = sb.PracticeNumber,
                            RelateSubjects = SubjectRelateList == null ? null : SubjectRelateList,
                            Purpose = sb.Purpose
                        }, JsonRequestBehavior.AllowGet);

        }

         [Authorize(Roles = "Editor")]
        [HttpGet]
        public ActionResult EditSubject(int ID)
        {
            var Faculties = BUSFaculty.GetFaculties()
                            .Select(s => new
                            {
                                ID = s.ID,
                                FacultyName = s.VietNameseName + " (" + s.EnglishName + ")"
                            }
                            ).ToList();
            var Accounts = BUSAccount.GetAccounts().OrderBy(x => x.FullName).OrderBy(x => x.Faculty.VietNameseName)
                           .Select(s => new
                           {
                               ID = s.ID,
                               Name = s.FullName + " (" + s.Faculty.VietNameseName + ")"
                           }
                           ).ToList();

            ViewBag.Faculties = new SelectList(Faculties, "ID", "FacultyName");
            ViewBag.Subjects = new SelectList(BUSSubject.GetSubjects(), "ID", "Name");
            ViewBag.Accounts = new SelectList(Accounts, "ID", "Name", "--- Chọn giảng viên ---");

            Subject subj = BUSSubject.GetSubjectByID(ID);

            return View(subj);

        }

        [ValidateAntiForgeryToken]
        [HttpPost]

        public ActionResult EditSubject(Subject subject, List<int> AccountIDs, List<int> subjectConditionIDs)
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
                var Accounts = BUSAccount.GetAccounts().OrderBy(x => x.FullName).OrderBy(x => x.Faculty.VietNameseName)
                               .Select(s => new
                               {
                                   ID = s.ID,
                                   Name = s.FullName + " (" + s.Faculty.VietNameseName + ")"
                               }
                               ).ToList();

                ViewBag.Faculties = new SelectList(Faculties, "ID", "FacultyName");
                ViewBag.Subjects = new SelectList(BUSSubject.GetSubjects(), "ID", "Name");
                ViewBag.Accounts = new SelectList(Accounts, "ID", "Name", "--- Chọn giảng viên ---");

                return View(subject);
            }

            BUSSubject.EditSubject(subject, AccountIDs, subjectConditionIDs);

            return RedirectToAction("SubjectsList");

        }
    }
}
