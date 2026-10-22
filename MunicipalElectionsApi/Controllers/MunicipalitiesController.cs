using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

// Public endpoints for municipalities (no login needed)
[Route("api/[controller]")]
[ApiController]
public class MunicipalitiesController : ControllerBase
{
    // Database context, injected by ASP.NET (dependency injection)
    private readonly ApplicationDbContext _context;

    public MunicipalitiesController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: api/Municipalities
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Municipality>>> GetMunicipalities()
    {
        return await _context.Municipalities!.ToListAsync();
    }

    // GET: api/Municipalities/1
    [HttpGet("{id}")]
    public async Task<ActionResult<Municipality>> GetMunicipality(int id)
    {
        // FindAsync looks up a row by its primary key
        var municipality = await _context.Municipalities!.FindAsync(id);

        if (municipality == null)
        {
            return NotFound();
        }

        return municipality;
    }
}