using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ProgramBuilder.DA;


namespace ProgramBuilder.BUS
{
    public static class BUSFacility
    {

       static DAFacility DAFaci = new DAFacility();
        public static void AddFacility(Facility facility)
        {
            DAFaci.AddFacility(facility);
        }

        public static List<Facility> GetFacilities()
        {
            List<Facility> facis = DAFaci.GetFacilities();

            return facis;
        }


    }
}
