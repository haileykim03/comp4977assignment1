using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

public abstract class CityScopedController : ControllerBase
{
    protected readonly ApplicationDbContext _context;

    protected CityScopedController(ApplicationDbContext context)
    {
        _context = context;
    }

    protected async Task<(Municipality? municipality, ActionResult? error)> FindCityAsync(string? city)
    {
        if (string.IsNullOrWhiteSpace(city))
        {
            return (null, BadRequest(new { message = "The city parameter is required, for example ?city=Burnaby." }));
        }

        string name = city.Trim().ToLower();
        var municipality = await _context.Municipalities!
            .FirstOrDefaultAsync(m => m.Name!.ToLower() == name);

        if (municipality == null)
        {
            return (null, NotFound(new { message = $"Unknown municipality: {city}." }));
        }

        return (municipality, null);
    }
}
