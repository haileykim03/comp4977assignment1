using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

[Authorize]
[Route("api/positions")]
[Route("api/offices")]
[ApiController]
public class PositionsController : CityScopedController
{
    public PositionsController(ApplicationDbContext context) : base(context) { }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Position>>> GetPositions(string? city)
    {
        var (municipality, error) = await FindCityAsync(city);
        if (error != null)
        {
            return error;
        }

        return await _context.Positions!
            .Where(p => p.MunicipalityId == municipality!.MunicipalityId)
            .Include(p => p.Municipality)
            .OrderBy(p => p.PositionId)
            .ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Position>> GetPosition(int id, string? city)
    {
        var (municipality, error) = await FindCityAsync(city);
        if (error != null)
        {
            return error;
        }

        var position = await _context.Positions!
            .Include(p => p.Municipality)
            .FirstOrDefaultAsync(p => p.PositionId == id && p.MunicipalityId == municipality!.MunicipalityId);

        if (position == null)
        {
            return NotFound(new { message = "Position not found in this municipality." });
        }

        return position;
    }
}
