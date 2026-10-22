using Microsoft.AspNetCore.Identity;

namespace MunicipalElectionsApi.Models;

// User is managed by ASP.NET Identity. Name is added for the registration screen.
public class ApplicationUser : IdentityUser
{
    public string? Name { get; set; }
}