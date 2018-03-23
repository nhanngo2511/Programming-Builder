using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.DA
{
    public class DAAccount
    {

        private ProgramBuilderEntities pbDB;

        public Account FindAccount(string username, string password)
        {
            pbDB = new ProgramBuilderEntities();

            Account acc = pbDB.Accounts.Where(x => x.UserName == username && x.Password == password).FirstOrDefault();

            return acc;

        }

        public void AddAccount(Account Acc, List<int> RoleIDs)
        {
            pbDB = new ProgramBuilderEntities();
            Acc.CreationTime = DateTime.Now;

            pbDB.Accounts.Add(Acc);

            pbDB.SaveChanges();

            int CurrentAccID = Acc.ID;

            Account acc = pbDB.Accounts.FirstOrDefault(x => x.ID == CurrentAccID);
            foreach (int RoleID in RoleIDs)
            {

                Role role = pbDB.Roles.FirstOrDefault(x => x.ID == RoleID);
                acc.Roles.Add(role);

            }

            pbDB.SaveChanges();


        }

        public void EditAccount(Account Acc, List<int> RoleIDs)
        {
            pbDB = new ProgramBuilderEntities();
            Account AccReslut = pbDB.Accounts.FirstOrDefault(x => x.ID == Acc.ID);

            AccReslut.UserName = Acc.UserName;
            AccReslut.Password = Acc.Password;
            AccReslut.FullName = Acc.FullName;
            AccReslut.Degree = Acc.Degree;
            AccReslut.PhoneNumber = Acc.PhoneNumber;
            AccReslut.Email = Acc.Email;
            AccReslut.FacultyID = Acc.FacultyID;

            AccReslut.Roles.Clear();
      
            foreach (int RoleID in RoleIDs)
            {
                Role role = pbDB.Roles.FirstOrDefault(x => x.ID == RoleID);

                AccReslut.Roles.Add(role);

            }

            pbDB.SaveChanges();
        }

        public void DeleteAccount(int ID)
        {
            pbDB = new ProgramBuilderEntities();
            Account AccReslut = pbDB.Accounts.Where(x => x.ID == ID).FirstOrDefault();
            pbDB.Accounts.Remove(AccReslut);

            pbDB.Roles.RemoveRange(AccReslut.Roles);

            pbDB.SaveChanges();

        }

        public List<Account> GetAccountsByFacultyID(int? FacultyID)
        {
            pbDB = new ProgramBuilderEntities();
            List<Account> Accs = pbDB.Accounts.Where(x => x.FacultyID == FacultyID || FacultyID == null).ToList();
            return Accs;
        }

        public List<Account> GetAccountsTeachSubjectByFacultyID(int FacultyID)
        {
            pbDB = new ProgramBuilderEntities();
            List<Account> accs = (from acc in pbDB.Accounts                                  
                    join sa in pbDB.SubjectsAccounts on acc.ID equals sa.AccountID
                    join su in pbDB.Subjects on sa.SubjectID equals su.ID
                    where su.FacultyID == FacultyID
                    select acc).ToList();

            return accs;
        }

        public bool IsExistAccount(string username)
        {
            pbDB = new ProgramBuilderEntities();
            bool IsExist = pbDB.Accounts.Any(x => x.UserName == username);

            return IsExist;

        }

        public List<Role> GetRoles()
        {
            pbDB = new ProgramBuilderEntities();
            List<Role> Roles = pbDB.Roles.ToList();

            return Roles;
        }

        public Account GetAccountByID(int ID)
        {
            pbDB = new ProgramBuilderEntities();
            Account acc = pbDB.Accounts.Where(x => x.ID == ID).FirstOrDefault();

            return acc;
        }

        public List<Account> GetAccounts()
        {
            pbDB = new ProgramBuilderEntities();
            List<Account> Accs = pbDB.Accounts.Where(x => x.FacultyID != null).ToList();
            return Accs;

        }

        public Account AcccountDetail(int ID)
        {
            pbDB = new ProgramBuilderEntities();
            Account acc = pbDB.Accounts.Single(x => x.ID == ID);
            return acc;
        }
    }
}