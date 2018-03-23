using ProgramBuilder.BUS;
using ProgramBuilder.DA;
using ProgramBuilder.WEB.Models;
using ProgramBuilder.WEB.Principal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using System.Web.Security;
using PagedList.Mvc;
using PagedList;

namespace ProgramBuilder.WEB.Controllers
{
    public class AccountController : Controller
    {

        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
       
        public ActionResult Login(string UserName, string Password, string returnURL)
        {

            Account acc = BUSAccount.FindAccount(UserName, Password);

            if (acc == null)
            {
                ModelState.AddModelError("", "UserName or Password was wrong");
                return View(acc);
            }

            List<string> accRoles = new List<string>();
            
            for (int i = 0; i < acc.Roles.ToList().Count; i++)
            {
                accRoles.Add(acc.Roles.ToList()[i].Name);
            }

            //--------------My Principal--------------------

            CustomPrincipalSerializedModel serializeModel = new CustomPrincipalSerializedModel();
            serializeModel.ID = acc.ID;
            serializeModel.FullName = acc.FullName;
            serializeModel.Roles = accRoles.ToArray();

            JavaScriptSerializer selialier = new JavaScriptSerializer();

            string AccountData = selialier.Serialize(serializeModel);

            //----------------------------------

            FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(
              1,
              acc.ID.ToString(),
              DateTime.Now,
              DateTime.Now.AddMinutes(90),
              false,
              AccountData,
              "/");

            //----------My Principal---------------

            string encTiket = FormsAuthentication.Encrypt(authTicket);
            HttpCookie faCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTiket);
            Response.Cookies.Add(faCookie);

            //Using Principal : int UserID = (User as AuthoriziePrincipal).ID;

            if (accRoles.Contains("Admin"))
            {
                return Redirect(returnURL ?? Url.Action("AccountsList", "Account"));
            }
            if (accRoles.Contains("Lecturer"))
            {
                return Redirect(returnURL ?? Url.Action("SyllabusesList", "Syllabus"));
            }
            if (accRoles.Contains("Deanery"))
            {
                return Redirect(returnURL ?? Url.Action("ProgramsList", "Program"));
            }
            if (accRoles.Contains("Editor"))
            {
                 return Redirect(returnURL ?? Url.Action("FaculitiesList", "Faculty"));
            }
            
            return Redirect(returnURL ?? Url.Action("Index", "Home"));

        }

        [Authorize]
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
              return RedirectToAction("Login", "Account");
        
        }

        [Authorize(Roles = "Admin")]        
        public ActionResult AddAccount()
        {

            List<Role> Roles = BUSAccount.GetRoles();
            ViewBag.Roles = new SelectList(Roles, "ID", "Name");

            List<Faculty> Faculties = BUSFaculty.GetFaculties();
            ViewBag.Faculties = new SelectList(Faculties, "ID", "VietNameseName", null);

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddAccount(Account acc, List<int> RoleIDs, string IsExist)
        {
            if (!ModelState.IsValid || IsExist == "true" || RoleIDs == null)
            {
                if ( IsExist == "true" && RoleIDs == null)
                {
                    ModelState.AddModelError("IsExist", "Tài khoản đã tồn tại");
                    ModelState.AddModelError("RoleIDs", "Vui lòng chọn vai trò cho account");
                }
                else
                {
                    if (IsExist == "true")
                    {
                        ModelState.AddModelError("IsExist", "Tài khoản đã tồn tại");
                    }

                    if (RoleIDs == null)
                    {
                        ModelState.AddModelError("RoleIDs", "Vui lòng chọn vai trò cho account");
                    }

                }

                List<Role> Roles = BUSAccount.GetRoles();
                ViewBag.Roles = new SelectList(Roles, "ID", "Name");

                List<Faculty> Faculties = BUSFaculty.GetFaculties();
                ViewBag.Faculties = new SelectList(Faculties, "ID", "VietNameseName", null);

                return View(acc);
            }

            BUSAccount.AddAccount(acc, RoleIDs);

            return RedirectToAction("AccountsList");
        }

       [Authorize(Roles = "Admin")]
        public ActionResult AccountsList( int? FacultyID, int? page = 1)
        {
            List<Faculty> Faculties = BUSFaculty.GetFaculties();
            ViewBag.Faculties = new SelectList(Faculties, "ID", "VietNameseName", "--- Tất cả ---");

            var Accs = BUSAccount.GetAccountsByFacultyID(FacultyID).OrderByDescending(x=>x.CreationTime).ToList();

            int pageSize = 5;
            return View(Accs.ToPagedList(page.Value, pageSize));
        }

        [HttpPost]
        public ActionResult AccountsList(int? FacultyID)
        {
            return RedirectToAction("AccountsList", new { FacultyID = FacultyID});
        }


       [Authorize]
        public ActionResult AccountDetail(int ID) {
            Account acc = BUSAccount.AccountDetail(ID);
            return View(acc);
        }

       [Authorize(Roles = "Admin")]
        public ActionResult EditAccount(int ID) {
            Account acc = BUSAccount.GetAccountByID(ID);

            List<Role> Roles = BUSAccount.GetRoles();
            ViewBag.Roles = new SelectList(Roles, "ID", "Name");

            List<Faculty> Faculties = BUSFaculty.GetFaculties();
            ViewBag.Faculties = new SelectList(Faculties, "ID", "VietNameseName", acc.Faculty);

            return View(acc);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditAccount(Account acc, List<int> RoleIDs)
        {
            if (!ModelState.IsValid)
            {
                List<Role> Roles = BUSAccount.GetRoles();
                ViewBag.Roles = new SelectList(Roles, "ID", "Name");

                List<Faculty> Faculties = BUSFaculty.GetFaculties();
                ViewBag.Faculties = new SelectList(Faculties, "ID", "VietNameseName", null);

                return View(acc);
            }

            BUSAccount.EditAccount(acc, RoleIDs);

            return RedirectToAction("AccountsList");
        }

        public ActionResult IsExistAccount(string username) {
            bool IsExist = BUSAccount.IsExistAccount(username);

            string message = IsExist ? "Username đã tồn tại." : "Bạn có thể sử dụng Username này.";

            return Json(new {IsExist = IsExist, Message = message}, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetAccountTeachSubjectByFacultyID(int ID) {
            List<Account> Accs = BUSAccount.GetAccountsTeachSubjectByFacultyID(ID);

            string HtmlResult = HelperAttribute.ViewUltility.RenderViewToString(this, "~/Views/Partials/LectureList.cshtml", Accs);

            return Json(new { HtmlResult = HtmlResult }, JsonRequestBehavior.AllowGet);
        }


        public ActionResult GetCurrentAccount() {
            int CurrentAccountID = (User as AuthorizePrincipal).ID;

            Account acc = BUSAccount.GetAccountByID(CurrentAccountID);

            return Json(new {
                                Name = acc.FullName, Degree = acc.Degree, 
                                Address = acc.Faculty.Classroom.Facility.Address + "(" + acc.Faculty.Classroom.Name + ")",
                                PhoneNumber = acc.Faculty.PhoneNumber + " hoặc " + acc.PhoneNumber,
                                Email = acc.Email
                            }, JsonRequestBehavior.AllowGet);
        }

    }
}
