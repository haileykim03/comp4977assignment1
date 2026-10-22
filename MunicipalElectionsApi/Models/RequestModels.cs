// Request bodies the API receives.
// The attributes ([Required], [EmailAddress], [MinLength]) are server-side validation.
using System.ComponentModel.DataAnnotations;

namespace MunicipalElectionsApi.Models;

// Body for POST api/auth/register
public class RegisterModel
{
    [Required]
    public string? Name { get; set; }

    [Required, EmailAddress]
    public string? Email { get; set; }

    [Required, MinLength(6)]
    public string? Password { get; set; }
}

// Body for POST api/auth/login
public class LoginModel
{
    [Required, EmailAddress]
    public string? Email { get; set; }

    [Required]
    public string? Password { get; set; }
}

// Body for POST api/savedcandidates
public class SaveCandidateModel
{
    public int CandidateId { get; set; }
}