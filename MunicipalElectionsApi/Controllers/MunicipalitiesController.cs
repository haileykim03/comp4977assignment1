using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

[Route("api/[controller]")]
[ApiController]
public class MunicipalitiesController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public MunicipalitiesController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Municipality>>> GetMunicipalities()
    {
        return await _context.Municipalities!.OrderBy(m => m.Name).ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Municipality>> GetMunicipality(int id)
    {
        var municipality = await _context.Municipalities!.FindAsync(id);

        if (municipality == null)
        {
            return NotFound();
        }

        return municipality;
    }
}