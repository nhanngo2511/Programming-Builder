﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ProgramBuilder.DA
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.ComponentModel.DataAnnotations;
    using System.Web.Mvc;
    
    public partial class Program
    {
        public int ID { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập chương trình đào tạo")]
        [DisplayName("Tên chương trình")]
        public string Name { get; set; }


        [Required(ErrorMessage = "Vui lòng nhập trình độ đào tạo")]
        [DisplayName("Trình độ đào tạo")]
        public string TrainingLevel { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập ngành đào tạo")]
        [DisplayName("Ngành đào tạo")]
        public string BranchName { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập loại hình đào tạo")]
        [DisplayName("Loại hình đào tạo")]
        public string EducationType { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mục tiêu đào tạo đào tạo")]
        [AllowHtml]
        [DisplayName("Mục tiêu đào tạo")]
        public string TrainingPurpose { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập đối tượng tuyển sinh")]
        [DisplayName("Đối tượng tuyển sinh")]
        public string EntranceStudent { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập thời gian đào tạo")]
        [DisplayName("Thời gian đào tạo")]
        public string TrainingTimeDetail { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập khối lượng kiến thức toàn khóa")]
        [DisplayName("khối lượng kiến thức toàn khóa")]
        public string KnowledgeTotal { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập điều kiện tốt nghiệp")]
        [DisplayName("Điều kiện tốt nghiệp")]
        public string GraduateCondition { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập thang điểm")]
        [Range(1, 10, ErrorMessage = "Thang điểm trong khoảng [1, 10]")]
        [DisplayName("Thang điểm")]
        public int PointLadder { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập cơ sở vật chất phục vụ học tập")]
        [AllowHtml]
        [DisplayName("Cơ sở vật chất phục vụ học tập")]
        public string TrainingSupport { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập nội dung chương trình")]
        [AllowHtml]
        [DisplayName("Nội dung chương trình")]
        public string Content { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập kế hoạch giảng dạy")]
        [AllowHtml]
        [DisplayName("Kế hoạch giảng dạy")]
        public string TrainingPlan { get; set; }

        public bool Status { get; set; }
        [Required(ErrorMessage = "Vui lòng nhập mô tả vắn tắt nội dung và khối lượng các học phần")]
        [AllowHtml]
        [DisplayName("Mô tả vắn tắt nội dung và khối lượng các học phần")]
        public string ShortContentDescription { get; set; }


        [Required(ErrorMessage = "Vui lòng nhập danh sách giảng viên")]
        [AllowHtml]
        [DisplayName("Danh sách giảng viên")]
        public string LecturerList { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn khoa")]
        [DisplayName("Chương trình đào tạo của khoa")]
        public int FacultyID { get; set; }
        public System.DateTime CreationTime { get; set; }
    
        public virtual Faculty Faculty { get; set; }

    }
}