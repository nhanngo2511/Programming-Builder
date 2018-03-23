
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProgramBuilder.DA
{
    public class DAFacility
    {
        private ProgramBuilderEntities pbDB;
        public void AddFacility(Facility Faci)
        {
            pbDB = new ProgramBuilderEntities();

            pbDB.Facilities.Add(Faci);

            pbDB.SaveChanges();

        }

        public List<Facility> GetFacilities()
        {
            pbDB = new ProgramBuilderEntities();

            List<Facility> Facis = pbDB.Facilities.ToList();

            return Facis;
        }

    }
}
