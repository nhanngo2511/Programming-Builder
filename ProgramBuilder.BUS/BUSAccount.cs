using ProgramBuilder.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.BUS
{
    public static class BUSAccount
    {
        static DAAccount DAA = new DAAccount();
        public static Account FindAccount(string username, string password) {
            Account acc = DAA.FindAccount(username, password);

            return acc;        
        }

        public static void AddAccount(Account Acc, List<int> RoleIDs)
        {
            DAA.AddAccount(Acc, RoleIDs);
        }

        public static void EditAccount(Account Acc, List<int>RoleIDs)
        {
            DAA.EditAccount(Acc, RoleIDs);
        }

        public static void DeleteAccount(int ID)
        {
            DAA.DeleteAccount(ID);
        }

        public static List<Account> GetAccountsByFacultyID(int? FacultyID)
        {
            List<Account> Accs = DAA.GetAccountsByFacultyID(FacultyID);
            return Accs;
        }

        public static List<Account> GetAccountsTeachSubjectByFacultyID(int FacultyID)
        {
            return DAA.GetAccountsTeachSubjectByFacultyID(FacultyID);
            
        }

        public static bool IsExistAccount(string username)
        {
            bool isExist = DAA.IsExistAccount(username);

            return isExist;
        }


        public static List<Role> GetRoles()
        {
            List<Role> Roles = DAA.GetRoles();

            return Roles;
        }

        public static Account GetAccountByID(int ID)
        {
            Account acc = DAA.GetAccountByID(ID);
            return acc;
        }

        public static List<Account> GetAccounts()
        {
            List<Account> Accs = DAA.GetAccounts();

            return Accs;
        }

        public static Account AccountDetail(int ID)
        {
            return DAA.AcccountDetail(ID);

        }
    }
}
