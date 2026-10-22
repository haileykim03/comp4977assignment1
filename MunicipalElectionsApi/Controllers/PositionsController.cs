using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

// Public endpoints for positions (no login needed)
[Route("api/[controller]")]
[ApiController]
public class PositionsController : ControllerBase
{
    // Database context, injected by ASP.NET (dependency injection)
    private readonly ApplicationDbContext _context;

    public PositionsController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: api/Positions
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Position>>> GetPositions()
    {
        // Include() also loads the municipality of each position
        return await _context.Positions!
            .Include(p => p.Municipality)
            .ToListAsync();
    }

    // GET: api/Positions/1
    [HttpGet("{id}")]
    public async Task<ActionResult<Position>> GetPosition(int id)
    {
        var position = await _context.Positions!
            .Include(p => p.Municipality)
            .FirstOrDefaultAsync(p => p.PositionId == id);

        if (position == null)
        {
            return NotFound();
        }

        return position;
    }
}