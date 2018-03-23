using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ProgramBuilder.WEB.HelperAttribute
{
    public static class ViewUltility
    {
        public static string RenderViewToString(this Controller Controller, string ViewPath, object model)
        {
            Controller.ViewData.Model = model;

            using (var sw = new StringWriter())
            {
                var ViewResult = ViewEngines.Engines.FindPartialView(Controller.ControllerContext, ViewPath);
                var ViewContext = new ViewContext(Controller.ControllerContext, ViewResult.View, Controller.ViewData, Controller.TempData, sw);
                ViewResult.View.Render(ViewContext, sw);

                return sw.GetStringBuilder().ToString();

            }
        }     
    }
}