using Microsoft.AspNetCore.Identity;

namespace MunicipalElectionsApi.Models;

public class ApplicationUser : IdentityUser
{
    public string? Name { get; set; }
}